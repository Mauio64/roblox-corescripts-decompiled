local Parent = script:FindFirstAncestor("VideoUtils").Parent
local t1 = nil

if require(Parent.SharedFlags).FFlagLuaAppShareEdpVideoBlockingConfig then
	t1 = {
		enableManufacturerDeny = game:DefineFastFlag("LuaAppEdpVideoManufacturerDeny2", false),
		enableDeviceDeny = game:DefineFastFlag("LuaAppEdpVideoDeviceDeny", false),
		enableMaxMemoryDeny = game:DefineFastFlag("LuaAppEdpVideoMaxMemoryDeny", false),
		enableAvailableRamDeny = game:DefineFastFlag("LuaAppEdpVideoAvailableRamDeny", false),
		manufacturerDenyList = game:DefineFastString("LuaAppEdpVideoManufacturerPipeDenyList", ""),
		deviceDenyList = game:DefineFastString("LuaAppEdpVideoDevicePipeDenyList", ""),
		maxMemoryThresholdMb = game:DefineFastInt("LuaAppEdpVideoMaxMemoryThresholdMb", -1),
		availableRamThresholdMb = game:DefineFastInt("LuaAppEdpVideoAvailableRamThresholdMb", -1)
	}
end

return t1
