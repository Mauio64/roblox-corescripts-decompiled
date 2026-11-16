local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local Cryo = require(parent3.Cryo)
local t = require(parent3.t)
local RoactGamepad = require(parent3.RoactGamepad)
local ImageSetComponent = require(parent.ImageSet.ImageSetComponent)

local useCursorByType = require(parent2.App.SelectionCursor.useCursorByType)
local CursorType = require(parent2.App.SelectionCursor.CursorType)
local lerp = require(parent2.Utility.lerp)
local withSelectionCursorProvider = require(parent2.App.SelectionImage.withSelectionCursorProvider)

local extended = Roact.PureComponent:extend("GenericSlider")

extended.validateProps = t.strictInterface({
	lowerValue = t.number,
	upperValue = t.optional(t.number),
	min = t.number,
	max = t.number,
	stepInterval = t.numberPositive,
	isDisabled = t.optional(t.boolean),
	onValueChanged = t.callback,
	onDragStartLower = t.optional(t.callback),
	onDragStartUpper = t.optional(t.callback),
	onDragEnd = t.optional(t.callback),
	trackImage = t.union(t.string, t.table),
	trackColor = t.union(t.Color3, t.table),
	trackTransparency = t.union(t.number, t.table),
	trackSliceCenter = t.optional(t.Rect),
	trackFillImage = t.union(t.string, t.table),
	trackFillColor = t.union(t.Color3, t.table),
	trackFillTransparency = t.union(t.number, t.table),
	trackFillSliceCenter = t.optional(t.Rect),
	knobImage = t.union(t.string, t.table),
	knobColorLower = t.union(t.Color3, t.table),
	knobColorUpper = t.optional(t.union(t.Color3, t.table)),
	knobTransparency = t.union(t.number, t.table),
	knobImagePadding = t.optional(t.numberMin(0)),
	knobShadowImage = t.union(t.string, t.table),
	knobShadowTransparencyLower = t.union(t.number, t.table),
	knobShadowTransparencyUpper = t.optional(t.union(t.number, t.table)),
	width = t.optional(t.UDim),
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	layoutOrder = t.optional(t.integer),
	imageButtonRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	focusController = t.optional(t.table),
	containerRef = t.optional(t.table),
	customTrack = t.optional(t.table),
	customKnobHeight = t.optional(t.number),
	customKnobBorderColor = t.optional(t.Color3),
	customKnobBorderSize = t.optional(t.number),
	selectedCursor = t.table,
	unselectedCursor = t.table
})

extended.defaultProps = {
	width = UDim.new(1, 0),
	knobImagePadding = 0,
	customKnobBorderColor = Color3.new(0, 0, 0)
}

function extended:init()
	self.rootRef = self.props.imageButtonRef or Roact.createRef()
	self.lowerKnobRef = Roact.createRef()
	self.upperKnobRef = Roact.createRef()
	self.moveDirection = 0

	self.lowerKnobDrag = false
	self.upperKnobDrag = false
	self.totalMoveTime = 0
	self.isFirstMove = true
	self.unhandledTime = 0

	self.state = { lowerKnobIsSelected = false, upperKnobIsSelected = false }
end

function extended:getKnobVisibleHeight()
	if self.props.customKnobHeight then
		return (44 - self.props.knobImagePadding * 2) / 44 * self.props.customKnobHeight
	end

	return 44 - self.props.knobImagePadding * 2
end

function extended:getKnobHeight()
	if self.props.customKnobHeight then
		return 44 / (44 - self.props.knobImagePadding * 2) * self.props.customKnobHeight
	end

	return 44
end

function extended:onMoveStep(p, p2)
	if not (self.state.lowerKnobIsSelected or self.state.upperKnobIsSelected) then
		return
	end

	local position = p[Enum.KeyCode.Thumbstick1].Position
	local v = position.Magnitude > 0.2
	local v2 = 0

	self.totalMoveTime += p2
	local v3, v4, v5

	if v then
		v3 = position.x > 0 and 1 or -1
		v4 = 0.2
		v5 = 12
	else
		v3 = (p[Enum.KeyCode.DPadLeft].UserInputState == Enum.UserInputState.Begin and -1 or 0) + (p[Enum.KeyCode.DPadRight].UserInputState == Enum.UserInputState.Begin and 1 or 0)
		v4 = 0.5
		v5 = 8
	end

	if v3 == 0 then
		self.totalMoveTime = 0
		self.isFirstMove = true
	elseif self.isFirstMove then
		self.isFirstMove = false
		self.totalMoveTime = 0
		self.unhandledTime = 0
		v2 = 1
	elseif v4 < self.totalMoveTime then
		local v6 = p2 - math.max(v4 - self.totalMoveTime - p2, 0) + self.unhandledTime
		v2 = math.floor(v5 * v6)

		self.unhandledTime = v6 - v2 / v5
	else
		self.unhandledTime = 0
		v2 = 0
	end

	if v2 > 0 then
		self:processGamepadInput(v3, v2)
	end
end

function extended:processGamepadInput(p, p2)
	if self:hasTwoKnobs() then
		self:processTwoKnobGamepadInput(p, p2)
	else
		self:processOneKnobGamepadInput(p, p2)
	end
end

function extended:processTwoKnobGamepadInput(p, p2)
	local v = self.props.stepInterval * p
	local v2 = self.props.lowerValue
	local v3 = self.props.upperValue

	if v2 == v3 and not self.state.processingGamepad then
		if self.state.lowerKnobIsSelected and p == 1 and v2 ~= self.props.max then
			self:setState({
				lowerKnobIsSelected = false,
				upperKnobIsSelected = true,
				processingGamepad = true
			})

			self.props.focusController.moveFocusTo(self.upperKnobRef)
		elseif self.state.upperKnobIsSelected and p == -1 and v3 ~= self.props.min then
			self:setState({
				lowerKnobIsSelected = true,
				upperKnobIsSelected = false,
				processingGamepad = true
			})

			self.props.focusController.moveFocusTo(self.lowerKnobRef)
		end
	elseif not self.state.processingGamepad then
		self:setState({ processingGamepad = true })
	end

	if self.state.lowerKnobIsSelected then
		v2 = math.max(math.min(v2 + v * p2, self.props.max), self.props.min)

		if not (v2 <= v3) then
			v2 = v3
		end
	elseif self.state.upperKnobIsSelected then
		v3 = math.max(math.min(v3 + v * p2, self.props.max), self.props.min)

		if not (v2 <= v3) then
			v3 = v2
		end
	end

	if v3 ~= self.props.upperValue or v2 ~= self.props.lowerValue then
		self.props.onValueChanged(v2, v3)
	end
end

function extended:processOneKnobGamepadInput(p, p2)
	local v = self.props.stepInterval * p
	local v2 = self.props.lowerValue

	if self.state.lowerKnobIsSelected then
		v2 = math.max(math.min(v2 + v * p2, self.props.max), self.props.min)
	end

	if v2 ~= self.props.lowerValue then
		self.props.onValueChanged(v2)
	end
end

function extended:renderTrack(size, p, p2)
	if self.props.customTrack then
		return self.props.customTrack
	end

	return Roact.createElement(ImageSetComponent.Label, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ImageColor3 = self.props.trackColor,
		ImageTransparency = self.props.trackTransparency,
		Image = self.props.trackImage,
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.fromScale(0.5, 0.5),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = self.props.trackSliceCenter
	}, {
		TrackFill = Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			ImageColor3 = self.props.trackFillColor,
			ImageTransparency = self.props.trackFillTransparency,
			Image = self.props.trackFillImage,
			Size = size,
			Position = p and UDim2.new(p2, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = self.props.trackFillSliceCenter
		})
	})
end

function extended:wrapKnobWithBorder(knobContent, position)
	local v

	if self.props.customKnobHeight then
		v = self.props.customKnobHeight
	else
		v = self:getKnobVisibleHeight()
	end

	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(v, v),
		Position = position,
		BackgroundColor3 = self.props.customKnobBorderColor,
		ZIndex = 3
	}, {
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		KnobContent = knobContent
	})
end

function extended:renderUpperKnob(p, p2, p3, _)
	if not p3 then
		return nil
	end

	local knobHeight = self:getKnobHeight()
	local position

	if self.props.customKnobBorderSize and self.props.customKnobBorderSize > 0 then
		knobHeight -= 2 * (self.props.customKnobBorderSize + 2)
		position = UDim2.fromScale(0.5, 0.5)
	else
		position = p
	end

	local createElement = Roact.createElement
	local v = RoactGamepad.Focusable[ImageSetComponent.Button]
	local v2 = {}
	v2.AnchorPoint = Vector2.new(0.5, 0.5)
	v2.BackgroundTransparency = 1
	v2.ImageColor3 = self.props.knobColorUpper
	v2.ImageTransparency = self.props.knobTransparency
	v2.Image = self.props.knobImage
	v2.Size = UDim2.fromOffset(knobHeight, knobHeight)
	v2.Position = position
	v2.ZIndex = 3
	local nextSelectionLeft

	if not (p2 or self.props.upperValue == self.props.lowerValue) then
		nextSelectionLeft = self.lowerKnobRef or nil
	end

	v2.NextSelectionLeft = nextSelectionLeft
	local nextSelectionRight

	if p2 then
		nextSelectionRight = self.upperKnobRef or nil
	end

	v2.NextSelectionRight = nextSelectionRight
	local nextSelectionUp

	if p2 then
		nextSelectionUp = self.upperKnobRef or nil
	end

	v2.NextSelectionUp = nextSelectionUp
	local nextSelectionDown

	if p2 then
		nextSelectionDown = self.upperKnobRef or nil
	end

	v2.NextSelectionDown = nextSelectionDown
	v2.SelectionImageObject = p2 and self.props.selectedCursor or self.props.unselectedCursor
	v2[Roact.Ref] = self.upperKnobRef
	v2[Roact.Event.InputBegan] = function(_, p4)
		if self.props.isDisabled then
			return
		end

		self:onInputBegan(p4, true)
	end
	local inputBindings = {
		OnMoveStep = RoactGamepad.Input.onMoveStep(function(p4, p5)
			self:onMoveStep(p4, p5)
		end),
		SelectUpperKnob = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function()
			self:setState(function(p4)
				return {
					upperKnobIsSelected = not p4.upperKnobIsSelected,
					processingGamepad = false
				}
			end)
		end),
		UnselectUpperKnob = 0
	}
	local unselectUpperKnob

	if p2 then
		unselectUpperKnob = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function()
			self:setState({ upperKnobIsSelected = false, processingGamepad = false })
		end) or nil
	end

	inputBindings.UnselectUpperKnob = unselectUpperKnob
	v2.inputBindings = inputBindings
	local element = createElement(v, v2)

	if self.props.customKnobBorderSize and self.props.customKnobBorderSize > 0 then
		return self:wrapKnobWithBorder(element, p)
	end

	return element
end

function extended:renderLowerKnob(p, p2, p3, _)
	local knobHeight = self:getKnobHeight()
	local position

	if self.props.customKnobBorderSize and self.props.customKnobBorderSize > 0 then
		knobHeight -= 2 * (self.props.customKnobBorderSize + 2)
		position = UDim2.fromScale(0.5, 0.5)
	else
		position = p
	end

	local createElement = Roact.createElement
	local v = RoactGamepad.Focusable[ImageSetComponent.Button]
	local v2 = {}
	v2.AnchorPoint = Vector2.new(0.5, 0.5)
	v2.BackgroundTransparency = 1
	v2.ImageColor3 = self.props.knobColorLower
	v2.ImageTransparency = self.props.knobTransparency
	v2.Image = self.props.knobImage
	v2.Size = UDim2.fromOffset(knobHeight, knobHeight)
	v2.Position = position
	v2.ZIndex = 3
	local inputBindings = {
		OnMoveStep = RoactGamepad.Input.onMoveStep(function(p4, p5)
			self:onMoveStep(p4, p5)
		end),
		SelectLowerKnob = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function()
			self:setState(function(p4)
				return {
					lowerKnobIsSelected = not p4.lowerKnobIsSelected,
					processingGamepad = false
				}
			end)
		end),
		UnselectLowerKnob = 0
	}
	local unselectLowerKnob

	if p2 then
		unselectLowerKnob = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function()
			self:setState({ lowerKnobIsSelected = false, processingGamepad = false })
		end) or nil
	end

	inputBindings.UnselectLowerKnob = unselectLowerKnob
	v2.inputBindings = inputBindings
	local nextSelectionLeft

	if p2 then
		nextSelectionLeft = self.lowerKnobRef or nil
	end

	v2.NextSelectionLeft = nextSelectionLeft
	local nextSelectionRight

	if p3 and not p2 and self.props.upperValue ~= self.props.lowerValue then
		nextSelectionRight = self.upperKnobRef or nil
	end

	v2.NextSelectionRight = nextSelectionRight
	local nextSelectionUp

	if p2 then
		nextSelectionUp = self.lowerKnobRef or nil
	end

	v2.NextSelectionUp = nextSelectionUp
	local nextSelectionDown

	if p2 then
		nextSelectionDown = self.lowerKnobRef or nil
	end

	v2.NextSelectionDown = nextSelectionDown
	v2.SelectionImageObject = p2 and self.props.selectedCursor or self.props.unselectedCursor
	v2[Roact.Ref] = self.lowerKnobRef
	v2[Roact.Event.InputBegan] = function(_, p4)
		if self.props.isDisabled then
			return
		end

		self:onInputBegan(p4, true)
	end

	local element = createElement(v, v2)

	if self.props.customKnobBorderSize and self.props.customKnobBorderSize > 0 then
		return self:wrapKnobWithBorder(element, p)
	end

	return element
end

function extended:renderKnobShadow(imageTransparency, position)
	return Roact.createElement(ImageSetComponent.Label, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ImageTransparency = imageTransparency,
		Image = self.props.knobShadowImage,
		Size = UDim2.fromOffset(self:getKnobHeight(), self:getKnobHeight()),
		Position = position,
		ZIndex = 2
	})
end

function extended:render()
	local lowerKnobIsSelected = self.state.lowerKnobIsSelected or self.state.upperKnobIsSelected
	local twoKnobs = self:hasTwoKnobs()
	local v = (self.props.lowerValue - self.props.min) / (self.props.max - self.props.min)
	local v2

	if twoKnobs then
		v2 = (self.props.upperValue - self.props.min) / (self.props.max - self.props.min) or nil
	end

	local knobVisibleHeight = self:getKnobVisibleHeight()
	local v3 = lerp(knobVisibleHeight / 2, -knobVisibleHeight / 2, v)
	local v4

	if twoKnobs then
		v4 = lerp(knobVisibleHeight / 2, -knobVisibleHeight / 2, v2) or nil
	end

	local udim = UDim2.new(v, v3, 0.5, 0)
	local udim2

	if twoKnobs then
		udim2 = UDim2.new(v2, v4, 0.5, 0) or nil
	else
		udim2 = nil
	end

	local udim3 = twoKnobs and UDim2.fromScale(v2 - v, 1) or UDim2.fromScale(v, 1)
	local lowerKnobIsSelected2 = self.state.lowerKnobIsSelected or self.state.upperKnobIsSelected

	return withSelectionCursorProvider(function(p)
		return Roact.createElement(RoactGamepad.Focusable[ImageSetComponent.Button], {
			BackgroundTransparency = 1,
			AnchorPoint = self.props.anchorPoint,
			Size = UDim2.new(self.props.width.Scale, self.props.width.Offset, 0, 36),
			LayoutOrder = self.props.layoutOrder,
			Position = self.props.position,
			[Roact.Event.InputBegan] = function(_, p2)
				if self.props.isDisabled then
					return
				end

				self:onInputBegan(p2, false)
			end,
			[Roact.Ref] = self.rootRef,
			NextSelectionLeft = lowerKnobIsSelected2 and self.rootRef or nil,
			NextSelectionRight = lowerKnobIsSelected2 and self.rootRef or nil,
			NextSelectionUp = not lowerKnobIsSelected2 and self.props.NextSelectionUp or self.rootRef,
			NextSelectionDown = not lowerKnobIsSelected2 and self.props.NextSelectionDown or self.rootRef,
			defaultChild = self.props.upperValue ~= self.props.min and self.lowerKnobRef or self.upperKnobRef or nil,
			onFocusLost = function()
				if self.state.lowerKnobIsSelected or self.state.upperKnobIsSelected then
					self:setState({ lowerKnobIsSelected = false, upperKnobIsSelected = false })
				end
			end
		}, {
			Track = self:renderTrack(udim3, twoKnobs, v),
			LowerKnob = self:renderLowerKnob(udim, lowerKnobIsSelected, twoKnobs, p),
			LowerKnobShadow = self:renderKnobShadow(self.props.knobShadowTransparencyLower, udim),
			UpperKnob = self:renderUpperKnob(udim2, lowerKnobIsSelected, twoKnobs, p),
			UpperKnobShadow = twoKnobs and self:renderKnobShadow(self.props.knobShadowTransparencyUpper, udim2) or nil
		})
	end)
end

function extended:didMount()
	local current = self.rootRef.current

	local ancestryChangedConnection = nil
	local function checkAncestry() -- 1 equivalent call inferred from this helper
		if not current:IsDescendantOf(game) then
			return
		end

		ancestryChangedConnection:Disconnect()

		self.canUseUserInputService = current:FindFirstAncestorWhichIsA("PluginGui") == nil
	end
	ancestryChangedConnection = current.AncestryChanged:Connect(checkAncestry)
	checkAncestry() -- inferred equivalent call
end

function extended:didUpdate(_, p)
	if self.props.disabled then
		self:stopListeningForDrag()
	end

	local v = p.lowerKnobIsSelected and not self.state.lowerKnobIsSelected
	local v2 = p.upperKnobIsSelected and not self.state.upperKnobIsSelected

	if self.props.onDragEnd ~= nil and (v or v2) then
		self.props.onDragEnd()
	elseif self.props.onDragStartLower ~= nil and not p.lowerKnobIsSelected and self.state.lowerKnobIsSelected then
		self.props.onDragStartLower()
	elseif self.props.onDragStartUpper ~= nil and not p.upperKnobIsSelected and self.state.upperKnobIsSelected then
		self.props.onDragStartUpper()
	end
end

function extended:willUnmount()
	self:stopListeningForDrag()
end

function extended:onInputBegan(data, p)
	if self.props.disabled or data.UserInputState ~= Enum.UserInputState.Begin then
		return
	end

	local userInputType = data.UserInputType

	if
		userInputType ~= Enum.UserInputType.MouseButton1 and userInputType ~= Enum.UserInputType.Touch
		or userInputType == Enum.UserInputType.Touch and not p
	then
		return
	end

	self:processDrag(data.Position.X)
	self:startListeningForDrag()
end

function extended:startListeningForDrag()
	local current = self.rootRef.current

	if current == nil or self.dragging then
		return
	end

	if self.canUseUserInputService then
		local function onInputChanged(data)
			if not self.dragging then
				return
			end

			local userInputType = data.UserInputType

			if
				userInputType ~= Enum.UserInputType.MouseMovement and userInputType ~= Enum.UserInputType.Touch
				or data.UserInputState ~= Enum.UserInputState.Change
			then
				return
			end

			self:processDrag(data.Position.X)
		end

		if self.props.containerRef then
			self.moveConnection = self.props.containerRef.current.InputChanged:Connect(onInputChanged)
		else
			self.moveConnection = UserInputService.InputChanged:Connect(onInputChanged)
		end

		self.releaseConnection = UserInputService.InputEnded:Connect(function(input)
			local userInputType = input.UserInputType

			if userInputType ~= Enum.UserInputType.MouseButton1 and userInputType ~= Enum.UserInputType.Touch then
				return
			end

			self:stopListeningForDrag()

			if not self.props.containerRef then
				self:processOneKnobDrag(input.Position.X)
			end
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
			self:processOneKnobDrag(p)
		end)

		self.focusLostConnection = sliderPluginGuiInputCapturer.MouseLeave:Connect(function(p)
			self:stopListeningForDrag()
			self:processOneKnobDrag(p)
		end)

		sliderPluginGuiInputCapturer.Parent = pluginGui
		self.inputCapturerButton = sliderPluginGuiInputCapturer
	end

	self.dragging = true

	if self.lowerKnobDrag and self.props.onDragStartLower ~= nil then
		self.props.onDragStartLower()
	end

	if self.upperKnobDrag and self.props.onDragStartUpper ~= nil then
		self.props.onDragStartUpper()
	end
end

function extended:getSteppedValue(p)
	local current = self.rootRef.current

	if current == nil then
		return 0
	end

	local min = self.props.min
	local max = self.props.max
	local stepInterval = self.props.stepInterval

	local x = current.AbsoluteSize.X
	return math.floor((math.clamp(p - current.AbsolutePosition.X, 0, x) / x * (max - min) + min) / stepInterval + 0.5) * stepInterval
end

function extended:processDrag(p)
	if self:hasTwoKnobs() then
		self:processTwoKnobDrag(p)
	else
		self:processOneKnobDrag(p)
	end
end

function extended:processOneKnobDrag(p)
	if self:hasTwoKnobs() then
		return
	end

	local steppedValue = self:getSteppedValue(p)
	self.lowerKnobDrag = true

	if steppedValue ~= self.props.lowerValue then
		self.props.onValueChanged(steppedValue)
	end
end

function extended:processTwoKnobDrag(p)
	local steppedValue = self:getSteppedValue(p)
	local v = self.props.lowerValue
	local v2 = self.props.upperValue

	if self.lowerKnobDrag or self.upperKnobDrag then
		if self.lowerKnobDrag and self.upperKnobDrag then
			if v2 <= steppedValue - self.props.stepInterval then
				self.upperKnobDrag = true
				self.lowerKnobDrag = false
				v2 = steppedValue
			elseif steppedValue + self.props.stepInterval <= v then
				self.upperKnobDrag = false
				self.lowerKnobDrag = true
				v = steppedValue
			end
		elseif self.lowerKnobDrag then
			if steppedValue <= v2 then
				v = steppedValue
			end
		elseif self.upperKnobDrag and v <= steppedValue then
			v2 = steppedValue
		end
	else
		if steppedValue == v then
			self.lowerKnobDrag = true
		end

		if steppedValue == v2 then
			self.upperKnobDrag = true
		end
	end

	if v2 ~= self.props.upperValue or v ~= self.props.lowerValue then
		self.props.onValueChanged(v, v2)
	end
end

function extended:stopListeningForDrag()
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

	self.dragging = false
	self.lowerKnobDrag = false
	self.upperKnobDrag = false

	if self.props.onDragEnd ~= nil then
		self.props.onDragEnd()
	end
end

function extended:hasTwoKnobs(): boolean
	return self.props.upperValue ~= nil
end

return Roact.forwardRef(function(p, imageButtonRef)
	local selectedCursor = useCursorByType(CursorType.SelectedKnob)
	local unselectedCursor = useCursorByType(CursorType.UnselectedKnob)
	local joined = Cryo.Dictionary.join(p, {
		selectedCursor = selectedCursor,
		unselectedCursor = unselectedCursor
	})

	return Roact.createElement(extended, Cryo.Dictionary.join(joined, {
		imageButtonRef = imageButtonRef
	}))
end)
