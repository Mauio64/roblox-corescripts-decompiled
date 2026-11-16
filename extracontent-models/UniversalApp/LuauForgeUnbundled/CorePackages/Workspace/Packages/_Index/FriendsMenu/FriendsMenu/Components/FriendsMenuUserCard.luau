local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagFriendsMenuUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Flags/FFlagFriendsMenuUseProfileFrameThumbnail")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable
local useStyle = UIBlox.Core.Style.useStyle

require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Constants")
local SelectedUsersContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContext")

local udim = UDim.new(1, 0)

return (React.forwardRef(function(props, ref)
	local v5 = React.useContext(SelectedUsersContext)

	local v6 = useStyle()
	local theme = v6.Theme
	local font = v6.Font

	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb(props.userId, FFlagFriendsMenuUseProfileFrameThumbnail)

	local v7 = React.useCallback(function()
		if props.onRemoved then
			props.onRemoved()
		end

		v5.removeFriend(props.userId, props.displayName)
	end, { props.userId, v5.removeFriend, props.onRemoved })

	local createElement = React.createElement
	local v9 = {
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(0, Constants.FRIEND_MENU_CARD_SIZE, 0, Constants.FRIEND_MENU_CARD_SIZE),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local activated = React.Event.Activated

	if props.unremovable then
		v7 = nil
	end

	v9[activated] = v7
	v9.ref = ref

	local createElement2 = React.createElement
	local v11 = {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromOffset(60, 60),
		BackgroundTransparency = 1
	}

	local v12 = {
		UICorner = React.createElement("UICorner", { CornerRadius = udim }),
		Avatar = React.createElement(
			imageSetLabel,
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

	local v13 = if not props.unremovable then React.createElement(imageSetLabel, {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = theme.SystemPrimaryDefault.Transparency,
		BackgroundColor3 = theme.SystemPrimaryDefault.Color,
		Image = images["icons/navigation/close_small"],
		ImageColor3 = theme.SystemPrimaryContent.Color,
		ZIndex = 2
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = udim })
	}) else nil
	v12.CloseButton = v13
	local children = {
		AvatarContainer = createElement2("Frame", v11, v12),
		DisplayName = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		AnchorPoint = Vector2.new(0.5, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.fromOffset(Constants.FRIEND_MENU_CARD_SIZE, 0),
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		Text = 0,
		TextColor3 = 0,
		TextSize = 0,
		TextTransparency = 0,
		TextTruncate = 0
	}

	local v16 = if not foundationFontFaceMigration then font.Footer.Font else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.CaptionSmall.Font) else nil
	v15.FontFace = v17

	v15.Text = props.displayName
	v15.TextColor3 = theme.TextDefault.Color
	v15.TextSize = font.BaseSize * font.Footer.RelativeSize
	v15.TextTransparency = theme.TextDefault.Transparency
	v15.TextTruncate = Enum.TextTruncate.AtEnd
	children.DisplayName = createElement3("TextLabel", v15)
	return createElement(interactable, v9, children)
end))
