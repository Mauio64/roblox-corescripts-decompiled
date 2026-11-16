local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local IconHost = require(script.Parent.IconHost)

local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)

local closePeoplePageOpenedWithSideSheet = require(InExperienceSideSheet.Utils.closePeoplePageOpenedWithSideSheet)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local Flags = require(InExperienceSideSheet.Flags)
local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local function UnibarItem(props)
	local onActivated = React.useCallback(function()
		props.onActivated()

		if FFlagSideSheetOpenPeoplePage then
			closePeoplePageOpenedWithSideSheet()
		end

		toggleSideSheet(false)
		SidesheetAnalytics.logSidesheetClosed(AnalyticsConstants.Source.ItemSelected)
	end, { props.onActivated })
	local ref

	if FFlagSideSheetFocusNav then
		ref = React.useRef(nil)
	end

	local createElement = React.createElement
	local v = { tag = "auto-xy", LayoutOrder = props.layoutOrder }
	local v2 = {
		IconHost = React.createElement(IconHost, {
			icon = props.icon,
			notification = props.notification
		}),
		ActivationOverlay = 0
	}

	local createElement2 = React.createElement
	local selection

	if FFlagSideSheetFocusNav and props.disableGamepadDirections then
		selection = { NextSelectionLeft = 0 }
		local nextSelectionLeft

		if props.disableGamepadDirections.left then
			nextSelectionLeft = ref
		end

		selection.NextSelectionLeft = nextSelectionLeft
	end

	v2.ActivationOverlay = createElement2(View, {
		tag = "size-full radius-circle",
		ZIndex = 10,
		onActivated = onActivated,
		selection = selection,
		ref = ref
	})
	return createElement(View, v, v2)
end

return React.memo(UnibarItem)
