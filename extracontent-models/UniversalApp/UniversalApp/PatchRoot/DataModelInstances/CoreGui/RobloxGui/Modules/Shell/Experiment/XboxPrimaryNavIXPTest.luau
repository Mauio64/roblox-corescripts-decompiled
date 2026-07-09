local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local makeExperiment = require(script.Parent.makeExperiment)
local v4 = game:DefineFastFlag("XboxPrimaryNavABIXPEnabled", false)
local v5 = game:DefineFastFlag("XboxPrimaryNavABIXPEnrolledForAll", false)
local v6 = game:DefineFastString("XboxPrimaryNavABIXPVariable", "tenFootPrimaryNavEnabled")
local t1 = {}
local v8 = makeExperiment("OnUserLayerLoadingStatusChanged", "GetUserLayerLoadingStatus", "GetUserLayerVariables", "LogUserLayerExposure", "GetUserStatusForLayer")

return {
	isEnabled = function() -- line: 37
		-- upvalues: v5 (copy), v4 (copy)
		return v5 or v4
	end,
	isEnrolledForAll = function() -- line: 33
		-- upvalues: v5 (copy)
		return v5
	end,
	isUserEnrolled = function() -- line: 41
		-- upvalues: v5 (copy), v4 (copy), t1 (ref), AppUserLayers (copy), v6 (copy)
		if v5 then
			return true
		end

		if not v5 and not v4 then
			return false
		end

		return (t1[AppUserLayers.XboxClassicUILayer] or {})[v6] or false
	end,
	layer = AppUserLayers.XboxClassicUILayer,
	experiment = v8,
	setExperimentState = function(p1) -- line: 29
		-- upvalues: t1 (ref)
		t1 = p1
	end
}
