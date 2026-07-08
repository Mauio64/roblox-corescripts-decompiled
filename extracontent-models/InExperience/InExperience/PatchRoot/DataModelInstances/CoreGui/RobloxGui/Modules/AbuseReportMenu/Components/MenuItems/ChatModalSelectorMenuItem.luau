local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ChatModalSelector = require(AbuseReportMenu.Components.ChatModalSelector)
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)

require(AbuseReportMenu.Components.Types)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), ReportMenuItem (copy), ChatModalSelector (copy)
	return React.createElement(ReportMenuItem, {
		label = t1.label,
		layoutOrder = t1.layoutOrder,
		rightComponent = React.createElement(ChatModalSelector, t1),
		menuContainerWidth = t1.menuContainerWidth,
		isSmallPortraitViewport = t1.isSmallPortraitViewport,
		placeholderText = t1.placeholderText
	})
end
