game:DefineFastFlag("InternationalNamesEnabledForAll", false)

local defineFastString = game:DefineFastString("InternationalNamesIXPLayer", "Social.InternationalDisplayName")

local defineFastString2 = game:DefineFastString("InternationalNamesIXPExperimentDefinition", "enableInternationalNames")

local IXPService = game:GetService("IXPService")

local parent = script:FindFirstAncestor("EditProfile").Parent
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local function internationalNamesEnabledForAll() -- 1 equivalent call inferred from this helper
	return game:GetFastFlag("InternationalNamesEnabledForAll")
end

local function isExperimentEnabled(options)
	return ((options or {})[defineFastString] or {})[defineFastString2] == true or internationalNamesEnabledForAll() -- inferred equivalent call
end

local InternationalNamesIXP = {}
InternationalNamesIXP.FFlagIsExperimentEnabled = isExperimentEnabled

function InternationalNamesIXP.useIsExperimentEnabled(p)
	return useUserExperiment(
		{ defineFastString },
		isExperimentEnabled,
		(p or { isExposureEnabled = false }).isExposureEnabled
	)
end

function InternationalNamesIXP.logExposure()
	IXPService:LogUserLayerExposure(defineFastString)
end

return InternationalNamesIXP
