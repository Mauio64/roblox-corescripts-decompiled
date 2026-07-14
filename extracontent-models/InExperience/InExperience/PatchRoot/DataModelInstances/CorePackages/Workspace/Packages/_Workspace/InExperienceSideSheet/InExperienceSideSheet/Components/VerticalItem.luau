local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local InExperienceSideSheetParent = InExperienceSideSheet.Parent
local React = require(InExperienceSideSheetParent.React)
local Foundation = require(InExperienceSideSheetParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)
local FFlagSideSheetFocusNav = require(InExperienceSideSheetParent.SharedFlags).FFlagSideSheetFocusNav

local function VerticalItem(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy), FFlagSideSheetFocusNav (copy), View (copy), FoundationText (copy)
	local v13 = React.useCallback(function() -- line: 31
		-- upvalues: t1 (copy), toggleSideSheet (copy), SidesheetAnalytics (copy), AnalyticsConstants (copy)
		t1.onActivated()
		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
	end, { t1.onActivated })
	local v14 = if not FFlagSideSheetFocusNav then nil else React.useRef(nil)
	local v15 = if not FFlagSideSheetFocusNav then nil else React.useCallback(function(p1) -- line: 39
		-- upvalues: v14 (copy), t1 (copy)
		if v14 then
			v14.current = p1
		end

		if p1 and t1.firstIntegrationToFocusCallback then
			t1.firstIntegrationToFocusCallback(p1)
		end
	end, { t1.firstIntegrationToFocusCallback })

	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y radius-medium",
		LayoutOrder = t1.layoutOrder,
		onActivated = v13,
		selection = if not FFlagSideSheetFocusNav or not t1.disableGamepadDirections then nil else {
			NextSelectionRight = if not t1.disableGamepadDirections.right then nil else v14,
			NextSelectionLeft = if not t1.disableGamepadDirections.left then nil else v14
		},
		ref = if not FFlagSideSheetFocusNav then nil else v15
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
