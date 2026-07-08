local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local VRService = game:GetService("VRService")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local BuildExperience = require(CorePackages.Workspace.Packages.BuildExperience)
local Service = require(Chrome.Service)
local ButtonVariant = Foundation.Enums.ButtonVariant

local function canShowAssistantBuild() -- line: 14
	-- upvalues: BuildExperience (copy), VRService (copy)
	return BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled
end

return (Service:register({
	id = "assistant_build",
	label = "CommonUI.Features.NavBar.Build",
	initialAvailability = if not (BuildExperience.BuildModeLaunch:hasBuildMode() and not VRService.VREnabled) then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	activated = function(_) -- line: 24
		-- upvalues: BuildExperience (copy)
		local v11 = BuildExperience.GetAssistantBuildStore()
		local v12 = BuildExperience.GetPlayButtonStore()

		if not v11.getIsDisabled() then
			v11.setIsDisabledTooltipOpen(false)
			v12.setIsActive(true)

			return
		end

		v11.setIsDisabledTooltipOpen(not v11.getIsDisabledTooltipOpen())
	end,
	components = {
		Icon = function(_) -- line: 35
			-- upvalues: React (copy), BuildExperience (copy), ButtonVariant (copy)
			return React.createElement(BuildExperience.AssistantBuild, {
				variant = ButtonVariant.Utility
			})
		end
	}
}))
