local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel
local NotificationsCommon = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon.LocalizationHelper
require(parent.NotificationsCommon)
require(FriendsMenu.friendsMenuModalType)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local useStyle = UIBlox.Core.Style.useStyle
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags2.FFlagEnableBlackbirdCheck
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local v = {
	online = "Common.Presence.Label.Online",
	inStudio = "Common.Presence.Label.RobloxStudio"
}

local iconslogostudiologo_small = Images["icons/logo/studiologo_small"]

local function fn(friend, localizedStrings) -- 1 equivalent call inferred from this helper
	if friend.presence == UserModel.PresenceType.IN_GAME then
		return friend.lastLocation
	end

	if friend.presence == UserModel.PresenceType.ONLINE then
		return localizedStrings.online
	end

	if friend.presence == UserModel.PresenceType.IN_STUDIO then
		return localizedStrings.inStudio
	end

	return "@" .. friend.name
end

return function(props)
	local v2 = useStyle()

	local theme = v2.Theme
	local font = v2.Font

	local textSize = font.BaseSize * font.Header2.RelativeSize
	local textSize2 = font.BaseSize * font.CaptionBody.RelativeSize

	local localizedStrings = getLocalizedStrings(v)

	local friend = props.friend
	assert(friend, "friend should be non-nil. Silence type checker.")
	local v3 = friend.presence == UserModel.PresenceType.IN_STUDIO
	local v4

	if FFlagEnableBlackbirdCheck and friend.id then
		v4 = friend.id
	end

	local v5 = useIsRobloxSubscriber(v4)
	local displayName

	if props.isFetchingFriendsNames then
		displayName = React.createElement(Skeleton, {
			Size = UDim2.new(0, 120, 0, 10),
			radius = Radius.Small,
			LayoutOrder = 1
		})
	elseif FFlagEnableBlackbirdCheck and v5 then
		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, textSize),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local children = {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			DisplayName = 0,
			SubscriptionBadge = 0
		}

		local createElement2 = React.createElement
		local v7 = {
			Size = UDim2.new(0, 0, 0, textSize),
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = friend.displayName,
			TextSize = textSize,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextWrapped = false,
			TextTruncate = 0,
			LayoutOrder = 1
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Header2.Font
		end

		v7.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Tokens.Typography.TitleLarge.Font)
		end

		v7.FontFace = fontFace

		v7.TextXAlignment = Enum.TextXAlignment.Left

		v7.TextTruncate = Enum.TextTruncate.AtEnd
		children.DisplayName = createElement2("TextLabel", v7, {
			UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink })
		})

		children.SubscriptionBadge = React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.RobloxPlus,
			size = Foundation.Enums.IconSize.Small,
			style = {
				Color3 = theme.TextEmphasis.Color,
				Transparency = theme.TextEmphasis.Transparency
			},
			LayoutOrder = 2
		})
		displayName = createElement("Frame", v6, children)
	else
		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, textSize),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = friend.displayName,
			TextSize = textSize,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextWrapped = true,
			TextTruncate = 0,
			LayoutOrder = 1
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Header2.Font
		end

		v6.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Tokens.Typography.TitleLarge.Font)
		end

		v6.FontFace = fontFace

		v6.TextXAlignment = Enum.TextXAlignment.Left

		v6.TextTruncate = Enum.TextTruncate.AtEnd
		displayName = createElement("TextLabel", v6)
	end

	local createElement = React.createElement
	local v6 = {
		Position = props.position,
		Size = props.size,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local v7 = {
		UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink }),
		Padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, 12) }),
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 4)
		}),
		DisplayName = displayName,
		UserContextContainer = 0
	}

	local userContextContainer = props.isFetchingFriendsNames
		and React.createElement(Skeleton, {
			Size = UDim2.new(0, 80, 0, 10),
			radius = Radius.Small,
			LayoutOrder = 2
		})

	if not userContextContainer then
		local createElement2 = React.createElement
		local v8 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, textSize2),
			ClipsDescendants = true
		}

		local v9 = {
			ListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 4)
			}),
			StudioImage = v3 and React.createElement(ImageSetLabel, {
				Image = iconslogostudiologo_small,
				ImageColor3 = theme.TextDefault.Color,
				ImageTransparency = theme.TextDefault.Transparency,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, textSize2, 0, textSize2),
				LayoutOrder = 1
			}),
			UserContext = 0
		}

		local createElement3 = React.createElement
		local v10 = {
			Size = UDim2.new(1, -textSize2, 0, textSize2),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = fn(friend, localizedStrings), -- inferred equivalent call
			TextSize = textSize2,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextWrapped = true,
			TextTruncate = 0,
			LayoutOrder = 2,
			OpenTypeFeatures = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.CaptionBody.Font
		end

		v10.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Tokens.Typography.BodySmall.Font)
		end

		v10.FontFace = fontFace

		v10.TextXAlignment = Enum.TextXAlignment.Left

		v10.TextTruncate = Enum.TextTruncate.AtEnd
		local openTypeFeatures

		if GetFFlagLuaAppEnableOpenTypeSupport() then
			openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
		end

		v10.OpenTypeFeatures = openTypeFeatures
		v9.UserContext = createElement3("TextLabel", v10)
		userContextContainer = createElement2("Frame", v8, v9)
	end

	v7.UserContextContainer = userContextContainer
	return createElement("Frame", v6, v7)
end
