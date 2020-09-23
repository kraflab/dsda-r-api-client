### OTP JSON Example
Request:
```json
{
  "otp": { }
}
```

Response:
```json
{
  "otp": "1234abcd"
}
```

### Usage
This is a one-time call to generate a time-based otp code for your account.
Enter the code into your preferred otp storage app.
If you try to call this again, you will get an error.
