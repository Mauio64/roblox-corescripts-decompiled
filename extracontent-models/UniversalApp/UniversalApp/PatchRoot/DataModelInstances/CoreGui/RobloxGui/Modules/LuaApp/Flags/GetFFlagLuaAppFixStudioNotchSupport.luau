local CorePackages = game:GetService("CorePackages")
local FFlagLuaAppSupportDeviceSafeInsets = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSupportDeviceSafeInsets

game:DefineFastFlag("LuaAppFixStudioNotchSupport3", false)

return function() -- line: 6
	-- upvalues: FFlagLuaAppSupportDeviceSafeInsets (copy)
	return game:GetFastFlag("LuaAppFixStudioNotchSupport3") or FFlagLuaAppSupportDeviceSafeInsets
end
