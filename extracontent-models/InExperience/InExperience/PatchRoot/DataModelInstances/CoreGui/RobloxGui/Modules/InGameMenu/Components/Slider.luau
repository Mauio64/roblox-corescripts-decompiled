local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Otter = InGameMenuDependencies.Otter
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local withStyle = UIBlox.Core.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ParentParent = script.Parent.Parent
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local AssetImage = require(script.Parent.AssetImage)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local t1 = {
	frequency = 5
}

local function isGamepad(p1) -- line: 43
	return p1 == Enum.UserInputType.Gamepad1 or (p1 == Enum.UserInputType.Gamepad2 or (p1 == Enum.UserInputType.Gamepad3 or (p1 == Enum.UserInputType.Gamepad4 or (p1 == Enum.UserInputType.Gamepad5 or (p1 == Enum.UserInputType.Gamepad6 or (p1 == Enum.UserInputType.Gamepad7 or p1 == Enum.UserInputType.Gamepad8))))))
end

local t2 = {}

local function getInputObjects() -- line: 56
	-- upvalues: UserInputService (copy), isGamepad (copy), t2 (copy)
	local LastInputType = UserInputService:GetLastInputType()

	if not isGamepad(LastInputType) then
		return nil
	end

	if t2[LastInputType] == nil then
		local GamepadState = UserInputService:GetGamepadState(LastInputType)
		local t3 = {}

		for _, v in ipairs(GamepadState) do
			t3[v.KeyCode] = v
		end

		t2[LastInputType] = t3
	end

	return t2[LastInputType]
end

local v23 = Roact.PureComponent:extend("Slider")

v23.validateProps = t.intersection(t.strictInterface({
	min = t.number,
	max = t.number,
	stepInterval = t.numberPositive,
	value = t.number,
	valueChanged = t.callback,
	disabled = t.optional(t.boolean),
	width = t.optional(t.UDim),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean),
	onSelectionLost = t.optional(t.callback),
	onSelectionGained = t.optional(t.callback),
	NextSelectionRight = t.optional(t.table),
	sliderDotRef = t.optional(t.union(t.callback, t.table))
}), function(p2) -- line: 115
	if p2.min > p2.max then
		return false, "min must be less than or equal to max"
	end

	if p2.value > p2.max or p2.value < p2.min then
		return false, "value must be within min and max"
	end

	return true
end)
v23.defaultProps = {
	disabled = false,
	width = UDim.new(1, 0)
}

function v23.init(p3) -- line: 133
	-- upvalues: Roact (copy), Otter (copy)
	p3.state = {
		dragging = false,
		hovering = false,
		entryMode = false
	}
	p3.totalMoveTime = 0
	p3.isFirstMove = true
	p3.unhandledTime = 0
	p3.rootButtonRef = Roact.createRef()
	p3.hoverRef = Roact.createRef()
	p3.hoverMotor = Otter.createSingleMotor(0)
	p3.hoverMotor:onStep(function(p4) -- line: 148
		-- upvalues: p3 (copy)
		local current = p3.hoverRef.current

		if current ~= nil then
			current.Size = UDim2.new(0, p4, 0, p4)
		end
	end)

	function p3.onInputBegan(_, p6) -- line: 156
		-- upvalues: p3 (copy)
		if p3.props.disabled then
			return
		end

		local UserInputType = p6.UserInputType

		if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local PositionX = p6.Position.X

		p3:processDrag(PositionX)
		p3:startListeningForDrag()
	end
end
function v23.renderFocusHandler(p7) -- line: 173
	-- upvalues: Roact (copy), FocusHandler (copy), GuiService (copy), RunService (copy), getInputObjects (copy), ContextActionService (copy)
	return Roact.createElement(FocusHandler, {
		isFocused = p7.state.entryMode and p7.props.canCaptureFocus,
		didFocus = function() -- line: 177
			-- upvalues: GuiService (copy), p7 (copy), RunService (copy), getInputObjects (copy), ContextActionService (copy)
			GuiService.CoreGuiNavigationEnabled = false
			p7.joystickListener = RunService.Heartbeat:Connect(function(dt) -- line: 181
				-- upvalues: p7 (copy), getInputObjects (copy)
				p7:onMoveStep(dt, (getInputObjects()))
			end)

			local value = p7.props.value

			ContextActionService:BindCoreAction("LeaveEntryMode", function(_, p9) -- line: 190
				-- upvalues: p7 (copy), value (copy)
				if p9 == Enum.UserInputState.End then
					p7:setState({
						entryMode = false
					})
					p7.props.valueChanged(value)

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB)
		end,
		didBlur = function() -- line: 200
			-- upvalues: p7 (copy), GuiService (copy), ContextActionService (copy)
			p7.joystickListener:Disconnect()
			GuiService.CoreGuiNavigationEnabled = true
			ContextActionService:UnbindCoreAction("LeaveEntryMode")
			p7:setState({
				entryMode = false
			})
		end
	}) or nil
end
function v23.renderWithSelectionCursor(p10, p11) -- line: 209
	-- upvalues: withStyle (copy), Roact (copy), ImageSetButton (copy), AssetImage (copy), divideTransparency (copy), CursorKind (copy)
	local min = p10.props.min
	local v36 = p10.props.max - min
	local v37 = (p10.props.value - min) / v36
	local v38 = math.abs(v37)
	local v39 = v37 / 2
	local v40 = p10.state.entryMode and p10.props.canCaptureFocus

	return withStyle(function(p12) -- line: 220
		-- upvalues: Roact (copy), ImageSetButton (copy), p10 (copy), AssetImage (copy), divideTransparency (copy), v39 (copy), v38 (copy), v37 (copy), p11 (copy), v40 (copy), CursorKind (copy)
		return Roact.createElement(ImageSetButton, {
			AnchorPoint = p10.props.AnchorPoint,
			BackgroundTransparency = 1,
			Image = "",
			LayoutOrder = p10.props.LayoutOrder,
			Position = p10.props.Position,
			Size = UDim2.new(p10.props.width.Scale, p10.props.width.Offset, 0, 36),
			[Roact.Ref] = p10.rootButtonRef,
			[Roact.Event.InputBegan] = p10.onInputBegan,
			Selectable = false
		}, {
			FocusHandler = p10:renderFocusHandler(),
			Gutter = Roact.createElement(AssetImage.Label, {
				BackgroundTransparency = 1,
				imageKey = "SliderCircle",
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = p12.Theme.UIMuted.Color,
				ImageTransparency = p12.Theme.UIMuted.Transparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 4)
			}, {
				FilledGutter = Roact.createElement(AssetImage.Label, {
					BackgroundTransparency = 1,
					imageKey = "SliderCircle",
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageColor3 = p12.Theme.ContextualPrimaryDefault.Color,
					ImageTransparency = divideTransparency(p12.Theme.ContextualPrimaryDefault.Transparency, not p10.props.disabled and 1 or 2),
					Position = UDim2.new(v39, 0, 0.5, 0),
					Size = UDim2.new(v38, 0, 1, 0)
				})
			}),
			DotTrack = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 4,
				Selectable = false,
				Size = UDim2.new(1, -12, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, {
				Dot = Roact.createElement(AssetImage.Button, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					imageKey = "SliderButton",
					Position = UDim2.new(v37, 0, 0.5, 0),
					Size = UDim2.new(0, 42, 0, 42),
					ImageTransparency = not p10.props.disabled and 0 or 0.5,
					ZIndex = 2,
					SelectionImageObject = p11(v40 and CursorKind.SelectedKnob or CursorKind.UnselectedKnob),
					[Roact.Event.Activated] = function(_, p14) -- line: 274
						-- upvalues: p10 (copy)
						if p14.KeyCode == Enum.KeyCode.ButtonA then
							p10:setState({
								entryMode = not p10.state.entryMode
							})
						end
					end,
					[Roact.Event.InputBegan] = function(p15, p16) -- line: 281
						-- upvalues: p10 (copy)
						if p10.props.disabled then
							return
						end

						if p16.UserInputType == Enum.UserInputType.MouseMovement then
							p10:setState({
								hovering = true
							})

							return
						end

						p10.onInputBegan(p15, p16)
					end,
					[Roact.Event.InputEnded] = function(_, p18) -- line: 294
						-- upvalues: p10 (copy)
						if p10.props.disabled then
							return
						end

						if p18.UserInputType == Enum.UserInputType.MouseMovement then
							p10:setState({
								hovering = false
							})
						end
					end,
					[Roact.Ref] = p10.props.sliderDotRef,
					[Roact.Event.SelectionLost] = p10.props.onSelectionLost,
					[Roact.Event.SelectionGained] = p10.props.onSelectionGained,
					NextSelectionRight = p10.props.NextSelectionRight
				}),
				HoverOverlay = Roact.createElement(AssetImage.Label, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					imageKey = "SliderHover",
					Position = UDim2.new(v37, 0, 0.5, 0),
					Size = UDim2.new(0, 0, 0, 0),
					[Roact.Ref] = p10.hoverRef
				})
			})
		})
	end)
end
function v23.render(p19) -- line: 323
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p20) -- line: 324
		-- upvalues: p19 (copy)
		return p19:renderWithSelectionCursor(p20)
	end)
end
function v23.didMount(p21) -- line: 329
	local current = p21.rootButtonRef.current
	local connection = nil

	connection = current.AncestryChanged:Connect(function() -- line: 337
		-- upvalues: current (copy), connection (ref), p21 (copy)
		if not current:IsDescendantOf(game) then
			return
		end

		connection:Disconnect()
		p21.canUseUserInputService = current:FindFirstAncestorWhichIsA("PluginGui") == nil
	end)
	p21.hoverMotor:start()
end
function v23.didUpdate(p22) -- line: 352
	-- upvalues: Otter (copy), t1 (copy)
	if p22.props.disabled then
		p22:stopListeningForDrag()
	end

	local n1 = 0

	if not p22.props.disabled and (p22.state.dragging or p22.state.hovering) then
		n1 = 42
	end

	p22.hoverMotor:setGoal(Otter.spring(n1, t1))
end
function v23.willUnmount(p23) -- line: 365
	p23.hoverMotor:stop()
	p23:disconnectDragEvents()
end
function v23.startListeningForDrag(p24) -- line: 370
	-- upvalues: UserInputService (copy)
	local current = p24.rootButtonRef.current

	if current == nil then
		return
	end

	if p24.state.dragging then
		return
	end

	if p24.canUseUserInputService then
		p24.moveConnection = UserInputService.InputChanged:Connect(function(input) -- line: 383
			-- upvalues: p24 (copy)
			if not p24.state.dragging then
				return
			end

			local UserInputType = input.UserInputType

			if UserInputType ~= Enum.UserInputType.MouseMovement and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if input.UserInputState ~= Enum.UserInputState.Change then
				return
			end

			p24:processDrag(input.Position.X)
		end)
		p24.releaseConnection = UserInputService.InputEnded:Connect(function(input) -- line: 405
			-- upvalues: p24 (copy)
			local UserInputType = input.UserInputType

			if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			p24:stopListeningForDrag()
			p24:processDrag(input.Position.X)
		end)
		p24.focusLostConnection = UserInputService.WindowFocusReleased:Connect(function() -- line: 420
			-- upvalues: p24 (copy)
			p24:stopListeningForDrag()
		end)
	else
		local PluginGui = current:FindFirstAncestorWhichIsA("PluginGui")
		local ImageButton = Instance.new("ImageButton")

		ImageButton.BackgroundTransparency = 1
		ImageButton.Image = ""
		ImageButton.Name = "SliderPluginGuiInputCapturer"
		ImageButton.Size = UDim2.new(1, 0, 1, 0)
		ImageButton.ZIndex = 100000
		p24.moveConnection = ImageButton.MouseMoved:Connect(function(p25) -- line: 440
			-- upvalues: p24 (copy)
			p24:processDrag(p25)
		end)
		p24.releaseConnection = ImageButton.MouseButton1Up:Connect(function(p26) -- line: 444
			-- upvalues: p24 (copy)
			p24:stopListeningForDrag()
			p24:processDrag(p26)
		end)
		p24.focusLostConnection = ImageButton.MouseLeave:Connect(function(x) -- line: 449
			-- upvalues: p24 (copy)
			p24:stopListeningForDrag()
			p24:processDrag(x)
		end)
		ImageButton.Parent = PluginGui
		p24.inputCapturerButton = ImageButton
	end

	p24:setState({
		dragging = true
	})
end
function v23.processDrag(p27, p28) -- line: 463
	local current = p27.rootButtonRef.current

	if current == nil then
		return
	end

	local min = p27.props.min
	local max = p27.props.max
	local stepInterval = p27.props.stepInterval
	local AbsoluteSizeX = current.AbsoluteSize.X
	local v59 = math.floor((math.clamp(p28 - current.AbsolutePosition.X, 0, AbsoluteSizeX) / AbsoluteSizeX * (max - min) + min) / stepInterval + 0.5) * stepInterval

	if v59 ~= p27.props.value then
		p27.props.valueChanged(v59)
	end
end
function v23.disconnectDragEvents(p29) -- line: 486
	if p29.moveConnection ~= nil then
		p29.moveConnection:Disconnect()
		p29.moveConnection = nil
	end

	if p29.releaseConnection ~= nil then
		p29.releaseConnection:Disconnect()
		p29.releaseConnection = nil
	end

	if p29.focusLostConnection ~= nil then
		p29.focusLostConnection:Disconnect()
		p29.focusLostConnection = nil
	end

	if p29.inputCapturerButton ~= nil then
		p29.inputCapturerButton:Destroy()
		p29.inputCapturerButton = nil
	end
end
function v23.stopListeningForDrag(p30) -- line: 508
	if not p30.state.dragging then
		return
	end

	p30:disconnectDragEvents()
	p30:setState({
		dragging = false
	})
end
function v23.processGamepadInput(p31, p32, p33) -- line: 520
	local v65 = p31.props.stepInterval * p32
	local v66 = math.max(math.min(p31.props.value + v65 * p33, p31.props.max), p31.props.min)

	if v66 ~= p31.props.value then
		p31.props.valueChanged(v66)
	end
end
function v23.onMoveStep(p34, p35, p36) -- line: 531
	local Position = p36[Enum.KeyCode.Thumbstick1].Position
	local v71 = Position.Magnitude > 0.2
	local n2 = 0

	p34.totalMoveTime = p34.totalMoveTime + p35

	local v73, n3, n4

	if v71 then
		v73 = not (Position.x > 0) and -1 or 1
		n3 = 0.2
		n4 = 12
	else
		v73 = (p36[Enum.KeyCode.DPadLeft].UserInputState ~= Enum.UserInputState.Begin and 0 or -1) + (p36[Enum.KeyCode.DPadRight].UserInputState ~= Enum.UserInputState.Begin and 0 or 1)
		n3 = 0.5
		n4 = 8
	end

	if v73 ~= 0 then
		if p34.isFirstMove then
			p34.isFirstMove = false
			p34.totalMoveTime = 0
			p34.unhandledTime = 0
			n2 = 1
		elseif n3 < p34.totalMoveTime then
			local v76 = p35 - math.max(n3 - p34.totalMoveTime - p35, 0) + p34.unhandledTime

			n2 = math.floor(n4 * v76)
			p34.unhandledTime = v76 - n2 / n4
		else
			n2 = 0
			p34.unhandledTime = 0
		end
	else
		p34.totalMoveTime = 0
		p34.isFirstMove = true
	end

	if n2 > 0 then
		p34:processGamepadInput(v73, n2)
	end
end
function v23.getDerivedStateFromProps(p37) -- line: 581
	if not p37.isMenuOpen then
		return {
			entryMode = false
		}
	end

	return nil
end

return v23
