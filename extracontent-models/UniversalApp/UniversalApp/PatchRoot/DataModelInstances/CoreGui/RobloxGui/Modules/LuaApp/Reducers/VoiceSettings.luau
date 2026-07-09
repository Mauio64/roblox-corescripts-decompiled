local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local SetVoiceSettings = require(Modules.LuaApp.Actions.SetVoiceSettings)

return function(p1, p2) -- line: 8
	-- upvalues: SetVoiceSettings (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetVoiceSettings.name then
		v7 = Cryo.Dictionary.join(v7, {
			isUserEligible = p2.isUserEligible,
			isVoiceEnabled = p2.isVoiceEnabled,
			isUserOptIn = p2.isUserOptIn
		})
	end

	return v7
end
