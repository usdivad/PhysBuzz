public class Sonifier {

    // footstep foley
    Shakers shaker => dac;
    9 => shaker.preset; // crunch
    
    ModalBar bar => NRev r => dac;
    1 => bar.preset;


    fun void sonifyShoot(OscMsg msg) {
        <<< "SHOOT:", "shot #", msg.getString(0), ", force:", msg.getFloat(1), "]" >>>;
    }

    fun void sonifyFootStep(OscMsg msg) {
        // <<< "FOOTSTEP:", "footstep #", msg.getInt(0) >>>;
        <<< "FOOTSTEP:", "[", msg.getFloat(0), ",", msg.getFloat(1), ",", msg.getFloat(2), "]" >>>;
        // msg.getInt(0) => int stepNum;
        msg.getFloat(1) => float y;

        // hacky way to do gravel vs. marble
        if (y > 1.0) { // marble
            Std.mtof(Math.random2(10, 15)) * (y) => bar.freq;
            Math.random2f(0.0, 0.25) => bar.strikePosition;
            Math.random2f(0.45, 0.5) => bar.stickHardness;
            Math.random2f(0.0, 0.1) => bar.damp;
            1.0 => bar.noteOn;
            Math.random2f(0.45, 0.55)::second => now;
        }
        else { // gravel
            Math.random2f(200, 400) => shaker.freq;
            Math.random2f(0.8, 1.0) => shaker.decay;
            Math.random2f(0.6, 1.0) => shaker.energy;
            Math.random2(80, 120) => shaker.objects;
            Math.random2f(0.45, 0.55)::second => now;
        }
    }

    fun void sonifyExplode(OscMsg msg) {
        <<< "EXPLODE:", "distance:", msg.getFloat(0) >>>;
    }

    fun void sonifyEyeball(OscMsg msg) {
        // <<< "EYEBALL:", "distance:", msg.getFloat(0) >>>;
    }
}