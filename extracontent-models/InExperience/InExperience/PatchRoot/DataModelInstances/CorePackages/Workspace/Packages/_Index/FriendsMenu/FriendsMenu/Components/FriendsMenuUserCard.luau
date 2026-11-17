local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent
local Context = FriendsMenu.Context

local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagFriendsMenuUseProfileFrameThumbnail = require(FriendsMenu.Flags.FFlagFriendsMenuUseProfileFrameThumbnail)

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local useStyle = UIBlox.Core.Style.useStyle

require(FriendsMenu.friendsMenuModalType)
local Constants = require(FriendsMenu.Constants)
local SelectedUsersContext = require(Context.SelectedUsersContext)

local udim = UDim.new(1, 0)

return (React.forwardRef(function(props, ref)
	local v = React.useContext(SelectedUsersContext)

	local v2 = useStyle()
	local theme = v2.Theme
	local font = v2.Font

	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb(
		props.userId,
		FFlagFriendsMenuUseProfileFrameThumbnail
	)

	local v3 = React.useCallback(function()
		if props.onRemoved then
			props.onRemoved()
		end

		v.removeFriend(props.userId, props.displayName)
	end, { props.userId, v.removeFriend, props.onRemoved })

	local createElement = React.createElement
	local v4 = {
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(0, Constants.FRIEND_MENU_CARD_SIZE, 0, Constants.FRIEND_MENU_CARD_SIZE),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local activated = React.Event.Activated

	if props.unremovable then
		v3 = nil
	end

	v4[activated] = v3
	v4.ref = ref

	local createElement2 = React.createElement
	local v5 = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromOffset(60, 60),
		BackgroundTransparency = 1
	}

	local v6 = {
		UICorner = React.createElement("UICorner", { CornerRadius = udim }),
		Avatar = React.createElement(
			ImageSetLabel,
			{
				Size = UDim2.fromOffset(60, 60),
				BackgroundColor3 = theme.UIDefault.Color,
				Image = standardSizeAvatarHeadShotRbxthumb,
				ZIndex = 1
			},
			{
				UICorner = React.createElement("UICorner", { CornerRadius = udim })
			}
		),
		CloseButton = 0
	}
	local closeButton

	if not props.unremovable then
		closeButton = React.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = theme.SystemPrimaryDefault.Transparency,
			BackgroundColor3 = theme.SystemPrimaryDefault.Color,
			Image = Images["icons/navigation/close_small"],
			ImageColor3 = theme.SystemPrimaryContent.Color,
			ZIndex = 2
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = udim })
		})
	end

	v6.CloseButton = closeButton
	return createElement(Interactable, v4, {
		AvatarContainer = createElement2("Frame", v5, v6),
		DisplayName = React.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromOffset(Constants.FRIEND_MENU_CARD_SIZE, 0),
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(v2.Tokens.Typography.CaptionSmall.Font),
			Text = props.displayName,
			TextColor3 = theme.TextDefault.Color,
			TextSize = font.BaseSize * font.Footer.RelativeSize,
			TextTransparency = theme.TextDefault.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end))
