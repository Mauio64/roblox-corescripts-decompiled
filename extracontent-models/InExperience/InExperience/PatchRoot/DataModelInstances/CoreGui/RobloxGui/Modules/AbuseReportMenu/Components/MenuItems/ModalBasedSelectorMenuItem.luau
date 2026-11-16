local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ModalBasedSelector = require(AbuseReportMenu.Components.ModalBasedSelector)
local ReportMenuItem = require(AbuseReportMenu.Components.MenuItems.ReportMenuItem)

return function(props)
	return React.createElement(ReportMenuItem, {
		label = props.label,
		layoutOrder = props.layoutOrder,
		rightComponent = React.createElement(ModalBasedSelector, props),
		menuContainerWidth = props.menuContainerWidth,
		isSmallPortraitViewport = props.isSmallPortraitViewport,
		placeholderText = props.placeholderText
	})
end
