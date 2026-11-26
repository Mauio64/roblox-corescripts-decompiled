local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib").Models.UserModel
local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon").LocalizationHelper
require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/NotificationsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local openTypeSupport = UIBlox.Utility.OpenTypeSupport

local useStyle = UIBlox.Core.Style.useStyle
local getLocalizedStrings = localizationHelper.getLocalizedStrings

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/SharedFlags").FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/UserProfiles").Hooks.useIsRobloxSubscriber

local v5 = {
	online = "Common.Presence.Label.Online",
	inStudio = "Common.Presence.Label.RobloxStudio"
}

local iconslogostudiologo_small = images["icons/logo/studiologo_small"]

return function(props)
	local v6 = useStyle()

	local theme = v6.Theme
	local font = v6.Font

	local v7 = font.BaseSize * font.Header2.RelativeSize
	local v8 = font.BaseSize * font.CaptionBody.RelativeSize

	local localizedStrings = getLocalizedStrings(v5)

	local friend = props.friend
	assert(friend, "friend should be non-nil. Silence type checker.")
	local v9 = friend.presence == userModel.PresenceType.IN_STUDIO

	local v11 = if fFlagEnableBlackbirdCheck and friend.id then friend.id else nil
	local v12 = useIsRobloxSubscriber(v11)
	local v13

	if props.isFetchingFriendsNames then
		v13 = React.createElement(skeleton, {
			Size = UDim2.new(0, 120, 0, 10),
			radius = radius.Small,
			LayoutOrder = 1
		})
	elseif fFlagEnableBlackbirdCheck and v12 then
		v13 = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v7),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			},
			{
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				DisplayName = React.createElement("TextLabel", {
					Size = UDim2.new(0, 0, 0, v7),
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = friend.displayName,
					TextSize = v7,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = false,
					TextTruncate = Enum.TextTruncate.AtEnd,
					LayoutOrder = 1
				}, {
					UIFlexItem = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Shrink
					})
				}),
				SubscriptionBadge = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small,
					style = {
						Color3 = theme.TextEmphasis.Color,
						Transparency = theme.TextEmphasis.Transparency
					},
					LayoutOrder = 2
				})
			}
		)
	else
		v13 = React.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, v7),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = friend.displayName,
			TextSize = v7,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			FontFace = normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			LayoutOrder = 1
		})
	end

	local createElement = React.createElement
	local v15 = {
		Position = props.position,
		Size = props.size,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local v16 = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}),
		Padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, 12) }),
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		DisplayName = v13,
		UserContextContainer = 0
	}

	local v17 = props.isFetchingFriendsNames
		and React.createElement(skeleton, {
			Size = UDim2.new(0, 80, 0, 10),
			radius = radius.Small,
			LayoutOrder = 2
		})

	if not v17 then
		local createElement2 = React.createElement
		local v19 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, v8),
			ClipsDescendants = true
		}

		local v20 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			StudioImage = v9 and React.createElement(imageSetLabel, {
				Image = iconslogostudiologo_small,
				ImageColor3 = theme.TextDefault.Color,
				ImageTransparency = theme.TextDefault.Transparency,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v8, 0, v8),
				LayoutOrder = 1
			}),
			UserContext = 0
		}

		local createElement3 = React.createElement
		local v22 = {
			Size = UDim2.new(1, -v8, 0, v8),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			FontFace = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextWrapped = true,
			TextTruncate = 0,
			LayoutOrder = 2,
			OpenTypeFeatures = 0
		}
		local v23

		if friend.presence == userModel.PresenceType.IN_GAME then
			v23 = friend.lastLocation
		elseif friend.presence == userModel.PresenceType.ONLINE then
			v23 = localizedStrings.online
		elseif friend.presence == userModel.PresenceType.IN_STUDIO then
			v23 = localizedStrings.inStudio
		else
			v23 = "@" .. friend.name
		end

		v22.Text = v23
		v22.TextSize = v8
		v22.TextColor3 = theme.TextEmphasis.Color
		v22.TextTransparency = theme.TextEmphasis.Transparency
		v22.FontFace = normalizeFontFace(v6.Tokens.Typography.BodySmall.Font)

		v22.TextXAlignment = Enum.TextXAlignment.Left

		v22.TextTruncate = Enum.TextTruncate.AtEnd

		local v24 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
		v22.OpenTypeFeatures = v24
		v20.UserContext = createElement3("TextLabel", v22)
		v17 = createElement2("Frame", v19, v20)
	end

	v16.UserContextContainer = v17
	return createElement("Frame", v15, v16)
end
