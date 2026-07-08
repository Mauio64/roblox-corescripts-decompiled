local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local Slider = require(script.Parent.Slider)
local AssetImage = require(script.Parent.AssetImage)
local v18 = Roact.PureComponent:extend("SliderWithInput")

v18.defaultProps = {
	width = UDim.new(1, 0)
}
v18.validateProps = t.intersection(t.strictInterface({
	min = t.number,
	max = t.number,
	stepInterval = t.numberPositive,
	keyboardInputStepInterval = t.optional(t.numberPositive),
	value = t.number,
	valueChanged = t.callback,
	disabled = t.optional(t.boolean),
	width = t.optional(t.UDim),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean),
	sliderDotRef = t.optional(t.table),
	onSelectionLost = t.callback,
	onSelectionGained = t.callback
}), function(p1) -- line: 66
	if p1.min > p1.max then
		return false, "min must be less than or equal to max"
	end

	if p1.value > p1.max or p1.value < p1.min then
		return false, "value must be within min and max"
	end

	return true
end)

function v18.init(p2) -- line: 79
	-- upvalues: Roact (copy)
	p2.textBoxRef = Roact.createRef()
	p2.state = {
		textEntryMode = false
	}
end
function v18.renderFocusHandler(p3) -- line: 87
	-- upvalues: Roact (copy), FocusHandler (copy), GuiService (copy), ContextActionService (copy)
	return Roact.createElement(FocusHandler, {
		isFocused = not not p3.props.canCaptureFocus and (p3.state.textEntryMode or false),
		didFocus = function() -- line: 91
			-- upvalues: GuiService (copy), p3 (copy), ContextActionService (copy)
			GuiService.CoreGuiNavigationEnabled = false

			local value = p3.props.value

			ContextActionService:BindCoreAction("LeaveTextEntryMode", function(_, p5) -- line: 100
				-- upvalues: p3 (copy), value (copy)
				if p5 == Enum.UserInputState.End then
					p3:setState({
						textEntryMode = false
					})

					local current = p3.textBoxRef.current

					current.Text = value
					current:ReleaseFocus()

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB)
		end,
		didBlur = function() -- line: 112
			-- upvalues: GuiService (copy), ContextActionService (copy)
			GuiService.CoreGuiNavigationEnabled = true
			ContextActionService:UnbindCoreAction("LeaveTextEntryMode")
		end
	}) or nil
end
function v18.renderWithSelectionCursor(p6, p7) -- line: 119
	-- upvalues: Cryo (copy), Roact (copy), Slider (copy), withStyle (copy), AssetImage (copy), CursorKind (copy), ExternalEventConnection (copy), UserInputService (copy)
	local props = p6.props
	local v25 = Cryo.Dictionary.join(props, {
		width = UDim.new(1, -80),
		LayoutOrder = Cryo.None,
		Position = Cryo.None,
		AnchorPoint = Cryo.None,
		keyboardInputStepInterval = Cryo.None,
		NextSelectionRight = p6.textBoxRef
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(props.width.Scale, props.width.Offset, 0, 36),
		Position = props.Position,
		LayoutOrder = props.LayoutOrder
	}, {
		Slider = Roact.createElement(Slider, v25),
		TextContainer = withStyle(function(p8) -- line: 137
			-- upvalues: props (copy), Roact (copy), AssetImage (copy), p6 (copy), p7 (copy), CursorKind (copy)
			local v29 = props.disabled and p8.Theme.TextMuted or p8.Theme.TextDefault

			return Roact.createElement(AssetImage.Label, {
				BackgroundTransparency = 1,
				imageKey = "RoundedRect",
				ImageTransparency = p8.Theme.BackgroundUIContrast.Transparency,
				ImageColor3 = p8.Theme.BackgroundUIContrast.Color,
				Size = UDim2.new(0, 64, 0, 36),
				Position = UDim2.new(1, 0, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5)
			}, {
				FocusHandler = p6:renderFocusHandler(),
				Box = Roact.createElement("TextBox", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Font = p8.Font.Body.Font,
					TextScaled = true,
					ClearTextOnFocus = false,
					TextEditable = not props.disabled,
					TextColor3 = v29.Color,
					TextTransparency = v29.Transparency,
					Text = tostring(props.value),
					NextSelectionLeft = p6.props.sliderDotRef,
					SelectionImageObject = p7(CursorKind.InputFields),
					[Roact.Event.SelectionLost] = p6.props.onSelectionLost,
					[Roact.Event.SelectionGained] = p6.props.onSelectionGained,
					[Roact.Ref] = p6.textBoxRef,
					[Roact.Event.Focused] = props.disabled and function(p9) -- line: 167
						p9:ReleaseFocus(false)
					end or function() -- line: 169
						-- upvalues: p6 (copy)
						p6:setState({
							textEntryMode = true
						})
					end,
					[Roact.Event.FocusLost] = function(p10, _) -- line: 172
						-- upvalues: p6 (copy), props (copy)
						p6:setState({
							textEntryMode = false
						})

						local num = tonumber(p10.Text)

						if num ~= props.value then
							if num == nil then
								p10.Text = tostring(props.value)

								return
							end

							local stepInterval = props.stepInterval

							if props.keyboardInputStepInterval then
								stepInterval = props.keyboardInputStepInterval
							end

							local v43 = math.clamp(math.floor(num / stepInterval + 0.5) * stepInterval, props.min, props.max)

							p10.Text = tostring(v43)

							if v43 ~= props.value then
								props.valueChanged(v43)
							end
						end
					end
				}, {
					TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MinTextSize = p8.Font.Body.RelativeMinSize * p8.Font.BaseSize,
						MaxTextSize = p8.Font.Body.RelativeSize * p8.Font.BaseSize
					})
				})
			})
		end),
		UserInputConnection = not props.disabled and Roact.createElement(ExternalEventConnection, {
			event = UserInputService.InputBegan,
			callback = function(p12, _) -- line: 210
				-- upvalues: UserInputService (copy), p6 (copy), props (copy)
				if p12.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end

				if UserInputService:GetFocusedTextBox() ~= p6.textBoxRef.current then
					return
				end

				local n1 = 0

				if p12.KeyCode == Enum.KeyCode.Up then
					n1 = 1
				elseif p12.KeyCode == Enum.KeyCode.Down then
					n1 = -1
				end

				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
					n1 *= 10
				end

				if n1 ~= 0 then
					local v33 = math.clamp(math.floor((props.value + props.stepInterval * n1) / props.stepInterval + 0.5) * props.stepInterval, props.min, props.max)

					if v33 ~= props.value then
						props.valueChanged(v33)
					end
				end
			end
		})
	})
end
function v18.render(p14) -- line: 250
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p15) -- line: 251
		-- upvalues: p14 (copy)
		return p14:renderWithSelectionCursor(p15)
	end)
end

return v18
