local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local Foundation = require(Parent.Foundation)
local SignalsReact = require(Parent.SignalsReact)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local FriendsStore = require(Parent.DataHydration).Friends.FriendsStore
local SetCurrentToastMessage = require(Parent.ToastRodux).Actions.SetCurrentToastMessage
local Enums = require(Parent.FriendsNetworking).Enums
local IconButton = Foundation.IconButton
local Enums2 = Foundation.Enums
local Small = Enums2.InputSize.Small
local v13 = Enums.FriendshipOriginSourceType.PlayerSearch.rawValue()

local function SduiFriendRequestButton(t1: {[any]: any}) -- line: 46
	-- upvalues: useDispatch (copy), SignalsReact (copy), FriendsStore (copy), React (copy), v13 (copy), SetCurrentToastMessage (copy), IconButton (copy), Enums2 (copy), Small (copy)
	local userId = t1.userId
	local v17 = useDispatch()
	local v18 = SignalsReact.useSignalState(FriendsStore.get().GetFriendshipStatus(userId or "").data)
	local v19 = v18 == Enum.FriendStatus.FriendRequestSent or v18 == Enum.FriendStatus.FriendRequestReceived
	local v20 = React.useCallback(function() -- line: 60
		-- upvalues: v19 (copy), userId (copy), t1 (copy), v13 (copy), FriendsStore (copy), v17 (copy), SetCurrentToastMessage (copy)
		if v19 or userId == nil then
			return
		end

		local v21 = if typeof(t1.source) ~= "string" or t1.source == "" then v13 else t1.source

		FriendsStore.get().RequestFriendship(userId, v21):andThen(function() -- line: 71
			-- upvalues: v17 (copy), SetCurrentToastMessage (copy)
			v17(SetCurrentToastMessage({
				toastMessage = "Feature.Friends.Action.FriendRequestSent",
				isLocalized = false
			}))
		end):catch(function(_) -- line: 77
			-- upvalues: v17 (copy), SetCurrentToastMessage (copy)
			v17(SetCurrentToastMessage({
				toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong",
				isLocalized = false
			}))
		end)
	end, {
		v19,
		userId,
		t1.source,
		v17
	})

	if v18 == nil or v18 == Enum.FriendStatus.Friend then
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
			variant = if not v19 then Enums2.ButtonVariant.OverMedia else Enums2.ButtonVariant.SubEmphasis,
			isDisabled = v19,
			size = t1.size or Small,
			onActivated = v20
		})
	})
end

return React.memo(SduiFriendRequestButton)
