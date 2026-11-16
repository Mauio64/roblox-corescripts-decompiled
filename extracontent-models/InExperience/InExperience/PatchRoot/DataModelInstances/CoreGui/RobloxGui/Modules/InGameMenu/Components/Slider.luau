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

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent

local divideTransparency = require(parent.Utility.divideTransparency)

local AssetImage = require(script.Parent.AssetImage)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton

local v3 = { frequency = 5 }

local function isGamepad(lastInputType): boolean
	return lastInputType == Enum.UserInputType.Gamepad1
		or lastInputType == Enum.UserInputType.Gamepad2
		or lastInputType == Enum.UserInputType.Gamepad3
		or lastInputType == Enum.UserInputType.Gamepad4
		or lastInputType == Enum.UserInputType.Gamepad5
		or lastInputType == Enum.UserInputType.Gamepad6
		or lastInputType == Enum.UserInputType.Gamepad7
		or lastInputType == Enum.UserInputType.Gamepad8
end

local v4 = {}
local function getInputObjects()
	local lastInputType = UserInputService:GetLastInputType()

	if not isGamepad(lastInputType) then
		return nil
	end

	if v4[lastInputType] ~= nil then
		return v4[lastInputType]
	end

	local gamepadState = UserInputService:GetGamepadState(lastInputType)
	local v5 = {}

	for _, v6 in ipairs(gamepadState) do
		v5[v6.KeyCode] = v6
	end

	v4[lastInputType] = v5

	return v4[lastInputType]
end

local extended = Roact.PureComponent:extend("Slider")
extended.validateProps = t.intersection(t.strictInterface({
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
}), function(data)
	if data.min > data.max then
		return false, "min must be less than or equal to max"
	end

	if data.value > data.max or data.value < data.min then
		return false, "value must be within min and max"
	end

	return true
end)

extended.defaultProps = { width = UDim.new(1, 0), disabled = false }

function extended:init()
	self.state = { dragging = false, hovering = false, entryMode = false }

	self.totalMoveTime = 0
	self.isFirstMove = true
	self.unhandledTime = 0

	self.rootButtonRef = Roact.createRef()
	self.hoverRef = Roact.createRef()

	self.hoverMotor = Otter.createSingleMotor(0)
	self.hoverMotor:onStep(function(p)
		local current = self.hoverRef.current

		if current ~= nil then
			current.Size = UDim2.new(0, p, 0, p)
		end
	end)

	function self.onInputBegan(_, p)
		if self.props.disabled then
			return
		end

		local userInputType = p.UserInputType

		if userInputType ~= Enum.UserInputType.MouseButton1 and userInputType ~= Enum.UserInputType.Touch then
			return
		end

		self:processDrag(p.Position.X)
		self:startListeningForDrag()
	end
end

function extended:renderFocusHandler()
	return Roact.createElement(FocusHandler, {
		isFocused = self.state.entryMode and self.props.canCaptureFocus,
		didFocus = function()
			GuiService.CoreGuiNavigationEnabled = false

			self.joystickListener = RunService.Heartbeat:Connect(function(dt)
				self:onMoveStep(dt, getInputObjects())
			end)

			local value = self.props.value

			ContextActionService:BindCoreAction("LeaveEntryMode", function(_, p)
				if p ~= Enum.UserInputState.End then
					return Enum.ContextActionResult.Pass
				end

				self:setState({ entryMode = false })
				self.props.valueChanged(value)
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB)
		end,
		didBlur = function()
			self.joystickListener:Disconnect()
			GuiService.CoreGuiNavigationEnabled = true
			ContextActionService:UnbindCoreAction("LeaveEntryMode")
			self:setState({ entryMode = false })
		end
	}) or nil
end

function extended:renderWithSelectionCursor(callback)
	local min = self.props.min
	local v5 = self.props.max - min
	local v6 = (self.props.value - min) / v5
	local v7 = math.abs(v6)
	local v8 = v6 / 2

	local canCaptureFocus = self.state.entryMode and self.props.canCaptureFocus

	return withFoundationOrUIBloxStyle(function(p)
		return {
			Theme = {
				UIMuted = {
					Color = p.Color.Shift.Shift_100.Color3,
					Transparency = p.Color.Shift.Shift_100.Transparency
				},
				ContextualPrimaryDefault = {
					Color = p.Color.ActionEmphasis.Background.Color3,
					Transparency = p.Color.ActionEmphasis.Background.Transparency
				}
			}
		}
	end, function(p)
		return Roact.createElement(ImageSetButton, {
			AnchorPoint = self.props.AnchorPoint,
			BackgroundTransparency = 1,
			Image = "",
			LayoutOrder = self.props.LayoutOrder,
			Position = self.props.Position,
			Size = UDim2.new(self.props.width.Scale, self.props.width.Offset, 0, 36),
			[Roact.Ref] = self.rootButtonRef,
			[Roact.Event.InputBegan] = self.onInputBegan,
			Selectable = false
		}, {
			FocusHandler = self:renderFocusHandler(),
			Gutter = Roact.createElement(AssetImage.Label, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				imageKey = "SliderCircle",
				ImageColor3 = p.Theme.UIMuted.Color,
				ImageTransparency = p.Theme.UIMuted.Transparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 4)
			}, {
				FilledGutter = Roact.createElement(AssetImage.Label, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					imageKey = "SliderCircle",
					ImageColor3 = p.Theme.ContextualPrimaryDefault.Color,
					ImageTransparency = divideTransparency(
						p.Theme.ContextualPrimaryDefault.Transparency,
						self.props.disabled and 2 or 1
					),
					Position = UDim2.new(v8, 0, 0.5, 0),
					Size = UDim2.new(v7, 0, 1, 0)
				})
			}),
			DotTrack = Roact.createElement("Frame", {
				Size = UDim2.new(1, -12, 1, 0),
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ZIndex = 4,
				Selectable = false
			}, {
				Dot = Roact.createElement(AssetImage.Button, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					imageKey = "SliderButton",
					Position = UDim2.new(v6, 0, 0.5, 0),
					Size = UDim2.new(0, 42, 0, 42),
					ImageTransparency = self.props.disabled and 0.5 or 0,
					ZIndex = 2,
					SelectionImageObject = callback(canCaptureFocus and v2.SelectedKnob or v2.UnselectedKnob),
					[Roact.Event.Activated] = function(_, p2)
						if p2.KeyCode == Enum.KeyCode.ButtonA then
							self:setState({
								entryMode = not self.state.entryMode
							})
						end
					end,
					[Roact.Event.InputBegan] = function(p2, p3)
						if self.props.disabled then
							return
						end

						if p3.UserInputType == Enum.UserInputType.MouseMovement then
							self:setState({ hovering = true })
						else
							self.onInputBegan(p2, p3)
						end
					end,
					[Roact.Event.InputEnded] = function(_, p2)
						if self.props.disabled then
							return
						end

						if p2.UserInputType == Enum.UserInputType.MouseMovement then
							self:setState({ hovering = false })
						end
					end,
					[Roact.Ref] = self.props.sliderDotRef,
					[Roact.Event.SelectionLost] = self.props.onSelectionLost,
					[Roact.Event.SelectionGained] = self.props.onSelectionGained,
					NextSelectionRight = self.props.NextSelectionRight
				}),
				HoverOverlay = Roact.createElement(AssetImage.Label, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					imageKey = "SliderHover",
					Position = UDim2.new(v6, 0, 0.5, 0),
					Size = UDim2.new(0, 0, 0, 0),
					[Roact.Ref] = self.hoverRef
				})
			})
		})
	end)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

function extended:didMount()
	local current = self.rootButtonRef.current

	local ancestryChangedConnection = nil
	ancestryChangedConnection = current.AncestryChanged:Connect(function()
		if not current:IsDescendantOf(game) then
			return
		end

		ancestryChangedConnection:Disconnect()

		self.canUseUserInputService = current:FindFirstAncestorWhichIsA("PluginGui") == nil
	end)

	self.hoverMotor:start()
end

function extended:didUpdate()
	if self.props.disabled then
		self:stopListeningForDrag()
	end

	local v5 = (self.props.disabled or not (self.state.dragging or self.state.hovering)) and 0 or 42

	self.hoverMotor:setGoal(Otter.spring(v5, v3))
end

function extended:willUnmount()
	self.hoverMotor:stop()
	self:disconnectDragEvents()
end

function extended:startListeningForDrag()
	local current = self.rootButtonRef.current

	if current == nil or self.state.dragging then
		return
	end

	if self.canUseUserInputService then
		self.moveConnection = UserInputService.InputChanged:Connect(function(input)
			if not self.state.dragging then
				return
			end

			local userInputType = input.UserInputType

			if
				userInputType ~= Enum.UserInputType.MouseMovement and userInputType ~= Enum.UserInputType.Touch
				or input.UserInputState ~= Enum.UserInputState.Change
			then
				return
			end

			self:processDrag(input.Position.X)
		end)

		self.releaseConnection = UserInputService.InputEnded:Connect(function(input)
			local userInputType = input.UserInputType

			if userInputType ~= Enum.UserInputType.MouseButton1 and userInputType ~= Enum.UserInputType.Touch then
				return
			end

			self:stopListeningForDrag()
			self:processDrag(input.Position.X)
		end)

		self.focusLostConnection = UserInputService.WindowFocusReleased:Connect(function()
			self:stopListeningForDrag()
		end)
	else
		local pluginGui = current:FindFirstAncestorWhichIsA("PluginGui")

		local sliderPluginGuiInputCapturer = Instance.new("ImageButton")
		sliderPluginGuiInputCapturer.BackgroundTransparency = 1
		sliderPluginGuiInputCapturer.Image = ""
		sliderPluginGuiInputCapturer.Name = "SliderPluginGuiInputCapturer"
		sliderPluginGuiInputCapturer.Size = UDim2.new(1, 0, 1, 0)
		sliderPluginGuiInputCapturer.ZIndex = 100000
		self.moveConnection = sliderPluginGuiInputCapturer.MouseMoved:Connect(function(p)
			self:processDrag(p)
		end)

		self.releaseConnection = sliderPluginGuiInputCapturer.MouseButton1Up:Connect(function(p)
			self:stopListeningForDrag()
			self:processDrag(p)
		end)

		self.focusLostConnection = sliderPluginGuiInputCapturer.MouseLeave:Connect(function(p)
			self:stopListeningForDrag()
			self:processDrag(p)
		end)

		sliderPluginGuiInputCapturer.Parent = pluginGui
		self.inputCapturerButton = sliderPluginGuiInputCapturer
	end

	self:setState({ dragging = true })
end

function extended:processDrag(p)
	local current = self.rootButtonRef.current

	if current == nil then
		return
	end

	local min = self.props.min
	local max = self.props.max
	local stepInterval = self.props.stepInterval

	local x = current.AbsoluteSize.X
	local v5 = math.floor((math.clamp(p - current.AbsolutePosition.X, 0, x) / x * (max - min) + min) / stepInterval + 0.5) * stepInterval

	if v5 ~= self.props.value then
		self.props.valueChanged(v5)
	end
end

function extended:disconnectDragEvents()
	if self.moveConnection ~= nil then
		self.moveConnection:Disconnect()
		self.moveConnection = nil
	end

	if self.releaseConnection ~= nil then
		self.releaseConnection:Disconnect()
		self.releaseConnection = nil
	end

	if self.focusLostConnection ~= nil then
		self.focusLostConnection:Disconnect()
		self.focusLostConnection = nil
	end

	if self.inputCapturerButton ~= nil then
		self.inputCapturerButton:Destroy()
		self.inputCapturerButton = nil
	end
end

function extended:stopListeningForDrag()
	if not self.state.dragging then
		return
	end

	self:disconnectDragEvents()

	self:setState({ dragging = false })
end

function extended:processGamepadInput(p, p2)
	local v5 = self.props.stepInterval * p
	local v6 = math.max(math.min(self.props.value + v5 * p2, self.props.max), self.props.min)

	if v6 ~= self.props.value then
		self.props.valueChanged(v6)
	end
end

function extended:onMoveStep(p, p2)
	local position = p2[Enum.KeyCode.Thumbstick1].Position
	local v5 = position.Magnitude > 0.2
	local v6 = 0

	self.totalMoveTime += p
	local v7, v8, v9

	if v5 then
		v7 = position.x > 0 and 1 or -1
		v8 = 0.2
		v9 = 12
	else
		v7 = (p2[Enum.KeyCode.DPadLeft].UserInputState == Enum.UserInputState.Begin and -1 or 0) + (p2[Enum.KeyCode.DPadRight].UserInputState == Enum.UserInputState.Begin and 1 or 0)
		v8 = 0.5
		v9 = 8
	end

	if v7 == 0 then
		self.totalMoveTime = 0
		self.isFirstMove = true
	elseif self.isFirstMove then
		self.isFirstMove = false
		self.totalMoveTime = 0
		self.unhandledTime = 0
		v6 = 1
	elseif v8 < self.totalMoveTime then
		local v10 = p - math.max(v8 - self.totalMoveTime - p, 0) + self.unhandledTime
		v6 = math.floor(v9 * v10)

		self.unhandledTime = v10 - v6 / v9
	else
		self.unhandledTime = 0
		v6 = 0
	end

	if v6 > 0 then
		self:processGamepadInput(v7, v6)
	end
end

function extended.getDerivedStateFromProps(p)
	if p.isMenuOpen then
		return nil
	end

	return { entryMode = false }
end

return extended
