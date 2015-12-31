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
    ModalBar bar => NRev r => Chorus chorus => dac;
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

    // 4. PulseOsc for small shot
    PulseOsc pulse => PRCRev prc => dac;
    1.0 => pulse.phase;
    0 => pulse.sync;
    0.5 => pulse.width;
    0 => pulse.gain;
    0.1 => prc.mix;

    // 5. Brass for big shot
    Brass brass => JCRev jc => dac;


    // 6. BlowBotl for eyeball
    BlowBotl botl => r => dac;
    0.0 => botl.volume;
    400 => botl.freq;
    // 400.0 => float botl_lastFreq;
    // 10.0 => float botl_maxStep; 

    // 0.5 => botl.noteOn;

    // 7. Shakers for flare explosion
    Shakers es1 => jc => dac; // explosion shaker 1
    Shakers es2 => prc => dac; // explosion shaker 2

    12 => es1.preset; // coke can
    128 => es1.objects;
    1.0 => es1.energy;
    0.75 => es1.decay;
    0.0 => es1.noteOn;

    11 => es2.preset; // sandpaper
    128 => es2.objects;
    1.0 => es2.energy;
    0.75 => es2.decay;
    0.0 => es2.noteOn;

    // 8. Shaker, Sitar, and beat-interference SinOscs for explosion explosion
    Shakers es3 => PitShift ps => jc => dac;
    Sitar sitar => ps => jc => dac;
    SinOsc sin1 => ADSR sinAdsr => prc => dac;
    SinOsc sin2 => sinAdsr => prc => dac;

    22 => es3.preset; // tuned bamboo
    128 => es3.objects;
    1.0 => es3.energy;
    0.75 => es3.decay;
    0.0 => es3.noteOn;

    1.0 => ps.mix;
    0.1 => ps.shift;

    0 => sin1.gain;
    0 => sin2.gain;

    sinAdsr.set(10::ms, 8::ms, 1.0, 500::ms);


    fun void sonifyShoot(OscMsg msg) {
        <<< "SHOOT:", "shot ", msg.getString(0), ", force:", msg.getFloat(1), "]" >>>;
        msg.getString(0) => string shotName;
        msg.getFloat(1) => float force;

        if (isFizzBuzz(shotName)) {
            spork ~ largeShot(shotName, force);
        }
        else {
            spork ~ smallShot(Std.atoi(shotName), force);
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
        msg.getFloat(0) => float distance;
        msg.getString(1) => string explosionType;

        if (explosionType == "flare") {
            spork ~ explodeFlare(distance);
        }
        else {
            // spork ~ explodeFlare(distance);
            spork ~ explodeExplosion(distance);
        }
    }

    fun void sonifyEyeball(OscMsg msg) {
        // <<< "EYEBALL:", "distance:", msg.getFloat(0) >>>;
        msg.getFloat(0) => float distance;
        1 - (Math.exp(distance) * 0.0001) => float gain;
        // (1 - (distance/25)) => float gain;
        Math.max(0.1, gain) => float vol;
        // <<<gain, vol>>>;
        Math.random2f(380.0, 420.0) => botl.freq;
        vol => botl.noteOn;
        Math.max(0.25, gain) => botl.noiseGain;

        // botl.freq() / 4 => float sin1Freq;
        // sin1Freq + Math.random2f(1, 3) => float sin2Freq;
        // sin1Freq => sin1.freq;
        // sin2Freq => sin2.freq;
        // vol => sin1.gain;
        // vol => sin2.gain;
    }


    fun void smallShot(int shotNum, float force) {
        ((shotNum % 5) + 1) * 200 => pulse.freq;
        ((shotNum % 5) + 1) * 217 => pulse.sfreq;
        // ((shotNum % 5) + 1) * 600 => pulse.vibratoFreq;
        // 0.5 => pulse.volume;
        // 0.75 => pulse.vibratoGain;
        // 0.5 => pulse.noiseGain;
        0.035 => pulse.gain;
        0.05::second => now;
        0.0 => pulse.gain;
    }

    fun void largeShot(string shot, float force) {
        // <<<force*4>>>;
        // force * 4 => brass.freq;

        Math.random2f(400.0, 500.0) => brass.freq;
        <<<brass.freq()>>>;
        100 => brass.vibratoFreq;
        0.75 => brass.vibratoGain;
        0.9 => brass.lip; // higher values make it go cray!
        0.75 => brass.startBlowing;
        1.0::second => now;
        1.0 => brass.stopBlowing;
    }

    fun void explodeFlare(float distance) {
        setVolumeFromDistance(distance) => float gain;
        Math.max(0.1, gain) => float vol;
        <<<gain, vol>>>;

        Math.random2f(100.0, 500.0) => es1.freq;
        vol => es1.noteOn;

        Math.random2f(100.0, 500.0) => es2.freq;
        vol => es2.noteOn;
    }

    fun void explodeExplosion(float distance) {
        setVolumeFromDistance(distance) => float gain;
        Math.max(0.1, gain) => float vol;
        <<<gain, vol>>>;

        Math.random2f(10.0, 50.0) => es3.freq;
        vol => es3.noteOn;

        Math.random2f(50,60) => sitar.freq;
        vol * 0.75 => sitar.noteOn;

        Math.random2f(90, 110) => float sin1Freq;
        sin1Freq + Math.random2f(1, 3) => float sin2Freq;
        sin1Freq => sin1.freq;
        sin2Freq => sin2.freq;
        vol * 0.3 => sin1.gain;
        vol * 0.2 => sin2.gain;

        sinAdsr.keyOn();
        0.75::second => now;
        sinAdsr.keyOff();
        // 0 => sin1.gain;
        // 0 => sin2.gain;
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

    fun float setVolumeFromDistance(float distance) {
        return ((1 - (distance / 25)) * 1.5);
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
    oin => now;
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