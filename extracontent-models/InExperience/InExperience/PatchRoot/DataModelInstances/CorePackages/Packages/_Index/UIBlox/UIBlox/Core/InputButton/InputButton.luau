local parent = script.Parent.Parent.Parent.Parent
local Roact = require(parent.Roact)
local t = require(parent.t)
local Cryo = require(parent.Cryo)
local RoactGamepad = require(parent.RoactGamepad)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = require(parent.UIBlox.Core.Style.withStyle)
local ImageSetComponent = require(parent.UIBlox.Core.ImageSet.ImageSetComponent)
local Controllable = require(parent.UIBlox.Core.Control.Controllable)
local ControlState = require(parent.UIBlox.Core.Control.Enum.ControlState)

local FitFrame = require(parent.FitFrame)
local FitTextLabel = FitFrame.FitTextLabel
local FitFrame2 = require(parent.FitFrame)
local FitFrameHorizontal = FitFrame2.FitFrameHorizontal

local extended = Roact.PureComponent:extend("InputButton")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { layoutOrder = 0, isDisabled = false, isRoactGamepadEnabled = true }

function extended:init()
	self.state = {
		outerImage = self.props.image,
		outerTransparency = 1,
		outerImageColor = self.props.imageColor,
		innerImage = self.props.image,
		innerImageColor = self.props.fillImageColor,
		innerTransparency = 1
	}

	function self.changeSprite(p)
		if p == ControlState.Hover then
			if not self.props.isDisabled then
				self:setState({ outerImageColor = self.props.selectedColor })
			end
		elseif p == ControlState.Default then
			self:setState({ outerImageColor = self.props.imageColor })
		end
	end

	if not self.props.size then
		local binding, updateSizeBinding = Roact.createBinding(UDim2.new(1, 0, 0, 26))
		self.sizeBinding = binding
		self.updateSizeBinding = updateSizeBinding

		function self.textAbsoluteSizeChanged(p)
			local v = 26

			if v < p.AbsoluteSize.Y then
				v = p.AbsoluteSize.Y
			end

			self.updateSizeBinding(UDim2.new(1, 0, 0, v))
		end
	end
end

function extended.render(data)
	return withStyle(function(p)
		local font = p.Font
		local textSize = font.Body.RelativeSize * font.BaseSize
		local font2 = font.Body.Font

		local v = {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = data.props.text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = textSize,
			FontFace = normalizeFontFace(font2),
			TextWrapped = true,
			TextColor3 = data.props.textColor,
			TextTransparency = data.props.transparency
		}

		local v2 = "Frame"
		local flag = false
		local component, props

		if data.props.size then
			component = "TextButton"

			local join = Cryo.Dictionary.join
			local v3 = {
				["Size"] = nil,
				Size = UDim2.new(1, -34, 0, 26),
				AutomaticSize = Enum.AutomaticSize.Y
			}
			local activated = Roact.Event.Activated
			local v4

			if not data.props.isDisabled then
				v4 = data.props.onActivated or nil
			end

			v3[activated] = v4
			props = join(v, v3)
		else
			v2 = FitFrameHorizontal
			component = FitTextLabel
			props = Cryo.Dictionary.join(v, {
				Font = normalizeFontFace(font2),
				FontFace = Cryo.None,
				width = FitTextLabel.Width.FitToText,
				onActivated = data.props.onActivated,
				[Roact.Change.AbsoluteSize] = data.textAbsoluteSizeChanged
			})
			flag = true
		end

		local fillImage = data.props.fillImage

		local createElement = Roact.createElement

		if data.props.isRoactGamepadEnabled then
			v2 = RoactGamepad.Focusable[v2]
		end

		local size

		if not flag then
			size = data.props.size or data.sizeBinding or nil
		end

		local frameRefsByRef = {
			Size = size,
			height = flag and UDim.new(0, 26) or nil,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = data.props.layoutOrder,
			[Roact.Ref] = data.props.frameRef,
			SelectionImageObject = data.props.SelectionImageObject,
			FillDirection = flag and Enum.FillDirection.Horizontal or nil,
			VerticalAlignment = flag and Enum.VerticalAlignment.Center or nil,
			contentPadding = flag and UDim.new(0, 8) or nil,
			NextSelectionLeft = data.props.NextSelectionLeft,
			NextSelectionRight = data.props.NextSelectionRight,
			NextSelectionUp = data.props.NextSelectionUp,
			NextSelectionDown = data.props.NextSelectionDown,
			inputBindings = data.props.isRoactGamepadEnabled and {
				Activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, data.props.onActivated)
			} or nil
		}
		local horizontalLayout

		if not flag then
			horizontalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 8),
					VerticalAlignment = Enum.VerticalAlignment.Center
				})
				or nil
		end

		local padding

		if not flag then
			padding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 8) }) or nil
		end

		local createElement2 = Roact.createElement
		local controlComponent = { component = ImageSetComponent.Button, props = 0, children = 0 }
		local onActivatedsByActivated = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 26, 0, 26),
			Image = data.props.image,
			ImageTransparency = data.props.transparency,
			ScaleType = data.props.buttonSliceType,
			SliceCenter = data.props.buttonSliceCenter,
			ImageColor3 = data.state.outerImageColor,
			[Roact.Event.Activated] = data.props.onActivated,
			LayoutOrder = 1
		}
		controlComponent.props = onActivatedsByActivated

		controlComponent.children = {
			InputFillImage = fillImage and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Size = data.props.fillImageSize,
				Image = fillImage,
				ImageTransparency = data.props.transparency,
				ImageColor3 = data.props.fillImageColor,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		}
		local v3 = {
			HorizontalLayout = horizontalLayout,
			Padding = padding,
			InputButtonImage = createElement2(Controllable, {
				controlComponent = controlComponent,
				isDisabled = data.props.isDisabled,
				onStateChanged = function(_, p2)
					data.changeSprite(p2)
				end
			}),
			InputButtonText = 0
		}
		local inputButtonText

		if data.props.text == "" then
			inputButtonText = false
		else
			inputButtonText = Roact.createElement(Controllable, {
				controlComponent = { component = component, props = props },
				isDisabled = data.props.isDisabled,
				onStateChanged = function(_, p2)
					data.changeSprite(p2)
				end
			})
		end

		v3.InputButtonText = inputButtonText
		return createElement(v2, frameRefsByRef, v3)
	end)
end

return Roact.forwardRef(function(p, frameRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)
