//
//  Noise.metal
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/21/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 noise(float2 position, half4 currentColor, float time) {
    float scale = 5; // Adjust this value to make noise bigger (0.1 = large noise, 10.0 = small noise)
    float value = fract(sin(dot(position * scale + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * currentColor.a;
}
