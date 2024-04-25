# NPM Integration Examples for FaceVerify

You can import the libary as a module into your own JS build system (tested with Webpack). We offer two different setups: using our assets via a Content Delivery Network (CDN) or hosting them locally. Both of these examples have been thoroughly tested with Webpack and are designed to be easily integrated into most JavaScript build systems.

Please take a look at the example files for more information on implementation.

## Prerequisites

Before you begin, ensure you have [Node.js](https://nodejs.org/) installed on your system. This will provide you with Node Package Manager (npm), essential for managing the dependencies in your project.

## Example Using NPM with CDN

To test our package with assets delivered via CDN, follow these steps:

1. **Navigate to the CDN Example Directory:**

   Open your terminal and change to the `npm_cdn` directory, which contains the CDN-based example project.

   ```bash
   cd npm_cdn
   ```

2. **Install Dependencies:**

   Use npm to install the project dependencies.

   ```bash
   npm install
   ```

3. **Build and Run the Example Project:**

   Compile the example project using the following command:

   ```bash
   npm run build
   ```

   This step integrates our package into the example project using CDN.

## Example Using NPM Locally

If you prefer to test our package with locally hosted assets, here's how you can set up the local example:

1. **Navigate to the Local Example Directory:**

   In your terminal, switch to the `npm_local` directory, which contains the local asset-based example project.

   ```bash
   cd npm_local
   ```

2. **Install Dependencies:**

   Just as before, install the necessary dependencies using npm.

   ```bash
   npm install
   ```

3. **Build and Run the Example Project:**

   Build the example project with this command:

   ```bash
   npm run build
   ```

   This build process is crucial as it copies the assets from the `node_modules` directory into the example project. This allows you to test our package using assets hosted within your local environment.
