import QtQuick
import QtQuick.Effects

Item {
    id: root
    property var values: []
    property int bars: 50
    property bool out: true
    property real blurRadius: 10
    property color accentColor: "#1E4BB1" // Darker blue
    
    // Original math constants from Flutter
    readonly property real a: out ? 2.0 : 1.3
    readonly property real b: out ? 1.0 : 1.2
    
    onValuesChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        renderTarget: Canvas.FramebufferObject
        
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            
            if (!values || values.length === 0) return;

            var centerX = width / 2;
            var centerY = height / 2;
            var baseRadius = Math.min(width, height) / 2.5; // Adjusted to match scale
            
            ctx.save();
            ctx.translate(centerX, centerY);

            var points = [];
            for (var i = 0; i < values.length; i++) {
                var progress = i / (values.length - 1);
                var angle = progress * Math.PI * 2 - Math.PI / 2;
                
                // Flutter math: length = a * pow(values[i], b)
                // then end = offset * (1 + length)
                var val = values[i] || 0;
                var length = a * Math.pow(val, b);
                var r = (width / 2) * (1 + (out ? length * 0.2 : -length * 0.3)); // Scaled to fit canvas

                points.push({
                    x: Math.cos(angle) * r,
                    y: Math.sin(angle) * r
                });
            }

            // Spline path (Quadratic Bezier as in Flutter)
            function drawSpline(context, pts) {
                if (pts.length < 3) return;
                context.beginPath();
                var mx0 = (pts[0].x + pts[pts.length - 1].x) / 2;
                var my0 = (pts[0].y + pts[pts.length - 1].y) / 2;
                context.moveTo(mx0, my0);

                for (var j = 0; j < pts.length; j++) {
                    var next = (j + 1) % pts.length;
                    var mx = (pts[j].x + pts[next].x) / 2;
                    var my = (pts[j].y + pts[next].y) / 2;
                    context.quadraticCurveTo(pts[j].x, pts[j].y, mx, my);
                }
                context.closePath();
            }

            // Gradient stops match background.dart
            var grad = ctx.createRadialGradient(0, 0, 0, 0, 0, width / 2);
            grad.addColorStop(0.17, 'transparent');
            grad.addColorStop(0.57, 'transparent');
            grad.addColorStop(0.7, Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.7));
            grad.addColorStop(0.8, Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.2));
            
            ctx.fillStyle = grad;
            drawSpline(ctx, points);
            ctx.fill();

            // Handle the second paint path for inner visualizer (out: false)
            if (!root.out) {
                var grad2 = ctx.createRadialGradient(0, 0, 0, 0, 0, width / 2);
                grad2.addColorStop(0.709, 'transparent');
                grad2.addColorStop(0.71, Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.1));
                
                ctx.fillStyle = grad2;
                // Draw same path but with different fill
                drawSpline(ctx, points);
                ctx.fill();
            }

            ctx.restore();
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: root.blurRadius > 0
            blur: root.blurRadius / 100.0 // Normalize for MultiEffect
            brightness: 1.1
        }
    }
}
