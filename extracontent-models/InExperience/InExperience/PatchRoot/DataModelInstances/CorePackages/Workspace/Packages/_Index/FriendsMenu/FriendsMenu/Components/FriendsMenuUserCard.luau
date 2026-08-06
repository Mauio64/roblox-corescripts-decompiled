local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local Context = FriendsMenu.Context
local getStandardSizeAvatarHeadShotRbxthumb = require(FriendsMenuParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagFriendsMenuUseProfileFrameThumbnail = require(FriendsMenu.Flags.FFlagFriendsMenuUseProfileFrameThumbnail)
local React = require(FriendsMenuParent.React)
local UIBlox = require(FriendsMenuParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local useStyle = UIBlox.Core.Style.useStyle

require(FriendsMenu.friendsMenuModalType)

local Constants = require(FriendsMenu.Constants)
local SelectedUsersContext = require(Context.SelectedUsersContext)
local uDim = UDim.new(1, 0)

return (React.forwardRef(function(p1, p2) -- line: 24
	-- upvalues: React (copy), SelectedUsersContext (copy), useStyle (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FFlagFriendsMenuUseProfileFrameThumbnail (copy), Interactable (copy), Constants (copy), uDim (copy), ImageSetLabel (copy), Images (copy)
	local v17 = React.useContext(SelectedUsersContext)
	local v18 = useStyle()
	local Theme = v18.Theme
	local Font = v18.Font
	local v21 = getStandardSizeAvatarHeadShotRbxthumb(p1.userId, FFlagFriendsMenuUseProfileFrameThumbnail)
	local v22 = React.useCallback(function() -- line: 34
		-- upvalues: p1 (copy), v17 (copy)
		if p1.onRemoved then
			p1.onRemoved()
		end

		v17.removeFriend(p1.userId, p1.displayName)
	end, {
		p1.userId,
		v17.removeFriend,
		p1.onRemoved
	})

	return React.createElement(Interactable, {
		Size = UDim2.new(0, Constants.FRIEND_MENU_CARD_SIZE, 0, Constants.FRIEND_MENU_CARD_SIZE),
		BackgroundTransparency = 1,
		LayoutOrder = p1.layoutOrder,
		[React.Event.Activated] = if not p1.unremovable then v22 else nil,
		ref = p2
	}, {
		AvatarContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromOffset(60, 60)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = uDim
			}),
			Avatar = React.createElement(ImageSetLabel, {
				ZIndex = 1,
				Size = UDim2.fromOffset(60, 60),
				BackgroundColor3 = Theme.UIDefault.Color,
				Image = v21
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				})
			}),
			CloseButton = if not p1.unremovable then React.createElement(ImageSetLabel, {
				ZIndex = 2,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = Theme.SystemPrimaryDefault.Transparency,
				BackgroundColor3 = Theme.SystemPrimaryDefault.Color,
				Image = Images["icons/navigation/close_small"],
				ImageColor3 = Theme.SystemPrimaryContent.Color
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim
				})
			}) else nil
		}),
		DisplayName = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.fromScale(0.5, 1),
			Size = UDim2.fromOffset(Constants.FRIEND_MENU_CARD_SIZE, 0),
			Font = Font.Footer.Font,
			Text = p1.displayName,
			TextColor3 = Theme.TextDefault.Color,
			TextSize = Font.BaseSize * Font.Footer.RelativeSize,
			TextTransparency = Theme.TextDefault.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end))
