local parent = script.Parent.Parent.Parent

local Rodux = require(parent.Rodux)

local CaptureManager = require(script.Parent.CaptureManager)
local Captures = require(script.Parent.Captures)
local Carousel = require(script.Parent.Carousel)
local IsActive = require(script.Parent.IsActive)
local IsCapturesCoreGuiEnabled = require(script.Parent.IsCapturesCoreGuiEnabled)
local IsMenuOpen = require(script.Parent.IsMenuOpen)
local IsOverlayActive = require(script.Parent.IsOverlayActive)
local IsOverlayFlashActive = require(script.Parent.IsOverlayFlashActive)
local IsVideoCaptureActive = require(script.Parent.IsVideoCaptureActive)
local MomentsEligibility = require(script.Parent.MomentsEligibility)
local MomentsCreationFlow = require(script.Parent.MomentsCreationFlow)
local Prompts = require(script.Parent.Prompts)
local Toast = require(script.Parent.Toast)

return function()
	return Rodux.combineReducers({
		CaptureManager = CaptureManager,
		Captures = Captures,
		Carousel = Carousel,
		IsActive = IsActive,
		IsCapturesCoreGuiEnabled = IsCapturesCoreGuiEnabled,
		IsMenuOpen = IsMenuOpen,
		IsOverlayActive = IsOverlayActive,
		IsOverlayFlashActive = IsOverlayFlashActive,
		IsVideoCaptureActive = IsVideoCaptureActive,
		MomentsEligibility = MomentsEligibility,
		MomentsCreationFlow = MomentsCreationFlow,
		Prompts = Prompts,
		Toast = Toast
	})
end
