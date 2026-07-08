local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReportTextEntry = require(AbuseReportMenu.Components.ReportTextEntry)
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)
local Constants = require(AbuseReportMenu.Components.Constants)

local function FreeCommentsMenuItem(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), ReportMenuItem (copy), ReportTextEntry (copy), Constants (copy)
	return React.createElement(ReportMenuItem, {
		label = "Abuse Description",
		isRightComponentFullWidth = true,
		layoutOrder = t1.layoutOrder,
		rightComponent = React.createElement(ReportTextEntry, {
			layoutOrder = t1.layoutOrder,
			text = t1.comment,
			placeholderText = t1.placeholderText,
			onUpdate = t1.onUpdate
		}),
		heightOverride = Constants.FreeCommentsMenuItemHeight,
		menuContainerWidth = t1.menuContainerWidth,
		isSmallPortraitViewport = t1.isSmallPortraitViewport
	})
end

return FreeCommentsMenuItem
