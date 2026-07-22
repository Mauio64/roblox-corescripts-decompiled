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
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v15 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v16 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local ParentParent = script.Parent.Parent
local divideTransparency = require(ParentParent.Utility.divideTransparency)
local AssetImage = require(script.Parent.AssetImage)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local t1 = {
	frequency = 5
}

local function isGamepad(p1) -- line: 50
	return p1 == Enum.UserInputType.Gamepad1 or (p1 == Enum.UserInputType.Gamepad2 or (p1 == Enum.UserInputType.Gamepad3 or (p1 == Enum.UserInputType.Gamepad4 or (p1 == Enum.UserInputType.Gamepad5 or (p1 == Enum.UserInputType.Gamepad6 or (p1 == Enum.UserInputType.Gamepad7 or p1 == Enum.UserInputType.Gamepad8))))))
end

local t2 = {}

local function getInputObjects() -- line: 63
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

local v25 = Roact.PureComponent:extend("Slider")

v25.validateProps = t.intersection(t.strictInterface({
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
}), function(p2) -- line: 122
	if p2.min > p2.max then
		return false, "min must be less than or equal to max"
	end

	if p2.value > p2.max or p2.value < p2.min then
		return false, "value must be within min and max"
	end

	return true
end)
v25.defaultProps = {
	disabled = false,
	width = UDim.new(1, 0)
}

function v25.init(p3) -- line: 140
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
	p3.hoverMotor:onStep(function(p4) -- line: 155
		-- upvalues: p3 (copy)
		local current = p3.hoverRef.current

		if current ~= nil then
			current.Size = UDim2.new(0, p4, 0, p4)
		end
	end)

	function p3.onInputBegan(_, p6) -- line: 163
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
function v25.renderFocusHandler(p7) -- line: 180
	-- upvalues: Roact (copy), FocusHandler (copy), GuiService (copy), RunService (copy), getInputObjects (copy), ContextActionService (copy)
	return Roact.createElement(FocusHandler, {
		isFocused = p7.state.entryMode and p7.props.canCaptureFocus,
		didFocus = function() -- line: 184
			-- upvalues: GuiService (copy), p7 (copy), RunService (copy), getInputObjects (copy), ContextActionService (copy)
			GuiService.CoreGuiNavigationEnabled = false
			p7.joystickListener = RunService.Heartbeat:Connect(function(dt) -- line: 188
				-- upvalues: p7 (copy), getInputObjects (copy)
				p7:onMoveStep(dt, (getInputObjects()))
			end)

			local value = p7.props.value

			ContextActionService:BindCoreAction("LeaveEntryMode", function(_, p9) -- line: 197
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
		didBlur = function() -- line: 207
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
function v25.renderWithSelectionCursor(p10, p11) -- line: 216
	-- upvalues: withFoundationOrUIBloxStyle (copy), Roact (copy), ImageSetButton (copy), AssetImage (copy), divideTransparency (copy), v16 (copy)
	local min = p10.props.min
	local v38 = p10.props.max - min
	local v39 = (p10.props.value - min) / v38
	local v40 = math.abs(v39)
	local v41 = v39 / 2
	local v42 = p10.state.entryMode and p10.props.canCaptureFocus

	return withFoundationOrUIBloxStyle(function(p12) -- line: 227
		return {
			Theme = {
				UIMuted = {
					Color = p12.Color.Shift.Shift_100.Color3,
					Transparency = p12.Color.Shift.Shift_100.Transparency
				},
				ContextualPrimaryDefault = {
					Color = p12.Color.ActionEmphasis.Background.Color3,
					Transparency = p12.Color.ActionEmphasis.Background.Transparency
				}
			}
		}
	end, function(p13) -- line: 234
		-- upvalues: Roact (copy), ImageSetButton (copy), p10 (copy), AssetImage (copy), divideTransparency (copy), v41 (copy), v40 (copy), v39 (copy), p11 (copy), v42 (copy), v16 (copy)
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
				ImageColor3 = p13.Theme.UIMuted.Color,
				ImageTransparency = p13.Theme.UIMuted.Transparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 4)
			}, {
				FilledGutter = Roact.createElement(AssetImage.Label, {
					BackgroundTransparency = 1,
					imageKey = "SliderCircle",
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageColor3 = p13.Theme.ContextualPrimaryDefault.Color,
					ImageTransparency = divideTransparency(p13.Theme.ContextualPrimaryDefault.Transparency, not p10.props.disabled and 1 or 2),
					Position = UDim2.new(v41, 0, 0.5, 0),
					Size = UDim2.new(v40, 0, 1, 0)
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
					Position = UDim2.new(v39, 0, 0.5, 0),
					Size = UDim2.new(0, 42, 0, 42),
					ImageTransparency = not p10.props.disabled and 0 or 0.5,
					ZIndex = 2,
					SelectionImageObject = p11(v42 and v16.SelectedKnob or v16.UnselectedKnob),
					[Roact.Event.Activated] = function(_, p15) -- line: 288
						-- upvalues: p10 (copy)
						if p15.KeyCode == Enum.KeyCode.ButtonA then
							p10:setState({
								entryMode = not p10.state.entryMode
							})
						end
					end,
					[Roact.Event.InputBegan] = function(p16, p17) -- line: 295
						-- upvalues: p10 (copy)
						if p10.props.disabled then
							return
						end

						if p17.UserInputType == Enum.UserInputType.MouseMovement then
							p10:setState({
								hovering = true
							})

							return
						end

						p10.onInputBegan(p16, p17)
					end,
					[Roact.Event.InputEnded] = function(_, p19) -- line: 308
						-- upvalues: p10 (copy)
						if p10.props.disabled then
							return
						end

						if p19.UserInputType == Enum.UserInputType.MouseMovement then
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
					Position = UDim2.new(v39, 0, 0.5, 0),
					Size = UDim2.new(0, 0, 0, 0),
					[Roact.Ref] = p10.hoverRef
				})
			})
		})
	end)
end
function v25.render(p20) -- line: 337
	-- upvalues: v15 (copy)
	return v15(function(p21) -- line: 338
		-- upvalues: p20 (copy)
		return p20:renderWithSelectionCursor(p21)
	end)
end
function v25.didMount(p22) -- line: 343
	local current = p22.rootButtonRef.current
	local connection = nil

	connection = current.AncestryChanged:Connect(function() -- line: 351
		-- upvalues: current (copy), connection (ref), p22 (copy)
		if not current:IsDescendantOf(game) then
			return
		end

		connection:Disconnect()
		p22.canUseUserInputService = current:FindFirstAncestorWhichIsA("PluginGui") == nil
	end)
	p22.hoverMotor:start()
end
function v25.didUpdate(p23) -- line: 366
	-- upvalues: Otter (copy), t1 (copy)
	if p23.props.disabled then
		p23:stopListeningForDrag()
	end

	local n1 = 0

	if not p23.props.disabled and (p23.state.dragging or p23.state.hovering) then
		n1 = 42
	end

	p23.hoverMotor:setGoal(Otter.spring(n1, t1))
end
function v25.willUnmount(p24) -- line: 379
	p24.hoverMotor:stop()
	p24:disconnectDragEvents()
end
function v25.startListeningForDrag(p25) -- line: 384
	-- upvalues: UserInputService (copy)
	local current = p25.rootButtonRef.current

	if current == nil then
		return
	end

	if p25.state.dragging then
		return
	end

	if p25.canUseUserInputService then
		p25.moveConnection = UserInputService.InputChanged:Connect(function(input) -- line: 397
			-- upvalues: p25 (copy)
			if not p25.state.dragging then
				return
			end

			local UserInputType = input.UserInputType

			if UserInputType ~= Enum.UserInputType.MouseMovement and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if input.UserInputState ~= Enum.UserInputState.Change then
				return
			end

			p25:processDrag(input.Position.X)
		end)
		p25.releaseConnection = UserInputService.InputEnded:Connect(function(input) -- line: 419
			-- upvalues: p25 (copy)
			local UserInputType = input.UserInputType

			if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			p25:stopListeningForDrag()
			p25:processDrag(input.Position.X)
		end)
		p25.focusLostConnection = UserInputService.WindowFocusReleased:Connect(function() -- line: 434
			-- upvalues: p25 (copy)
			p25:stopListeningForDrag()
		end)
	else
		local PluginGui = current:FindFirstAncestorWhichIsA("PluginGui")
		local ImageButton = Instance.new("ImageButton")

		ImageButton.BackgroundTransparency = 1
		ImageButton.Image = ""
		ImageButton.Name = "SliderPluginGuiInputCapturer"
		ImageButton.Size = UDim2.new(1, 0, 1, 0)
		ImageButton.ZIndex = 100000
		p25.moveConnection = ImageButton.MouseMoved:Connect(function(p26) -- line: 454
			-- upvalues: p25 (copy)
			p25:processDrag(p26)
		end)
		p25.releaseConnection = ImageButton.MouseButton1Up:Connect(function(p27) -- line: 458
			-- upvalues: p25 (copy)
			p25:stopListeningForDrag()
			p25:processDrag(p27)
		end)
		p25.focusLostConnection = ImageButton.MouseLeave:Connect(function(x) -- line: 463
			-- upvalues: p25 (copy)
			p25:stopListeningForDrag()
			p25:processDrag(x)
		end)
		ImageButton.Parent = PluginGui
		p25.inputCapturerButton = ImageButton
	end

	p25:setState({
		dragging = true
	})
end
function v25.processDrag(p28, p29) -- line: 477
	local current = p28.rootButtonRef.current

	if current == nil then
		return
	end

	local min = p28.props.min
	local max = p28.props.max
	local stepInterval = p28.props.stepInterval
	local AbsoluteSizeX = current.AbsoluteSize.X
	local v61 = math.floor((math.clamp(p29 - current.AbsolutePosition.X, 0, AbsoluteSizeX) / AbsoluteSizeX * (max - min) + min) / stepInterval + 0.5) * stepInterval

	if v61 ~= p28.props.value then
		p28.props.valueChanged(v61)
	end
end
function v25.disconnectDragEvents(p30) -- line: 500
	if p30.moveConnection ~= nil then
		p30.moveConnection:Disconnect()
		p30.moveConnection = nil
	end

	if p30.releaseConnection ~= nil then
		p30.releaseConnection:Disconnect()
		p30.releaseConnection = nil
	end

	if p30.focusLostConnection ~= nil then
		p30.focusLostConnection:Disconnect()
		p30.focusLostConnection = nil
	end

	if p30.inputCapturerButton ~= nil then
		p30.inputCapturerButton:Destroy()
		p30.inputCapturerButton = nil
	end
end
function v25.stopListeningForDrag(p31) -- line: 522
	if not p31.state.dragging then
		return
	end

	p31:disconnectDragEvents()
	p31:setState({
		dragging = false
	})
end
function v25.processGamepadInput(p32, p33, p34) -- line: 534
	local v67 = p32.props.stepInterval * p33
	local v68 = math.max(math.min(p32.props.value + v67 * p34, p32.props.max), p32.props.min)

	if v68 ~= p32.props.value then
		p32.props.valueChanged(v68)
	end
end
function v25.onMoveStep(p35, p36, p37) -- line: 545
	local Position = p37[Enum.KeyCode.Thumbstick1].Position
	local v73 = Position.Magnitude > 0.2
	local n2 = 0

	p35.totalMoveTime = p35.totalMoveTime + p36

	local v75, n3, n4

	if v73 then
		v75 = not (Position.x > 0) and -1 or 1
		n3 = 0.2
		n4 = 12
	else
		v75 = (p37[Enum.KeyCode.DPadLeft].UserInputState ~= Enum.UserInputState.Begin and 0 or -1) + (p37[Enum.KeyCode.DPadRight].UserInputState ~= Enum.UserInputState.Begin and 0 or 1)
		n3 = 0.5
		n4 = 8
	end

	if v75 ~= 0 then
		if p35.isFirstMove then
			p35.isFirstMove = false
			p35.totalMoveTime = 0
			p35.unhandledTime = 0
			n2 = 1
		elseif n3 < p35.totalMoveTime then
			local v78 = p36 - math.max(n3 - p35.totalMoveTime - p36, 0) + p35.unhandledTime

			n2 = math.floor(n4 * v78)
			p35.unhandledTime = v78 - n2 / n4
		else
			n2 = 0
			p35.unhandledTime = 0
		end
	else
		p35.totalMoveTime = 0
		p35.isFirstMove = true
	end

	if n2 > 0 then
		p35:processGamepadInput(v75, n2)
	end
end
function v25.getDerivedStateFromProps(p38) -- line: 595
	if not p38.isMenuOpen then
		return {
			entryMode = false
		}
	end

	return nil
end

return v25
