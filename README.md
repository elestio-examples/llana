# Llana CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/llana"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Llana by JuicyLlama with CI/CD on Elestio

<img src="llana.png" style='width: 20%;'/>
<br/>
<br/>

# Once deployed ...

Connect to Llana Server URL here:

    URL: https://[CI_CD_DOMAIN]

## Building Request

Llana offer a dedicated `/auth/login` endpoint where you can exchange your username and password for an access token, which can be used for authentication in subsequent requests.

    curl -X POST https://[CI_CD_DOMAIN]/auth/login \
    -H "Content-Type: application/json" \
    -d '{
        "username": "test@test.com",
        "password": "test"
    }'

Expected Response:

    {
        "access_token": "your_access_token"
    }

### Use the Access Token for Authorization in Postman

1. In Postman, open the "Authorization" tab for the request where you want to use the token.
2. Choose the "Bearer Token" option from the dropdown.
3. Paste the `access_token` obtained from the previous step into the token field.
4. Now, the request will automatically include the token in the `Authorization` header as Bearer `<access_token>`.

## Documentation

- You can access and fork our Postman collection for the JuicyLlama Framework [here](https://www.postman.com/juicyllama/workspace/framework/folder/18538466-e4034b2d-9a3e-42a9-a850-c551d47abfbe).
- For more information how to query, you can follow the [Official Documentation](https://juicyllama.com/tools/llana/endpoints)
