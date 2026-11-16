local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RoactUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/Foundation")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SignalsReact")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local firePlayerFriendAddTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Analytics/firePlayerFriendAddTelemetry")
local SduiRequestFriendshipAction = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Actions/SduiRequestFriendshipAction")
local getCurrentUserId = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Common/getCurrentUserId")
local friendsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/DataHydration").Friends.FriendsStore
local friendsStoreChallengeNetwork = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Networking/friendsStoreChallengeNetwork")

local fFlagEnableFriendsStoreChallengeInterceptor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagEnableFriendsStoreChallengeInterceptor
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/ToastRodux").Actions.SetCurrentToastMessage
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/NetworkingFriends").Enums

local sduiActionType = SduiCoreSystem.SduiActionType

local iconButton = Foundation.IconButton
local enums2 = Foundation.Enums

local fFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags.FFlagSduiSearchPeoplePlayerTileTelemetry
local fFlagSduiRequestFriendshipActionHandler = SharedFlags.FFlagSduiRequestFriendshipActionHandler

local FFlagSduiFriendRequestButtonHideForSelf = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Flags/FFlagSduiFriendRequestButtonHideForSelf")

local small = enums2.InputSize.Small
local rawValue = enums.FriendshipOriginSourceType.PlayerSearch.rawValue()

local function SduiFriendRequestButton(props)
	local userId = props.userId
	local v5 = useDispatch()

	local v6 = SignalsReact.useSignalState(friendsStore.get().GetFriendshipStatus(userId or "").data)

	local v7 = v6 == Enum.FriendStatus.FriendRequestSent or v6 == Enum.FriendStatus.FriendRequestReceived

	local useCallback = React.useCallback
	local function fn()
		if v7 or userId == nil then
			return
		end

		if fFlagSduiRequestFriendshipActionHandler and props.sduiContext then
			SduiRequestFriendshipAction({
				actionType = sduiActionType.RequestFriendship,
				actionParams = { targetUserId = userId, source = props.source }
			}, props.analyticsContext, props.sduiContext)
			return
		end

		local v8 = if typeof(props.source) == "string" and props.source ~= "" then props.source else rawValue

		local requestFriendship = friendsStore.get().RequestFriendship
		local v11 = if fFlagEnableFriendsStoreChallengeInterceptor then friendsStoreChallengeNetwork else nil
		requestFriendship(userId, v8, nil, v11):andThen(function()
			v5(setCurrentToastMessage({
				toastMessage = "Feature.Friends.Action.FriendRequestSent",
				isLocalized = false
			}))
		end):catch(function(p2)
			v5(setCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
				isLocalized = false
			}))
		end)

		if fFlagSduiSearchPeoplePlayerTileTelemetry then
			firePlayerFriendAddTelemetry(userId, props.analyticsContext, props.sduiContext)
		end
	end

	local source = props.source
	local analyticsContext

	if fFlagSduiSearchPeoplePlayerTileTelemetry or fFlagSduiRequestFriendshipActionHandler then
		analyticsContext = props.analyticsContext
	end

	local v9 = if fFlagSduiSearchPeoplePlayerTileTelemetry or fFlagSduiRequestFriendshipActionHandler then props.sduiContext else nil
	local v10 = useCallback(fn, { v7, userId, source, v5, analyticsContext, v9 })

	if
		v6 == nil
		or v6 == Enum.FriendStatus.Friend
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
		Button = React.createElement(iconButton, {
			icon = "icons/common/plus_small",
			variant = enums2.ButtonVariant.OverMedia,
			isDisabled = v7,
			isCircular = true,
			size = props.size or small,
			onActivated = v10
		})
	})
end

return React.memo(SduiFriendRequestButton)
