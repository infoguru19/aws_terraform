## What this script does:
- Creates an IAM role for Lambda
- Creates a Lambda function using a ZIP file
- Uses Node.js runtime (can be Python, Go, etc.)
- Deploys Lambda in a specified region
- Run this command to zip it:

```bash
cd lambda
zip function.zip index.js 
```