
# _NeoVault

_**NeoVault** is a secure, end-to-end encrypted storage solution built with SwiftUI using the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern. The app provides encrypted local and cloud storage, allowing seamless synchronization between the two storage types.

The cloud storage backend is powered by Wasabi S3, and the app implements AES-256 encryption to protect files both locally and when uploaded to the cloud. The encryption key and initialization vector (IV) are derived from a combination of the user's password and a salt.

## Features

- **End-to-End Encryption**: All files, whether stored locally or on the cloud, are encrypted using AES-256 encryption. The encryption key is derived from both the user's password and a salt, ensuring that only the user can decrypt the files.
- **Local Storage Sync**: Syncs encrypted local file storage with cloud storage using Apple's `FileManager`.
- **Cloud Storage**: Uploads encrypted files to Wasabi S3, a secure and low-cost cloud storage service.
- **Custom S3 SDK**: Wasabi S3 has no publicly available SDK for iOS, so a custom SDK was created from scratch to integrate with Wasabi's service.
- **MVVM-C Architecture**: Implements the MVVM-C design pattern for clean code, separation of concerns, and scalability.

## Configuration

The app relies on certain external services for functionality, and you'll need to configure them before you can use it. These include Firebase for local storage and Wasabi S3 for cloud storage.

### 1. **Firebase Configuration**
The app uses Firebase for certain features. You will need to provide your own `GoogleService-Info.plist` file to connect the app to Firebase services.

- Download this file from your Firebase project at [Firebase Console](https://console.firebase.google.com/).
- Add the `GoogleService-Info.plist` to the project directory where the app expects it.

### 2. **Wasabi S3 Configuration**
To use the cloud storage features of the app, you'll need to provide your Wasabi S3 credentials in the `Live.config` file.

You will need to replace the following values:

- **Key**: Your Wasabi S3 access key.
- **Secret**: Your Wasabi S3 secret key.
- **Bucket**: The name of your Wasabi S3 bucket.

Follow these steps to configure Wasabi S3:

1. Create an account with Wasabi: [Wasabi Cloud](https://wasabi.com/).
2. After logging in, navigate to your [S3 Settings](https://console.wasabi.com/) and generate an access key and secret key.
3. Update the `Live.config` file with the following details:
    - **Key**: Your Wasabi access key.
    - **Secret**: Your Wasabi secret key.
    - **Bucket**: The name of your Wasabi S3 bucket.

Once these values are added, the app should be ready to upload and sync files with Wasabi S3 storage.

## How It Works

The app allows users to securely upload files to the cloud and sync them with local storage. Here’s a high-level overview of the process:

### 1. Local Storage

Files stored locally are encrypted using AES-256 encryption and stored on the device. The encryption key is derived from both the user’s password and a salt, ensuring that each user’s data is uniquely protected.

### 2. Cloud Storage

When a user uploads a file, it is first encrypted using AES-256 with the encryption key derived from the user's password and a salt. The encrypted file is then uploaded to Wasabi S3 cloud storage. A custom SDK was written to handle the interaction with Wasabi S3, as there is no publicly available SDK for iOS. All files are encrypted in the cloud, ensuring data privacy.

### 3. Syncing

The app automatically syncs encrypted files between the local storage and the cloud storage. This ensures that users can access their files from any device connected to the cloud storage, while maintaining the highest level of security.

### 4. Previewing Files

Files are only decrypted when previewing them within the app. The decryption is done using the encryption key derived from the user's password and a salt. This ensures that even if the data is stored in the cloud or locally, it remains secure at all times. The decrypted file is not saved; it is only available temporarily for viewing.

## Encryption Details

- **AES-256 Encryption**: All files are encrypted using the AES-256 algorithm both locally and before being uploaded to the cloud.
- **Key Derivation**: The encryption key is derived from the user’s password and a salt using a secure key derivation function (e.g., PBKDF2, scrypt, or bcrypt).
- **Decryption for Previewing**: Files are only decrypted when previewing them in the app, ensuring that encrypted data is never exposed when not needed.

## Contributing

Feel free to fork the repository and submit pull requests for improvements, bug fixes, or features. Contributions are welcome!

1. Fork the repository.
2. Create a new branch.
3. Commit your changes.
4. Push your changes to your fork.
5. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- **Wasabi S3**: For providing a reliable and affordable cloud storage solution.
- **AES-256**: For offering industry-standard encryption.
- **SwiftUI**: For building the user interface using Apple's declarative framework.
