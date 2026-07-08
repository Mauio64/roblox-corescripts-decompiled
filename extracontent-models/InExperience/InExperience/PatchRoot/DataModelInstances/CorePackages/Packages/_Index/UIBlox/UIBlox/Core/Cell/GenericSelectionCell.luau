local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local ControlState = require(ParentParentParent.UIBlox.Core.Control.Enum.ControlState)
local GenericCell = require(ParentParentParent.UIBlox.Core.Cell.GenericCell)
local ImageSetComponent = require(ParentParentParent.UIBlox.Core.ImageSet.ImageSetComponent)
local v10 = Roact.PureComponent:extend("GenericSelectionCell")
local t1 = {
	[ControlState.Default] = "BackgroundDefault",
	[ControlState.Hover] = "BackgroundOnHover",
	[ControlState.Pressed] = "BackgroundOnPress"
}
local t2 = {
	[ControlState.Default] = "IconDefault",
	[ControlState.Hover] = "IconEmphasis",
	[ControlState.Pressed] = "IconDefault"
}

local function getCellStyle(p1, p2, p3) -- line: 30
	-- upvalues: ControlState (copy)
	local v19 = p1[p2] or p1[ControlState.Default]
	local t3 = {
		Color = p3.Theme[v19].Color,
		Transparency = p3.Theme[v19].Transparency
	}

	if p2 == ControlState.Default or p2 == ControlState.Disabled then
		t3.Transparency = 1
	end

	return t3
end
local function getIconStyle(p4, p5, p6) -- line: 47
	-- upvalues: ControlState (copy)
	local v24 = p4[p5] or p4[ControlState.Default]
	local t4 = {
		Color = p6.Theme[v24].Color,
		Transparency = p6.Theme[v24].Transparency
	}

	if p5 == ControlState.Disabled or p5 == ControlState.Pressed then
		t4.Transparency = 0.5 * t4.Transparency + 0.5
	end

	return t4
end
local function getTextStyle(p7, p8) -- line: 63
	-- upvalues: ControlState (copy)
	local t5 = {
		Color = p7.Color,
		Transparency = p7.Transparency
	}

	if p8 == ControlState.Disabled or p8 == ControlState.Pressed then
		t5.Transparency = 0.5 * t5.Transparency + 0.5
	end

	return t5
end

v10.validateProps = t.strictInterface({
	text = t.string,
	subtitleText = t.optional(t.string),
	defaultImage = t.union(t.string, t.table),
	selectedImage = t.union(t.string, t.table),
	defaultImageSize = t.number,
	selectedImageSize = t.number,
	onActivated = t.optional(t.callback),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	useDefaultControlState = t.optional(t.boolean),
	controlRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	SelectionImageObject = t.optional(t.table)
})
v10.defaultProps = {
	isSelected = false
}

function v10.init(p9) -- line: 121
	-- upvalues: ControlState (copy)
	p9.state = {
		controlState = ControlState.Default
	}

	function p9.onStateChanged(_, p11) -- line: 126
		-- upvalues: p9 (copy)
		p9:setState({
			controlState = p11
		})
	end
end
function v10.render(p12) -- line: 133
	-- upvalues: withStyle (copy), ControlState (copy), getIconStyle (copy), t2 (copy), getCellStyle (copy), t1 (copy), Roact (copy), GenericCell (copy), ImageSetComponent (copy)
	assert(p12.validateProps(p12.props))

	return withStyle(function(p13) -- line: 136
		-- upvalues: p12 (copy), ControlState (copy), getIconStyle (copy), t2 (copy), getCellStyle (copy), t1 (copy), Roact (copy), GenericCell (copy), ImageSetComponent (copy)
		local p13Font = p13.Font
		local Theme = p13.Theme
		local v38 = p12.props.useDefaultControlState and ControlState.Default or p12.state.controlState
		local v39 = getIconStyle(t2, v38, p13)
		local v40 = getCellStyle(t1, v38, p13)
		local TextEmphasis = Theme.TextEmphasis
		local t6 = {
			Color = TextEmphasis.Color,
			Transparency = TextEmphasis.Transparency
		}

		if v38 == ControlState.Disabled or v38 == ControlState.Pressed then
			t6.Transparency = 0.5 * t6.Transparency + 0.5
		end

		local TextDefault = Theme.TextDefault
		local t7 = {
			Color = TextDefault.Color,
			Transparency = TextDefault.Transparency
		}

		if v38 == ControlState.Disabled or v38 == ControlState.Pressed then
			t7.Transparency = 0.5 * t7.Transparency + 0.5
		end

		local Divider = Theme.Divider

		return Roact.createElement(GenericCell, {
			titleText = p12.props.text,
			colorStyle = v40,
			textStyle = t6,
			fontStyle = p13Font.Header2,
			subtitleText = p12.props.subtitleText,
			subtitleTextStyle = t7,
			subtitleFontStyle = p13Font.Body,
			rightContentWidth = p12.props.defaultImageSize,
			onActivated = p12.props.onActivated,
			dividerStyle = Divider,
			isDisabled = p12.props.isDisabled,
			[Roact.Ref] = p12.props.controlRef,
			NextSelectionUp = p12.props.NextSelectionUp,
			NextSelectionDown = p12.props.NextSelectionDown,
			NextSelectionLeft = p12.props.NextSelectionLeft,
			NextSelectionRight = p12.props.NextSelectionRight,
			SelectionImageObject = p12.props.SelectionImageObject,
			renderRightContent = function() -- line: 166
				-- upvalues: Roact (copy), p12 (copy), ImageSetComponent (copy), v39 (copy)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(0, p12.props.defaultImageSize, 1, 0)
				}, {
					SelectionImage = Roact.createElement(ImageSetComponent.Label, {
						BackgroundTransparency = 1,
						Image = p12.props.defaultImage,
						Size = UDim2.new(0, p12.props.defaultImageSize, 0, p12.props.defaultImageSize),
						ImageColor3 = v39.Color,
						ImageTransparency = v39.Transparency,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					}, {
						SelectedImage = p12.props.isSelected and Roact.createElement(ImageSetComponent.Label, {
							BackgroundTransparency = 1,
							Image = p12.props.selectedImage,
							Size = UDim2.new(0, p12.props.selectedImageSize, 0, p12.props.selectedImageSize),
							ImageColor3 = v39.Color,
							ImageTransparency = v39.Transparency,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0)
						})
					})
				})
			end,
			onStateChanged = p12.onStateChanged
		})
	end)
end

return Roact.forwardRef(function(p14, p15) -- line: 198
	-- upvalues: Roact (copy), v10 (copy), Cryo (copy)
	return Roact.createElement(v10, Cryo.Dictionary.join(p14, {
		controlRef = p15
	}))
end)
