local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local Foundation = require(InExperienceSideSheetParent.Foundation)
local React = require(InExperienceSideSheetParent.React)
local View = Foundation.View
local IconHost = require(script.Parent.IconHost)
local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)
local FFlagSideSheetFocusNav = require(InExperienceSideSheetParent.SharedFlags).FFlagSideSheetFocusNav

local function UnibarItem(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), FFlagSideSheetFocusNav (copy), View (copy), IconHost (copy)
	local v13 = React.useCallback(function() -- line: 31
		-- upvalues: t1 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		t1.onActivated()
		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
	end, { t1.onActivated })
	local v14 = if not FFlagSideSheetFocusNav then nil else React.useRef(nil)

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
			onActivated = v13,
			selection = if not FFlagSideSheetFocusNav or not t1.disableGamepadDirections then nil else {
				NextSelectionLeft = if not t1.disableGamepadDirections.left then nil else v14
			},
			ref = v14
		})
	})
end

return React.memo(UnibarItem)
