package de.reikodd.ddweki;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends Activity implements View.OnClickListener {

    private DrawingView drawView;
    private Button clearButton,saveButton;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        drawView = (DrawingView)findViewById(R.id.drawing);
        clearButton = (Button)findViewById(R.id.clear);
        clearButton.setOnClickListener(this);
        saveButton = (Button) findViewById(R.id.save);
        saveButton.setOnClickListener(this);
        getActionBar().setTitle("DDWEKI     Version:" + BuildConfig.VERSION_NAME);
    }

    @Override
    public void onClick(View view)
    {
        if(view.getId()==R.id.clear)
        {
            drawView.startNew();
        }

        if(view.getId()==R.id.save)
        {
            drawView.postJson();
            Toast.makeText(MainActivity.this,
                    "JSON send to database", Toast.LENGTH_LONG).show();
            drawView.startNew();
        }
    }
}