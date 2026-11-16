local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local SharedFlags = require(parent.SharedFlags)
local FFlagCTAChangeMorePageFlyoutButtonText = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutReportLogs(props)
	local v = useRoactService(AppEventIngestService)
	local onActivated = React.useCallback(function()
		props.closeDrawer()

		if props.openReportLogConfirmation then
			props.openReportLogConfirmation()
		end

		local reportLogs = FlyoutContentSettings.ItemType.ReportLogs
		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v, reportLogs)
	end, { props.openReportLogConfirmation, props.closeDrawer, v })
	local v2 = useLocalization({
		text = FFlagCTAChangeMorePageFlyoutButtonText and "CommonUI.Features.Label.ReportLogsSentenceCase" or "CommonUI.Features.Label.ReportLogs"
	})

	return React.createElement(Foundation.Button, {
		testId = "--core-ui-flyout-button-report-logs",
		text = v2.text,
		variant = ButtonVariant.Standard,
		LayoutOrder = props.layoutOrder,
		isDisabled = false,
		size = ButtonSize.Large,
		width = UDim.new(1, 0),
		onActivated = onActivated
	})
end

return FlyoutReportLogs
