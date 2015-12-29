public class Sonifier {
    fun void sonifyShoot(OscMsg msg) {
        <<< "SHOOT:", "shot #", msg.getString(0), ", force:", msg.getFloat(1), "]" >>>;
    }

    fun void sonifyFootStep(OscMsg msg) {
        <<< "FOOTSTEP:", "footstep #", msg.getInt(0) >>>;
    }

    fun void sonifyExplode(OscMsg msg) {
        <<< "EXPLODE:", "distance:", msg.getFloat(0) >>>;
    }

    fun void sonifyEyeball(OscMsg msg) {
        <<< "EYEBALL:", "distance:", msg.getFloat(0) >>>;
    }
}