local UserInputService = game:GetService("UserInputService")
local FFlagExpChatPresetChatVREnabled = require(script.Parent.FFlagExpChatPresetChatVREnabled)

local function isSupportedPlatform() -- line: 5
	-- upvalues: UserInputService (copy), FFlagExpChatPresetChatVREnabled (copy)
	if UserInputService.VREnabled then
		return FFlagExpChatPresetChatVREnabled
	end

	return true
end

local v4 = game:DefineFastFlag("ExpChatPresetChatLoadTestEnabled", false)

if v4 then
	v4 = game:GetEngineFeature("TextChatPresetsEnabled")

	if v4 then
		if UserInputService.VREnabled then
			return FFlagExpChatPresetChatVREnabled
		end

		v4 = true
	end
end

return v4
