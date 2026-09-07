/// Identity provider configuration read out of google-services.json.
///
/// These are public client identifiers, not secrets. They are checked in so a
/// fresh clone builds and signs in without anyone having to hunt through the
/// Firebase console.
library;

/// The WEB OAuth client, not the Android one.
///
/// This is the counter-intuitive part and the reason Google sign in returns
/// DEVELOPER_ERROR without it. On Android, google_sign_in uses the Android
/// client (matched by package name and SHA-1) to authenticate the app, and the
/// WEB client as the audience for the ID token it hands back. Firebase will
/// only accept a credential whose token was minted for that web client, so
/// leaving serverClientId unset yields either a null idToken or a plain
/// DEVELOPER_ERROR with nothing else to go on.
const googleServerClientId =
    '253195662046-qf7ki2rdi2r4sraa663dpkivrefihdvo.apps.googleusercontent.com';
