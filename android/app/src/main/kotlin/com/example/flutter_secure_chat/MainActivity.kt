package com.example.flutter_secure_chat

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ekran rasmini olishni bloklash
        window.setFlags(
            LayoutParams.FLAG_SECURE,
            LayoutParams.FLAG_SECURE
        )
    }
}
