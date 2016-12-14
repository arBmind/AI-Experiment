package de.reikodd.ddweki;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * zeichnet eine Linie in ein Canvas
 */
public class DrawingView extends View {

    private Path drawPath;
    private Paint drawPaint, canvasPaint;
    private Canvas drawCanvas;
    private Bitmap canvasBitmap;
    static long startTime = 0;
    static String DeviceModel = Build.MODEL;
    int recordcount=0;
    int strokecount=1;
    int recordSize=0;
    int recordOutputSize=0;


    DecimalFormat decimalFormat = new DecimalFormat("0.00000");
    JSONCreate jsonCreate = new JSONCreate();
    Context context;

    public DrawingView(Context context) {
        super(context);
        this.context = context;
        setUpDrawing();
    }

    public DrawingView(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        setUpDrawing();
    }

    public DrawingView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.context = context;
        setUpDrawing();
    }

    private void setUpDrawing() {
        drawPath = new Path();
        drawPaint = new Paint();
        drawPaint.setAntiAlias(true);
        drawPaint.setColor(Color.BLACK);
        drawPaint.setStrokeWidth(3);
        drawPaint.setStrokeCap(Paint.Cap.ROUND);
        drawPaint.setStrokeJoin(Paint.Join.ROUND);
        drawPaint.setStyle(Paint.Style.STROKE);
        canvasPaint = new Paint(Paint.DITHER_FLAG);
    }

    public void startNew() {
        drawCanvas.drawColor(0, PorterDuff.Mode.CLEAR);
        TextView txtView = (TextView) ((Activity) context).findViewById(R.id.Data);
        txtView.setText("");
        recordcount=0;
        recordSize=0;
        recordOutputSize=0;
        strokecount=1;
        jsonCreate.clear();
        invalidate();
        startTime = System.currentTimeMillis();
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        canvas.drawBitmap(canvasBitmap, 0, 0, canvasPaint);
        canvas.drawPath(drawPath, drawPaint);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        canvasBitmap = Bitmap.createBitmap(w, h,
                Bitmap.Config.ARGB_8888);
        drawCanvas = new Canvas(canvasBitmap);
        drawCanvas.drawColor(Color.WHITE);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {

        float touchX = event.getX();
        float touchY = event.getY();

        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                drawPath.moveTo(touchX, touchY);
                break;

            case MotionEvent.ACTION_MOVE:
                recordcount++;
                recordSize++;

                double showTimeDouble = (double) (System.currentTimeMillis() - startTime) / 1000.;
                TextView txtView = (TextView) ((Activity) context).findViewById(R.id.Data);
                drawPath.lineTo(touchX, touchY);

                String jsonOutput = "{" +
                        "\"x\":" + decimalFormat.format(event.getX()).replace(",", ".") + "," +
                        "\"y\":" + decimalFormat.format(event.getY()).replace(",", ".") + "," +
                        "\"t\":" + decimalFormat.format(showTimeDouble).replace(",", ".") + "," +
                        "\"p\":" + decimalFormat.format(event.getPressure()).replace(",", ".") + "}";

                txtView.setText(jsonOutput);
                jsonCreate.put(strokecount, recordcount, jsonOutput);

                Log.i("Reiko", jsonOutput);
                lastTime = startTime;
                break;

            case MotionEvent.ACTION_UP:
                drawPath.lineTo(touchX, touchY);
                drawCanvas.drawPath(drawPath, drawPaint);
                drawPath.reset();
                recordcount=0;
                strokecount++;
                Log.i("Reiko", "neuer Stroke");
                break;
            default:
                return false;
        }
        invalidate();
        return true;
    }

    public void writeToSDFile(){

        File root = android.os.Environment.getExternalStorageDirectory();
        File dir = new File (root.getAbsolutePath() + "/Reiko");
        dir.mkdirs();
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String filename = sdf.format(c.getTimeInMillis()) + ".txt";
        EditText desctxt = (EditText) ((Activity)context).findViewById(R.id.Description);
        File file = new File(dir, filename);
        int stroke = 1;
        String description = desctxt.getText().toString();

        try {
            FileOutputStream f = new FileOutputStream(file);
            PrintWriter pw = new PrintWriter(f);
            StringBuilder sb = new StringBuilder();
            if (jsonCreate.sizex(stroke) == 0) {
                pw.write("keine Daten" + "\r\n");
                sb.append("keine Daten");
            } else {
                pw.write("[{" + "\r\n");
                sb.append("[{\n");
                pw.write("\"strokes\":[" + "\r\n");
                sb.append("\"strokes\":[\n");

                for (int i = 1; i <= jsonCreate.sizex(stroke); i++) {
                    recordOutputSize++;

                    if(i==1)
                    {
                        pw.write("[");
                        sb.append("[");
                    }

                    if(i<jsonCreate.sizex(stroke))
                    {
                        pw.write(jsonCreate.get(stroke, i)+"," + "\r\n");
                        sb.append(jsonCreate.get(stroke, i) + ",\n");
                    }

                    if(i == jsonCreate.sizex(stroke) && recordOutputSize<recordSize)
                    {
                        pw.write(jsonCreate.get(stroke, i)+"]," + "\r\n");
                        sb.append(jsonCreate.get(stroke, i) + "],\n");
                    }

                    if(i == jsonCreate.sizex(stroke) && recordOutputSize==recordSize)
                    {
                        pw.write(jsonCreate.get(stroke, i)+"]" + "\r\n");
                        sb.append(jsonCreate.get(stroke, i) + "]\n");
                    }

                    if (i == jsonCreate.sizex(stroke)) {
                        stroke++;
                        i = 0;
                        if (jsonCreate.sizex(stroke) == 0) {
                            pw.write("]," + "\r\n");
                            sb.append("],\n");
                            pw.write("\"description\":\""+ description + "\"," + "\r\n");
                            sb.append("\"description\":\""+ description + "\"," + "\n");
                            pw.write("\"client\":\""+ DeviceModel +"\"" + "\r\n");
                            sb.append("\"client\":\""+ DeviceModel +"\"" + "\n");
                            pw.write("}]");
                            sb.append("}]");
                        }
                    }
                }
            }
            pw.flush();
            pw.close();
            f.close();
            new URLConnection().execute("http://52.212.255.218/datas/",sb.toString());
            //new URLConnection().execute("http://groens.ch/ai-experment-api/datas",sb.toString());

        } catch (FileNotFoundException e) {
            e.printStackTrace();
            Log.i("Reiko", "Datei nicht gefunden");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
