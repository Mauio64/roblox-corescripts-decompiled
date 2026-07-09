local GameInvite = script:FindFirstAncestor("GameInvite")
local Context = GameInvite.Context
local GameInviteParent = GameInvite.Parent
local React = require(GameInviteParent.React)
local UIBlox = require(GameInviteParent.UIBlox)
local FFlagGameInviteModalUnlockMouse = require(GameInviteParent.SharedFlags).FFlagGameInviteModalUnlockMouse
local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GameInviteModalManager = require(GameInvite.GameInviteModalManager)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSet = UIBlox.Core.ImageSet
local Images = UIBlox.App.ImageSet.Images
local rect = Rect.new(8, 8, 9, 9)

return function(p1) -- line: 22
	-- upvalues: useStyle (copy), React (copy), GameInviteModalLayoutContext (copy), ImageSet (copy), FFlagGameInviteModalUnlockMouse (copy), GameInviteModalManager (copy), Images (copy), rect (copy)
	local v14 = useStyle()
	local Theme = v14.Theme
	local v16 = React.useContext(GameInviteModalLayoutContext)
	local isFullWidth = v16.isFullWidth
	local isFullHeight = v16.isFullHeight
	local modalSize = v16.modalSize
	local vector2, s1, uDim2

	if isFullWidth or isFullHeight then
		vector2 = Vector2.new(0.5, 1)
		s1 = "component_assets/bullet_17"
		uDim2 = UDim2.new(0.5, 0, 1, 0)
	else
		vector2 = Vector2.new(0.5, 0.5)
		s1 = "component_assets/circle_17"
		uDim2 = UDim2.new(0.5, 0, 0.5, 0)
	end

	return React.createElement(ImageSet.ImageSetButton, {
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v14.Theme.Overlay.Color,
		Transparency = v14.Theme.Overlay.Transparency,
		AutoButtonColor = false,
		Modal = not not FFlagGameInviteModalUnlockMouse or nil,
		ZIndex = 0,
		[React.Event.Activated] = function() -- line: 52
			-- upvalues: GameInviteModalManager (copy)
			GameInviteModalManager:closeModal()
		end
	}, {
		GameInviteModalContainer = React.createElement(ImageSet.ImageSetButton, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false,
			Position = uDim2,
			Size = modalSize,
			AnchorPoint = vector2,
			Image = Images[s1],
			ImageColor3 = Theme.BackgroundDefault.Color,
			ImageTransparency = Theme.BackgroundDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect
		}, p1.children)
	})
end
