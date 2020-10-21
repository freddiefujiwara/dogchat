importScripts("https://www.gstatic.com/firebasejs/7.23.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.23.0/firebase-messaging.js");
firebase.initializeApp({
  apiKey: "AIzaSyC36UGcGGkJR5RXihM8KFXLlnwLONs8DAo",
  authDomain: "dogchat-freddiefujiwara-com.firebaseapp.com",
  databaseURL: "https://dogchat-freddiefujiwara-com.firebaseio.com",
  projectId: "dogchat-freddiefujiwara-com",
  storageBucket: "dogchat-freddiefujiwara-com.appspot.com",
  messagingSenderId: "513169717999",
  appId: "1:513169717999:web:b39ddeb76d9a754cca391a",
  measurementId: "G-NMSFJ93Z6B"
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});