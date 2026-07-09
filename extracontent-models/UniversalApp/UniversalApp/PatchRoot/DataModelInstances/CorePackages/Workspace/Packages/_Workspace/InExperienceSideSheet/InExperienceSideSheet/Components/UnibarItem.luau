local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local View = Foundation.View
local IconHost = require(script.Parent.IconHost)
local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local function UnibarItem(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), View (copy), IconHost (copy)
	local v12 = React.useCallback(function() -- line: 25
		-- upvalues: t1 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		t1.onActivated()
		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
	end, { t1.onActivated })

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t1.layoutOrder
	}, {
		IconHost = React.createElement(IconHost, {
			icon = t1.icon,
			notification = t1.notification
		}),
		ActivationOverlay = React.createElement(View, {
			tag = "size-full radius-circle",
			ZIndex = 10,
			onActivated = v12
		})
	})
end

return React.memo(UnibarItem)
