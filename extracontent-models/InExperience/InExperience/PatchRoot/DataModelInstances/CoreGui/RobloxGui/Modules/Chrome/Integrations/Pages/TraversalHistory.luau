local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")

local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)

local pageOpenSignal = InGameMenuIntegrationUtils.createPageOpenSignal("TraversalHistoryPage")

return Service:register({
	initialAvailability = Service.AvailabilitySignal.Available,
	id = "traversal_history",
	label = "CoreScripts.TopBar.Traversal.History",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	activated = function(_)
		InGameMenuIntegrationUtils.toggleIGMPage("TraversalHistoryPage", pageOpenSignal:get())
	end,
	isActivated = pageOpenSignal,
	components = {
		Icon = function(_)
			return CommonIcon("Clock", nil, pageOpenSignal)
		end
	}
})
