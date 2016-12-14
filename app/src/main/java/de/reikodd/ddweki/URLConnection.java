package de.reikodd.ddweki;

import android.os.AsyncTask;
import android.util.Log;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class URLConnection extends AsyncTask<String, String, String> {

    @Override
    protected String doInBackground(String... urls) {

        try {
            URL url = new URL(urls[0]);
            String input = urls[1];
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("connection", "close");
            OutputStream os = conn.getOutputStream();
            os.write(input.getBytes());
            os.flush();
            int resp = conn.getResponseCode();
            if(conn.getResponseCode() == 200) {
                Log.i("Reiko", "" + urls[0] + " - POST Success " + resp);
            }
            else
            {
                Log.i("Reiko", "Fehler: " + resp);
            }
            conn.disconnect();

            return null;

        } catch (MalformedURLException rat) {
            rat.printStackTrace();
            Log.i("Reiko", ""+rat);
            return null;
        } catch (Exception rat) {
            Log.i("Reiko", ""+rat);
            return null;
        }
    }

    @Override
    protected void onPostExecute(String result) {

    }


}