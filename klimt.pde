function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}



class HSBVector {
    int H, S, B;

    public HSBVector(int h, int s, int b) {
        H = h;
        S = s;
        B = b;
    }

    public String toRGB() {
        return "rgb(" + (int)red(color(H, S, B)) + ", " +
            (int)green(color(H, S, B)) + ", " +
            (int)blue(color(H, S, B)) + ")";
    }

    public String toHex() {
        return rgbToHex((int)(255*((int)red(color(H, S, B)))/359),
            (int)(255*((int)green(color(H, S, B)))/359),
            (int)(255*((int)blue(color(H, S, B)))/359));
    }
}


PImage img;
static final int hueRange = 360;

public void setup() {
    size(640, 600);
    background(0);
    noStroke();
    colorMode(HSB, (hueRange - 1));
}

public void setImg(String filename) {
    img = requestImage(filename, "", drawOnce);
}

public void drawOnce() {
    image(img, 0, 0, 640, 480);
    readColors();
}


private void readColors() {
    img.loadPixels();
    int[] hues = new int[hueRange];
    float[] sats = new float[hueRange];
    float[] bris = new float[hueRange];

    for (int i = 0; i < img.pixels.length; i++) {
        int p = img.pixels[i];

        int h0 = (int)(hue(p));
        float s0 = saturation(p);
        float b0 = brightness(p);
        hues[h0]++;
        if (s0 > sats[h0]) sats[h0] = s0;
        bris[h0] += b0;
    }

    //    int bin = 32;//, sat = 0, satSum = 0;
    //    for (int i = bin; i < 360; i+=bin) {
    //        int maxHueIndex = 0;
    //        int satSum = 0;
    //        for (int j = i - bin/4; j < i + bin/4; j++) {
    //            satSum += saturations[j];
    //            if (saturations[j] >= saturations[maxHueIndex]) {
    //                maxHueIndex = j;
    ////
    //            }
    //        }
    //        //int sat = (int)(saturations[maxHueIndex]);// / (hues[maxHueIndex]));
    //        int bri = (int)(brightnesses[maxHueIndex] / (.1*hues[maxHueIndex]));

    int pos=-1;
    int max=-1;
    for (int i=0;i<hues.length;i++)
    {
        if (hues[i]>max)
        {
            pos=i;
            max=hues[i];
        }
    }
     ArrayList<HSBVector> pts = new ArrayList<HSBVector>();

    pts.add(new HSBVector(pos, (int)sats[pos], (int)bris[pos]/hues[pos]));

    // println(bris[pos]);
    fill(pos, sats[pos], bris[pos]/hues[pos]);
    rect(0, 480, width, 400);

    int cannots = 0;

    for (int i = 0; i < 15; i++) {
        int r = (int) random(img.pixels.length);
        int h = (int)hue(img.pixels[r]),
        b = (int)brightness(img.pixels[r]),
        s = (int)saturation(img.pixels[r]);
        boolean canAdd = true;
        for (HSBVector t : pts) {
            if (cannots<10 && abs(h - t.H) < 5 || b < 100 || s < 150) {
                canAdd = false;
                cannots+=1;
                i--;
                break;
            }
        }
        if (canAdd) {
            pts.add(new HSBVector(h, s, b));
        }
    }

    document.getElementById('output').innerHTML = "";

    for (int i = 0; i < pts.size(); i++) {
        fill(pts.get(i).H, pts.get(i).S, pts.get(i).B);
        rect(i * 30, 540, 30, 40);
        console.log("%c " + pts.get(i).toHex(), "background-color: " + pts.get(i).toHex());
        document.getElementById('output').innerHTML += "<span style='background-color: " + pts.get(i).toHex() + "; color: black; font-family: monospace;'>" + pts.get(i).toHex() + "</span><br>";
    }

    for (int i=0; i < 16; i++) {
        baseTemp = baseTemp.replace('<%= @base["0' + i.toString(16).toUpperCase()  + '"]["hex"] %>', pts.get(i).toHex(), "gi");
        console.log('<%= @base["0' + i.toString(16)  + '"]["hex"] %>');
    }

        baseTemp = baseTemp.replace('<%= @scheme %>', "", "gi");
        baseTemp = baseTemp.replace('<%= @slug %>', "", "gi");
        baseTemp = baseTemp.replace('<%= @uuid %>', "", "gi");

    document.getElementById('output-theme').innerText = baseTemp;

}



