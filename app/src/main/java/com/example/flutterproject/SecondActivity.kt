package com.example.flutterproject

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec

class SecondActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterEngine?.dartExecutor?.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        back()
    }
    private fun back(){
        //设置消息通道
        val messenger = flutterEngine?.dartExecutor?.getBinaryMessenger()
        messenger?.let {
            val basicMessageChannel =
                BasicMessageChannel(messenger, "通道名", StandardMessageCodec.INSTANCE)
            basicMessageChannel.setMessageHandler { message, reply ->
                if (message == "back"){
                    setResult(RESULT_OK)
                    finish()
                }
            }
        }

    }
}