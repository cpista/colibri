import os
import sys
import mysql.connector
import re

# read command line arguments
if len(sys.argv) != 6:
    print(
        "Usage: ./db-upgrade.py directory-with-sql-scripts "
        "username-for-the-db db-host db-name db-password"
    )
    sys.exit(1)

scripts_dir, db_user, db_host, db_name, db_password = sys.argv[1:]

# connect to the database
try:
    conn = mysql.connector.connect(
        host=db_host, user=db_user, password=db_password, database=db_name
    )
except mysql.connector.Error as err:
    print(f"Error connecting to database: {err}")
    sys.exit(1)

cur = conn.cursor()

# get the current database version
try:
    cur.execute("SELECT version FROM versionTable")
    current_version = cur.fetchone()[0]
except mysql.connector.Error as err:
    print(f"Error retrieving current database version: {err}")
    cur.close()
    conn.close()
    sys.exit(1)

# find all script files in the specified directory
try:
    # define the regular expression pattern to match different file name formats
    pattern = re.compile(r'^\d+\D.*\.sql$', re.IGNORECASE)

    # find all script files in the specified directory
    script_files = sorted([
        os.path.join(scripts_dir, f)
        for f in os.listdir(scripts_dir)
        if os.path.isfile(os.path.join(scripts_dir, f))
        and f.endswith(".sql")
        and pattern.match(f)
    ])


except OSError as err:
    print(f"Error reading script files from directory {scripts_dir}: {err}")
    cur.close()
    conn.close()
    sys.exit(1)

# find the highest script version number
try:
    highest_version = max(
        [
            int(re.findall(r"^\d+", os.path.basename(f))[0])
            for f in script_files
        ]
    )
except ValueError:
    print("Error: no valid script files found in the specified directory")
    cur.close()
    conn.close()
    sys.exit(1)

# execute all scripts with version number greater than current_version
for f in script_files:
    version = int(re.findall(r"^\d+", os.path.basename(f))[0])
    if version > current_version:
        with open(f) as script_file:
            script = script_file.read()
            try:
                cur.execute(script, multi=True)
                conn.commit()
                print(f"Executed script {f}")
            except mysql.connector.Error as err:
                print(f"Error executing script {f}: {err}")
                cur.close()
                conn.close()
                sys.exit(1)
        # update the versionTable with the new version
        try:
            cur.execute(f"UPDATE versionTable SET version = {version}")
            conn.commit()
            print(f"Scripts ${script_files} were executed successfully")
        except mysql.connector.Error as err:
            print(f"Error updating database version: {err}")
            cur.close()
            conn.close()
            sys.exit(1)

# close database connection
cur.close()
conn.close()
