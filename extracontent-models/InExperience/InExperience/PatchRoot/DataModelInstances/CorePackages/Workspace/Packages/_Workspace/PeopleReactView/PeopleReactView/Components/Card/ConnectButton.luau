local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local IconButton = Foundation.IconButton
local View = Foundation.View

local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)

local function ConnectButton(props)
	local v = useGetPeopleService("FriendStatusStore")
	local v2 = useGetPeopleService("Constants")

	local personButtonConfigs = PersonButtonConfigs(props.person.UserId)

	local v3 = React.useMemo(function()
		return personButtonConfigs[v2.PERSON_BUTTONS.ADD_FRIEND]
	end, { personButtonConfigs, v2.PERSON_BUTTONS.ADD_FRIEND })

	local v4 = SignalsReact.useSignalState(v.getFriendStatus(props.person.UserId))

	local v5 = SignalsReact.useSignalState(v.getIsFriendButtonGrayedOut(props.person.UserId))

	local icon = React.useMemo(function()
		if v4 then
			return { name = IconName.PersonCheck, variant = IconVariant.Filled }
		end

		if v5 then
			return { name = IconName.Clock, variant = IconVariant.Filled }
		end

		return { name = IconName.PersonPlus, variant = IconVariant.Regular }
	end, { v4, v5 })

	local isDisabled = SignalsReact.useSignalState(v.getIsFriendButtonDisabled(props.person.UserId))

	local onActivated = React.useCallback(function()
		v3.onActivated(v2.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
	end, { v3.onActivated, v2.ANALYTICS.ENTRY_POINT.PEOPLE_CARD })

	local createElement = React.createElement
	local v6 = {
		tag = "auto-xy",
		LayoutOrder = props.layoutOrder,
		stateLayer = { affordance = StateLayerAffordance.None },
		onStateChanged = props.onStateChanged
	}

	local createElement2 = React.createElement
	local variant

	if isDisabled then
		variant = ButtonVariant.Utility
	else
		variant = ButtonVariant.Standard
	end

	return createElement(View, v6, {
		ConnectButton = createElement2(IconButton, {
			icon = icon,
			variant = variant,
			size = props.size or InputSize.Medium,
			isDisabled = isDisabled,
			Visible = v3.shouldShow(),
			onActivated = onActivated
		})
	})
end

return React.memo(ConnectButton)
