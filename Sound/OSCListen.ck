/*
 * OSC receivers for PhysBuzz!
 */


// shoot
OscIn oin_shoot;
6449 => oin_shoot.port;
oin_shoot.addAddress("/PhysBuzz/Shoot");
OscMsg msg_shoot;

// footstep
OscIn oin_footstep;
6449 => oin_footstep.port;
oin_footstep.addAddress("/PhysBuzz/FootStep");
OscMsg msg_footstep;

while (true) {
    while (oin_shoot.recv(msg_shoot)) {
        msg_shoot @=> OscMsg msg;
        <<< "got message:", msg.address, msg.typetag, "[", msg.getFloat(0), ",", msg.getFloat(1), ",", msg.getFloat(2), "]" >>>;
    }

    while (oin_footstep.recv(msg_footstep)) {
        msg_footstep @=> OscMsg msg;
        <<< "got message:", msg.address, msg.typetag, msg.getInt(0) >>>;
    }
}