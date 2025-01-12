KeyConversion = {}

-- taken from OpenOS, translated to love2d keys
KeyConversion["1"]           = 0x02
KeyConversion["2"]           = 0x03
KeyConversion["3"]           = 0x04
KeyConversion["4"]           = 0x05
KeyConversion["5"]           = 0x06
KeyConversion["6"]           = 0x07
KeyConversion["7"]           = 0x08
KeyConversion["8"]           = 0x09
KeyConversion["9"]           = 0x0A
KeyConversion["0"]           = 0x0B
KeyConversion.a               = 0x1E
KeyConversion.b               = 0x30
KeyConversion.c               = 0x2E
KeyConversion.d               = 0x20
KeyConversion.e               = 0x12
KeyConversion.f               = 0x21
KeyConversion.g               = 0x22
KeyConversion.h               = 0x23
KeyConversion.i               = 0x17
KeyConversion.j               = 0x24
KeyConversion.k               = 0x25
KeyConversion.l               = 0x26
KeyConversion.m               = 0x32
KeyConversion.n               = 0x31
KeyConversion.o               = 0x18
KeyConversion.p               = 0x19
KeyConversion.q               = 0x10
KeyConversion.r               = 0x13
KeyConversion.s               = 0x1F
KeyConversion.t               = 0x14
KeyConversion.u               = 0x16
KeyConversion.v               = 0x2F
KeyConversion.w               = 0x11
KeyConversion.x               = 0x2D
KeyConversion.y               = 0x15
KeyConversion.z               = 0x2C

KeyConversion["'"]            = 0x28
KeyConversion["@"]            = 0x91
KeyConversion.backspace       = 0x0E -- backspace
KeyConversion["\\"]           = 0x2B
KeyConversion.capslock        = 0x3A -- capslock
KeyConversion[":"]            = 0x92
KeyConversion[","]            = 0x33
KeyConversion["return"]       = 0x1C
KeyConversion["="]            = 0x0D
KeyConversion["`"]            = 0x29 -- accent grave
KeyConversion["["]            = 0x1A
KeyConversion.lctrl           = 0x1D
KeyConversion.lalt            = 0x38 -- left Alt
KeyConversion.lshift          = 0x2A
KeyConversion["-"]            = 0x0C
KeyConversion.numlock         = 0x45
KeyConversion.pause           = 0xC5
KeyConversion["."]            = 0x34
KeyConversion["]"]            = 0x1B
KeyConversion.rctrl           = 0x9D
KeyConversion.ralt            = 0xB8 -- right Alt
KeyConversion.rshift          = 0x36
KeyConversion.scrolllock      = 0x46 -- Scroll Lock
KeyConversion[";"]            = 0x27
KeyConversion["/"]            = 0x35 -- / on main keyboard
KeyConversion.space           = 0x39
KeyConversion.stop            = 0x95 -- ??
KeyConversion.tab             = 0x0F
KeyConversion["_"]            = 0x93

-- Keypad (and numpad with numlock off)
KeyConversion.up              = 0xC8
KeyConversion.down            = 0xD0
KeyConversion.left            = 0xCB
KeyConversion.right           = 0xCD
KeyConversion.home            = 0xC7
KeyConversion["end"]         = 0xCF
KeyConversion.pageup          = 0xC9
KeyConversion.pagedown        = 0xD1
KeyConversion.insert          = 0xD2
KeyConversion.delete          = 0xD3

-- Function keys
KeyConversion.f1              = 0x3B
KeyConversion.f2              = 0x3C
KeyConversion.f3              = 0x3D
KeyConversion.f4              = 0x3E
KeyConversion.f5              = 0x3F
KeyConversion.f6              = 0x40
KeyConversion.f7              = 0x41
KeyConversion.f8              = 0x42
KeyConversion.f9              = 0x43
KeyConversion.f10             = 0x44
KeyConversion.f11             = 0x57
KeyConversion.f12             = 0x58
KeyConversion.f13             = 0x64
KeyConversion.f14             = 0x65
KeyConversion.f15             = 0x66
KeyConversion.f16             = 0x67
KeyConversion.f17             = 0x68
KeyConversion.f18             = 0x69
KeyConversion.f19             = 0x71

-- Japanese keyboards, idk what these are in love2d
KeyConversion.kana            = 0x70
KeyConversion.kanji           = 0x94
KeyConversion.convert         = 0x79
KeyConversion.noconvert       = 0x7B
KeyConversion.yen             = 0x7D
KeyConversion.circumflex      = 0x90
KeyConversion.ax              = 0x96

-- Numpad
KeyConversion.kp0             = 0x52
KeyConversion.kp1             = 0x4F
KeyConversion.kp2             = 0x50
KeyConversion.kp3             = 0x51
KeyConversion.kp4             = 0x4B
KeyConversion.kp5             = 0x4C
KeyConversion.kp6             = 0x4D
KeyConversion.kp7             = 0x47
KeyConversion.kp8             = 0x48
KeyConversion.kp9             = 0x49
KeyConversion["kp*"]          = 0x37
KeyConversion["kp/"]          = 0xB5
KeyConversion["kp-"]          = 0x4A
KeyConversion["kp+"]          = 0x4E
KeyConversion["kp."]          = 0x53
KeyConversion["kp,"]          = 0xB3
KeyConversion.kpenter         = 0x9C
KeyConversion["kp="]          = 0x8D