/*
 * Sonifier class
 * (globalize it for now for grrobots)
 */
// public class Sonifier {

    // SOUND GENERATORS

    // 1. Shaker for gravel footstep
    Shakers shaker => dac;
    9 => shaker.preset; // crunch
    
    // 2. ModalBar for marble footstep
    ModalBar bar => NRev r => dac;
    1 => bar.preset;

    // 3. Square Plate for marble footstep
    28 => int NUM_MODES;
    440.0 => float BASEFREQ;

    [[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],
     [2,2],[2,3],[2,4],[2,5],[2,6],[2,7],
     [3,3],[3,4],[3,5],[3,6],[3,7],
     [4,4],[4,5],[4,6],[4,7],
     [5,5],[5,6],[5,7],
     [6,6],[6,7],
     [7,7]] @=> int modes[][];

    Impulse imp;
    ResonZ mode[NUM_MODES];

    for (int i;i<NUM_MODES;i++)   {
       500 => mode[i].Q;
       imp => mode[i] => dac;
       100.0 / (i+1) => mode[i].gain;
    }

    // 4. BlowBotl
    BlowBotl bottle => dac;
    Brass largeBottle => JCRev jc => dac;


    fun void sonifyShoot(OscMsg msg) {
        <<< "SHOOT:", "shot ", msg.getString(0), ", force:", msg.getFloat(1), "]" >>>;
        msg.getString(0) => string shotName;
        msg.getFloat(1) => float force;

        if (isFizzBuzz(shotName)) {
            blowBottleLarge(shotName, force);
        }
        else {
            blowBottleSmall(Std.atoi(shotName), force);
        }
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

            setFreqs(Math.random2f(220.0,880.0));
            0.5 => imp.next;

            0.25::second => now;
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
        <<< "EXPLODE:", "distance:", msg.getFloat(0), ", explosionType:", msg.getString(1) >>>;
    }

    fun void sonifyEyeball(OscMsg msg) {
        // <<< "EYEBALL:", "distance:", msg.getFloat(0) >>>;
    }


    fun void blowBottleSmall(int shotNum, float force) {
        ((shotNum % 5) + 1) * 200 => bottle.freq;
        ((shotNum % 5) + 1) * 600 => bottle.vibratoFreq;
        0.75 => bottle.vibratoGain;
        0.5 => bottle.noiseGain;
        0.5 => bottle.startBlowing;
        0.5::second => now;
        1.0 => bottle.stopBlowing;
    }

    fun void blowBottleLarge(string shot, float force) {
        500 => largeBottle.freq;
        100 => largeBottle.vibratoFreq;
        0.75 => largeBottle.vibratoGain;
        0.9 => largeBottle.lip;
        0.75 => largeBottle.startBlowing;
        1.0::second => now;
        1.0 => largeBottle.stopBlowing;
    }

    // UTILITIES

    fun void setFreqs(float freq)  {
        for (int i;i<NUM_MODES;i++)   {
            freq * Math.sqrt(modes[i][0]*modes[i][0] +
                                modes[i][1]*modes[i][1]) => mode[i].freq;
        }
    }

    fun int isFizzBuzz(string s) {
        if (s == "Fizz" || s == "Buzz" || s == "FizzBuzz") {
            return 1;
        }
        else {
            return 0;
        }
    }

// }




/*
 * OSC receivers for PhysBuzz!
 */

OscIn oin;
6449 => oin.port;
oin.listenAll();
OscMsg msg;

while (true) {
    while (oin.recv(msg)) {
        // <<< "got message:", msg.address, msg.typetag>>>;

        if (msg.address == "/PhysBuzz/Shoot") {
            sonifyShoot(msg);
        }
        else if (msg.address == "/PhysBuzz/FootStep") {
            sonifyFootStep(msg);
        }
        else if (msg.address == "/PhysBuzz/Explode") {
            sonifyExplode(msg);
        }
        else if (msg.address == "/PhysBuzz/Eyeball") {
            sonifyEyeball(msg);
        }
    }
}