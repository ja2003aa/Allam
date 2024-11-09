from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams
from ibm_watsonx_ai import Credentials
access_token='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im5WZTRrVnZkc25JUUdrOWs0YzFRMlhrNjBmekhKSW1GUW5NWUJjN3A4ZkkifQ.eyJ1aWQiOiIxMDAwMzMxMDg2IiwidXNlcm5hbWUiOiI0MWI0NDUwZC00OGVlLTQ5MmYtYTczNi01YjkxMjQ5ZTVmZGQiLCJyb2xlIjoiVXNlciIsInBlcm1pc3Npb25zIjpbInNpZ25faW5fb25seSJdLCJncm91cHMiOlsxMDAzNiwxMDAwMF0sInN1YiI6IjQxYjQ0NTBkLTQ4ZWUtNDkyZi1hNzM2LTViOTEyNDllNWZkZCIsImlzcyI6IktOT1hTU08iLCJhdWQiOiJEU1giLCJhcGlfcmVxdWVzdCI6dHJ1ZSwiaWF0IjoxNzMxMDgwMjgyLCJleHAiOjUzMzEwNzY2ODJ9.2ghUL52tD7dKa_CkwmPEYBhAT4hIRm-7gnvWE_-AYsVzWKZyG9Uvo5fzM15nkSRINoXYGyimUI1Ahyz_G9Zi0bMqtSt3otgQyvXh42E5-mHvdNytoVt6_0TNknhmuvCdQCHwNPmMq1SfoH5kpNz42I4kno677tNl-BA2BYlZeyTf3tAFejHfIvedednnvTCj5H9SszIFh6a68ujmvXK41p3nE6FgwYJUBmOcP62xSls9bmMi_8HPeqpekLGTiTUzAr357JRojFhj6gFeoQAAS5Jb7JkNakLTEyUIEc1GhWuZc_5iFA8dUe9QPePVehqiPKEYXQYNcjlAB1gHdrrjMg'
wml_credentials = {
                   "url": "https://ai.deem.sa/",
                  
                   "token": access_token,
                   "instance_id": "openshift",
                   "version": "5.0"
                  }
generate_params = {
    GenParams.MAX_NEW_TOKENS: 100
}

deployment_inference = ModelInference(
    deployment_id="2cbbcdce-86af-46ad-a51b-0fc8134a864f",
    credentials = wml_credentials,
     params=generate_params,

    project_id="c0ceb3f4-68f4-42c3-bfeb-73aa3149e44d"
    )


response = deployment_inference.generate("اكتب شعر")
print(response)