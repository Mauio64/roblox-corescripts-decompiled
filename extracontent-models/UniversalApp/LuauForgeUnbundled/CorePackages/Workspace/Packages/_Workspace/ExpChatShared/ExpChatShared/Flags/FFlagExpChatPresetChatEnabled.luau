local UserInputService = game:GetService("UserInputService")

local FFlagExpChatPresetChatVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/FFlagExpChatPresetChatVREnabled")

local function isSupportedPlatform()
	if UserInputService.VREnabled then
		return FFlagExpChatPresetChatVREnabled
	end

	return true
end

local v5 = game:DefineFastFlag("ExpChatPresetChatEnabled10", false)
	and game:GetEngineFeature("TextChatPresetsEnabled")

if not v5 then
	return v5
end

if UserInputService.VREnabled then
	return FFlagExpChatPresetChatVREnabled
end

v5 = true
return true
