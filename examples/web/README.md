# Web Integration Examples for FaceVerify

Integrate FaceVerify into your web projects using one of three methods: Script Tag, NPM, or React. Each method is designed to suit different project setups and requirements.

## Integration Methods

### 1. Script Tag

Easily add FaceVerify to your HTML files using the Script Tag method.

```html
<!-- Add FaceVerify directly in your HTML -->
<script src="../dist/faceverify.obf.js"></script>
```

### 2. NPM

For projects using NPM and a module bundler like Webpack or Rollup, you can import FaceVerify as an ES6 module or with CommonJS require syntax.

```bash
npm install --save @datachecker/faceverify
```

```js
// Import FaceVerify in your JavaScript file

// ES6 style import
import FaceVerify from '@datachecker/faceverify';

// CommonJS style require
let FaceVerify = require('@datachecker/faceverify')
```

For more detailed NPM integration examples, refer to the [NPM examples section](npm/npm.md).

### 3. React

Integrating FaceVerify into React applications is straightforward with ES6 module import or with CommonJS require syntax. These approaches are perfect for projects created with Create React App or similar React frameworks.

```bash
npm install --save @datachecker/faceverify
```

```js
// Import FaceVerify in your React component

// ES6 style import
import FaceVerify from '@datachecker/faceverify';

// CommonJS style require
let FaceVerify = require('@datachecker/faceverify')
```

For additional React-specific examples, check out the [React examples section](react/react.md).
