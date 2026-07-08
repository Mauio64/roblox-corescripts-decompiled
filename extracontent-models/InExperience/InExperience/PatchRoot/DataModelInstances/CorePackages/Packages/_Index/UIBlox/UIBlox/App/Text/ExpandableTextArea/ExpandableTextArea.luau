local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Cryo = require(ParentParentParentParent.Cryo)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local t = require(ParentParentParentParent.t)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local SpringAnimatedItem = require(ParentParentParent.Utility.SpringAnimatedItem)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local Images = require(ParentParentParent.App.ImageSet.Images)
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local ExpandableTextUtils = require(ParentParentParent.Core.Text.ExpandableText.ExpandableTextUtils)
local withSelectionCursorProvider = require(ParentParent.SelectionImage.withSelectionCursorProvider)
local CursorType = require(ParentParent.SelectionCursor.CursorType)
local useCursorByType = require(ParentParent.SelectionCursor.useCursorByType)
local n1 = 30
local n2 = 5
local uDim2 = UDim2.new(0, 36, 0, 36)
local uDim2_2 = UDim2.new(1, 0, 0, 36)
local v21 = Images["gradient/gradient_0_100"]
local v22 = Images["truncate_arrows/actions_truncationExpand"]
local v23 = Images["truncate_arrows/actions_truncationCollapse"]
local t1 = {
	dampingRatio = 1,
	frequency = 3.5
}
local t2 = {
	dampingRatio = 1,
	frequency = 3.5
}
local v26 = SpringAnimatedItem.wrap(ImageSetComponent.Label)
local v27 = Roact.PureComponent:extend("ExpandableTextArea")

v27.validateProps = t.strictInterface({
	Text = t.optional(t.string),
	Position = t.optional(t.UDim2),
	compactNumberOfLines = t.optional(t.number),
	LayoutOrder = t.optional(t.number),
	width = t.optional(t.UDim),
	padding = t.optional(t.Vector2),
	onClick = t.optional(t.callback),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	frameRef = t.optional(t.table),
	gradientColor = t.optional(t.Color3),
	selectionCursor = t.table,
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v27.defaultProps = {
	compactNumberOfLines = 2,
	Text = "",
	isRoactGamepadEnabled = true
}

function v27.init(p1) -- line: 74
	-- upvalues: Roact (copy)
	p1.state = {
		isExpanded = false,
		frameWidth = 0
	}

	function p1.onClick() -- line: 80
		-- upvalues: p1 (copy)
		p1:setState(function(p2) -- line: 81
			return {
				isExpanded = not p2.isExpanded
			}
		end)

		if p1.props.onClick then
			p1.props.onClick(p1.state.isExpanded)
		end
	end

	p1.ref = Roact.createRef()
	p1.layoutRef = Roact.createRef()
end
function v27.getRef(p3) -- line: 95
	return p3.props.frameRef or p3.ref
end
function v27.applyFit(p4, p5) -- line: 99
	-- upvalues: n1 (ref), n2 (ref)
	local v32 = p4:getRef()

	if not v32.current then
		return
	end

	local current = v32.current
	local v34 = p5 + n1 + n2
	local width = p4.props.width

	if width then
		current.Size = UDim2.new(width.Scale, width.Offset, 0, v34)

		return
	end

	current.Size = UDim2.new(1, 0, 0, v34)
end
function v27.didMount(p6) -- line: 114
	p6.isMounted = true

	local current = p6.layoutRef.current

	if current then
		p6:applyFit(current.AbsoluteContentSize.y)
	end
end
function v27.willUnmount(p7) -- line: 123
	p7.isMounted = false
end
function v27.render(p8) -- line: 127
	-- upvalues: n1 (ref), n2 (ref), withStyle (copy), withSelectionCursorProvider (copy), ExpandableTextUtils (copy), RoactGamepad (copy), Roact (copy), SpringAnimatedItem (copy), t1 (copy), GenericTextLabel (copy), v26 (copy), v21 (copy), t2 (copy), uDim2_2 (copy), ImageSetComponent (copy), v23 (copy), v22 (copy), uDim2 (copy)
	local propsText = p8.props.Text
	local propsPosition = p8.props.Position
	local compactNumberOfLines = p8.props.compactNumberOfLines
	local propsLayoutOrder = p8.props.LayoutOrder
	local width = p8.props.width
	local padding = p8.props.padding
	local gradientColor = p8.props.gradientColor
	local v47 = p8:getRef()

	n1 = padding and padding.Y or 30
	n2 = padding and padding.X or 5

	return withStyle(function(p9) -- line: 140
		-- upvalues: withSelectionCursorProvider (copy), ExpandableTextUtils (copy), p8 (copy), propsText (copy), compactNumberOfLines (copy), n2 (ref), RoactGamepad (copy), Roact (copy), propsLayoutOrder (copy), propsPosition (copy), width (copy), v47 (copy), n1 (ref), SpringAnimatedItem (copy), t1 (copy), GenericTextLabel (copy), v26 (copy), v21 (copy), gradientColor (copy), t2 (copy), uDim2_2 (copy), ImageSetComponent (copy), v23 (copy), v22 (copy), uDim2 (copy)
		return withSelectionCursorProvider(function(_) -- line: 141
			-- upvalues: p9 (copy), ExpandableTextUtils (copy), p8 (copy), propsText (copy), compactNumberOfLines (copy), n2 (ref), RoactGamepad (copy), Roact (copy), propsLayoutOrder (copy), propsPosition (copy), width (copy), v47 (copy), n1 (ref), SpringAnimatedItem (copy), t1 (copy), GenericTextLabel (copy), v26 (copy), v21 (copy), gradientColor (copy), t2 (copy), uDim2_2 (copy), ImageSetComponent (copy), v23 (copy), v22 (copy), uDim2 (copy)
			local Theme = p9.Theme
			local p9Font = p9.Font
			local v57 = p9Font.BaseSize * p9Font.Body.RelativeSize
			local v58, v59 = ExpandableTextUtils.getExpandableTextHeights(p9Font, p8.state.frameWidth, propsText, compactNumberOfLines)
			local uDim2_3 = UDim2.new(1, 0, 0, v59 + n2)
			local uDim2_4 = UDim2.new(1, 0, 0, v58 + n2)
			local v62 = v59 < v58
			local v63 = not v62 or p8.state.isExpanded
			local v64 = v63 and uDim2_4 or uDim2_3
			local v65 = not v63 and 30 or 0
			local v66 = (not p8.props.isRoactGamepadEnabled or not v62) and "Frame" or RoactGamepad.Focusable.Frame

			return Roact.createElement(v66, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = propsLayoutOrder,
				Position = propsPosition,
				Size = width and UDim2.new(width.Scale, width.Offset, 0, 0) or UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				SelectionImageObject = p8.props.selectionCursor,
				[Roact.Ref] = v47,
				[Roact.Change.AbsoluteSize] = function(p11) -- line: 174
					-- upvalues: p8 (copy)
					if p8.state.frameWidth ~= p11.AbsoluteSize.X then
						p8:setState({
							frameWidth = p11.AbsoluteSize.X
						})
					end
				end,
				NextSelectionUp = p8.props.NextSelectionUp,
				NextSelectionDown = p8.props.NextSelectionDown,
				NextSelectionLeft = p8.props.NextSelectionLeft,
				NextSelectionRight = p8.props.NextSelectionRight,
				inputBindings = if not p8.props.isRoactGamepadEnabled or not v62 then nil else {
					Activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, p8.onClick)
				}
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10),
					[Roact.Change.AbsoluteContentSize] = function(p12) -- line: 198
						-- upvalues: p8 (copy)
						p8:applyFit(p12.AbsoluteContentSize.y)
					end,
					[Roact.Ref] = p8.layoutRef
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, n1)
				}),
				ExpandableContainer = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
					animatedValues = {
						height = v64.Y.Offset
					},
					mapValuesToProps = function(p13) -- line: 211
						-- upvalues: v64 (copy)
						return {
							Size = UDim2.new(1, 0, v64.Y.Scale, p13.height)
						}
					end,
					regularProps = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						LayoutOrder = 0,
						Size = v64
					},
					springOptions = t1
				}, {
					DescriptionText = Roact.createElement(GenericTextLabel, {
						TextWrapped = true,
						BackgroundTransparency = 1,
						colorStyle = Theme.TextDefault,
						fontStyle = p9Font.Body,
						Size = v64,
						Text = propsText,
						TextSize = v57,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					Gradient = v62 and Roact.createElement(v26, {
						animatedValues = {
							height = v65
						},
						mapValuesToProps = function(p14) -- line: 239
							return {
								Size = UDim2.new(1, 0, 0, p14.height)
							}
						end,
						regularProps = {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 30),
							Position = UDim2.new(0, 0, 1, 0),
							AnchorPoint = Vector2.new(0, 1),
							Image = v21,
							ImageColor3 = gradientColor or Theme.BackgroundDefault.Color
						},
						springOptions = t2
					})
				}),
				ButtonContainer = v62 and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 10)
				}, {
					PressableButton = Roact.createElement("TextButton", {
						Position = UDim2.new(0, 0, 0, -24),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = uDim2_2,
						Text = "",
						[Roact.Event.Activated] = p8.onClick
					}, {
						DownArrow = Roact.createElement(ImageSetComponent.Label, {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AnchorPoint = Vector2.new(0.5, 0),
							Position = UDim2.new(0.5, 0, 0, 0),
							Image = v64 == uDim2_4 and v23 or v22,
							ImageColor3 = Theme.IconEmphasis.Color,
							ImageTransparency = Theme.IconEmphasis.Transparency,
							Size = uDim2
						})
					})
				})
			})
		end)
	end)
end

return Roact.forwardRef(function(p15, p16) -- line: 286
	-- upvalues: useCursorByType (copy), CursorType (copy), Cryo (copy), Roact (copy), v27 (copy)
	local v50 = useCursorByType(CursorType.RoundedRect)
	local v51 = Cryo.Dictionary.join(p15, {
		selectionCursor = v50
	})

	return Roact.createElement(v27, Cryo.Dictionary.join(v51, {
		frameRef = p16
	}))
end)
