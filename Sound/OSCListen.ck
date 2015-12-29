/*
 * OSC receivers for PhysBuzz!
 */

OscIn oin;
6449 => oin.port;
oin.listenAll();
OscMsg msg;

while (true) {
    while (oin.recv(msg)) {
        <<< "got message:", msg.address, msg.typetag>>>;

        if (msg.address == "/PhysBuzz/Shoot") {
            handleShoot(msg);
        }
        else if (msg.address == "/PhysBuzz/FootStep") {
            handleFootStep(msg);
        }
        else if (msg.address == "/PhysBuzz/Explode") {
            handleExplode(msg);
        }
    }
}

fun void handleShoot(OscMsg msg) {
    <<< "shoot", "[", msg.getFloat(0), ",", msg.getFloat(1), ",", msg.getFloat(2), "]" >>>;
}

fun void handleFootStep(OscMsg msg) {
    <<< "footstep", msg.getInt(0) >>>;
}

fun void handleExplode(OscMsg msg) {
    <<< "explode", msg.getFloat(0) >>>;
}