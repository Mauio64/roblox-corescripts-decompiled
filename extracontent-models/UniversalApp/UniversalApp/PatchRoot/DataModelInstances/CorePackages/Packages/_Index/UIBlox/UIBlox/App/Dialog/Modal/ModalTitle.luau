local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Cryo = require(ParentParentParentParent.Cryo)
local Images = require(ParentParent.ImageSet.Images)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local Controllable = require(Core.Control.Controllable)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local CloseButtonIcon = require(script.Parent.Enum.CloseButtonIcon)
local v14 = Roact.PureComponent:extend("ModalTitle")

v14.validateProps = t.strictInterface({
	title = t.string,
	position = t.optional(t.UDim2),
	anchor = t.optional(t.Vector2),
	closeButtonIcon = t.optional(CloseButtonIcon.isEnumValue),
	onCloseClicked = t.optional(t.callback),
	titleBackgroundImageProps = t.optional(t.strictInterface({
		image = t.string,
		imageHeight = t.number,
		text = t.optional(t.string)
	})),
	onTitleSizeChanged = t.optional(t.callback)
})
v14.defaultProps = {
	title = "",
	position = UDim2.new(0.5, 0, 0, 0),
	anchor = Vector2.new(0.5, 0),
	closeButtonIcon = CloseButtonIcon.Close
}

function v14.GetHeight(_) -- line: 53
	return 48
end

local function getCloseButtonIcon(p2) -- line: 57
	-- upvalues: CloseButtonIcon (copy)
	if p2 == CloseButtonIcon.Close then
		return "icons/navigation/close"
	end

	if p2 == CloseButtonIcon.Back then
		return "icons/actions/cycleLeft"
	end

	return nil
end
local function renderBackgroundImage(p3, p4, p5) -- line: 67
	-- upvalues: Cryo (copy), Roact (copy), GenericTextLabel (copy), ImageSetComponent (copy)
	local text = p3.text
	local v23 = text and #text > 0
	local v24 = text and #text > 0
	local v25 = math.clamp(p3.imageHeight, 48, 261)

	if v23 then
		v25 += 8
		p5 = Cryo.Dictionary.join(p5, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		})
	end

	if text and #text > 0 then
		p5 = Cryo.Dictionary.join(p5, {
			BackgroundText = Roact.createElement(GenericTextLabel, {
				RichText = true,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, -56),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 48),
				fontStyle = p4.Font.Body,
				colorStyle = p4.Theme.TextEmphasis,
				Text = text,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		})
	end

	if v24 then
		p5 = Cryo.Dictionary.join(p5, {
			BackgroundTextShadow = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				ZIndex = 1,
				Size = UDim2.new(1, 0, 1, not v23 and 0 or -8),
				Position = UDim2.new(0, 0, 0, 0)
			}, {
				UIGradient = Roact.createElement("UIGradient", {
					Rotation = 90,
					Color = ColorSequence.new(Color3.new(0, 0, 0)),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.6, 0.25),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			})
		})
	end

	local v26 = Roact.createElement(ImageSetComponent.Label, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(1, 0, 0, v25),
		Position = UDim2.new(0, 0, 0, 0),
		ScaleType = Enum.ScaleType.Crop,
		Image = p3.image,
		ImageColor3 = Color3.fromRGB(255, 255, 255)
	}, p5)

	if v23 then
		v26 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, v25 - 8),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			TitleBackground = v26
		})
	end

	return v26
end

function v14.render(p6) -- line: 147
	-- upvalues: withStyle (copy), Roact (copy), Controllable (copy), ImageSetComponent (copy), Images (copy), CloseButtonIcon (copy), GenericTextLabel (copy), renderBackgroundImage (copy)
	local titleBackgroundImageProps = p6.props.titleBackgroundImageProps

	return withStyle(function(p7) -- line: 150
		-- upvalues: Roact (copy), p6 (copy), Controllable (copy), ImageSetComponent (copy), Images (copy), CloseButtonIcon (copy), GenericTextLabel (copy), titleBackgroundImageProps (copy), renderBackgroundImage (copy)
		local p7Font = p7.Font
		local Theme = p7.Theme
		local v32 = p7Font.BaseSize * p7Font.Header1.RelativeSize
		local createElement = Roact.createElement
		local t1 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 48),
			BackgroundTransparency = 1,
			[Roact.Change.AbsoluteSize] = p6.props.onTitleSizeChanged
		}
		local t2 = {}
		local g47 = nil
		local v46 = nil

		if p6.props.onCloseClicked then
			local createElement2 = Roact.createElement
			local v37 = Controllable
			local t3 = {}
			local t4 = {
				component = ImageSetComponent.Button,
				props = {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 32, 0.5, 0),
					Size = UDim2.new(0, 48, 0, 48),
					[Roact.Event.Activated] = p6.props.onCloseClicked
				}
			}
			local t5 = {}
			local createElement3 = Roact.createElement
			local ImageSetComponentLabel = ImageSetComponent.Label
			local t6 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 36, 0, 36)
			}
			local v44 = Images
			local closeButtonIcon = p6.props.closeButtonIcon

			t6.Image = v44[if closeButtonIcon ~= CloseButtonIcon.Close then if closeButtonIcon ~= CloseButtonIcon.Back then nil else "icons/actions/cycleLeft" else "icons/navigation/close"]
			t6.ImageColor3 = Theme.IconEmphasis.Color
			t6.ImageTransparency = Theme.IconEmphasis.Transparency
			t6.AnchorPoint = Vector2.new(0.5, 0.5)
			t6.Position = UDim2.new(0.5, 0, 0.5, 0)
			t5.InputFillImage = createElement3(ImageSetComponentLabel, t6)
			t4.children = t5
			t3.controlComponent = t4

			function t3.onStateChanged(...) -- line: 184
			end

			v46 = createElement2(v37, t3)

			if v46 then
				g47 = true
			end
		end

		if not g47 then
			v46 = nil
		end

		g47 = false
		t2.CloseButton = v46
		t2.Title = Roact.createElement(GenericTextLabel, {
			LayoutOrder = 1,
			TextWrapped = true,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -104, 1, 0),
			colorStyle = Theme.TextEmphasis,
			fontStyle = p7Font.Header1,
			Text = p6.props.title,
			TextSize = v32,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8)
			})
		})
		t2.Underline = not titleBackgroundImageProps and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 1, 0),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency,
			Size = UDim2.new(1, 0, 0, 1)
		})

		local v48 = createElement("Frame", t1, t2)

		if titleBackgroundImageProps then
			return (renderBackgroundImage(titleBackgroundImageProps, p7, {
				TitleText = v48
			}))
		end

		return v48
	end)
end

return v14
