local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local ReportTextEntry = require(AbuseReportMenu.Components.ReportTextEntry)
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)
local Constants = require(AbuseReportMenu.Components.Constants)

local function FreeCommentsMenuItem(props)
	return React.createElement(ReportMenuItem, {
		label = "Abuse Description",
		isRightComponentFullWidth = true,
		layoutOrder = props.layoutOrder,
		rightComponent = React.createElement(ReportTextEntry, {
			layoutOrder = props.layoutOrder,
			text = props.comment,
			placeholderText = props.placeholderText,
			onUpdate = props.onUpdate
		}),
		heightOverride = Constants.FreeCommentsMenuItemHeight,
		menuContainerWidth = props.menuContainerWidth,
		isSmallPortraitViewport = props.isSmallPortraitViewport
	})
end

return FreeCommentsMenuItem
