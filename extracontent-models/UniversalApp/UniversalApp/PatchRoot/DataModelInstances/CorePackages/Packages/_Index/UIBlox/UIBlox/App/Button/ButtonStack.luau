local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local RoactGamepad = require(ParentParentParent.RoactGamepad)
local t = require(ParentParentParent.t)
local Button = require(scriptParent.Button)
local ButtonType = require(scriptParent.Enum.ButtonType)
local GetTextSize = require(ParentParent.Core.Text.GetTextSize)
local withStyle = require(ParentParent.Core.Style.withStyle)
local FitFrameOnAxis = require(ParentParentParent.FitFrame).FitFrameOnAxis
local v13 = Roact.PureComponent:extend("ButtonStack")

v13.validateProps = t.strictInterface({
	buttons = t.array(t.strictInterface({
		buttonType = t.optional(ButtonType.isEnumValue),
		props = Button.validateProps,
		isDefaultChild = t.optional(t.boolean)
	})),
	buttonHeight = t.optional(t.numberMin(0)),
	forcedFillDirection = t.optional(t.enum(Enum.FillDirection)),
	marginBetween = t.optional(t.numberMin(0)),
	minHorizontalButtonPadding = t.optional(t.numberMin(0)),
	disableRoactGamepadButtonSelection = t.optional(t.boolean),
	disableGamepadRefs = t.optional(t.boolean),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	frameRef = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v13.defaultProps = {
	buttonHeight = 36,
	marginBetween = 12,
	minHorizontalButtonPadding = 8,
	isRoactGamepadEnabled = true
}

function v13.init(p1) -- line: 71
	-- upvalues: RoactGamepad (copy)
	p1.buttonRefs = RoactGamepad.createRefCache()
	p1.state = {
		frameWidth = 0
	}

	function p1.updateFrameSize(p2) -- line: 78
		-- upvalues: p1 (copy)
		local AbsoluteSizeX = p2.AbsoluteSize.X

		if AbsoluteSizeX ~= p1.state.frameWidth then
			p1:setState({
				frameWidth = AbsoluteSizeX
			})
		end
	end
end
function v13.render(p3) -- line: 88
	-- upvalues: withStyle (copy), GetTextSize (copy), ButtonType (copy), Cryo (copy), Roact (copy), Button (copy), RoactGamepad (copy), FitFrameOnAxis (copy)
	return withStyle(function(p4) -- line: 89
		-- upvalues: p3 (copy), GetTextSize (copy), ButtonType (copy), Cryo (copy), Roact (copy), Button (copy), RoactGamepad (copy), FitFrameOnAxis (copy)
		local p4Font = p4.Font
		local v23 = p4Font.Body.RelativeSize * p4Font.BaseSize
		local isRoactGamepadEnabled = p3.props.isRoactGamepadEnabled
		local buttons = p3.props.buttons
		local v26 = #buttons > 1 and p3.props.marginBetween or 0
		local v27 = p3.state.frameWidth / #buttons - v26 * (#buttons - 1) / #buttons
		local v28 = false
		local v29 = nil
		local forcedFillDirection

		if p3.props.forcedFillDirection then
			v28 = p3.props.forcedFillDirection == Enum.FillDirection.Vertical
			forcedFillDirection = p3.props.forcedFillDirection
		else
			for _, v in ipairs(buttons) do
				if GetTextSize(v.props.text or "", v23, p4Font.Body.Font, Vector2.new(p3.state.frameWidth, p3.props.buttonHeight), not not v.props.buttonTextOverride and v.props.buttonTextOverride.RichText).X > v27 - 2 * p3.props.minHorizontalButtonPadding then
					v28 = true

					break
				end
			end

			forcedFillDirection = v28 and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		end

		local v33 = v28 and UDim2.new(1, 0, 0, p3.props.buttonHeight) or UDim2.new(0, v27, 0, p3.props.buttonHeight)
		local t1 = {}

		for i, v in ipairs(buttons) do
			local t2 = {
				key = tostring(i),
				layoutOrder = v28 and #buttons - i or i,
				size = v33,
				buttonType = v.buttonType or ButtonType.Secondary,
				isRoactGamepadEnabled = isRoactGamepadEnabled
			}
			local v38 = Cryo.Dictionary.join(t2, v.props)

			if v.isDefaultChild then
				v29 = i
			end

			if not p3.props.disableGamepadRefs and isRoactGamepadEnabled then
				local v39 = if not p3.props.disableRoactGamepadButtonSelection then {
					[Roact.Ref] = p3.buttonRefs[i],
					NextSelectionUp = v28 and (i > 1 and p3.buttonRefs[i - 1]) or nil,
					NextSelectionDown = v28 and (i < #buttons and p3.buttonRefs[i + 1]) or nil,
					NextSelectionLeft = not v28 and (i > 1 and p3.buttonRefs[i - 1]) or nil,
					NextSelectionRight = not v28 and (i < #buttons and p3.buttonRefs[i + 1]) or nil
				} else {
					[Roact.Ref] = p3.buttonRefs[i]
				}

				v38 = Cryo.Dictionary.join(v38, v39)
			end

			table.insert(t1, Roact.createElement(Button, v38))
		end

		return Roact.createElement(if not isRoactGamepadEnabled then FitFrameOnAxis else RoactGamepad.Focusable[FitFrameOnAxis], {
			BackgroundTransparency = 1,
			contentPadding = UDim.new(0, v26),
			FillDirection = forcedFillDirection,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			LayoutOrder = 3,
			minimumSize = UDim2.new(1, 0, 0, p3.props.buttonHeight),
			[Roact.Ref] = p3.props.frameRef,
			[Roact.Change.AbsoluteSize] = p3.updateFrameSize,
			NextSelectionLeft = if not isRoactGamepadEnabled then nil else p3.props.NextSelectionLeft,
			NextSelectionRight = if not isRoactGamepadEnabled then nil else p3.props.NextSelectionRight,
			NextSelectionUp = if not isRoactGamepadEnabled then nil else p3.props.NextSelectionUp,
			NextSelectionDown = if not isRoactGamepadEnabled then nil else p3.props.NextSelectionDown,
			defaultChild = if not isRoactGamepadEnabled then nil else v29 and p3.buttonRefs[v29] or nil
		}, t1)
	end)
end

local v14 = Roact.forwardRef(function(p5, p6) -- line: 190
	-- upvalues: Roact (copy), v13 (copy), Cryo (copy)
	return Roact.createElement(v13, Cryo.Dictionary.join(p5, {
		frameRef = p6
	}))
end)

v14.validateProps = v13.validateProps

return v14
