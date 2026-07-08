local Chrome = script:FindFirstAncestor("Chrome")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local EnumReactPage = require(CoreGui.RobloxGui.Modules.Settings.EnumReactPage)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local v10 = InGameMenuIntegrationUtils.createPageOpenSignal("TraversalHistoryPage")

return Service:register({
	id = "traversal_history",
	label = "CoreScripts.TopBar.Traversal.History",
	initialAvailability = Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Page,
	activated = function(_) -- line: 24
		-- upvalues: InGameMenuIntegrationUtils (copy), v10 (copy), EnumReactPage (copy)
		InGameMenuIntegrationUtils.toggleReactPage("TraversalHistoryPage", v10:get(), EnumReactPage.TraversalHistory)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 33
		-- upvalues: v10 (copy)
		return v10:get()
	end or v10,
	components = {
		Icon = function(_) -- line: 37
			-- upvalues: CommonIcon (copy), v10 (copy)
			return CommonIcon("Clock", nil, v10)
		end
	}
})
