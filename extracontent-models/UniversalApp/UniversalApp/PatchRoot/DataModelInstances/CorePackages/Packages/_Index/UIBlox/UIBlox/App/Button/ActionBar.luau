local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local React = require(parent4.React)
local Cryo = require(parent4.Cryo)
local RoactGamepad = require(parent4.RoactGamepad)
local t = require(parent4.t)

local FitFrame = require(parent4.FitFrame)
local FitFrameOnAxis = FitFrame.FitFrameOnAxis

local Button = require(parent.Button)
local ComboButton = require(parent.ComboButton)
local IconButton = require(parent.IconButton)
local TextButton = require(parent.TextButton)
local ButtonType = require(parent.Enum.ButtonType)

local withStyle = require(parent3.Core.Style.withStyle)
local IconSize = require(parent2.ImageSet.Enum.IconSize)
local getPageMargin = require(parent2.Container.getPageMargin)
local Constants = require(parent2.Style.Constants)

local UIBloxConfig = require(parent3.UIBloxConfig)

local extended = Roact.PureComponent:extend("ActionBar")

function extended:init()
	self.buttonRefs = self.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}

	self.state = { frameWidth = 0 }

	self.frameRef = self.props.frameRef or Roact.createRef()

	function self.updateFrameSize(p)
		local x = p.AbsoluteSize.X

		if x ~= self.state.frameWidth then
			self:setState({ frameWidth = x })
		end

		if self.props.onAbsoluteSizeChanged then
			self.props.onAbsoluteSizeChanged(p.AbsoluteSize)
		end
	end

	function self.getGamepadNextSelectionLeft(p, _)
		return p > 1 and self.buttonRefs[p - 1] or nil
	end

	function self.getGamepadNextSelectionRight(p, p2)
		return p < p2 and self.buttonRefs[p + 1] or nil
	end
end

extended.validateProps = t.strictInterface({
	button = t.optional(t.union(
		t.strictInterface({ props = Button.validateProps }),
		t.strictInterface({ props = ComboButton.validateProps })
	)),
	buttonOverride = t.optional(t.table),
	iconSize = t.optional(t.number),
	buttonHeight = t.optional(t.number),
	buttonPadding = t.optional(t.number),
	enableButtonAtStart = t.optional(t.boolean),
	icons = t.optional(t.array(t.strictInterface({ props = IconButton.validateProps }))),
	marginOverride = t.optional(t.strictInterface({
		left = t.number,
		right = t.number,
		top = t.number,
		bottom = t.number
	})),
	horizontalAlignment = t.optional(t.enum(Enum.HorizontalAlignment)),
	onAbsoluteSizeChanged = t.optional(t.callback),
	[Roact.Children] = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	frameRef = t.optional(t.table),
	textButtons = t.optional(t.array(t.strictInterface({ props = TextButton.validateProps }))),
	isRoactGamepadEnabled = t.optional(t.boolean),
	testId = t.optional(t.string)
})

extended.defaultProps = {
	horizontalAlignment = Enum.HorizontalAlignment.Center,
	iconSize = 36,
	buttonHeight = 48,
	buttonPadding = 12,
	isRoactGamepadEnabled = true,
	testId = "--uiblox-action-bar"
}

function extended.render(data)
	return withStyle(function(_)
		local pageMargin = getPageMargin(data.state.frameWidth)
		local v = data.state.frameWidth - pageMargin * 2
		local medium = IconSize.Medium
		local margin

		if data.props.marginOverride then
			margin = data.props.marginOverride
		else
			margin = {
				left = pageMargin,
				right = pageMargin,
				top = 0,
				bottom = Constants.Layout.ActionBar.PositionOffset
			}
		end

		local v2 = 0
		v2 = data.props.icons and #data.props.icons and #data.props.icons or v2

		local v3 = 0
		v3 = data.props.textButtons and #data.props.textButtons and #data.props.textButtons or v3

		local v4 = data.props.button == nil
			and (not UIBloxConfig.enableActionBarButtonOverride or data.props.buttonOverride == nil)
			and 0
			or 1
		local v5

		if data.props.enableButtonAtStart == true then
			v5 = v4 ~= 0
		else
			v5 = false
		end

		local v6 = v3 + v2 + v4
		local children = {}

		if v2 ~= 0 then
			for i, icon in ipairs(data.props.icons) do
				i = v5 and i + v4 or i
				local joined = Cryo.Dictionary.join({ layoutOrder = i, iconSize = medium }, icon.props)

				if not data.props.isRoactGamepadEnabled then
					data.buttonRefs[i] = data.buttonRefs[i] or Roact.createRef()
				end

				local createElement = Roact.createElement
				local v7 = not data.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
				local v8 = {
					["key"] = nil,
					key = "Button" .. tostring(i),
					Size = UDim2.fromOffset(data.props.iconSize, data.props.iconSize),
					BackgroundTransparency = 1,
					[Roact.Ref] = data.buttonRefs[i],
					NextSelectionUp = nil,
					NextSelectionDown = nil,
					NextSelectionLeft = data.getGamepadNextSelectionLeft(i, v6),
					NextSelectionRight = data.getGamepadNextSelectionRight(i, v6)
				}
				local inputBindings

				if data.props.isRoactGamepadEnabled then
					inputBindings = { Activated = 0 }
					local activated

					if joined.onActivated then
						activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, joined.onActivated) or nil
					end

					inputBindings.Activated = activated
				end

				v8.inputBindings = inputBindings

				local tag = React.Tag
				local v9

				if data.props.testId then
					v9 = `data-testid={data.props.testId}--icon-button`
				end

				v8[tag] = v9
				table.insert(children, createElement(v7, v8, {
					Icon = Roact.createElement(IconButton, joined)
				}))
			end
		end

		if v3 ~= 0 then
			for total, textButton in ipairs(data.props.textButtons) do
				if v5 then
					total += v4
				end

				local layoutOrder = total + v2

				local joined = Cryo.Dictionary.join({ layoutOrder = layoutOrder }, textButton.props)

				if not data.props.isRoactGamepadEnabled then
					data.buttonRefs[layoutOrder] = data.buttonRefs[layoutOrder] or Roact.createRef()
				end

				local createElement = Roact.createElement
				local v7 = not data.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
				local v8 = {
					key = "Button" .. tostring(layoutOrder),
					Size = UDim2.fromOffset(0, data.props.iconSize),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					[Roact.Ref] = data.buttonRefs[layoutOrder],
					NextSelectionUp = nil,
					NextSelectionDown = nil,
					NextSelectionLeft = data.getGamepadNextSelectionLeft(layoutOrder, v6),
					NextSelectionRight = data.getGamepadNextSelectionRight(layoutOrder, v6)
				}
				local inputBindings

				if data.props.isRoactGamepadEnabled then
					inputBindings = { Activated = 0 }
					local activated

					if joined.onActivated then
						activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, joined.onActivated) or nil
					end

					inputBindings.Activated = activated
				end

				v8.inputBindings = inputBindings
				table.insert(children, createElement(v7, v8, {
					TextButton = Roact.createElement(TextButton, joined)
				}))
			end
		end

		if v4 ~= 0 then
			local udim = UDim2.fromOffset(
				v - v2 * (data.props.iconSize + data.props.buttonPadding),
				data.props.buttonHeight
			)

			local layoutOrder = v5 and 1 or v2 + 1
			local v7, joined

			if not (UIBloxConfig.enableActionBarButtonOverride and data.props.buttonOverride) then
				v7 = ComboButton.validateProps(data.props.button.props)
				joined = Cryo.Dictionary.join({ layoutOrder = layoutOrder, size = udim }, data.props.button.props)

				if not v7 and joined.buttonType == nil then
					local buttonType

					if v2 == 0 then
						buttonType = ButtonType.PrimarySystem
					else
						buttonType = ButtonType.PrimaryContextual
					end

					joined.buttonType = buttonType
				end
			end

			if not data.props.isRoactGamepadEnabled then
				data.buttonRefs[layoutOrder] = data.buttonRefs[layoutOrder] or Roact.createRef()
			end

			local createElement = Roact.createElement
			local v8 = not data.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
			local v9 = {
				["key"] = nil,
				key = "Button" .. layoutOrder,
				Size = udim,
				BackgroundTransparency = 1,
				[Roact.Ref] = data.buttonRefs[layoutOrder],
				NextSelectionUp = nil,
				NextSelectionDown = nil,
				NextSelectionLeft = data.getGamepadNextSelectionLeft(layoutOrder, v6),
				NextSelectionRight = data.getGamepadNextSelectionRight(layoutOrder, v6)
			}
			local inputBindings

			if data.props.isRoactGamepadEnabled then
				inputBindings = { Activated = 0 }
				local activated

				if not (v7 or UIBloxConfig.enableActionBarButtonOverride and data.props.buttonOverride) then
					activated = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, joined.onActivated)
				end

				inputBindings.Activated = activated
			end

			v9.inputBindings = inputBindings

			local tag = React.Tag
			local v10

			if data.props.testId then
				v10 = `data-testid={data.props.testId}--primary-button`
			end

			v9[tag] = v10
			local icon

			if UIBloxConfig.enableActionBarButtonOverride and data.props.buttonOverride then
				icon = data.props.buttonOverride
			else
				local createElement2 = Roact.createElement
				local v11 = if v7 then ComboButton else Button
				icon = createElement2(v11, joined)
			end

			table.insert(children, v5 and 1 or v6, createElement(v8, v9, { Icon = icon }))
		end

		if data.props[Roact.Children] then
			children = data.props[Roact.Children]
		end

		local createElement = Roact.createElement
		local v7

		if data.props.isRoactGamepadEnabled then
			v7 = RoactGamepad.Focusable[FitFrameOnAxis]
		else
			v7 = FitFrameOnAxis
		end

		return createElement(v7, {
			BackgroundTransparency = 1,
			minimumSize = UDim2.new(1, 0, 0, data.props.buttonHeight),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = data.props.horizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			contentPadding = UDim.new(0, 12),
			[Roact.Ref] = data.frameRef,
			[Roact.Change.AbsoluteSize] = data.updateFrameSize,
			margin = margin,
			NextSelectionLeft = data.props.NextSelectionLeft,
			NextSelectionRight = data.props.NextSelectionRight,
			NextSelectionUp = data.props.NextSelectionUp,
			NextSelectionDown = data.props.NextSelectionDown
		}, children)
	end)
end

function extended.didMount(p)
	if p.frameRef.current then
		p.updateFrameSize(p.frameRef.current)
	end
end

local forwardRef = Roact.forwardRef(function(p, frameRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)

forwardRef.validateProps = extended.validateProps

return forwardRef
