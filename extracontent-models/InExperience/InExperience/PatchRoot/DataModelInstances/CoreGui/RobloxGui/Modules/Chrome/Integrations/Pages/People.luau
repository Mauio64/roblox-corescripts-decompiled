local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)

local pageOpenSignal = InGameMenuIntegrationUtils.createPageOpenSignal("PlayersPage")

return Service:register({
	initialAvailability = Service.AvailabilitySignal.Available,
	id = "people",
	label = "CoreScripts.InGameMenu.PageTitle.Players",
	sideSheetPlacement = SideSheetPlacement.AboveFold,
	activated = function(_)
		InGameMenuIntegrationUtils.toggleIGMPage("PlayersPage", pageOpenSignal:get())
	end,
	isActivated = pageOpenSignal,
	components = {
		Icon = function(_)
			return CommonIcon("icons/menu/friends", "icons/menu/friendsOn", pageOpenSignal)
		end
	}
})
