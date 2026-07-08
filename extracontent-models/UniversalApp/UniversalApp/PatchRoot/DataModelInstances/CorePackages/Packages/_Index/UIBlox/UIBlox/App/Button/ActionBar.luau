local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Roact = require(scriptParentParentParentParent.Roact)
local React = require(scriptParentParentParentParent.React)
local Cryo = require(scriptParentParentParentParent.Cryo)
local RoactGamepad = require(scriptParentParentParentParent.RoactGamepad)
local t = require(scriptParentParentParentParent.t)
local FitFrameOnAxis = require(scriptParentParentParentParent.FitFrame).FitFrameOnAxis
local Button = require(scriptParent.Button)
local ComboButton = require(scriptParent.ComboButton)
local IconButton = require(scriptParent.IconButton)
local TextButton = require(scriptParent.TextButton)
local ButtonType = require(scriptParent.Enum.ButtonType)
local withStyle = require(scriptParentParentParent.Core.Style.withStyle)
local IconSize = require(scriptParentParent.ImageSet.Enum.IconSize)
local getPageMargin = require(scriptParentParent.Container.getPageMargin)
local Constants = require(scriptParentParent.Style.Constants)
local UIBloxConfig = require(scriptParentParentParent.UIBloxConfig)
local v21 = Roact.PureComponent:extend("ActionBar")

function v21.init(p1) -- line: 33
	-- upvalues: RoactGamepad (copy), Roact (copy)
	p1.buttonRefs = p1.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}
	p1.state = {
		frameWidth = 0
	}
	p1.frameRef = p1.props.frameRef or Roact.createRef()

	function p1.updateFrameSize(p2) -- line: 42
		-- upvalues: p1 (copy)
		local AbsoluteSizeX = p2.AbsoluteSize.X

		if AbsoluteSizeX ~= p1.state.frameWidth then
			p1:setState({
				frameWidth = AbsoluteSizeX
			})
		end

		if p1.props.onAbsoluteSizeChanged then
			p1.props.onAbsoluteSizeChanged(p2.AbsoluteSize)
		end
	end
	function p1.getGamepadNextSelectionLeft(p3, _) -- line: 55
		-- upvalues: p1 (copy)
		return p3 > 1 and p1.buttonRefs[p3 - 1] or nil
	end
	function p1.getGamepadNextSelectionRight(p5, p6) -- line: 59
		-- upvalues: p1 (copy)
		return p5 < p6 and p1.buttonRefs[p5 + 1] or nil
	end
end

v21.validateProps = t.strictInterface({
	button = t.optional(t.union(t.strictInterface({
		props = Button.validateProps
	}), t.strictInterface({
		props = ComboButton.validateProps
	}))),
	buttonOverride = t.optional(t.table),
	iconSize = t.optional(t.number),
	buttonHeight = t.optional(t.number),
	buttonPadding = t.optional(t.number),
	enableButtonAtStart = t.optional(t.boolean),
	icons = t.optional(t.array(t.strictInterface({
		props = IconButton.validateProps
	}))),
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
	textButtons = t.optional(t.array(t.strictInterface({
		props = TextButton.validateProps
	}))),
	isRoactGamepadEnabled = t.optional(t.boolean),
	testId = t.optional(t.string)
})
v21.defaultProps = {
	iconSize = 36,
	buttonHeight = 48,
	buttonPadding = 12,
	isRoactGamepadEnabled = true,
	testId = "--uiblox-action-bar",
	horizontalAlignment = Enum.HorizontalAlignment.Center
}

function v21.render(p7) -- line: 136
	-- upvalues: withStyle (copy), getPageMargin (copy), IconSize (copy), Constants (copy), UIBloxConfig (copy), Cryo (copy), Roact (copy), RoactGamepad (copy), React (copy), IconButton (copy), TextButton (copy), ComboButton (copy), ButtonType (copy), Button (copy), FitFrameOnAxis (copy)
	return withStyle(function(_) -- line: 137
		-- upvalues: getPageMargin (copy), p7 (copy), IconSize (copy), Constants (copy), UIBloxConfig (copy), Cryo (copy), Roact (copy), RoactGamepad (copy), React (copy), IconButton (copy), TextButton (copy), ComboButton (copy), ButtonType (copy), Button (copy), FitFrameOnAxis (copy)
		local v35 = getPageMargin(p7.state.frameWidth)
		local v36 = p7.state.frameWidth - v35 * 2
		local Medium = IconSize.Medium
		local v38 = if not p7.props.marginOverride then {
			top = 0,
			left = v35,
			right = v35,
			bottom = Constants.Layout.ActionBar.PositionOffset
		} else p7.props.marginOverride
		local n1 = 0

		if p7.props.icons and #p7.props.icons then
			n1 = #p7.props.icons
		end

		local n2 = 0

		if p7.props.textButtons and #p7.props.textButtons then
			n2 = #p7.props.textButtons
		end

		local v41 = p7.props.button == nil and (not UIBloxConfig.enableActionBarButtonOverride or p7.props.buttonOverride == nil) and 0 or 1
		local v42 = p7.props.enableButtonAtStart == true and v41 ~= 0
		local v43 = n2 + n1 + v41
		local t1 = {}

		if n1 ~= 0 then
			for i, v in ipairs(p7.props.icons) do
				local v47 = v42 and i + v41 or i
				local t2 = {
					layoutOrder = v47,
					iconSize = Medium
				}
				local v49 = Cryo.Dictionary.join(t2, v.props)

				if not p7.props.isRoactGamepadEnabled then
					p7.buttonRefs[v47] = p7.buttonRefs[v47] or Roact.createRef()
				end

				table.insert(t1, Roact.createElement(not p7.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
					key = "Button" .. tostring(v47),
					Size = UDim2.fromOffset(p7.props.iconSize, p7.props.iconSize),
					BackgroundTransparency = 1,
					[Roact.Ref] = p7.buttonRefs[v47],
					NextSelectionUp = nil,
					NextSelectionDown = nil,
					NextSelectionLeft = p7.getGamepadNextSelectionLeft(v47, v43),
					NextSelectionRight = p7.getGamepadNextSelectionRight(v47, v43),
					inputBindings = if not p7.props.isRoactGamepadEnabled then nil else {
						Activated = v49.onActivated and RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, v49.onActivated) or nil
					},
					[React.Tag] = if not p7.props.testId then nil else `data-testid={ p7.props.testId }--icon-button`
				}, {
					Icon = Roact.createElement(IconButton, v49)
				}))
			end
		end

		if n2 ~= 0 then
			for i, v in ipairs(p7.props.textButtons) do
				local v52 = ((if not v42 then i else i + v41)) + n1
				local t3 = {
					layoutOrder = v52
				}
				local v54 = Cryo.Dictionary.join(t3, v.props)

				if not p7.props.isRoactGamepadEnabled then
					p7.buttonRefs[v52] = p7.buttonRefs[v52] or Roact.createRef()
				end

				table.insert(t1, Roact.createElement(not p7.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
					key = "Button" .. tostring(v52),
					Size = UDim2.fromOffset(0, p7.props.iconSize),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					[Roact.Ref] = p7.buttonRefs[v52],
					NextSelectionUp = nil,
					NextSelectionDown = nil,
					NextSelectionLeft = p7.getGamepadNextSelectionLeft(v52, v43),
					NextSelectionRight = p7.getGamepadNextSelectionRight(v52, v43),
					inputBindings = if not p7.props.isRoactGamepadEnabled then nil else {
						Activated = v54.onActivated and RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, v54.onActivated) or nil
					}
				}, {
					TextButton = Roact.createElement(TextButton, v54)
				}))
			end
		end

		if v41 ~= 0 then
			local uDim2 = UDim2.fromOffset(v36 - n1 * (p7.props.iconSize + p7.props.buttonPadding), p7.props.buttonHeight)
			local v56 = if not v42 then n1 + 1 else 1
			local v57 = nil
			local v58 = nil

			if not UIBloxConfig.enableActionBarButtonOverride or not p7.props.buttonOverride then
				v57 = ComboButton.validateProps(p7.props.button.props)

				local t4 = {
					layoutOrder = v56,
					size = uDim2
				}

				v58 = Cryo.Dictionary.join(t4, p7.props.button.props)

				if not v57 and v58.buttonType == nil then
					v58.buttonType = if n1 ~= 0 then ButtonType.PrimaryContextual else ButtonType.PrimarySystem
				end
			end

			if not p7.props.isRoactGamepadEnabled then
				p7.buttonRefs[v56] = p7.buttonRefs[v56] or Roact.createRef()
			end

			table.insert(t1, if not v42 then v43 else 1, Roact.createElement(not p7.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
				key = "Button" .. v56,
				Size = uDim2,
				BackgroundTransparency = 1,
				[Roact.Ref] = p7.buttonRefs[v56],
				NextSelectionUp = nil,
				NextSelectionDown = nil,
				NextSelectionLeft = p7.getGamepadNextSelectionLeft(v56, v43),
				NextSelectionRight = p7.getGamepadNextSelectionRight(v56, v43),
				inputBindings = if not p7.props.isRoactGamepadEnabled then nil else {
					Activated = if v57 or not not UIBloxConfig.enableActionBarButtonOverride and p7.props.buttonOverride then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, v58.onActivated)
				},
				[React.Tag] = if not p7.props.testId then nil else `data-testid={ p7.props.testId }--primary-button`
			}, {
				Icon = if not UIBloxConfig.enableActionBarButtonOverride or not p7.props.buttonOverride then Roact.createElement(if not v57 then Button else ComboButton, v58) else p7.props.buttonOverride
			}))
		end

		if p7.props[Roact.Children] then
			t1 = p7.props[Roact.Children]
		end

		return Roact.createElement(if not p7.props.isRoactGamepadEnabled then FitFrameOnAxis else RoactGamepad.Focusable[FitFrameOnAxis], {
			BackgroundTransparency = 1,
			minimumSize = UDim2.new(1, 0, 0, p7.props.buttonHeight),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = p7.props.horizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			contentPadding = UDim.new(0, 12),
			[Roact.Ref] = p7.frameRef,
			[Roact.Change.AbsoluteSize] = p7.updateFrameSize,
			margin = v38,
			NextSelectionLeft = p7.props.NextSelectionLeft,
			NextSelectionRight = p7.props.NextSelectionRight,
			NextSelectionUp = p7.props.NextSelectionUp,
			NextSelectionDown = p7.props.NextSelectionDown
		}, t1)
	end)
end
function v21.didMount(p9) -- line: 352
	if p9.frameRef.current then
		p9.updateFrameSize(p9.frameRef.current)
	end
end

local v22 = Roact.forwardRef(function(p10, p11) -- line: 358
	-- upvalues: Roact (copy), v21 (copy), Cryo (copy)
	return Roact.createElement(v21, Cryo.Dictionary.join(p10, {
		frameRef = p11
	}))
end)

v22.validateProps = v21.validateProps

return v22
