local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local getMenuItemsFromConfigs = require(AbuseReportMenu.MenuConfigs.getMenuItemsFromConfigs)
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)
local ReportExperienceMenuItemConfigList = require(AbuseReportMenu.MenuConfigs.Experience.ReportExperienceMenuItemConfigList)
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)
local Cryo = require(CorePackages.Packages.Cryo)
local reportExperienceUIStateReducer = require(AbuseReportMenu.Reducers.reportExperienceUIStateReducer)

local function ReportExperienceMenuItemsContainer(p)
	local menuItemSizings = getMenuItemSizings()

	local v, v2 = React.useReducer(reportExperienceUIStateReducer, Constants.InitExperienceUIState)
	React.useEffect(function()
		if p.utilityProps.isReportTabVisible then
			p.utilityProps.analyticsDispatch({
				type = Constants.AnalyticsActions.SwitchToExperienceInitialSelections
			})
		end
	end, { p.utilityProps.isReportTabVisible })

	local menuItemsFromConfigs = getMenuItemsFromConfigs(
		v,
		v2,
		p.utilityProps,
		ReportExperienceMenuItemConfigList,
		p.isSmallPortraitViewport
	)

	local joined = Cryo.Dictionary.join({
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, menuItemSizings.ItemPadding)
		})
	}, menuItemsFromConfigs)

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		MenuItems = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, joined)
	})
end

return ReportExperienceMenuItemsContainer
