local parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(parent.Roact)
local t = require(parent.t)

local UIBlox = require(parent.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ControlState = UIBlox.Core.Control.Enum.ControlState
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local LoadableImage = UIBlox.App.Loading.LoadableImage
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle

local HoverButtonBackground = require(script.Parent.HoverButtonBackground)

local iconSize = getIconSize(IconSize.Large)

local udim = UDim2.fromScale(0.4, 0.512)
local udim2 = UDim2.fromOffset(64, 48)
local udim3 = UDim2.fromScale(0.25, 0.33)

local extended = Roact.Component:extend("ThumbnailButton")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.number),
	size = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	itemKey = t.any,
	imageId = t.optional(t.string),
	isVideo = t.optional(t.boolean),
	useScaledPlayButton = t.optional(t.boolean),
	isSelected = t.optional(t.boolean),
	userInteractionEnabled = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	onPlayActivated = t.optional(t.callback)
})

extended.defaultProps = {
	size = UDim2.fromScale(1, 1),
	imageId = "",
	isVideo = false,
	isSelected = false,
	userInteractionEnabled = true
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.onStateChanged(_, controlState)
		self:setState({ controlState = controlState })
	end

	function self.onActivated()
		if self.props.onActivated then
			self.props.onActivated(self.props.itemKey)
		end
	end

	function self.onPlayActivated()
		if self.props.onPlayActivated then
			self.props.onPlayActivated(self.props.itemKey)
		end
	end
end

function extended:renderButton()
	local useScaledPlayButton = self.props.useScaledPlayButton
	local size2

	if useScaledPlayButton then
		size2 = udim
	else
		size2 = udim2
	end

	return withStyle(function(p)
		local layoutOrder = self.props.layoutOrder
		local anchorPoint = self.props.anchorPoint
		local position = self.props.position
		local size = self.props.size
		local isSelected = self.props.isSelected
		local imageId = self.props.imageId
		local isVideo = self.props.isVideo
		local userInteractionEnabled = self.props.userInteractionEnabled

		local v = self.state.controlState == ControlState.Hover
		local backgroundDefault = isSelected and p.Theme.BackgroundDefault or p.Theme.BackgroundUIDefault

		local createElement = Roact.createElement
		local onActivatedsByActivated = {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			AutoButtonColor = false,
			BackgroundColor3 = backgroundDefault.Color,
			BackgroundTransparency = backgroundDefault.Transparency,
			onStateChanged = self.onStateChanged,
			userInteractionEnabled = userInteractionEnabled,
			[Roact.Event.Activated] = self.onActivated
		}
		local v2 = {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Tile = Roact.createElement(LoadableImage, {
				Size = UDim2.fromScale(1, 1),
				cornerRadius = UDim.new(0, 8),
				Image = imageId,
				useShimmerAnimationWhileLoading = true,
				ZIndex = -1
			}),
			PlayButton = 0,
			PlayIcon = 0,
			HoverBackground = 0
		}
		local playButton

		if isVideo then
			local createElement2 = Roact.createElement
			local v3 = {
				buttonType = ButtonType.PrimaryContextual,
				size = size2,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = 0,
				onActivated = 0
			}
			local icon

			if not useScaledPlayButton then
				icon = Images["icons/common/play"]
			end

			v3.icon = icon
			v3.onActivated = self.onPlayActivated
			playButton = createElement2(Button, v3)
		end

		v2.PlayButton = playButton
		local playIcon

		if isVideo and useScaledPlayButton then
			playIcon = Roact.createElement(ImageSetLabel, {
				Size = udim3,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/common/play"],
				BackgroundTransparency = 1,
				ZIndex = 2
			})
		end

		v2.PlayIcon = playIcon

		v2.HoverBackground = v and Roact.createElement(HoverButtonBackground) or nil
		return createElement(Interactable, onActivatedsByActivated, v2)
	end)
end

function extended:renderEmptyState()
	return withStyle(function(p)
		local layoutOrder = self.props.layoutOrder
		local anchorPoint = self.props.anchorPoint
		local position = self.props.position
		local size = self.props.size

		return Roact.createElement("Frame", {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BackgroundColor3 = p.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = p.Theme.BackgroundUIDefault.Transparency
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Icon = Roact.createElement(ImageSetLabel, {
				Size = UDim2.fromOffset(iconSize, iconSize),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/imageUnavailable"],
				ImageColor3 = p.Theme.UIDefault.Color,
				ImageTransparency = p.Theme.UIDefault.Transparency,
				BackgroundTransparency = 1
			})
		})
	end)
end

function extended:render()
	if self.props.imageId == "" then
		return self:renderEmptyState()
	end

	return self:renderButton()
end

return extended
