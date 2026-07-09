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

local function FlyoutReportLogs(t1: {[any]: any}) -- line: 19
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), React (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), useLocalization (copy), Foundation (copy), ButtonVariant (copy), ButtonSize (copy)
	local v13 = useRoactService(AppEventIngestService)
	local v14 = React.useCallback(function() -- line: 21
		-- upvalues: t1 (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), v13 (copy)
		t1.closeDrawer()

		if t1.openReportLogConfirmation then
			t1.openReportLogConfirmation()
		end

		local ReportLogs = FlyoutContentSettings.ItemType.ReportLogs

		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v13, ReportLogs)
	end, {
		t1.openReportLogConfirmation,
		t1.closeDrawer,
		v13
	})
	local v15 = useLocalization({
		text = "CommonUI.Features.Label.ReportLogs"
	})

	return React.createElement(Foundation.Button, {
		isDisabled = false,
		text = v15.text,
		variant = ButtonVariant.Standard,
		LayoutOrder = t1.layoutOrder,
		size = ButtonSize.Large,
		width = UDim.new(1, 0),
		onActivated = v14
	})
end

return FlyoutReportLogs
