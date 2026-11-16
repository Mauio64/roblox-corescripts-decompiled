local UserInputService = game:GetService("UserInputService")

local v = require(script.Parent.FFlagDebugExpChatTextChannelWindowStaticExpressions)
local defineFastFlag = game:DefineFastFlag("ExpChatPresetChatVREnabled", false)
local defineFastFlag2 = game:DefineFastFlag("ExpChatTextChannelWindowExpressionTray", false)

local function isSupportedPlatform()
	return not UserInputService.VREnabled or defineFastFlag
end

if not defineFastFlag2 then
	return defineFastFlag2
end

if not (game:GetEngineFeature("TextChatPresetsEnabled") or v) then
	return v
end

if UserInputService.VREnabled then
	return defineFastFlag
end

v = true
return true
