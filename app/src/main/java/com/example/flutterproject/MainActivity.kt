package com.example.flutterproject

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.view.FlutterMain

class MainActivity : AppCompatActivity() {
    private val tv by lazy { findViewById<TextView>(R.id.tv) }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        var engine = FlutterEngine(this)
        //设置缓存
         engine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());
FlutterEngineCache.getInstance().put("main flutter",engine)
        engine.dartExecutor.executeDartEntrypoint(
            DartEntrypoint(
                FlutterMain.findAppBundlePath(),
                "main"
            )
        )
        tv.setOnClickListener {
//            startActivity(FlutterActivity.withCachedEngine("main flutter").build(this))
            startActivityForResult(Intent(this,SecondActivity::class.java),101)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode==101){
            tv.text = "已从flutter页面返回"
        }
    }

    private fun goToFlutterActivity(){

    }
}