local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local SocialServerDrivenUiParent = SocialServerDrivenUi.Parent
local React = require(SocialServerDrivenUiParent.React)
local RoactUtils = require(SocialServerDrivenUiParent.RoactUtils)
local Foundation = require(SocialServerDrivenUiParent.Foundation)

require(SocialServerDrivenUiParent.SduiCoreSystem)

local SignalsReact = require(SocialServerDrivenUiParent.SignalsReact)
local SharedFlags = require(SocialServerDrivenUiParent.SharedFlags)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local firePlayerFriendAddTelemetry = require(SocialServerDrivenUi.Analytics.firePlayerFriendAddTelemetry)
local FriendsStore = require(SocialServerDrivenUiParent.DataHydration).Friends.FriendsStore
local SetCurrentToastMessage = require(SocialServerDrivenUiParent.ToastRodux).Actions.SetCurrentToastMessage
local Enums = require(SocialServerDrivenUiParent.FriendsNetworking).Enums
local IconButton = Foundation.IconButton
local Enums2 = Foundation.Enums
local FFlagSduiSearchPeoplePlayerTileTelemetry = SharedFlags.FFlagSduiSearchPeoplePlayerTileTelemetry
local Small = Enums2.InputSize.Small
local v17 = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()

local function SduiFriendRequestButton(t1: {[any]: any}) -- line: 56
	-- upvalues: useDispatch (copy), SignalsReact (copy), FriendsStore (copy), React (copy), v17 (copy), SetCurrentToastMessage (copy), FFlagSduiSearchPeoplePlayerTileTelemetry (copy), firePlayerFriendAddTelemetry (copy), IconButton (copy), Enums2 (copy), Small (copy)
	local userId = t1.userId
	local v21 = useDispatch()
	local v22 = SignalsReact.useSignalState(FriendsStore.get().GetFriendshipStatus(userId or "").data)
	local v23 = v22 == Enum.FriendStatus.FriendRequestSent or v22 == Enum.FriendStatus.FriendRequestReceived
	local v24 = React.useCallback(function() -- line: 71
		-- upvalues: v23 (copy), userId (copy), t1 (copy), v17 (copy), FriendsStore (copy), v21 (copy), SetCurrentToastMessage (copy), FFlagSduiSearchPeoplePlayerTileTelemetry (copy), firePlayerFriendAddTelemetry (copy)
		if v23 or userId == nil then
			return
		end

		local v25 = if typeof(t1.source) ~= "string" or t1.source == "" then v17 else t1.source

		FriendsStore.get().RequestFriendship(userId, v25):andThen(function() -- line: 82
			-- upvalues: v21 (copy), SetCurrentToastMessage (copy)
			v21(SetCurrentToastMessage({
				toastMessage = "Feature.Friends.Action.FriendRequestSent",
				isLocalized = false
			}))
		end):catch(function(_) -- line: 88
			-- upvalues: v21 (copy), SetCurrentToastMessage (copy)
			v21(SetCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
				isLocalized = false
			}))
		end)

		if FFlagSduiSearchPeoplePlayerTileTelemetry then
			firePlayerFriendAddTelemetry(userId, t1.analyticsContext, t1.sduiContext)
		end
	end, {
		v23,
		userId,
		t1.source,
		v21,
		if not FFlagSduiSearchPeoplePlayerTileTelemetry then nil else t1.analyticsContext,
		if not FFlagSduiSearchPeoplePlayerTileTelemetry then nil else t1.sduiContext
	})

	if v22 == nil or v22 == Enum.FriendStatus.Friend then
		return nil
	end

	return React.createElement("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = t1.layoutOrder,
		Visible = t1.visible == nil or t1.visible
	}, {
		Button = React.createElement(IconButton, {
			icon = "icons/common/plus_small",
			isCircular = true,
			variant = Enums2.ButtonVariant.OverMedia,
			isDisabled = v23,
			size = t1.size or Small,
			onActivated = v24
		})
	})
end

return React.memo(SduiFriendRequestButton)
