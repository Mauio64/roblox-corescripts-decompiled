local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local firePlayerFriendAddTelemetry = require(SocialServerDrivenUi.Analytics.firePlayerFriendAddTelemetry)
local SduiRequestFriendshipAction = require(SocialServerDrivenUi.Actions.SduiRequestFriendshipAction)
local getCurrentUserId = require(SocialServerDrivenUi.Common.getCurrentUserId)
local DataHydration = require(parent.DataHydration)
local FriendsStore = DataHydration.Friends.FriendsStore
local friendsStoreChallengeNetwork = require(SocialServerDrivenUi.Networking.friendsStoreChallengeNetwork)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableFriendsStoreChallengeInterceptor = SharedFlags2.FFlagEnableFriendsStoreChallengeInterceptor
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local FriendsNetworking = require(parent.FriendsNetworking)
local Enums = FriendsNetworking.Enums

local SduiActionType = SduiCoreSystem.SduiActionType

local IconButton = Foundation.IconButton
local enums = Foundation.Enums

local FFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags.FFlagSduiSearchPeoplePlayerTileTelemetry
local FFlagSduiRequestFriendshipActionHandler = SharedFlags.FFlagSduiRequestFriendshipActionHandler

local FFlagSduiFriendRequestButtonHideForSelf = require(SocialServerDrivenUi.Flags.FFlagSduiFriendRequestButtonHideForSelf)

local Small = enums.InputSize.Small
local rawValue = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()

local function SduiFriendRequestButton(props)
	local userId = props.userId
	local v = useDispatch()

	local v2 = SignalsReact.useSignalState(FriendsStore.get().GetFriendshipStatus(userId or "").data)

	local isDisabled = v2 == Enum.FriendStatus.FriendRequestSent or v2 == Enum.FriendStatus.FriendRequestReceived

	local useCallback = React.useCallback
	local function fn()
		if isDisabled or userId == nil then
			return
		end

		if FFlagSduiRequestFriendshipActionHandler and props.sduiContext then
			SduiRequestFriendshipAction({
				actionType = SduiActionType.RequestFriendship,
				actionParams = { targetUserId = userId, source = props.source }
			}, props.analyticsContext, props.sduiContext)
			return
		end

		local v3

		if typeof(props.source) == "string" and props.source ~= "" then
			v3 = props.source
		else
			v3 = rawValue
		end

		local requestFriendship = FriendsStore.get().RequestFriendship
		local v4

		if FFlagEnableFriendsStoreChallengeInterceptor then
			v4 = friendsStoreChallengeNetwork
		end

		requestFriendship(userId, v3, nil, v4):andThen(function()
			v(SetCurrentToastMessage({
				toastMessage = "Feature.Friends.Action.FriendRequestSent",
				isLocalized = false
			}))
		end):catch(function(_)
			v(SetCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
				isLocalized = false
			}))
		end)

		if FFlagSduiSearchPeoplePlayerTileTelemetry then
			firePlayerFriendAddTelemetry(userId, props.analyticsContext, props.sduiContext)
		end
	end

	local source = props.source
	local analyticsContext

	if FFlagSduiSearchPeoplePlayerTileTelemetry or FFlagSduiRequestFriendshipActionHandler then
		analyticsContext = props.analyticsContext
	end

	local v3

	if FFlagSduiSearchPeoplePlayerTileTelemetry or FFlagSduiRequestFriendshipActionHandler then
		v3 = props.sduiContext
	end

	local onActivated = useCallback(fn, { isDisabled, userId, source, v, analyticsContext, v3 })

	if
		v2 == nil
		or v2 == Enum.FriendStatus.Friend
		or FFlagSduiFriendRequestButtonHideForSelf and userId ~= nil and userId == getCurrentUserId()
	then
		return nil
	end

	return React.createElement("TextButton", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Text = "",
		LayoutOrder = props.layoutOrder,
		Visible = props.visible == nil or props.visible
	}, {
		Button = React.createElement(IconButton, {
			icon = "icons/common/plus_small",
			variant = enums.ButtonVariant.OverMedia,
			isDisabled = isDisabled,
			isCircular = true,
			size = props.size or Small,
			onActivated = onActivated
		})
	})
end

return React.memo(SduiFriendRequestButton)
