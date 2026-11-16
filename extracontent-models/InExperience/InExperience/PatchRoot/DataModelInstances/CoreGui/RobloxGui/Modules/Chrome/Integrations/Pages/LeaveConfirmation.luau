local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local Enums = InExperienceSideSheet.Enums

local pageOpenSignal = InGameMenuIntegrationUtils.createPageOpenSignal("LeaveGamePage")

return Service:register({
	initialAvailability = Service.AvailabilitySignal.Available,
	id = Enums.ActionBinding.Leave,
	label = "CoreScripts.InGameMenu.LeaveGame",
	sideSheetPlacement = SideSheetPlacement.SessionAction,
	activated = function(_)
		InGameMenuIntegrationUtils.toggleIGMPage("LeaveGamePage", pageOpenSignal:get())
	end,
	isActivated = pageOpenSignal,
	components = {
		Icon = function(_)
			return CommonIcon("icons/actions/leave", nil, pageOpenSignal)
		end
	}
})
