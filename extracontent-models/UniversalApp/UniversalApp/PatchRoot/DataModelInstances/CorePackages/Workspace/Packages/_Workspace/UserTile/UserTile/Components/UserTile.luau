local UserTile = script:FindFirstAncestor("UserTile")
local UserTileParent = UserTile.Parent
local React = require(UserTileParent.React)
local Foundation = require(UserTileParent.Foundation)
local TitleStack = require(UserTile.Components.TitleStack)
local Avatar = require(UserTile.Components.Avatar)
local AvatarPile = require(UserTile.Components.AvatarPile)
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local Enums = Foundation.Enums
local LayoutMode = require(script.Parent.Parent.Enums.LayoutMode)
local FFlagProfilePlatformNewProfileHeader = require(UserTileParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagUserTileShowShimmerWhenLoading = require(UserTile.Flags.FFlagUserTileShowShimmerWhenLoading)
local FFlagUserTileTextTCIndicator = require(UserTileParent.SharedFlags).FFlagUserTileTextTCIndicator
local FFlagEnableBlackbirdCheck = require(UserTileParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagUserTileShowBadges = require(UserTileParent.SharedFlags).FFlagUserTileShowBadges
local FFlagEnableMobileGameJoinCard = require(UserTileParent.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagUserTileAddContextualInfoIcon = require(UserTileParent.SharedFlags).FFlagUserTileAddContextualInfoIcon

local function UserTile2(t1: {[any]: any}) -- line: 55
	-- upvalues: React (copy), ControlState (copy), View (copy), LayoutMode (copy), Enums (copy), AvatarPile (copy), Avatar (copy), FFlagUserTileShowShimmerWhenLoading (copy), TitleStack (copy), FFlagUserTileShowBadges (copy), FFlagUserTileAddContextualInfoIcon (copy), FFlagProfilePlatformNewProfileHeader (copy), FFlagEnableMobileGameJoinCard (copy), FFlagUserTileTextTCIndicator (copy), FFlagEnableBlackbirdCheck (copy)
	local v21, v22 = React.useState(false)
	local v23 = t1.onActivated ~= nil
	local v24 = React.useCallback(function(p1) -- line: 58
		-- upvalues: v22 (copy), v23 (copy), ControlState (copy), t1 (copy)
		v22(v23 and (p1 == ControlState.Hover or p1 == ControlState.Pressed))

		if t1.onStateChanged then
			t1.onStateChanged(p1)
		end
	end, {
		t1.onActivated,
		t1.onStateChanged
	})

	return React.createElement(View, {
		tag = {
			["size-full"] = true,
			["col align-x-center gap-small"] = t1.layoutMode == LayoutMode.compact,
			["row align-y-center gap-medium"] = t1.layoutMode == LayoutMode.wide
		},
		selection = {
			Selectable = t1.selectable
		},
		onStateChanged = v24,
		onActivated = t1.onActivated,
		stateLayer = {
			affordance = Enums.StateLayerAffordance.None
		}
	}, {
		AvatarThumbnail = React.createElement(View, {
			tag = "size-full aspect-1-1",
			LayoutOrder = 1,
			Size = t1.avatarSize
		}, {
			AvatarComponent = if not t1.facePileSecondUserId then React.createElement(Avatar, {
				layoutOrder = 1,
				ZIndex = 2,
				avatarThumbnailUrl = if not FFlagUserTileShowShimmerWhenLoading then nil else t1.avatarThumbnailUrl,
				userId = t1.userId,
				userPresenceType = t1.userPresenceType,
				hover = v21,
				backplateStyle = t1.backplateStyle
			}) else React.createElement(AvatarPile, {
				layoutOrder = 1,
				ZIndex = 2,
				primaryUserId = t1.userId,
				secondUserId = t1.facePileSecondUserId,
				userPresenceType = t1.userPresenceType,
				hover = v21
			})
		}),
		TitleStack = React.createElement(TitleStack, {
			layoutOrder = 2,
			ZIndex = 1,
			title = t1.title,
			isVerified = if not FFlagUserTileShowBadges then nil else t1.isVerified,
			isPremium = if not FFlagUserTileShowBadges then nil else t1.isPremium,
			isRobloxAdmin = if not FFlagUserTileShowBadges then nil else t1.isRobloxAdmin,
			subtitle = t1.subtitle,
			contextualInfo = t1.contextualInfo,
			contextualInfoIcon = if not FFlagUserTileAddContextualInfoIcon then nil else t1.contextualInfoIcon,
			layoutMode = t1.layoutMode,
			titleStyle = t1.titleStyle,
			subtitleStyle = t1.subtitleStyle,
			contextualInfoStyle = t1.contextualInfoStyle,
			titleIcon = t1.titleIcon,
			onSubtitleClicked = if not FFlagProfilePlatformNewProfileHeader and not FFlagEnableMobileGameJoinCard then nil else t1.onSubtitleClicked,
			isTitleLoading = if not FFlagUserTileShowShimmerWhenLoading then nil else t1.isTitleLoading,
			isSubtitleLoading = if not FFlagUserTileShowShimmerWhenLoading then nil else t1.isSubtitleLoading,
			isContextualInfoLoading = if not FFlagUserTileShowShimmerWhenLoading then nil else t1.isContextualInfoLoading,
			customTextTruncation = t1.customTextTruncation,
			isTrustedConnection = if not FFlagUserTileTextTCIndicator then nil else t1.isTrustedConnection,
			trustedConnectionIndicatorEnabled = if not FFlagUserTileTextTCIndicator then nil else t1.trustedConnectionIndicatorEnabled,
			isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else t1.isRobloxSubscriber
		})
	})
end

return UserTile2
