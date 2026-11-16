local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text

local AnalyticsConstants = require(InExperienceSideSheet.Analytics.AnalyticsConstants)
local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)

local closePeoplePageOpenedWithSideSheet = require(InExperienceSideSheet.Utils.closePeoplePageOpenedWithSideSheet)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local Flags = require(InExperienceSideSheet.Flags)
local SharedFlags = require(parent.SharedFlags)
local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav

local function VerticalItem(props)
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
	else
		ref = nil
	end

	local ref2

	if FFlagSideSheetFocusNav then
		ref2 = React.useCallback(function(current)
			if ref then
				ref.current = current
			end

			if current and props.firstIntegrationToFocusCallback then
				props.firstIntegrationToFocusCallback(current)
			end
		end, { props.firstIntegrationToFocusCallback })
	end

	local createElement = React.createElement
	local v = {
		tag = "row align-y-center gap-none size-full-1000 padding-left-xsmall radius-medium",
		LayoutOrder = props.layoutOrder,
		onActivated = onActivated,
		selection = 0,
		ref = 0
	}
	local selection

	if FFlagSideSheetFocusNav and props.disableGamepadDirections then
		selection = { NextSelectionRight = 0, NextSelectionLeft = 0 }
		local nextSelectionRight

		if props.disableGamepadDirections.right then
			nextSelectionRight = ref
		end

		selection.NextSelectionRight = nextSelectionRight
		local nextSelectionLeft

		if props.disableGamepadDirections.left then
			nextSelectionLeft = ref
		end

		selection.NextSelectionLeft = nextSelectionLeft
	end

	v.selection = selection

	if not FFlagSideSheetFocusNav then
		ref2 = nil
	end

	v.ref = ref2
	return createElement(View, v, {
		IconContainer = React.createElement(
			View,
			{ tag = "align-x-center align-y-center size-1000", LayoutOrder = 1 },
			{
				Icon = props.icon({ visible = true })
			}
		),
		Label = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.label,
			tag = "auto-xy padding-x-small text-label-medium text-align-x-left text-truncate-split content-emphasis"
		})
	})
end

return React.memo(VerticalItem)
