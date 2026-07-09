local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local React = require(InExperienceSideSheetParent.React)
local Foundation = require(InExperienceSideSheetParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local function VerticalItem(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), View (copy), FoundationText (copy)
	local v12 = React.useCallback(function() -- line: 23
		-- upvalues: t1 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		t1.onActivated()
		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
	end, { t1.onActivated })

	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y radius-medium",
		LayoutOrder = t1.layoutOrder,
		onActivated = v12
	}, {
		IconContainer = React.createElement(View, {
			tag = "align-x-center align-y-center size-1000 auto-xy",
			LayoutOrder = 1
		}, {
			Icon = t1.icon({
				visible = true
			})
		}),
		Label = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy padding-y-small text-title-medium text-align-x-left text-truncate-split content-emphasis",
			Text = t1.label
		})
	})
end

return React.memo(VerticalItem)
