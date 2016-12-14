package de.reikodd.ddweki;

import java.util.List;

public class JSONCreate {
    List<String> strokes = new List<String>();

    List<String> stroke = new List<String>();

    public void addStroke(String value) {
        stroke.add(value);
    }

    public void endstroke() {
        strokes.add("[" + String.join(",", stroke) + "]");
        stroke.clear();
    }

    public String getJSON() {
        return "[" + String.join(",", strokes) + "]";
    }

    public void clear() {
        strokes.clear();
        stroke.clear();
    }
}
