local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UIBlox")
local fFlagGameInviteModalUnlockMouse = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagGameInviteModalUnlockMouse

local GameInviteModalLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameInviteModalLayoutContext")
local GameInviteModalManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteModalManager")

local useStyle = UIBlox.Core.Style.useStyle
local imageSet = UIBlox.Core.ImageSet
local images = UIBlox.App.ImageSet.Images

local rect = Rect.new(8, 8, 9, 9)

return function(p2)
	local v5 = useStyle()
	local theme = v5.Theme

	local v6 = React.useContext(GameInviteModalLayoutContext)
	local isFullWidth = v6.isFullWidth
	local isFullHeight = v6.isFullHeight
	local modalSize = v6.modalSize
	local vector2, udim, v7

	if isFullWidth or isFullHeight then
		vector2 = Vector2.new(0.5, 1)

		udim = UDim2.new(0.5, 0, 1, 0)
		v7 = "component_assets/bullet_17"
	else
		vector2 = Vector2.new(0.5, 0.5)

		udim = UDim2.new(0.5, 0, 0.5, 0)
		v7 = "component_assets/circle_17"
	end

	return React.createElement(imageSet.ImageSetButton, {
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v5.Theme.Overlay.Color,
		Transparency = v5.Theme.Overlay.Transparency,
		AutoButtonColor = false,
		Modal = fFlagGameInviteModalUnlockMouse and true or nil,
		ZIndex = 0,
		[React.Event.Activated] = function()
			GameInviteModalManager:closeModal()
		end
	}, {
		GameInviteModalContainer = React.createElement(imageSet.ImageSetButton, {
			Position = udim,
			Size = modalSize,
			AnchorPoint = vector2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = images[v7],
			ImageColor3 = theme.BackgroundDefault.Color,
			ImageTransparency = theme.BackgroundDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect,
			AutoButtonColor = false,
			ClipsDescendants = true,
			Selectable = false
		}, p2.children)
	})
end
