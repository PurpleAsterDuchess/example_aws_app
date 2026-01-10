# Run terraform application
1. navigate to _state folder
2. run `bash ./init.sh`
3. run `bash ./plan.sh`
4. run `bash ./apply.sh`
5. navigate to main terraform folder
6. repeat steps 2-5


# Database requests
1. get api-url
`terraform output base_url`
2. run the CRUD request
## Post request
`curl -X POST "$(terraform output -raw base_url)/post" -d '{"name":"Alice"}' -H "Content-Type: application/json"`
## Get request
`curl "$(terraform output -raw base_url)/get"`