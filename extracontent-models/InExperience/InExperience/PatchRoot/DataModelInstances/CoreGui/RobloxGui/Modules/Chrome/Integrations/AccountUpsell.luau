local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local AccountUpgrade = require(CorePackages.Workspace.Packages.AccountUpgrade)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local Service = require(Chrome.Service)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local React = require(CorePackages.Packages.React)

local Pioneer = AccountUpgrade.AccountUpgradeFlow.Pioneer
local v = nil

local function openAccountUpsell()
	if AccountUpgrade.InExperienceController.mount({
		flow = Pioneer,
		onComplete = function(p)
			if p.reason == "success" and v then
				v.availability:unavailable()
			end
		end
	}) == "already_mounted" then
		AccountUpgrade.InExperienceController.unmount()
	end
end

local function AccountUpsellIntegration(p)
	return React.createElement(InExperienceSideSheet.AccountUpsell, {
		layoutOrder = p.layoutOrder,
		placement = p.placement,
		onActivated = openAccountUpsell
	})
end

local v2 = isPioneerLaunch() and {
	id = "AccountUpsell",
	label = "CoreScripts.InGameMenu.UnlockMore.Title",
	activated = function() end,
	sideSheetPlacement = Chrome2.Enums.SideSheetPlacement.ScrollableContentBottom,
	components = { Widget = AccountUpsellIntegration }
} or nil

if v2 then
	v2.initialAvailability = Service.AvailabilitySignal.Unavailable
	local v3 = Service:register(v2)
	v = v3

	task.spawn(function()
		if AccountUpgrade.Eligibility.getAvailability(Pioneer).granted then
			v3.availability:available()
		end
	end)
end

return v or {}
