local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagEnableSideSheetRobuxWidget = require(Chrome.Flags.FFlagEnableSideSheetRobuxWidget)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagHideHeaderForBuyRobuxInExperienceShop = SharedFlags.FFlagHideHeaderForBuyRobuxInExperienceShop

local function openShop()
	if Service:isIntegrationValid(Constants.IN_EXPERIENCE_SHOP_ID) or FFlagHideHeaderForBuyRobuxInExperienceShop then
		if FFlagHideHeaderForBuyRobuxInExperienceShop then
			InExperienceShop.setOpenedFromBuyRobux(true)
		end

		if not Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
			InExperienceShop.requestOpenToRobuxTab()
		end

		Service:activate(Constants.IN_EXPERIENCE_SHOP_ID)
	end
end

local function RobuxWidgetIntegration(props)
	return React.createElement(InExperienceSideSheet.RobuxWidget, {
		layoutOrder = props.layoutOrder,
		placement = props.placement,
		onBuyActivated = openShop,
		firstIntegrationToFocusCallback = props.firstIntegrationToFocusCallback
	})
end

local v

if FFlagEnableSideSheetRobuxWidget and isSideSheetEnabled then
	v = Service:register({
		id = "RobuxWidget",
		label = "Feature.Catalog.Label.BuyRobux",
		activated = function() end,
		initialAvailability = Service.AvailabilitySignal.Available,
		sideSheetPlacement = Chrome2.Enums.SideSheetPlacement.ScrollableContentTop,
		components = { Widget = RobuxWidgetIntegration }
	})
end

return v or {}
