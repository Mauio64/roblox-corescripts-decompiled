local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local parent = InExperienceSideSheet.Parent
require(parent.Chrome)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local VerticalItem = require(InExperienceSideSheet.Components.VerticalItem)
local getDidSideSheetOpenWithPeoplePage = require(InExperienceSideSheet.Utils.getDidSideSheetOpenWithPeoplePage)
local shouldShowInviteFriendsInSideSheet = require(InExperienceSideSheet.Utils.shouldShowInviteFriendsInSideSheet)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagHidePeoplePageInviteFriends = SharedFlags.FFlagHidePeoplePageInviteFriends
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local Flags = require(InExperienceSideSheet.Flags)
local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage

local function VerticalList(props)
	local integrationsGetter = props.integrationsGetter
	local v = SignalsReact.useSignalState(integrationsGetter)
	local v2

	if FFlagSideSheetOpenPeoplePage then
		v2 = SignalsReact.useSignalState(getDidSideSheetOpenWithPeoplePage)
	else
		v2 = false
	end

	local v3 = not (FFlagHidePeoplePageInviteFriends and FFlagAddInviteFriendsIntegration)
	local count = 0
	local children = {}

	for _, v4 in v do
		if not shouldShowInviteFriendsInSideSheet(v4.id, v2, v3) then
			continue
		end

		count += 1
		local id = v4.id
		local createElement = React.createElement
		local v5 = {
			label = v4.integration.label,
			layoutOrder = count,
			onActivated = v4.activated,
			icon = v4.component,
			disableGamepadDirections = FFlagSideSheetFocusNav and {
				right = not props.allowRightFocusEscape,
				left = true
			} or nil,
			firstIntegrationToFocusCallback = 0
		}
		local firstIntegrationToFocusCallback

		if FFlagSideSheetFocusNav and count == 1 then
			firstIntegrationToFocusCallback = props.firstIntegrationToFocusCallback
		end

		v5.firstIntegrationToFocusCallback = firstIntegrationToFocusCallback
		children[id] = createElement(VerticalItem, v5)
	end

	return React.createElement(
		View,
		{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		children
	)
end

return React.memo(VerticalList)
