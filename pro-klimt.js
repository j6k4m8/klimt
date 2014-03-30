import processing.core.PApplet;
import processing.core.PImage;

@SuppressWarnings("serial")
public class ImageViewApplet extends PApplet {

	PImage img;
	float hue;
	static final int hueRange = 360;
	float saturation;
	float brightness;

	public void setup() {
		size(640,600);
		background(0);
		img = loadImage("" /* Your image here */);
		colorMode(HSB, (hueRange - 1));
		extractColorFromImage();
	}

	public void draw() {
		image(img, 0, 0, 640, 480);
		fill(hue, saturation, brightness);
		rect(0, 480, 640, 120);
	}

	private void extractColorFromImage() {
		img.loadPixels();
		int numberOfPixels = img.pixels.length;
		int[] hues = new int[hueRange];
		float[] saturations = new float[hueRange];
		float[] brightnesses = new float[hueRange];

		for (int i = 0; i < numberOfPixels; i++) {
			int pixel = img.pixels[i];
			int hue = Math.round(hue(pixel));
			float saturation = saturation(pixel);
			float brightness = brightness(pixel);
			hues[hue]++;
			saturations[hue] += saturation;
			brightnesses[hue] += brightness;
		}

		// Find the most common hue.
		int hueCount = hues[0];
		int hue = 0;
		for (int i = 1; i < hues.length; i++) {
 			if (hues[i] > hueCount) {
				hueCount = hues[i];
				hue = i;
			}
		}

		// Set the vars for displaying the color.
		this.hue = hue;
		saturation = saturations[hue] / hueCount;
		brightness = brightnesses[hue] / hueCount;
	}
}