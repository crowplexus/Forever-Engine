package forever.ui;

import flixel.text.FlxText;
import forever.ui.base.ForeverTextField;

class ForeverText extends FlxText {
	/**
	 * Creates a new `ForeverText` object at the specified position.
	 *
	 * @param   x              The x position of the text.
	 * @param   y              The y position of the text.
	 * @param   width          The `width` of the text object. Enables `autoSize` if `<= 0`.
	 *                         (`height` is determined automatically).
	 * @param   text           The actual text you would like to display initially.
	 * @param   size           The font size for this text object.
	**/
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, text:String, size:Int = 10):Void {
		super(x, y, width, text, size);

		/*
			super(x, y);

			this.text = text;
			_width = Math.floor(width);
			font = AssetHelper.getAsset("vcr", FONT);
			_size = size;
		 */

		setFormat(AssetHelper.getAsset("vcr", FONT), size, 0xFFFFFFFF, LEFT, OUTLINE, 0xFF000000);
	}
}
