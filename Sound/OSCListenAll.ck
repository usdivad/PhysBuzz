//  Listen for all incoming messages on port

OscIn oin;        // make an OSC receiver
6449 => oin.port;  // set port #
oin.listenAll();  //   any message at all

OscMsg msg;   // message holder

while(true)
{
    oin => now;   // wait for any OSC
    
    while(oin.recv(msg))
    {
        <<< "got message:", msg.address, msg.typetag, "[", msg.getFloat(0), ",", msg.getFloat(1), ",", msg.getFloat(2), "]" >>>;
    }
}

