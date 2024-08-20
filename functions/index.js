/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");


const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.validateBid = functions.firestore
    .document("auctions/{auctionId}/bids/{bidId}")
    .onCreate(async (snap, context) => {
      const bidData = snap.data();
      const auctionId = context.params.auctionId;
      const bidUserId = bidData.userId;
      // Obtenha os detalhes do leilão
      const auctionDoc = await admin.firestore().
          collection("auctions").doc(auctionId).get();
      const auctionData = auctionDoc.data();
      if (!auctionData) {
        console.log(`Leilão com ID ${auctionId} não encontrado.`);
        return null;
      }
      const sellerId = auctionData.sellerId;
      // Verifique se o usuário que está fazendo o lance é o leiloeiro
      if (bidUserId === sellerId) {
        console.log(`Usuário ${bidUserId} tentou dar lance 
            no próprio leilão. Bloqueando...`);
        // Remova o lance inválido
        return snap.ref.delete().then(() => {
          console.log(`Lance do leiloeiro ${bidUserId} foi removido.`);
        }).catch((error) => {
          console.error("Erro ao remover o lance:", error);
        });
      }
      console.log(`Lance de ${bidUserId} aceito.`);
      return null;
    });


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
