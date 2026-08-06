local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)
local FFlagCTAChangeMorePageFlyoutButtonText = require(Parent.SharedFlags).FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutReportLogs(t1: {[any]: any}) -- line: 22
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), React (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), useLocalization (copy), FFlagCTAChangeMorePageFlyoutButtonText (copy), Foundation (copy), ButtonVariant (copy), ButtonSize (copy)
	local v14 = useRoactService(AppEventIngestService)
	local v15 = React.useCallback(function() -- line: 24
		-- upvalues: t1 (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), v14 (copy)
		t1.closeDrawer()

		if t1.openReportLogConfirmation then
			t1.openReportLogConfirmation()
		end

		local ReportLogs = FlyoutContentSettings.ItemType.ReportLogs

		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v14, ReportLogs)
	end, {
		t1.openReportLogConfirmation,
		t1.closeDrawer,
		v14
	})
	local v16 = useLocalization({
		text = not FFlagCTAChangeMorePageFlyoutButtonText and "CommonUI.Features.Label.ReportLogs" or "CommonUI.Features.Label.ReportLogsSentenceCase"
	})

	return React.createElement(Foundation.Button, {
		isDisabled = false,
		text = v16.text,
		variant = ButtonVariant.Standard,
		LayoutOrder = t1.layoutOrder,
		size = ButtonSize.Large,
		width = UDim.new(1, 0),
		onActivated = v15
	})
end

return FlyoutReportLogs
