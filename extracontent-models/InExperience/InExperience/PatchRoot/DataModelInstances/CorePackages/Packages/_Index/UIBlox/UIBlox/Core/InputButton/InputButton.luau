local ParentParent = script.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local Cryo = require(ParentParent.Cryo)
local RoactGamepad = require(ParentParent.RoactGamepad)
local withStyle = require(ParentParent.UIBlox.Core.Style.withStyle)
local ImageSetComponent = require(ParentParent.UIBlox.Core.ImageSet.ImageSetComponent)
local Controllable = require(ParentParent.UIBlox.Core.Control.Controllable)
local ControlState = require(ParentParent.UIBlox.Core.Control.Enum.ControlState)
local FitTextLabel = require(ParentParent.FitFrame).FitTextLabel
local FitFrameHorizontal = require(ParentParent.FitFrame).FitFrameHorizontal
local v12 = Roact.PureComponent:extend("InputButton")

v12.validateProps = t.strictInterface({
	text = t.string,
	size = t.optional(t.UDim2),
	image = t.table,
	imageColor = t.Color3,
	fillImage = t.optional(t.table),
	fillImageSize = t.optional(t.UDim2),
	fillImageColor = t.optional(t.Color3),
	selectedColor = t.Color3,
	textColor = t.Color3,
	transparency = t.number,
	onActivated = t.callback,
	isDisabled = t.optional(t.boolean),
	layoutOrder = t.optional(t.number),
	frameRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	SelectionImageObject = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v12.defaultProps = {
	layoutOrder = 0,
	isDisabled = false,
	isRoactGamepadEnabled = true
}

function v12.init(p1) -- line: 53
	-- upvalues: ControlState (copy), Roact (copy)
	p1.state = {
		outerTransparency = 1,
		innerTransparency = 1,
		outerImage = p1.props.image,
		outerImageColor = p1.props.imageColor,
		innerImage = p1.props.image,
		innerImageColor = p1.props.fillImageColor
	}

	function p1.changeSprite(p2) -- line: 63
		-- upvalues: ControlState (copy), p1 (copy)
		if p2 == ControlState.Hover then
			if not p1.props.isDisabled then
				p1:setState({
					outerImageColor = p1.props.selectedColor
				})

				return
			end
		elseif p2 == ControlState.Default then
			p1:setState({
				outerImageColor = p1.props.imageColor
			})
		end
	end

	if not p1.props.size then
		local v14, v15 = Roact.createBinding(UDim2.new(1, 0, 0, 26))

		p1.sizeBinding = v14
		p1.updateSizeBinding = v15

		function p1.textAbsoluteSizeChanged(p3) -- line: 81
			-- upvalues: p1 (copy)
			local n1 = 26

			if n1 < p3.AbsoluteSize.Y then
				n1 = p3.AbsoluteSize.Y
			end

			p1.updateSizeBinding(UDim2.new(1, 0, 0, n1))
		end
	end
end
function v12.render(p4) -- line: 91
	-- upvalues: withStyle (copy), Cryo (copy), Roact (copy), FitFrameHorizontal (copy), FitTextLabel (copy), RoactGamepad (copy), Controllable (copy), ImageSetComponent (copy)
	return withStyle(function(p5) -- line: 92
		-- upvalues: p4 (copy), Cryo (copy), Roact (copy), FitFrameHorizontal (copy), FitTextLabel (copy), RoactGamepad (copy), Controllable (copy), ImageSetComponent (copy)
		local p5Font = p5.Font
		local v24 = p5Font.Body.RelativeSize * p5Font.BaseSize
		local t1 = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			TextWrapped = true,
			Text = p4.props.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = v24,
			Font = p5Font.Body.Font,
			TextColor3 = p4.props.textColor,
			TextTransparency = p4.props.transparency
		}
		local s1 = "Frame"
		local v27 = false
		local s2, v29

		if p4.props.size then
			s2 = "TextButton"
			v29 = Cryo.Dictionary.join(t1, {
				Size = UDim2.new(1, -34, 0, 26),
				AutomaticSize = Enum.AutomaticSize.Y,
				[Roact.Event.Activated] = not p4.props.isDisabled and p4.props.onActivated or nil
			})
		else
			v27 = true
			s1 = FitFrameHorizontal
			s2 = FitTextLabel
			v29 = Cryo.Dictionary.join(t1, {
				width = FitTextLabel.Width.FitToText,
				onActivated = p4.props.onActivated,
				[Roact.Change.AbsoluteSize] = p4.textAbsoluteSizeChanged
			})
		end

		local fillImage = p4.props.fillImage

		return Roact.createElement(if not p4.props.isRoactGamepadEnabled then s1 else RoactGamepad.Focusable[s1], {
			Size = not v27 and (p4.props.size or p4.sizeBinding) or nil,
			height = v27 and UDim.new(0, 26) or nil,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = p4.props.layoutOrder,
			[Roact.Ref] = p4.props.frameRef,
			SelectionImageObject = p4.props.SelectionImageObject,
			FillDirection = v27 and Enum.FillDirection.Horizontal or nil,
			VerticalAlignment = v27 and Enum.VerticalAlignment.Center or nil,
			contentPadding = v27 and UDim.new(0, 8) or nil,
			NextSelectionLeft = p4.props.NextSelectionLeft,
			NextSelectionRight = p4.props.NextSelectionRight,
			NextSelectionUp = p4.props.NextSelectionUp,
			NextSelectionDown = p4.props.NextSelectionDown,
			inputBindings = if not p4.props.isRoactGamepadEnabled then nil else {
				Activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, p4.props.onActivated)
			}
		}, {
			HorizontalLayout = not v27 and Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}) or nil,
			Padding = not v27 and Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8)
			}) or nil,
			InputButtonImage = Roact.createElement(Controllable, {
				controlComponent = {
					component = ImageSetComponent.Button,
					props = {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 26, 0, 26),
						Image = p4.props.image,
						ImageTransparency = p4.props.transparency,
						ScaleType = p4.props.buttonSliceType,
						SliceCenter = p4.props.buttonSliceCenter,
						ImageColor3 = p4.state.outerImageColor,
						[Roact.Event.Activated] = p4.props.onActivated,
						LayoutOrder = 1
					},
					children = {
						InputFillImage = fillImage and Roact.createElement(ImageSetComponent.Label, {
							BackgroundTransparency = 1,
							Size = p4.props.fillImageSize,
							Image = fillImage,
							ImageTransparency = p4.props.transparency,
							ImageColor3 = p4.props.fillImageColor,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0)
						})
					}
				},
				isDisabled = p4.props.isDisabled,
				onStateChanged = function(_, p7) -- line: 196
					-- upvalues: p4 (copy)
					p4.changeSprite(p7)
				end
			}),
			InputButtonText = p4.props.text ~= "" and Roact.createElement(Controllable, {
				controlComponent = {
					component = s2,
					props = v29
				},
				isDisabled = p4.props.isDisabled,
				onStateChanged = function(_, p9) -- line: 207
					-- upvalues: p4 (copy)
					p4.changeSprite(p9)
				end
			})
		})
	end)
end

return Roact.forwardRef(function(p10, p11) -- line: 216
	-- upvalues: Roact (copy), v12 (copy), Cryo (copy)
	return Roact.createElement(v12, Cryo.Dictionary.join(p10, {
		frameRef = p11
	}))
end)
