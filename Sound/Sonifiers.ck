public class Sonifier {
    Shakers shaker => dac;
    9 => shaker.preset; // crunch

    fun void sonifyShoot(OscMsg msg) {
        <<< "SHOOT:", "shot #", msg.getString(0), ", force:", msg.getFloat(1), "]" >>>;
    }

    fun void sonifyFootStep(OscMsg msg) {
        <<< "FOOTSTEP:", "footstep #", msg.getInt(0) >>>;
        // msg.getInt(0) => int stepNum;

        Math.random2f(200, 400) => shaker.freq;
        Math.random2f(0.8, 1.0) => shaker.decay;
        Math.random2f(0.6, 1.0) => shaker.energy;
        Math.random2(80, 120) => shaker.objects;
        Math.random2f(0.45, 0.55)::second => now;
    }

    fun void sonifyExplode(OscMsg msg) {
        <<< "EXPLODE:", "distance:", msg.getFloat(0) >>>;
    }

    fun void sonifyEyeball(OscMsg msg) {
        // <<< "EYEBALL:", "distance:", msg.getFloat(0) >>>;
    }
}