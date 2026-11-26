game:DefineFastFlag("InternationalNamesEnabledForAll", false)

local defineFastString = game:DefineFastString(
	"InternationalNamesIXPLayer",
	"Social.InternationalDisplayName"
)

local defineFastString2 = game:DefineFastString(
	"InternationalNamesIXPExperimentDefinition",
	"enableInternationalNames"
)

local IXPService = game:GetService("IXPService")

local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactAppExperiment").useUserExperiment

local function internationalNamesEnabledForAll()
	return game:GetFastFlag("InternationalNamesEnabledForAll")
end

local function isExperimentEnabled(options)
	return ((options or {})[defineFastString] or {})[defineFastString2] == true
		or game:GetFastFlag("InternationalNamesEnabledForAll")
end

return {
	FFlagIsExperimentEnabled = isExperimentEnabled,
	useIsExperimentEnabled = function(p2)
		return useUserExperiment(
			{ defineFastString },
			isExperimentEnabled,
			(p2 or { isExposureEnabled = false }).isExposureEnabled
		)
	end,
	logExposure = function()
		IXPService:LogUserLayerExposure(defineFastString)
	end
}
