game:DefineFastFlag("InternationalNamesEnabledForAll", false)

local v1 = game:DefineFastString("InternationalNamesIXPLayer", "Social.InternationalDisplayName")
local v2 = game:DefineFastString("InternationalNamesIXPExperimentDefinition", "enableInternationalNames")
local IXPService = game:GetService("IXPService")
local Parent = script:FindFirstAncestor("EditProfile").Parent
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment

local function internationalNamesEnabledForAll() -- line: 14
	return game:GetFastFlag("InternationalNamesEnabledForAll")
end
local function isExperimentEnabled(p1) -- line: 18
	-- upvalues: v1 (copy), v2 (copy)
	return ((p1 or {})[v1] or {})[v2] == true or game:GetFastFlag("InternationalNamesEnabledForAll")
end

return {
	FFlagIsExperimentEnabled = isExperimentEnabled,
	useIsExperimentEnabled = function(t1: {[any]: any}) -- line: 28
		-- upvalues: useUserExperiment (copy), v1 (copy), isExperimentEnabled (copy)
		local v10 = t1 or {
			isExposureEnabled = false
		}

		return useUserExperiment({ v1 }, isExperimentEnabled, v10.isExposureEnabled)
	end,
	logExposure = function() -- line: 32
		-- upvalues: IXPService (copy), v1 (copy)
		IXPService:LogUserLayerExposure(v1)
	end
}
