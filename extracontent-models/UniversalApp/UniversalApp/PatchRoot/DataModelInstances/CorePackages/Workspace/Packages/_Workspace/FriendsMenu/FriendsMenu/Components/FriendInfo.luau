local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local Foundation = require(FriendsMenuParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local UserModel = require(FriendsMenuParent.UserLib).Models.UserModel
local LocalizationHelper = require(FriendsMenuParent.NotificationsCommon).LocalizationHelper

require(FriendsMenuParent.NotificationsCommon)
require(FriendsMenu.friendsMenuModalType)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local useStyle = UIBlox.Core.Style.useStyle
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings
local GetFFlagLuaAppEnableOpenTypeSupport = require(FriendsMenuParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local FFlagEnableBlackbirdCheck = require(FriendsMenuParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(FriendsMenuParent.UserProfiles).Hooks.useIsRobloxSubscriber
local t1 = {
	online = "Common.Presence.Label.Online",
	inStudio = "Common.Presence.Label.RobloxStudio"
}
local v19 = Images["icons/logo/studiologo_small"]

return function(t2: {[any]: any}) -- line: 57
	-- upvalues: useStyle (copy), getLocalizedStrings (copy), t1 (copy), UserModel (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), React (copy), Skeleton (copy), EnumsRadius (copy), Foundation (copy), ImageSetLabel (copy), v19 (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy)
	local v23 = useStyle()
	local Theme = v23.Theme
	local Font = v23.Font
	local v26 = Font.BaseSize * Font.Header2.RelativeSize
	local v27 = Font.BaseSize * Font.CaptionBody.RelativeSize
	local v28 = getLocalizedStrings(t1)
	local friend = t2.friend

	assert(friend, "friend should be non-nil. Silence type checker.")

	local v30 = friend.presence == UserModel.PresenceType.IN_STUDIO
	local v31 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck or not friend.id then nil else friend.id)
	local v32 = if not t2.isFetchingFriendsNames then if not FFlagEnableBlackbirdCheck or not v31 then React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextWrapped = true,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, v26),
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = friend.displayName,
		TextSize = v26,
		TextColor3 = Theme.TextEmphasis.Color,
		TextTransparency = Theme.TextEmphasis.Transparency,
		Font = Font.Header2.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd
	}) else React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, v26),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		DisplayName = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 0, v26),
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = friend.displayName,
			TextSize = v26,
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency,
			Font = Font.Header2.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Shrink
			})
		}),
		SubscriptionBadge = React.createElement(Foundation.Icon, {
			LayoutOrder = 2,
			name = Foundation.Enums.IconName.RobloxPlus,
			size = Foundation.Enums.IconSize.Small,
			style = {
				Color3 = Theme.TextEmphasis.Color,
				Transparency = Theme.TextEmphasis.Transparency
			}
		})
	}) else React.createElement(Skeleton, {
		LayoutOrder = 1,
		Size = UDim2.new(0, 120, 0, 10),
		radius = EnumsRadius.Small
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = t2.position,
		Size = t2.size,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12)
		}),
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		DisplayName = v32,
		UserContextContainer = t2.isFetchingFriendsNames and React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 80, 0, 10),
			radius = EnumsRadius.Small
		}) or React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, v27)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			StudioImage = v30 and React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Image = v19,
				ImageColor3 = Theme.TextDefault.Color,
				ImageTransparency = Theme.TextDefault.Transparency,
				Size = UDim2.new(0, v27, 0, v27)
			}),
			UserContext = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 2,
				Size = UDim2.new(1, -v27, 0, v27),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = if friend.presence ~= UserModel.PresenceType.IN_GAME then if friend.presence ~= UserModel.PresenceType.ONLINE then if friend.presence ~= UserModel.PresenceType.IN_STUDIO then "@" .. friend.name else v28.inStudio else v28.online else friend.lastLocation,
				TextSize = v27,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				Font = Font.CaptionBody.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				OpenTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
			})
		})
	})
end
