local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local v8 = InGameMenuIntegrationUtils.createPageOpenSignal("PlayersPage")

return Service:register({
	id = "people",
	label = "CoreScripts.InGameMenu.PageTitle.Players",
	initialAvailability = Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 22
		-- upvalues: InGameMenuIntegrationUtils (copy), v8 (copy)
		InGameMenuIntegrationUtils.toggleIGMPage("PlayersPage", v8:get())
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 27
		-- upvalues: v8 (copy)
		return v8:get()
	end or v8,
	components = {
		Icon = function(_) -- line: 31
			-- upvalues: CommonIcon (copy), v8 (copy)
			return CommonIcon("icons/menu/friends", "icons/menu/friendsOn", v8)
		end
	}
})
