// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendCreationToDevice = functions.firestore
    .document("submissions/{submissionId}")
    .onCreate(async (snapshot) => {
      const submission = snapshot.data(); // extract data
      // get user's device tokens from firestore
      const querySnapshot = await db
          .collection("users")
          .doc(submission.submittedTo)
          .collection("tokens")
          .get();
      const tokens = querySnapshot.docs.map((c) => c.id); // get the tokens
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "Incident Report Submitted",
          body: "An incident report has been submitted",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      return fcm.sendToDevice(tokens, payload);
    });

export const sendUpdateToDevice = functions.firestore
    .document("submissions/{submissionId}")
    .onUpdate(async (snapshot) => {
      const submission = snapshot.after.data(); // extract data
      // get user's device tokens from firestore
      const querySnapshot = await db
          .collection("users")
          .doc(submission.submittedTo)
          .collection("tokens")
          .get();
      const tokens = querySnapshot.docs.map((c) => c.id); // get the tokens
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: "Incident Report Updated",
          body: "An incident report has been updated",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      return fcm.sendToDevice(tokens, payload);
    });
