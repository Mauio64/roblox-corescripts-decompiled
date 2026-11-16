local UserInputService = game:GetService("UserInputService")

local FFlagExpChatPresetChatVREnabled = require(script.Parent.FFlagExpChatPresetChatVREnabled)

local function isSupportedPlatform()
	return not UserInputService.VREnabled or FFlagExpChatPresetChatVREnabled
end

local v = game:DefineFastFlag("ExpChatPresetChatEnabled10", false) and game:GetEngineFeature("TextChatPresetsEnabled")

if not v then
	return v
end

if UserInputService.VREnabled then
	return FFlagExpChatPresetChatVREnabled
end

v = true
return true
