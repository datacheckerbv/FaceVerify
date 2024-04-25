# React Integration Examples for FaceVerify

You can import the libary as a module into your own JS build system (tested with React). We offer two different setups: using our assets via a Content Delivery Network (CDN) or hosting them locally. Both of these examples have been thoroughly tested with Webpack and are designed to be easily integrated into most JavaScript build systems.

Please take a look at the example files for more information on implementation.

## Prerequisites

Before you begin, ensure you have [Node.js](https://nodejs.org/) installed on your system. This will provide you with Node Package Manager (npm), essential for managing the dependencies in your project.

## Working with React

### Import

```javascript
import FaceVerify from '@datachecker/faceverify';
```

### Configuration

Please refer to the [Configuration](../../../README.md#configuration) reference.

```javascript
const FaceVerifyComponent = () => {
  const initialized = useRef(false);

  useEffect(() => {
    // Initialized only once
    if (!initialized.current) {
      initialized.current = true;
      const FV = new FaceVerify();
      FV.init({
        CONTAINER_ID: 'FV_mount',
        LANGUAGE: 'en',
        TOKEN: "<SDK_TOKEN>",
        onComplete: function(data) {
          console.log(data);
        },
        onImage: function(data) {
          console.log(data);
        },
        onError: function(error) {
          console.log(error)
        },
        onUserExit: function(error) {
          console.log(error);
        }
      });
    }
  }, []);

  return (
    <div id="FV_mount" />
  );
}
```

### Working with Typescript

Create a file faceverify.d.ts & copy the following type definition and extend it according to your use case.

```ts
declare module '@datachecker/faceverify' {
   export type Output = {
     images: Array<{ data: string; type: string }>;
     meta: Array<{ x: string; y: string; width: string; height: string }>;
     token: string;
     transactionId: string;
     valid_challenges: boolean;
   };
   interface FaceVerifyConfig {
     CONTAINER_ID: string;
     LANGUAGE: string;
     TOKEN: string;
     DEBUG: boolean;
     ASSETS_MODE?: 'CDN' | 'LOCAL';
     ASSETS_FOLDER?: string;
     onComplete: (data: Output) => void;
     onError: (error: Error) => void;
     onUserExit: (error: Error) => void;
   }
   class FaceVerify {
     constructor();
     init(config: FaceVerifyConfig): void;
     start(): void;
     stop(): void;
   }
   export default FaceVerify;
}
```

## Using examples

### Example Using React with CDN

To test our package with assets delivered via CDN, follow these steps:

1. **Navigate to the CDN Example Directory:**

   Open your terminal and change to the `react_cdn` directory, which contains the CDN-based example project.

   ```bash
   cd react_cdn
   ```

2. **Install Dependencies:**

   Use npm to install the project dependencies.

   ```bash
   npm install
   ```

3. **Build and Run the Example Project:**

   Compile the example project using the following command:

   ```bash
   npm start
   ```

   This step integrates our package into the example project using CDN.

### Example Using React Locally

If you prefer to test our package with locally hosted assets, here's how you can set up the local example:

1. **Navigate to the Local Example Directory:**

   In your terminal, switch to the `react_local` directory, which contains the local asset-based example project.

   ```bash
   cd react_local
   ```

2. **Install Dependencies:**

   Just as before, install the necessary dependencies using npm.

   ```bash
   npm install
   ```

3. **Copy assets**

    Copy the assets from the `node_modules` directory into the example project `public` directory.

    ```bash
    cp -r node_modules/@datachecker/faceverify/dist/assets public/assets
    ```

4. **Build and Run the Example Project:**

   Build the example project with this command:

   ```bash
   npm start
   ```
