local IXPService = game:GetService("IXPService")
local CorePackages = game:GetService("CorePackages")
local v3 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy = require(script.Parent.Parent.Flags.GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy)
local v5 = game:DefineFastString("DisruptiveVoiceNudgeVariantIXPLayerName", "Voice.CivilityAndSafety")
local v6 = game:DefineFastString("DisruptiveVoiceNudgeVariantIXPVariableName", "UseNewDACopy")

local function VoiceNudgeUseNewDACopy() -- line: 11
	-- upvalues: GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy (copy), IXPService (copy), v5 (copy), v6 (copy), v3 (copy)
	if GetFFlagVoiceChatDisruptiveVoiceNudgeForceUseNewDACopy() then
		return true
	end

	local ok, result = pcall(function() -- line: 15
		-- upvalues: IXPService (copy), v5 (copy)
		return IXPService:GetUserLayerVariables(v5)
	end)

	if not ok or not result or result[v6] == nil then
		v3:debug("Failed to get IXP data for layer: " .. v5 .. " with variable: " .. v6)

		return false
	end

	IXPService:LogUserLayerExposure(v5)
	v3:debug("Experiment variant for " .. v6 .. ": " .. tostring(result[v6]))

	return result[v6]
end

return VoiceNudgeUseNewDACopy
