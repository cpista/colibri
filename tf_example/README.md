Terraform AWS infrastructure repository for SW platform and modules
=========

This is a Terraform project, for setup Schwaebische Werkzeugmaschinen platform.

**Current status:** Under development

## How to start

#TODO: Explain what is needed and how to setup project for first run

## How it works

#TODO: Describe project usage and development by examples

First module `shared_resources/sns_topic_module` can be tested with:
```
$ go test modules/shared_resources/sns_topic_module/test/sns_terraform_test.go
```


## Structure


| Sub-folder |  Description |
| :-------- | :------- |
| `modules/shared_resources` | `Location for any module of shared resources` |
| `modules/backend_components` | `Location for any module of backend service` |
| `modules/platform_frontend` | `Location for platform frontend modules` |
