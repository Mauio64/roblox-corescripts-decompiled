local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Otter = require(ParentParentParentParent.Otter)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local Images = require(ParentParent.ImageSet.Images)
local Label = require(ParentParentParent.Core.ImageSet.ImageSetComponent).Label
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local GetTextHeight = require(ParentParentParent.Core.Text.GetTextHeight)
local divideTransparency = require(ParentParentParent.Utility.divideTransparency)
local lerp = require(ParentParentParent.Utility.lerp)
local TooltipOrientation = require(scriptParent.Enum.TooltipOrientation)
local getPositionInfo = require(scriptParent.getPositionInfo)
local t1 = {
	[TooltipOrientation.Bottom] = Images["component_assets/triangleUp_16"],
	[TooltipOrientation.Top] = Images["component_assets/triangleDown_16"],
	[TooltipOrientation.Right] = Images["component_assets/triangleLeft_16"],
	[TooltipOrientation.Left] = Images["component_assets/triangleRight_16"]
}
local t2 = {
	frequency = 50,
	dampingRatio = 1
}
local v20 = Roact.PureComponent:extend("TooltipContainer")

v20.validateProps = t.strictInterface({
	triggerPosition = t.Vector2,
	triggerSize = t.Vector2,
	bodyText = t.string,
	headerText = t.optional(t.string),
	screenSize = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	orientation = t.optional(TooltipOrientation.isEnumValue),
	isDirectChild = t.optional(t.boolean)
})
v20.defaultProps = {
	isDirectChild = false,
	screenSize = Vector2.new(10000, 10000),
	orientation = TooltipOrientation.Bottom
}

function v20.init(p1) -- line: 61
	-- upvalues: Roact (copy), Otter (copy), t2 (copy)
	p1.visible = true

	local v22, v23 = Roact.createBinding(0)

	p1.progress = v22
	p1.progressMotor = Otter.createSingleMotor(0)
	p1.progressMotor:onStep(v23)
	p1.progressMotor:setGoal(Otter.spring(1, t2))
end
function v20.render(p2) -- line: 72
	-- upvalues: withStyle (copy), GetTextSize (copy), GetTextHeight (copy), getPositionInfo (copy), lerp (copy), divideTransparency (copy), Roact (copy), Label (copy), t1 (copy), GenericTextLabel (copy)
	return withStyle(function(p3) -- line: 73
		-- upvalues: GetTextSize (copy), p2 (copy), GetTextHeight (copy), getPositionInfo (copy), lerp (copy), divideTransparency (copy), Roact (copy), Label (copy), t1 (copy), GenericTextLabel (copy)
		local p3Font = p3.Font
		local Theme = p3.Theme
		local CaptionHeader = p3Font.CaptionHeader
		local CaptionBody = p3Font.CaptionBody
		local v35 = p3Font.BaseSize * p3Font.CaptionBody.RelativeSize
		local X = GetTextSize(p2.props.bodyText, v35, CaptionBody.Font, Vector2.new()).X

		if p2.props.headerText then
			X = math.max(X, GetTextSize(p2.props.headerText, p3Font.BaseSize * CaptionHeader.RelativeSize, CaptionHeader.Font, Vector2.new()).X)
		end

		local v37 = math.min(X, 216)
		local v38 = v37 + 24
		local v39 = GetTextHeight(p2.props.bodyText, CaptionBody.Font, v35, v37)
		local v40 = p2.props.headerText and GetTextHeight(p2.props.headerText, CaptionHeader.Font, v35, v37) or 0
		local v41 = p2.props.headerText and v40 + v39 + 24 + 4 or v39 + 24
		local v42 = getPositionInfo(v38, v41, p2.props.orientation, p2.props.triggerPosition, p2.props.triggerSize, p2.props.screenSize, p2.props.position)
		local v43 = p2.progress:map(function(p4) -- line: 113
			-- upvalues: p2 (copy), v42 (copy)
			local v47 = if not p2.props.position then p2.props.isDirectChild and v42.position or v42.absolutePosition else p2.props.position

			return v47:lerp(v47 + v42.animatedDistance, p4)
		end)
		local v44 = p2.progress:map(function(p5) -- line: 124
			-- upvalues: Theme (copy), lerp (copy), divideTransparency (copy)
			local BackgroundMutedTransparency = Theme.BackgroundMuted.Transparency

			return lerp(1, divideTransparency(BackgroundMutedTransparency, 1), p5)
		end)
		local v45 = p2.progress:map(function(p6) -- line: 130
			-- upvalues: Theme (copy), lerp (copy), divideTransparency (copy)
			local TextEmphasisTransparency = Theme.TextEmphasis.Transparency

			return lerp(1, divideTransparency(TextEmphasisTransparency, 2), p6)
		end)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = p2.visible,
			Position = v43,
			Size = v42.fillDirection == Enum.FillDirection.Vertical and UDim2.fromOffset(v38, v41 + 8) or UDim2.fromOffset(v38 + 8, v41)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = v42.fillDirection
			}),
			CaretFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = v42.caretFrameSize,
				LayoutOrder = v42.caretLayoutOrder
			}, {
				Caret = Roact.createElement(Label, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = v42.caretPosition,
					AnchorPoint = v42.caretAnchorPoint,
					Size = v42.caretImageSize,
					Image = t1[v42.updatedOrientation],
					ImageColor3 = Theme.BackgroundMuted.Color,
					ImageTransparency = v44,
					[Roact.Ref] = p2.caretRef
				})
			}),
			Content = Roact.createElement("TextButton", {
				AutoButtonColor = false,
				Text = "",
				Selectable = false,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(v38, v41),
				BackgroundColor3 = Theme.BackgroundMuted.Color,
				BackgroundTransparency = v44,
				LayoutOrder = v42.contentLayoutOrder
			}, {
				VerticalLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 4),
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				Header = p2.props.headerText and Roact.createElement(GenericTextLabel, {
					LayoutOrder = 1,
					colorStyle = Theme.TextEmphasis,
					fontStyle = CaptionHeader,
					Text = p2.props.headerText,
					TextTransparency = v45,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, v40)
				}),
				Body = Roact.createElement(GenericTextLabel, {
					LayoutOrder = 2,
					colorStyle = Theme.TextDefault,
					fontStyle = CaptionBody,
					Text = p2.props.bodyText,
					TextTransparency = v45,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(1, 0, 0, v39)
				})
			})
		})
	end)
end
function v20.didMount(p7) -- line: 212
	p7.progressMotor:start()
end
function v20.didUpdate(p8, p9, _) -- line: 216
	if p9.triggerPosition ~= p8.props.triggerPosition then
		if p8.props.triggerPosition.Y < 0 or p8.props.triggerPosition.Y + p8.props.triggerSize.Y > p8.props.screenSize.Y then
			p8.visible = false

			return
		end

		p8.visible = true
	end
end
function v20.willUnmount(p11) -- line: 229
	p11.progressMotor:destroy()
	p11.progressMotor = nil
end

return v20
