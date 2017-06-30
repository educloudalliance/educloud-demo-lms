## Quick start

1. Create the .env.development file :

        OAUTH_CLIENT_ID=xxx
        OAUTH_CLIENT_SECRET=xxx
        BAZAAR_USER_EMAIL=xxx@example.com
        BAZAAR_USER_PASSWORD=xxx
        IDP_CERT=xxx
        IDP_SSO_TARGET_URL=https://sample.idp.com/saml2/http-post/sso/
        BAZAAR_API_URL=bazaar.educloudalliance.org/api/v1
Get IDP_CERT and IDP_SSO_TARGET_URL from you SAML IDP metadata;

OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET, BAZAAR_USER_EMAIL and BAZAAR_USER_PASSWORD from bazaar.educloudalliance.org 

2. Start the web server:

        $ rails server

   Run with `--help` or `-h` for options.

3. Using a browser, go to `http://localhost:3000`