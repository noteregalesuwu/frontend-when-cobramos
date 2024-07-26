importScripts(
  "https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js"
);

const firebaseConfig = {
  apiKey: "AIzaSyAhpRw_tdWTObKUmL7Agy1aZA0YCcedOvQ",
  appId: "1:709631535156:web:d0f9f3ed752ad4c6dcc261",
  messagingSenderId: "709631535156",
  projectId: "uen-cobramos",
  authDomain: "uen-cobramos.firebaseapp.com",
  storageBucket: "uen-cobramos.appspot.com",
  measurementId: "G-JD8B5WC672",
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();
