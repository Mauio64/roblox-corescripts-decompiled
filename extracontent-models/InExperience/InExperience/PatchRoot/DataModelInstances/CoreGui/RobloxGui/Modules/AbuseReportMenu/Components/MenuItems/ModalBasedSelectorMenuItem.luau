local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ModalBasedSelector = require(AbuseReportMenu.Components.ModalBasedSelector)
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)

return function(p1) -- line: 15
	-- upvalues: React (copy), ReportMenuItem (copy), ModalBasedSelector (copy)
	return React.createElement(ReportMenuItem, {
		label = p1.label,
		layoutOrder = p1.layoutOrder,
		rightComponent = React.createElement(ModalBasedSelector, p1),
		menuContainerWidth = p1.menuContainerWidth,
		isSmallPortraitViewport = p1.isSmallPortraitViewport,
		placeholderText = p1.placeholderText
	})
end
