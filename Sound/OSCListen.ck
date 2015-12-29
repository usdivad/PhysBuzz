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
        else if (msg.address == "/PhysBuzz/Eyeball") {
            handleEyeball(msg);
        }
    }
}

fun void handleShoot(OscMsg msg) {
    <<< "SHOOT:", "shot #", msg.getString(0), ", force:", msg.getFloat(1), "]" >>>;
}

fun void handleFootStep(OscMsg msg) {
    <<< "FOOTSTEP:", "footstep #", msg.getInt(0) >>>;
}

fun void handleExplode(OscMsg msg) {
    <<< "EXPLODE:", "distance:", msg.getFloat(0) >>>;
}

fun void handleEyeball(OscMsg msg) {
    <<< "EYEBALL:", "distance:", msg.getFloat(0) >>>;
}