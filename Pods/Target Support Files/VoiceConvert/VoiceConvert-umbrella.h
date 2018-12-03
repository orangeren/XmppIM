#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EMVoiceConverter.h"
#import "amrFileCodec.h"
#import "wav.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "dec_if.h"
#import "if_rom.h"

FOUNDATION_EXPORT double VoiceConvertVersionNumber;
FOUNDATION_EXPORT const unsigned char VoiceConvertVersionString[];

