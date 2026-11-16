local CoreGui = game:GetService("CoreGui")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local UserInputService = game:GetService("UserInputService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local BuildExperienceCompositionStyleSheet = require(BuildExperience.Components.BuildExperienceCompositionStyleSheet)
local InstanceSelectionShell = require(script.Parent.InstanceSelectionShell)

local function isTouchInput(): boolean
	return UserInputService.PreferredInput == Enum.PreferredInput.Touch
end

local function mountInstanceSelection()
	local experienceStateCaptureSelectionMode = Enum.ExperienceStateCaptureSelectionMode

	if experienceStateCaptureSelectionMode ~= nil then
		ExperienceStateCaptureService.SelectionMode = experienceStateCaptureSelectionMode.SafetyHighlightMode
	end

	if game:GetEngineFeature("ExperienceStateCaptureHiddenSelection") then
		ExperienceStateCaptureService.HiddenSelectionEnabled = true
	end

	local buildExperienceInstanceSelection = Instance.new("ScreenGui")
	buildExperienceInstanceSelection.Name = "BuildExperienceInstanceSelection"
	buildExperienceInstanceSelection.ClipToDeviceSafeArea = false
	buildExperienceInstanceSelection.DisplayOrder = 9
	buildExperienceInstanceSelection.IgnoreGuiInset = true
	buildExperienceInstanceSelection.ResetOnSpawn = false
	buildExperienceInstanceSelection.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	buildExperienceInstanceSelection.ScreenInsets = Enum.ScreenInsets.None
	buildExperienceInstanceSelection.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	buildExperienceInstanceSelection.Parent = CoreGui

	local root = ReactRoblox.createRoot(buildExperienceInstanceSelection)
	root:render(React.createElement(Foundation.FoundationProvider, {
		colorMode = Foundation.Enums.ColorMode.Dark
	}, {
		CompositionStyleSheet = React.createElement(BuildExperienceCompositionStyleSheet),
		Shell = React.createElement(InstanceSelectionShell, {
			itemSelected = ExperienceStateCaptureService.ItemSelectedInCaptureMode,
			isTouchInput = isTouchInput
		})
	}))

	return root
end

return mountInstanceSelection
