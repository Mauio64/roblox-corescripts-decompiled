local Parent = script:FindFirstAncestor("AppBlox").Parent
local Roact = require(Parent.Roact)
local t = require(Parent.t)
local UIBlox = require(Parent.UIBlox)
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
local v16 = getIconSize(IconSize.Large)
local uDim2 = UDim2.fromScale(0.4, 0.512)
local uDim2_2 = UDim2.fromOffset(64, 48)
local uDim2_3 = UDim2.fromScale(0.25, 0.33)
local v20 = Roact.Component:extend("ThumbnailButton")

v20.validateProps = t.strictInterface({
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
v20.defaultProps = {
	imageId = "",
	isVideo = false,
	isSelected = false,
	userInteractionEnabled = true,
	size = UDim2.fromScale(1, 1)
}

function v20.init(p1) -- line: 57
	-- upvalues: ControlState (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})

	function p1.onStateChanged(_, p3) -- line: 62
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})
	end
	function p1.onActivated() -- line: 68
		-- upvalues: p1 (copy)
		if p1.props.onActivated then
			p1.props.onActivated(p1.props.itemKey)
		end
	end
	function p1.onPlayActivated() -- line: 74
		-- upvalues: p1 (copy)
		if p1.props.onPlayActivated then
			p1.props.onPlayActivated(p1.props.itemKey)
		end
	end
end
function v20.renderButton(p4) -- line: 81
	-- upvalues: uDim2 (copy), uDim2_2 (copy), withStyle (copy), ControlState (copy), Roact (copy), Interactable (copy), LoadableImage (copy), Button (copy), ButtonType (copy), Images (copy), ImageSetLabel (copy), uDim2_3 (copy), HoverButtonBackground (copy)
	local useScaledPlayButton = p4.props.useScaledPlayButton
	local u24 = if not useScaledPlayButton then uDim2_2 else uDim2

	return withStyle(function(p5) -- line: 90
		-- upvalues: p4 (copy), ControlState (copy), Roact (copy), Interactable (copy), LoadableImage (copy), Button (copy), ButtonType (copy), u24 (ref), useScaledPlayButton (copy), Images (copy), ImageSetLabel (copy), uDim2_3 (copy), HoverButtonBackground (copy)
		local layoutOrder = p4.props.layoutOrder
		local anchorPoint = p4.props.anchorPoint
		local position = p4.props.position
		local size = p4.props.size
		local isSelected = p4.props.isSelected
		local imageId = p4.props.imageId
		local isVideo = p4.props.isVideo
		local userInteractionEnabled = p4.props.userInteractionEnabled
		local v38 = p4.state.controlState == ControlState.Hover
		local v39 = isSelected and p5.Theme.BackgroundDefault or p5.Theme.BackgroundUIDefault

		return Roact.createElement(Interactable, {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			AutoButtonColor = false,
			BackgroundColor3 = v39.Color,
			BackgroundTransparency = v39.Transparency,
			onStateChanged = p4.onStateChanged,
			userInteractionEnabled = userInteractionEnabled,
			[Roact.Event.Activated] = p4.onActivated
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			Tile = Roact.createElement(LoadableImage, {
				useShimmerAnimationWhileLoading = true,
				ZIndex = -1,
				Size = UDim2.fromScale(1, 1),
				cornerRadius = UDim.new(0, 8),
				Image = imageId
			}),
			PlayButton = if not isVideo then nil else Roact.createElement(Button, {
				buttonType = ButtonType.PrimaryContextual,
				size = u24,
				anchorPoint = Vector2.new(0.5, 0.5),
				position = UDim2.fromScale(0.5, 0.5),
				icon = if not useScaledPlayButton then Images["icons/common/play"] else nil,
				onActivated = p4.onPlayActivated
			}),
			PlayIcon = if not isVideo or not useScaledPlayButton then nil else Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = uDim2_3,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/common/play"]
			}),
			HoverBackground = v38 and Roact.createElement(HoverButtonBackground) or nil
		})
	end)
end
function v20.renderEmptyState(p6) -- line: 151
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), v16 (copy), Images (copy)
	return withStyle(function(p7) -- line: 152
		-- upvalues: p6 (copy), Roact (copy), ImageSetLabel (copy), v16 (copy), Images (copy)
		local layoutOrder = p6.props.layoutOrder
		local anchorPoint = p6.props.anchorPoint
		local position = p6.props.position
		local size = p6.props.size

		return Roact.createElement("Frame", {
			LayoutOrder = layoutOrder,
			Size = size,
			AnchorPoint = anchorPoint,
			Position = position,
			BackgroundColor3 = p7.Theme.BackgroundUIDefault.Color,
			BackgroundTransparency = p7.Theme.BackgroundUIDefault.Transparency
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}),
			Icon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v16, v16),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/imageUnavailable"],
				ImageColor3 = p7.Theme.UIDefault.Color,
				ImageTransparency = p7.Theme.UIDefault.Transparency
			})
		})
	end)
end
function v20.render(p8) -- line: 182
	if p8.props.imageId == "" then
		return p8:renderEmptyState()
	end

	return p8:renderButton()
end

return v20
