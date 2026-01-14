import QtQuick

Item {
    id: root
    property var audioData: null // Pass the data texture here
    property int bars: 50
    property bool out: true
    property real blurRadius: 10
    property color accentColor: "#1E4BB1"
    
    readonly property real a: out ? 2.0 : 1.3
    readonly property real b: out ? 1.0 : 1.2
    
    ShaderEffect {
        id: shader
        anchors.fill: parent
        
        property var audioData: root.audioData
        property color accentColor: root.accentColor
        property real a: root.a
        property real b: root.b
        property bool isOut: root.out
        property real blur: root.blurRadius / 100.0

        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform highp float qt_Opacity;
            uniform lowp sampler2D audioData;
            uniform lowp vec4 accentColor;
            uniform highp float a;
            uniform highp float b;
            uniform bool isOut;
            uniform highp float blur;

            const float PI = 3.14159265359;

            void main() {
                vec2 uv = qt_TexCoord0 - 0.5;
                float dist = length(uv) * 2.1;
                float angle = atan(uv.y, uv.x) + PI / 2.0;
                if (angle < 0.0) angle += 2.0 * PI;
                
                float t = angle / (2.0 * PI);
                float val = texture2D(audioData, vec2(t, 0.5)).r;
                
                float len = a * pow(val, b);
                float target_r;
                if (isOut) {
                    target_r = 0.5 + len * 0.15;
                } else {
                    target_r = 0.5 - len * 0.2;
                }

                float mask = smoothstep(target_r + blur, target_r - blur, dist);
                
                float g = 0.0;
                if (isOut) {
                    if (dist > 0.4 && dist < 1.0) {
                        if (dist < 0.7) g = mix(0.0, 0.7, (dist - 0.4) / 0.3);
                        else if (dist < 0.8) g = mix(0.7, 0.2, (dist - 0.7) / 0.1);
                        else g = mix(0.2, 0.0, (dist - 0.8) / 0.2);
                    }
                } else {
                    if (dist < 0.6) {
                        g = mix(1.0, 0.0, dist / 0.6);
                    }
                }

                gl_FragColor = accentColor * g * mask * qt_Opacity;
            }
        "
    }
}
