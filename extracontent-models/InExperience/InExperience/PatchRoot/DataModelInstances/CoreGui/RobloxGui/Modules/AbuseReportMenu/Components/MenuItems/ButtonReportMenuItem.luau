local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)

return function(p1) -- line: 14
	-- upvalues: React (copy), ReportMenuItem (copy)
	return React.createElement(ReportMenuItem, {
		label = p1.label,
		layoutOrder = p1.layoutOrder,
		rightComponent = p1.button,
		menuContainerWidth = p1.menuContainerWidth,
		isSmallPortraitViewport = p1.isSmallPortraitViewport
	})
end
