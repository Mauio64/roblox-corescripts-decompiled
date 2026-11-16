local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local GuiService = game:GetService("GuiService")

local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local UserProfiles = require(parent.UserProfiles)
local formatUsername = UserProfiles.Formatters.formatUsername

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ControlState = Foundation.Enums.ControlState
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local ConnectButton = require(PeopleReactView.Components.Card.ConnectButton)

local PersonButtonConfigs = require(PeopleReactView.Configs.PersonButtonConfigs)
local useGetPeopleService = require(PeopleReactView.Hooks.useGetPeopleService)
local useInExperienceCombinedName = require(PeopleReactView.Hooks.useInExperienceCombinedName)
local useIsComponentInputEnded = require(PeopleReactView.Hooks.useIsComponentInputEnded)

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local SharedFlags = require(parent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage
local FFlagSideSheetOpenPeoplePage = SharedFlags.FFlagSideSheetOpenPeoplePage

local function CardDetails(props)
	local ref = React.useRef(nil)
	local v

	if FFlagAddIEMProfilePage then
		v = useGetPeopleService("PeopleAnalyticsManager")
	else
		v = nil
	end

	local v2

	if FFlagAddIEMProfilePage then
		v2 = useGetPeopleService("SettingsHubService")
	else
		v2 = nil
	end

	local text = useInExperienceCombinedName(props.person.UserId, props.person.DisplayName)

	local v3 = useIsComponentInputEnded(ref)

	local state, setState = React.useState(false)

	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover or p == ControlState.Pressed)
	end, {})
	local icon, isDisabled, v4, onActivated

	if FFlagSideSheetOpenPeoplePage then
		v4 = nil
	else
		local v5 = useGetPeopleService("FriendStatusStore")
		local v6 = useGetPeopleService("Constants")

		local personButtonConfigs = PersonButtonConfigs(props.person.UserId)

		v4 = React.useMemo(function()
			return personButtonConfigs[v6.PERSON_BUTTONS.ADD_FRIEND]
		end, { personButtonConfigs })

		local v7 = SignalsReact.useSignalState(v5.getFriendStatus(props.person.UserId))

		local v8 = SignalsReact.useSignalState(v5.getIsFriendButtonGrayedOut(props.person.UserId))

		icon = React.useMemo(function()
			if v7 then
				return { name = IconName.PersonCheck, variant = IconVariant.Filled }
			end

			if v8 then
				return { name = IconName.Clock, variant = IconVariant.Filled }
			end

			return { name = IconName.PersonPlus, variant = IconVariant.Regular }
		end, { v7, v8 })

		isDisabled = SignalsReact.useSignalState(v5.getIsFriendButtonDisabled(props.person.UserId))

		onActivated = React.useCallback(function()
			v4.onActivated(v6.ANALYTICS.ENTRY_POINT.PEOPLE_CARD)
		end, { v4.onActivated })
	end

	local onActivated2

	if FFlagAddIEMProfilePage then
		onActivated2 = React.useCallback(function()
			local hubRef = v2.hubRef()

			if hubRef then
				hubRef:SwitchToReactPage(hubRef.PlayerProfilePage, {
					userId = props.person.UserId,
					inspectAvatar = function()
						local v5

						if engineFeature then
							v5 = RbxAnalyticsService:GetPlaySessionId()
						end

						v:trackInspectButton(game.GameId, v5, "player_profile")

						GuiService:InspectPlayerFromUserIdWithCtx(props.person.UserId, "playerProfile")
						hubRef:SetVisibility(false)
					end,
					closePage = function()
						hubRef:CloseReactPage()
					end
				})
			end
		end, {})
	end

	local connectButtonBackground

	if FFlagSideSheetOpenPeoplePage then
		if not props.isCompactCardLayout then
			connectButtonBackground = React.createElement(ConnectButton, {
				person = props.person,
				layoutOrder = 2,
				onStateChanged = onStateChanged
			})
		end
	else
		local createElement = React.createElement
		local v5 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			LayoutOrder = 2,
			stateLayer = { affordance = StateLayerAffordance.None },
			onStateChanged = onStateChanged
		}

		local createElement2 = React.createElement
		local variant

		if isDisabled then
			variant = ButtonVariant.Utility
		else
			variant = ButtonVariant.Standard
		end

		connectButtonBackground = createElement(View, v5, {
			ConnectButton = createElement2(IconButton, {
				icon = icon,
				variant = variant,
				size = InputSize.Medium,
				isDisabled = isDisabled,
				Visible = v4.shouldShow(),
				onActivated = onActivated
			})
		})
	end

	local createElement = React.createElement
	local v5 = {
		tag = "row size-full-1400 align-y-center padding-x-small radius-medium",
		LayoutOrder = props.layoutOrder,
		stateLayer = 0,
		onActivated = 0,
		ref = 0
	}
	local affordance

	if state or v3 then
		affordance = StateLayerAffordance.None
	else
		affordance = StateLayerAffordance.Background
	end

	v5.stateLayer = { affordance = affordance }

	if not FFlagAddIEMProfilePage then
		onActivated2 = nil
	end

	v5.onActivated = onActivated2
	v5.ref = ref
	return createElement(View, v5, {
		NameContainer = React.createElement(View, { tag = "col fill auto-y", LayoutOrder = 1 }, {
			Name = React.createElement(Text, {
				tag = "size-full-0 auto-y content-emphasis text-title-medium text-align-x-left text-truncate-end padding-right-small",
				Text = text,
				LayoutOrder = 1
			}),
			Handle = React.createElement(Text, {
				tag = "size-full-0 auto-y content-default text-body-medium text-align-x-left text-truncate-end padding-right-small",
				Text = formatUsername(props.person.Name),
				LayoutOrder = 2
			})
		}),
		ConnectButtonBackground = connectButtonBackground
	})
end

return React.memo(CardDetails)
