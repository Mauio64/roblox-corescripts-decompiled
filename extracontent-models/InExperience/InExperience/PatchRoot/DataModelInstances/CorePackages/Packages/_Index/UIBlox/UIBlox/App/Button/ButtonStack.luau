local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local RoactGamepad = require(parent3.RoactGamepad)
local t = require(parent3.t)

local Button = require(parent.Button)
local ButtonType = require(parent.Enum.ButtonType)
local GetTextSize = require(parent2.Core.Text.GetTextSize)
local withStyle = require(parent2.Core.Style.withStyle)

local FitFrame = require(parent3.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis

local extended = Roact.PureComponent:extend("ButtonStack")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	buttonHeight = 36,
	marginBetween = 12,
	minHorizontalButtonPadding = 8,
	isRoactGamepadEnabled = true
}

function extended:init()
	self.buttonRefs = RoactGamepad.createRefCache()

	self.state = { frameWidth = 0 }

	function self.updateFrameSize(p)
		local x = p.AbsoluteSize.X

		if x ~= self.state.frameWidth then
			self:setState({ frameWidth = x })
		end
	end
end

function extended.render(data)
	return withStyle(function(p)
		local font = p.Font
		local v = font.Body.RelativeSize * font.BaseSize

		local isRoactGamepadEnabled = data.props.isRoactGamepadEnabled

		local buttons = data.props.buttons
		local marginBetween = #buttons > 1 and data.props.marginBetween or 0
		local v2 = data.state.frameWidth / #buttons - marginBetween * (#buttons - 1) / #buttons

		local v3 = false

		local v4 = nil
		local fillDirection

		if data.props.forcedFillDirection then
			v3 = data.props.forcedFillDirection == Enum.FillDirection.Vertical
			fillDirection = data.props.forcedFillDirection
		else
			for _, button in ipairs(buttons) do
				local text = button.props.text or ""

				local font2 = font.Body.Font
				local vector2 = Vector2.new(data.state.frameWidth, data.props.buttonHeight)
				local v5

				if button.props.buttonTextOverride then
					v5 = button.props.buttonTextOverride.RichText
				else
					v5 = false
				end

				if GetTextSize(text, v, font2, vector2, v5).X > v2 - 2 * data.props.minHorizontalButtonPadding then
					v3 = true
					break
				end
			end

			fillDirection = v3 and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
		end

		local udim = v3 and UDim2.new(1, 0, 0, data.props.buttonHeight) or UDim2.new(0, v2, 0, data.props.buttonHeight)

		local children = {}

		for i, button in ipairs(buttons) do
			local v5 = {
				key = tostring(i),
				layoutOrder = 0,
				size = 0,
				buttonType = 0,
				isRoactGamepadEnabled = 0
			}
			local layoutOrder

			if v3 then
				layoutOrder = #buttons - i or i
			else
				layoutOrder = i
			end

			v5.layoutOrder = layoutOrder
			v5.size = udim
			v5.buttonType = button.buttonType or ButtonType.Secondary
			v5.isRoactGamepadEnabled = isRoactGamepadEnabled

			local joined = Cryo.Dictionary.join(v5, button.props)

			if button.isDefaultChild then
				v4 = i
			end

			if not data.props.disableGamepadRefs and isRoactGamepadEnabled then
				local v6

				if data.props.disableRoactGamepadButtonSelection then
					v6 = {}
					v6[Roact.Ref] = data.buttonRefs[i]
				else
					v6 = {}
					v6[Roact.Ref] = data.buttonRefs[i]
					local nextSelectionUp

					if v3 and i > 1 then
						nextSelectionUp = data.buttonRefs[i - 1] or nil
					end

					v6.NextSelectionUp = nextSelectionUp
					local nextSelectionDown

					if v3 and i < #buttons then
						nextSelectionDown = data.buttonRefs[i + 1] or nil
					end

					v6.NextSelectionDown = nextSelectionDown
					local nextSelectionLeft

					if not (v3 or not (i > 1)) then
						nextSelectionLeft = data.buttonRefs[i - 1] or nil
					end

					v6.NextSelectionLeft = nextSelectionLeft
					local nextSelectionRight

					if not (v3 or not (i < #buttons)) then
						nextSelectionRight = data.buttonRefs[i + 1] or nil
					end

					v6.NextSelectionRight = nextSelectionRight
				end

				joined = Cryo.Dictionary.join(joined, v6)
			end

			table.insert(children, Roact.createElement(Button, joined))
		end

		local createElement = Roact.createElement
		local v5

		if isRoactGamepadEnabled then
			v5 = RoactGamepad.Focusable[FitFrameOnAxis]
		else
			v5 = FitFrameOnAxis
		end

		local v6 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			contentPadding = UDim.new(0, marginBetween),
			FillDirection = fillDirection,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			LayoutOrder = 3,
			minimumSize = UDim2.new(1, 0, 0, data.props.buttonHeight),
			[Roact.Ref] = data.props.frameRef,
			[Roact.Change.AbsoluteSize] = data.updateFrameSize
		}
		local nextSelectionLeft

		if isRoactGamepadEnabled then
			nextSelectionLeft = data.props.NextSelectionLeft
		end

		v6.NextSelectionLeft = nextSelectionLeft
		local nextSelectionRight

		if isRoactGamepadEnabled then
			nextSelectionRight = data.props.NextSelectionRight
		end

		v6.NextSelectionRight = nextSelectionRight
		local nextSelectionUp

		if isRoactGamepadEnabled then
			nextSelectionUp = data.props.NextSelectionUp
		end

		v6.NextSelectionUp = nextSelectionUp
		local nextSelectionDown

		if isRoactGamepadEnabled then
			nextSelectionDown = data.props.NextSelectionDown
		end

		v6.NextSelectionDown = nextSelectionDown
		local defaultChild

		if isRoactGamepadEnabled then
			defaultChild = v4 and data.buttonRefs[v4] or nil
		end

		v6.defaultChild = defaultChild
		return createElement(v5, v6, children)
	end)
end

local forwardRef = Roact.forwardRef(function(p, frameRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)

forwardRef.validateProps = extended.validateProps

return forwardRef
