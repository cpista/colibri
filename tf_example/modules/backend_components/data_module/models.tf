resource "aws_api_gateway_model" "machine_type_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "MachineTypeModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "MachineTypeModel",
    "title": "MachineTypeModel",
    "type": "string",
    "properties": {
       "machine_type":{
          "type":  "string"
       }
    }
}
EOF
}

resource "aws_api_gateway_model" "controller_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "ControllerModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "ControllerModel",
    "title": "ControllerModel",
    "type": "string",
    "properties": {
       "controller":{
            "type":  "string",
            "enum": [
                "Siemens 840D SL",
                "Siemens 840D PL",
                "Siemens S7-1500",
                "FANUC CNC Series 30i",
                "Rexroth MTX"
            ]
       }
    }
}
EOF
}

resource "aws_api_gateway_model" "country_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "CountryModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "CountryModel",
    "title": "CountryModel",
    "type": "string",
    "properties": {
       "country":{
           "type":  "string",
           "enum": [
              "DE",
              "US",
              "NL",
              "CA",
              "SK",
              "LI",
              "BR",
              "PT",
              "IT",
              "RU",
              "PL",
              "DK",
              "MA",
              "CH",
              "SE",
              "AT",
              "SI",
              "MX",
              "HR",
              "ES",
              "MK",
              "IN",
              "FR",
              "CZ",
              "HU",
              "CN",
              "JP",
              "GB",
              "TR",
              "KR",
              "RO"
            ]
       }
    }
}
EOF
}

resource "aws_api_gateway_model" "industry_sector_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "IndustrySector"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "IndustrySector",
    "title": "IndustrySector",
    "type": "string",
    "properties": {
       "industry_sector":{
           "type":  "string",
            "enum": [
                "Machine tool builder",
                "miscellaneous",
                "automotive oem",
                "automotive first-tier",
                "automotive second-tier",
                "automotive third-tier"
            ]
       }
    }
}
EOF
}

resource "aws_api_gateway_model" "coordinates_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name          = "CoordinatesModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "CoordinatesModel",
    "title": "CoordinatesModel",
    "type": "object",
    "properties": {
      "default": {
        "type": "boolean"
      },
      "latitude": {
        "type": "number",
        "format": "double"
      },
      "longitude": {
        "type": "number",
        "format": "double"
      }
    }
}
EOF
}

resource "aws_api_gateway_model" "address_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "AddressModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "AddressModel",
  "title": "AddressModel",
  "type": "object",
  "properties": {
    "street": {
      "type": "string"
    },
    "city": {
      "type": "string"
    },
    "state": {
      "type": "string"
    },
    "country": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/CountryModel"
    },
    "coordinates": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/CoordinatesModel"
    },
    "zipcode": {
      "type": "string"
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.controller_model,
    aws_api_gateway_model.coordinates_model
  ]
}

resource "aws_api_gateway_model" "machine_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "MachineModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "MachineModel",
    "title": "MachineModel",
    "type": "object",
    "properties": {
      "parent": {
        "type": "string"
      },
      "uri": {
        "type": "string"
      },
      "deleted": {
        "type": "boolean",
        "default": false
      },
      "name": {
        "type": "string"
      },
      "dates": {
        "type": "object",
        "properties": {
          "shipping": {
            "type": "string"
          },
          "delivery": {
            "type": "string"
          },
          "start_of_production": {
            "type": "string"
          },
          "warranty_start": {
            "type": "string"
          },
          "warranty_end": {
            "type": "string"
          },
          "contract_end": {
            "type": "string"
          }
        }
      },
      "controller": {
        "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/ControllerModel"
      },
      "machine_type": {
        "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/MachineTypeModel"
      },
      "machine_identifier_sw": {
        "type": "string"
      },
      "machine_identifier_customer": {
        "type": "string"
      },
      "cell_position": {
        "type": "string"
      }
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.controller_model,
    aws_api_gateway_model.machine_type_model
  ]
}

resource "aws_api_gateway_model" "machine_creation_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "MachineCreationModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "MachineCreationModel",
    "title": "MachineCreationModel",
    "type": "object",
    "properties": {
      "parent": {
        "type": "string"
      },
      "deleted": {
        "type": "boolean",
        "default": false
      },
      "name": {
        "type": "string"
      },
      "dates": {
        "type": "object",
        "properties": {
          "shipping": {
            "type": "string"
          },
          "delivery": {
            "type": "string"
          },
          "start_of_production": {
            "type": "string"
          },
          "warranty_start": {
            "type": "string"
          },
          "warranty_end": {
            "type": "string"
          },
          "contract_end": {
            "type": "string"
          }
        }
      },
      "controller": {
        "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/ControllerModel"
      },
      "machine_type": {
        "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/MachineTypeModel"
      },
      "machine_identifier_sw": {
        "type": "string"
      },
      "machine_identifier_customer": {
        "type": "string"
      },
      "cell_position": {
        "type": "string"
      }
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.controller_model,
    aws_api_gateway_model.machine_type_model
  ]
}

resource "aws_api_gateway_model" "line_creation_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "LineCreationModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "LineCreationModel",
    "title": "LineCreationModel",
    "type": "object",
    "properties": {
      "parent": {
        "type": "string"
      },
      "deleted": {
        "type": "boolean",
        "default": false
      },
      "name": {
        "type": "string"
      },
      "description": {
        "type": "string"
      }
    }
  }
}
EOF
}

resource "aws_api_gateway_model" "line_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "LineModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "LineModel",
  "title": "LineModel",
  "type": "object",
  "properties": {
    "parent": {
      "type": "string"
    },
    "uri": {
      "type": "string"
    },
    "deleted": {
      "type": "boolean",
      "default": false
    },
    "name": {
      "type": "string"
    },
    "description": {
      "type": "string"
    }
  }
}
EOF
}

resource "aws_api_gateway_model" "hall_creation_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "HallCreationModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "HallCreationModel",
  "title": "HallCreationModel",
  "type": "object",
  "properties": {
    "parent": {
      "type": "string"
    },
    "deleted": {
      "type": "boolean",
      "default": false
    },
    "name": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "coordinates": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/CoordinatesModel"
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.coordinates_model
  ]
}


resource "aws_api_gateway_model" "hall_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "HallModel"
  content_type = "application/json"

  schema = <<EOF
{
    "$schema": "HallModel",
    "title": "HallModel",
    "type": "object",
    "properties": {
      "parent": {
        "type": "string"
      },
      "uri": {
        "type": "string"
      },
      "deleted": {
        "type": "boolean",
        "default": false
      },
      "name": {
        "type": "string"
      },
      "description": {
        "type": "string"
      },
      "coordinates": {
        "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/CoordinatesModel"
      }
    }
}
EOF
  depends_on = [
    aws_api_gateway_model.coordinates_model
  ]
}

resource "aws_api_gateway_model" "location_creation_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "LocationCreationModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "LocationCreationModel",
  "title": "LocationCreationModel",
  "type": "object",
  "properties": {
    "parent": {
      "type": "string"
    },
    "deleted": {
      "type": "boolean",
      "default": false
    },
    "name": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "address": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/AddressModel"
    },
    "website": {
      "type": "string"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "language": {
      "type": "string"
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.address_model
  ]
}

resource "aws_api_gateway_model" "location_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "LocationModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "LocationModel",
  "title": "LocationModel",
  "type": "object",
  "properties": {
    "parent": {
      "type": "string"
    },
    "uri": {
      "type": "string"
    },
    "deleted": {
      "type": "boolean",
      "default": false
    },
    "name": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "address": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/AddressModel"
    },
    "website": {
      "type": "string"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "language": {
      "type": "string"
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.address_model
  ]
}

resource "aws_api_gateway_model" "company_creation_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "CompanyCreationModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "CompanyCreationModel",
  "title": "CompanyCreationModel",
  "type": "object",
  "properties": {
    "parent": {
      "type": "string"
    },
    "deleted": {
      "type": "boolean",
      "default": false
    },
    "name": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "address": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/AddressModel"
    },
    "website": {
      "type": "string"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "customer_number": {
      "type": "string"
    },
    "legal_form": {
      "type": "string"
    },
    "industry_sector": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/IndustrySector"
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.industry_sector_model,
    aws_api_gateway_model.address_model
  ]
}

resource "aws_api_gateway_model" "company_model" {
  rest_api_id  = aws_api_gateway_rest_api.assets_api.id
  name         = "CompanyModel"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "CompanyModel",
  "title": "CompanyModel",
  "type": "object",
  "properties": {
    "parent": {
      "type": "string"
    },
    "uri": {
      "type": "string"
    },
    "deleted": {
      "type": "boolean",
      "default": false
    },
    "name": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "address": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/AddressModel"
    },
    "website": {
      "type": "string"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "customer_number": {
      "type": "string"
    },
    "legal_form": {
      "type": "string"
    },
    "industry_sector": {
      "$ref": "https://apigateway.amazonaws.com/restapis/${aws_api_gateway_rest_api.assets_api.id}/models/IndustrySector"
    }
  }
}
EOF
  depends_on = [
    aws_api_gateway_model.industry_sector_model,
    aws_api_gateway_model.address_model
  ]
}