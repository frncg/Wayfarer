//
//  CRT Effect.metal
//  Wayfarer
//
//  Created by Christian Privelli on 2/7/25.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float2 distort(float2 uv, float strength) {
    float2 dist = 0.5 - uv;
    uv.x = (uv.x - dist.y * dist.y * dist.x * strength);
    uv.y = (uv.y - dist.x * dist.x * dist.y * strength);
    return uv;
}

[[stitchable]]
half4 crtEffect(float2 position, SwiftUI::Layer layer, float time, float2 size) {
    float2 uv = position / size;

    uv = distort(uv, 0);
    
    // render color
    half4 col;
    col.r = layer.sample(float2(uv.x, uv.y) * size).r;
    col.g = layer.sample(float2(uv.x, uv.y) * size).g;
    col.b = layer.sample(float2(uv.x, uv.y) * size).b;
    col.a = layer.sample(float2(uv.x, uv.y) * size).a;
    
    // brighten image
    float contrast = 1.2; // >1.0 increases contrast, <1.0 decreases
    col.rgb = 0.5 + (col.rgb - 0.5) * contrast;
    col *= 1.4
    ;
    
    // add scan lines
    float scans = clamp(0.35 + 0.35 * sin(3.5 * time + uv.y * size.y * 2.5), 0.0, 1.0);
    float s = pow(scans, 1.5);
    float sn = 0.4 + 0.7 * s;
    col = col * half4(sn, sn, sn, 0.8);

    // normalise color
    col *= 1.0 + 0.01 * sin(110.0 * time);
    float c = clamp((fmod(position.x, 2.0) - 1.5) * 2.0, 0.0, 1.0);
    col *= 1.0 - 0.65 * half4(c, c, c, 1);

    return col;
}
