local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local v8 = InGameMenuIntegrationUtils.createPageOpenSignal("TraversalHistoryPage")

return Service:register({
	id = "traversal_history",
	label = "CoreScripts.TopBar.Traversal.History",
	initialAvailability = Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Page,
	activated = function(_) -- line: 21
		-- upvalues: InGameMenuIntegrationUtils (copy), v8 (copy)
		InGameMenuIntegrationUtils.toggleIGMPage("TraversalHistoryPage", v8:get())
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 26
		-- upvalues: v8 (copy)
		return v8:get()
	end or v8,
	components = {
		Icon = function(_) -- line: 30
			-- upvalues: CommonIcon (copy), v8 (copy)
			return CommonIcon("Clock", nil, v8)
		end
	}
})
