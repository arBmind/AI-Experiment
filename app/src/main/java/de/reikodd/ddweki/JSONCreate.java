package de.reikodd.ddweki;

import java.util.HashMap;

public class JSONCreate {
    HashMap<Integer, HashMap<Integer, String>> data = new HashMap<Integer, HashMap<Integer, String>>();

    static JSONCreate jSONCreate=new JSONCreate();

    public void put(int x, int y, String value) {
        HashMap<Integer, String> m = data.get(x);
        if (m == null)
            m = new HashMap<Integer, String>();
        m.put(y, value);
        data.put(x, m);
    }

    public String get(int x, int y) {
        HashMap<Integer, String> m = data.get(x);
        if (m == null)
            return null;
        return m.get(y);
    }

    public int sizex(int x) {
        HashMap<Integer, String> m = data.get(x);
        if (m == null)
            return 0;
        return m.size();
    }

    public void clear() {
        data.clear();
    }

}