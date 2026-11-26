local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local controlState = UIBlox.Core.Control.Enum.ControlState
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable
local loadableImage = UIBlox.App.Loading.LoadableImage
local getIconSize = UIBlox.App.ImageSet.getIconSize
local withStyle = UIBlox.Core.Style.withStyle

local HoverButtonBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/MediaGallery/HoverButtonBackground")

local iconSize2 = getIconSize(iconSize.Large)

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
	self:setState({ controlState = controlState.Initialize })

	function self.onStateChanged(p2, p3)
		self:setState({ controlState = p3 })
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
	local v5 = if useScaledPlayButton then udim else udim2
	return withStyle(function(p2)
		local layoutOrder = self.props.layoutOrder
		local anchorPoint = self.props.anchorPoint
		local position = self.props.position
		local size = self.props.size
		local isSelected = self.props.isSelected
		local imageId = self.props.imageId
		local isVideo = self.props.isVideo
		local userInteractionEnabled = self.props.userInteractionEnabled

		local v6 = self.state.controlState == controlState.Hover
		local backgroundDefault = isSelected and p2.Theme.BackgroundDefault or p2.Theme.BackgroundUIDefault

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
		local v8 = {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Tile = Roact.createElement(loadableImage, {
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
		local v9

		if isVideo then
			local createElement2 = Roact.createElement
			local v11 = {
				buttonType = buttonType.PrimaryContextual,
				size = v5,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = 0,
				onActivated = 0
			}
			local v12 = if not useScaledPlayButton then images["icons/common/play"] else nil
			v11.icon = v12
			v11.onActivated = self.onPlayActivated
			v9 = createElement2(button, v11)
		end

		v8.PlayButton = v9

		local v10 = if isVideo and useScaledPlayButton then Roact.createElement(imageSetLabel, {
			Size = udim3,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = images["icons/common/play"],
			BackgroundTransparency = 1,
			ZIndex = 2
		}) else nil
		v8.PlayIcon = v10

		v8.HoverBackground = v6 and Roact.createElement(HoverButtonBackground) or nil
		return createElement(interactable, onActivatedsByActivated, v8)
	end)
end

function extended.renderEmptyState(p2)
	return withStyle(function(p3)
		local layoutOrder = p2.props.layoutOrder
		local anchorPoint = p2.props.anchorPoint
		local position = p2.props.position
		local size = p2.props.size

		return Roact.createElement("Frame", {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BackgroundColor3 = p3.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = p3.Theme.BackgroundUIDefault.Transparency
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Icon = Roact.createElement(imageSetLabel, {
				Size = UDim2.fromOffset(iconSize2, iconSize2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = images["icons/imageUnavailable"],
				ImageColor3 = p3.Theme.UIDefault.Color,
				ImageTransparency = p3.Theme.UIDefault.Transparency,
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
