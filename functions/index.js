const functions = require("firebase-functions");
const admin = require('firebase-admin');
const { firestore } = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

//kettő funkció lkell kezdetben

//1: ha kiraknak egy esményt megnézi kit érdekel
//      majd ezeknek frissíti az idővonalát


exports.onCreateEvent = functions.firestore
    .document("/events/{eventId}")
    .onCreate( async (snapshot, context) => {
        const eventId = context.params.eventId;

        const eventRef = await admin
            .firestore()
            .collection("events")
            .doc(eventId).get();


        const timelineEventsRef = admin
            .firestore()
            .collection("timeline");

        const querySnapshot = await admin
            .firestore()
            .collection("users")
            .get();

        querySnapshot.forEach(user => {
            const otheruserId = user.id;
            timelineEventsRef
                .doc(otheruserId).update({timelineEvents: firestore.FieldValue.arrayUnion(eventId)});
        });
    })

exports.onDeleteEvent = functions.firestore
    .document("/events/{eventId}")
    .onDelete( async (snapshot, context) => {
        const eventId = context.params.eventId;

        const timelineEventsRef = admin
            .firestore()
            .collection("timeline");

        const querySnapshot = await admin
            .firestore()
            .collection("users")
            .get();

        querySnapshot.forEach(user => {
            const otheruserId = user.id;
            timelineEventsRef
                .doc(otheruserId).update({timelineEvents: firestore.FieldValue.arrayRemove(eventId)});

        });
    })


/*
//2: a felhasználó érdeklődési körének létrehozásakor / frissítésekor
//      frissíti az idővonalát
exports.onWriteInterest = functions.firestore
    .document("interests/{userId}")
    .onWrite( async (snapshot, context) => {
        const userId = context.params.userId;

        const usersTimelineRef = admin
            .firestore()
            .collection("timeline")
            .doc(userId)
            .collection("timelineEvents");

        const querySnapshot = await usersTimelineRef.get();
        
        querySnapshot.forEach(doc => {
            if(doc.exists){
                doc.ref.delete();
            }
        })
        
    })

    */