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

local function ReportExperienceMenuItemsContainer(t1: {[any]: any}) -- line: 17
	-- upvalues: getMenuItemSizings (copy), React (copy), reportExperienceUIStateReducer (copy), Constants (copy), getMenuItemsFromConfigs (copy), ReportExperienceMenuItemConfigList (copy), Cryo (copy)
	local v12 = getMenuItemSizings()
	local v13, v14 = React.useReducer(reportExperienceUIStateReducer, Constants.InitExperienceUIState)

	React.useEffect(function() -- line: 21
		-- upvalues: t1 (copy), Constants (copy)
		if t1.utilityProps.isReportTabVisible then
			t1.utilityProps.analyticsDispatch({
				type = Constants.AnalyticsActions.SwitchToExperienceInitialSelections
			})
		end
	end, { t1.utilityProps.isReportTabVisible })

	local v15 = getMenuItemsFromConfigs(v13, v14, t1.utilityProps, ReportExperienceMenuItemConfigList, t1.isSmallPortraitViewport)
	local v16 = Cryo.Dictionary.join({
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v12.ItemPadding)
		})
	}, v15)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		MenuItems = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, v16)
	})
end

return ReportExperienceMenuItemsContainer
