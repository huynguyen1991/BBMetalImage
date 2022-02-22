//
//  BBMetalBulgeFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 8/16/20.
//  Copyright © 2020 Kaibo Lu. All rights reserved.
//
#include <metal_stdlib>
using namespace metal;

kernel void PixellatePositionKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                        texture2d<half, access::sample> inputTexture [[texture(1)]],
                        constant float2 *centerPointer [[buffer(0)]],
                        constant float *radiusPointer [[buffer(1)]],
                        constant float *fractionalWidth [[buffer(2)]],
                        uint2 gid [[thread_position_in_grid]]) {
    
    if ((gid.x >= outputTexture.get_width()) || (gid.y >= outputTexture.get_height())) { return; }

    float2 center = float2(*centerPointer);
    float radius =  float(*radiusPointer);
    float fractionalWidthOfPixel = float(*fractionalWidth);

    float aspectRatio = float(inputTexture.get_height()) / float(inputTexture.get_width());
    const float2 inCoordinateToUse = float2(float(gid.x) / outputTexture.get_width(), float(gid.y) / outputTexture.get_height());
    float2 textureCoordinateToUse = float2(inCoordinateToUse.x, (inCoordinateToUse.y - center.y) * aspectRatio + center.y);
    
    float dist = distance(center, textureCoordinateToUse);
    half4 outputColor;
    constexpr sampler inputSampler (mag_filter::linear, min_filter::linear);
    
    if (dist < radius) {
        float2 sampleDivisor = float2(fractionalWidthOfPixel, fractionalWidthOfPixel / aspectRatio);
        float2 samplePos = inCoordinateToUse - fmod(inCoordinateToUse, sampleDivisor) + 0.5 * sampleDivisor;
        outputColor = inputTexture.sample (inputSampler, samplePos);
    } else {
        outputColor = inputTexture.sample (inputSampler, inCoordinateToUse);
    }
    
    outputTexture.write(outputColor, gid);
}
