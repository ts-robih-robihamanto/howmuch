# Howmuch

Howuch is a module that allows app developers to easily convert currency from ApiLayer within their app.

# Requirements

Swift >= 5.4 is supported.


# **How to install**

## Swift Package Manager

Open your project settings in Xcode and add a new package in 'Swift Packages' tab:
* Repository URL: `https://github.com/ts-robih-robihamanto/howmuch`
* Version settings: 1.0.0

# **Configuring**

**Note:** Currently we are using APILayer 3rd parties to convert the currrency.

To use the module you must set your app's api key the provided methods:

### Runtime configuration
Provide a value for `apiKey` parameters when calling `Howmuch.configure` method. 
```swift
Howmuch.configure(apiKey: "your_api_key")
```

⚠️ The runtime configuration values take precedence over build-time configuration.

# **Using the SDK**

The SDK provides a public methods for the host applications to use:

```swift
func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int, completion: @escaping (Double?) -> (Void))
```

### **func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int, completion: @escaping (Double?) -> (Void))**  
This method is provided for converting any currency to others.

**The method signature is:**

```swift
func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int, completion: @escaping (Double?) -> (Void))
```

```swift
Howmuch.convertCurrency(from: .jpy, to: .usd, amount: 100000) { result in
    // Use the result here
}
```
