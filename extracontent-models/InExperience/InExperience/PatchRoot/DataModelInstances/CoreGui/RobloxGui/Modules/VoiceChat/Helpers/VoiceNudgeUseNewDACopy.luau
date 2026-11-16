local IXPService = game:GetService("IXPService")

local CorePackages = game:GetService("CorePackages")
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy = require(script.Parent.Parent.Flags.GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy)

local defineFastString = game:DefineFastString("DisruptiveVoiceNudgeVariantIXPLayerName", "Voice.CivilityAndSafety")
local defineFastString2 = game:DefineFastString("DisruptiveVoiceNudgeVariantIXPVariableName", "UseNewDACopy")

local function VoiceNudgeUseNewDACopy()
	if GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy() then
		return true
	end

	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(defineFastString)
	end)

	if not success or not result or result[defineFastString2] == nil then
		v:debug("Failed to get IXP data for layer: " .. defineFastString .. " with variable: " .. defineFastString2)
		return false
	end

	IXPService:LogUserLayerExposure(defineFastString)
	v:debug("Experiment variant for " .. defineFastString2 .. ": " .. tostring(result[defineFastString2]))
	return result[defineFastString2]
end

return VoiceNudgeUseNewDACopy
