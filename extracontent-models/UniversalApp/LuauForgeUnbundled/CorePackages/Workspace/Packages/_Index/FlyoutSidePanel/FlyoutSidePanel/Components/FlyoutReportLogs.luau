local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")

local fFlagCTAChangeMorePageFlyoutButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutReportLogs(props)
	local v5 = useRoactService(appEventIngestService)
	local v6 = React.useCallback(function()
		props.closeDrawer()

		if props.openReportLogConfirmation then
			props.openReportLogConfirmation()
		end

		local reportLogs = FlyoutContentSettings.ItemType.ReportLogs
		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v5, reportLogs)
	end, { props.openReportLogConfirmation, props.closeDrawer, v5 })
	local v7 = useLocalization({
		text = fFlagCTAChangeMorePageFlyoutButtonText and "CommonUI.Features.Label.ReportLogsSentenceCase" or "CommonUI.Features.Label.ReportLogs"
	})

	return React.createElement(Foundation.Button, {
		testId = "--core-ui-flyout-button-report-logs",
		text = v7.text,
		variant = buttonVariant.Standard,
		LayoutOrder = props.layoutOrder,
		isDisabled = false,
		size = buttonSize.Large,
		width = UDim.new(1, 0),
		onActivated = v6
	})
end

return FlyoutReportLogs
