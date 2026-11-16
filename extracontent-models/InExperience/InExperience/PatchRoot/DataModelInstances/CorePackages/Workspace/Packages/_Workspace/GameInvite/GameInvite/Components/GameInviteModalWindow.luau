local GameInvite = script:FindFirstAncestor("GameInvite")
local Context = GameInvite.Context
local parent = GameInvite.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local SharedFlags = require(parent.SharedFlags)
local FFlagGameInviteModalUnlockMouse = SharedFlags.FFlagGameInviteModalUnlockMouse

local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GameInviteModalManager = require(GameInvite.GameInviteModalManager)

local useStyle = UIBlox.Core.Style.useStyle
local ImageSet = UIBlox.Core.ImageSet
local Images = UIBlox.App.ImageSet.Images

local rect = Rect.new(8, 8, 9, 9)

return function(p)
	local v = useStyle()
	local theme = v.Theme

	local v2 = React.useContext(GameInviteModalLayoutContext)
	local isFullWidth = v2.isFullWidth
	local isFullHeight = v2.isFullHeight
	local modalSize = v2.modalSize
	local vector2, udim, v3

	if isFullWidth or isFullHeight then
		vector2 = Vector2.new(0.5, 1)

		udim = UDim2.new(0.5, 0, 1, 0)
		v3 = "component_assets/bullet_17"
	else
		vector2 = Vector2.new(0.5, 0.5)

		udim = UDim2.new(0.5, 0, 0.5, 0)
		v3 = "component_assets/circle_17"
	end

	return React.createElement(ImageSet.ImageSetButton, {
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v.Theme.Overlay.Color,
		Transparency = v.Theme.Overlay.Transparency,
		AutoButtonColor = false,
		Modal = FFlagGameInviteModalUnlockMouse and true or nil,
		ZIndex = 0,
		[React.Event.Activated] = function()
			GameInviteModalManager:closeModal()
		end
	}, {
		GameInviteModalContainer = React.createElement(ImageSet.ImageSetButton, {
			Position = udim,
			Size = modalSize,
			AnchorPoint = vector2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = Images[v3],
			ImageColor3 = theme.BackgroundDefault.Color,
			ImageTransparency = theme.BackgroundDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false
		}, p.children)
	})
end
