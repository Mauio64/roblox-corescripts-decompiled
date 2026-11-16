local CorePackages = game:GetService("CorePackages")
local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local makeExperiment = require(script.Parent.makeExperiment)
local defineFastFlag = game:DefineFastFlag("XboxPrimaryNavABIXPEnabled", false)
local defineFastFlag2 = game:DefineFastFlag("XboxPrimaryNavABIXPEnrolledForAll", false)

local defineFastString = game:DefineFastString("XboxPrimaryNavABIXPVariable", "tenFootPrimaryNavEnabled")

local v = {}

local function setExperimentState(p)
	v = p
end

local function isUserEnrolled()
	if defineFastFlag2 then
		return true
	end

	if defineFastFlag2 or defineFastFlag then
		return (v[AppUserLayers.XboxClassicUILayer] or {})[defineFastString] or false
	end

	return false
end

local experiment = makeExperiment(
	"OnUserLayerLoadingStatusChanged",
	"GetUserLayerLoadingStatus",
	"GetUserLayerVariables",
	"LogUserLayerExposure",
	"GetUserStatusForLayer"
)
local XboxPrimaryNavIXPTest = {}

function XboxPrimaryNavIXPTest.isEnabled()
	return defineFastFlag2 or defineFastFlag
end

function XboxPrimaryNavIXPTest.isEnrolledForAll()
	return defineFastFlag2
end

XboxPrimaryNavIXPTest.isUserEnrolled = isUserEnrolled
XboxPrimaryNavIXPTest.layer = AppUserLayers.XboxClassicUILayer
XboxPrimaryNavIXPTest.experiment = experiment
XboxPrimaryNavIXPTest.setExperimentState = setExperimentState
return XboxPrimaryNavIXPTest
