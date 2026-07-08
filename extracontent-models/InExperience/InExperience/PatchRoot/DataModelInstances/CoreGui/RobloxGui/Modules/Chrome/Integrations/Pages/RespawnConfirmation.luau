local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Service = require(Chrome.Service)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local InGameMenuIntegrationUtils = require(script.Parent.InGameMenuIntegrationUtils)
local Enums = require(CorePackages.Workspace.Packages.InExperienceSideSheet).Enums
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local v9 = InGameMenuIntegrationUtils.createPageOpenSignal("ResetCharacterPage")

return Service:register({
	label = "CoreScripts.InGameMenu.QuickActions.Respawn",
	initialAvailability = Service.AvailabilitySignal.Available,
	id = Enums.ActionBinding.Respawn,
	sideSheetPlacement = SideSheetPlacement.SessionAction,
	activated = function(_) -- line: 25
		-- upvalues: InGameMenuIntegrationUtils (copy), v9 (copy)
		InGameMenuIntegrationUtils.toggleIGMPage("ResetCharacterPage", v9:get())
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 30
		-- upvalues: v9 (copy)
		return v9:get()
	end or v9,
	components = {
		Icon = function(_) -- line: 34
			-- upvalues: CommonIcon (copy), v9 (copy)
			return CommonIcon("icons/actions/respawn", nil, v9)
		end
	}
})
