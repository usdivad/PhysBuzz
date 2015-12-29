/*
 * OSC receivers for PhysBuzz!
 */

OscIn oin;
6449 => oin.port;
oin.listenAll();
OscMsg msg;

Sonifier sonifier;

while (true) {
    while (oin.recv(msg)) {
        <<< "got message:", msg.address, msg.typetag>>>;

        if (msg.address == "/PhysBuzz/Shoot") {
            sonifier.sonifyShoot(msg);
        }
        else if (msg.address == "/PhysBuzz/FootStep") {
            sonifier.sonifyFootStep(msg);
        }
        else if (msg.address == "/PhysBuzz/Explode") {
            sonifier.sonifyExplode(msg);
        }
        else if (msg.address == "/PhysBuzz/Eyeball") {
            sonifier.sonifyEyeball(msg);
        }
    }
}