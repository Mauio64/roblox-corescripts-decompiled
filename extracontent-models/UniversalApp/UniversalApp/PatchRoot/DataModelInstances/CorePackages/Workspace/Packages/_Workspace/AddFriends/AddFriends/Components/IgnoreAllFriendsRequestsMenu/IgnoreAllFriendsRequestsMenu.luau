local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local UIBlox = require(AddFriendsParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local BaseMenu = UIBlox.App.Menu.BaseMenu
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local useDispatch = require(AddFriendsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local ToastRodux = require(AddFriendsParent.ToastRodux)
local useDesignTokens = require(AddFriendsParent.Style).useDesignTokens
local useLocalUserId = require(AddFriendsParent.RobloxAppHooks).useLocalUserId
local FriendsNetworking = require(AddFriendsParent.AddFriendsState).Networking.FriendsNetworking
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local EventNames = require(AddFriends.Analytics).EventNames

local function IgnoreAllFriendsRequestsMenu(t1: {[any]: any}) -- line: 31
	-- upvalues: useDispatch (copy), useLocalization (copy), useDesignTokens (copy), useLocalUserId (copy), useFireAnalyticsEvent (copy), React (copy), ToastRodux (copy), EventNames (copy), FriendsNetworking (copy), Images (copy), BaseMenu (copy)
	local open = t1.open
	local v18 = t1.width or UDim.new(0, 300)
	local v19 = t1.openPositionY or UDim.new(0, 0)
	local closeMenu = t1.closeMenu
	local v21 = useDispatch()
	local v22 = useLocalization({
		ignoreAllLabel = "Feature.AddFriends.Action.IgnoreAll"
	})
	local v23 = useDesignTokens()
	local v24 = useLocalUserId()
	local v25 = useFireAnalyticsEvent()
	local v26 = React.useCallback(function(p1) -- line: 46
		-- upvalues: v21 (copy), ToastRodux (copy)
		if not p1 then
			return
		end

		v21(ToastRodux.Actions.SetCurrentToastMessage({
			toastMessage = p1.toastTitle,
			toastIcon = p1.iconImage
		}))
	end, { v21 })
	local v27 = React.useCallback(function() -- line: 58
		-- upvalues: v25 (copy), EventNames (copy), v21 (copy), FriendsNetworking (copy), v24 (copy), v26 (copy), Images (copy)
		v25(EventNames.IgnoreAllBtnClick)

		return v21(FriendsNetworking.DeclineAllFriendRequests.API({
			currentUserId = v24
		})):andThen(function(p2) -- line: 63
			-- upvalues: v26 (copy), Images (copy)
			v26({
				toastTitle = (not p2 or (not p2.responseBody or not p2.responseBody.backgrounded)) and "Feature.Profile.Action.AllRequestsIgnored" or "Feature.AddFriends.Label.DeclineAllBackgrounded",
				iconImage = Images["icons/actions/reject"]
			})
		end)
	end, {
		v24,
		v25
	})
	local v28 = React.useCallback(function() -- line: 80
		-- upvalues: v27 (copy), closeMenu (copy)
		v27()
		closeMenu()
	end, {
		v27,
		closeMenu
	})

	return open and React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		ZIndex = 5,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		IgnoreAllMenuFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v23.Size.Size_1200)
		}, {
			IgnoreAllFriendsRequestsMenu = React.createElement(BaseMenu, {
				width = v18,
				buttonProps = {{
					text = v22.ignoreAllLabel,
					onActivated = v28
				}},
				anchorPoint = Vector2.new(1, 0),
				position = UDim2.new(UDim.new(1, 0), v19)
			})
		})
	}) or nil
end

return IgnoreAllFriendsRequestsMenu
