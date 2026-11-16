local parent = script.Parent.Parent
local SharedFlags = require(parent.SharedFlags)

return SharedFlags.FFlagLuaAppUseDeviceSafeInsetsForAppContainer and SharedFlags.FFlagLuaAppSupportDeviceSafeInsets
