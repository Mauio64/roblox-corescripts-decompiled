local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Signals

if FFlagBuildExperienceInGameShell then
	Signals = require(CorePackages.Packages.Signals)
end

local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local BuildModeLaunch = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.BuildModeLaunch)
local Display

if FFlagBuildExperienceInGameShell then
	Display = require(CorePackages.Workspace.Packages.Display)
else
	Display = nil
end

local Service = require(Chrome.Service)

local ButtonVariant = Foundation.Enums.ButtonVariant

local function canShowAssistantBuild(p): boolean -- 2 equivalent calls inferred from this helper
	if not BuildModeLaunch:hasBuildMode() or VRService.VREnabled then
		return false
	end

	if not FFlagBuildExperienceInGameShell then
		return true
	end

	local displaySize = Display.GetDisplayStore(p).getDisplaySize(p)
	return displaySize == nil or displaySize == Enum.DisplaySize.Small
end

local v = canShowAssistantBuild(false) -- inferred equivalent call
local initialAvailability

if v then
	initialAvailability = Service.AvailabilitySignal.Available
else
	initialAvailability = Service.AvailabilitySignal.Unavailable
end

local v2 = Service:register({
	id = "assistant_build",
	label = "CommonUI.Features.NavBar.Build",
	initialAvailability = initialAvailability,
	activated = function(_)
		local assistantBuildStore = BuildExperience.GetAssistantBuildStore()

		if FFlagBuildExperienceInGameShell then
			assistantBuildStore.activate()
			return
		end

		if assistantBuildStore.getIsDisabled() then
			assistantBuildStore.setIsDisabledTooltipOpen(not assistantBuildStore.getIsDisabledTooltipOpen())

			return
		end

		assistantBuildStore.setIsDisabledTooltipOpen(false)
		BuildExperience.GetPlayButtonStore().setIsActive(true)
	end,
	components = {
		Icon = function(_)
			return React.createElement(BuildExperience.AssistantBuild, {
				variant = ButtonVariant.Utility
			})
		end
	}
})

if FFlagBuildExperienceInGameShell then
	v2._disposeDisplaySizeEffect = Signals.createEffect(function(p)
		if canShowAssistantBuild(p) then -- inferred equivalent call
			v2.availability:available()
		else
			v2.availability:unavailable()
		end
	end)
end

return v2
