package backend.system;

/**
 * Implement this interface in any class so Conductor can automatically handle its events.
 * @author crowplexus
 **/
interface BeatSynced {
  public function onBeat(beat: Int): Void;
  public function onStep(step: Int): Void;
  public function onBar (bar:  Int): Void;
}

class Conductor extends flixel.FlxBasic {
  public static var time: Float = 0;
  public static var bpm(default, set): Float = 100;
  public static var rate: Float = 1;

  public static var enabled: Bool = false;

  public static var stepsPerBeat: Int = 4;
  public static var beatsPerBar : Int = 4;

  public static var stepf: Float = 0;
  public static var beatf: Float = 0;
  public static var barf:  Float = 0;

  public static var beat(get, never): Int;
  public static var step(get, never): Int;
  public static var bar (get, never): Int;

  public static var crochet: Float = 0;
  public static var stepCrochet: Float = 0;

  @:noCompletion private var _lastTime: Float = 0.0;

  public function new() {
    super();
    reset();
  }

  public static function reset(?_bpm: Float = -1, ?doActivate: Bool = false) {
    stepf = beatf = barf = 0;
    if (_bpm != -1) bpm = _bpm;
    enabled = doActivate;
  }

  public override function update(elapsed: Float) {
    if (!enabled) return;

    super.update(elapsed);

    final dt: Float = lime.system.System.getTimer();
    time += dt;

    if (FlxG.sound.music != null && FlxG.sound.music.playing)
      if (Math.abs(time - FlxG.sound.music.time) > 5)
        time = FlxG.sound.music.time;

    final beatdt: Float = ((bpm/60)*1000.0) * (time - _lastTime);
    if (beat != Math.floor(beatf += beatdt               ) ) beatHit(step);
    if (step != Math.floor(stepf += beatdt * stepsPerBeat) ) stepHit(beat);
    if (bar  != Math.floor(barf  += beatdt / beatsPerBar ) ) barHit (bar );
    _lastTime = time;
  }

  // --------------------------------------------------------- //
  //                Music Sync Functions                       //
  // NOTE: if this is slower than emitting a signal, change it //
  // --------------------------------------------------------- //

  // sanity checks (because I'm sure as hell going insane) -Crow
  @:noCompletion private var _oldStep: Int = 0;
  @:noCompletion private var _oldBeat: Int = 0;
  @:noCompletion private var _oldBar: Int  = 0;

  private function stepHit(receivedStep: Int) {
    if (_oldStep == receivedStep) return;
    if (FlxG.state is BeatSynced) {
      cast(FlxG.state, BeatSynced).onStep(receivedStep);
      if (FlxG.state.subState != null && FlxG.state.subState is BeatSynced)
	cast(FlxG.state.subState, BeatSynced).onStep(receivedStep);
    }
    _oldStep = receivedStep;
  }

  private function beatHit(receivedBeat: Int) {
    if (_oldBeat == receivedBeat) return;
    if (FlxG.state is BeatSynced) {
      cast(FlxG.state, BeatSynced).onBeat(receivedBeat);
      if (FlxG.state.subState != null && FlxG.state.subState is BeatSynced)
	cast(FlxG.state.subState, BeatSynced).onBeat(receivedBeat);
    }
   _oldBeat = receivedBeat;
  }

  private function barHit (receivedBar: Int) {
    if (_oldBar == receivedBar) return;
    if (FlxG.state is BeatSynced) {
      cast(FlxG.state, BeatSynced).onBar (receivedBar);
      if (FlxG.state.subState != null && FlxG.state.subState is BeatSynced)
	cast(FlxG.state.subState, BeatSynced).onBar (receivedBar);
   }
    _oldBar = receivedBar;
  }

  // ----------------- //
  // Getters & Setters //
  // ----------------- //

  inline static function get_beat() { return Math.floor(beatf); }
  inline static function get_step() { return Math.floor(stepf); }
  inline static function get_bar () { return Math.floor(barf ); }

  inline static function set_bpm(newBpm: Float) {
    crochet = (60 / newBpm) * 1000.0;
    stepCrochet = (crochet * 0.25);
    return bpm = newBpm;
  }
}
