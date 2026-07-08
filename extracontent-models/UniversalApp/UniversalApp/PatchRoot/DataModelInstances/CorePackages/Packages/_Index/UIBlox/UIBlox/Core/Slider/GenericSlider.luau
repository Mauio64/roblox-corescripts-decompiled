local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local Cryo = require(ParentParentParentParent.Cryo)
local t = require(ParentParentParentParent.t)
local RoactGamepad = require(ParentParentParentParent.RoactGamepad)
local ImageSetComponent = require(ParentParent.ImageSet.ImageSetComponent)
local useCursorByType = require(ParentParentParent.App.SelectionCursor.useCursorByType)
local CursorType = require(ParentParentParent.App.SelectionCursor.CursorType)
local lerp = require(ParentParentParent.Utility.lerp)
local withSelectionCursorProvider = require(ParentParentParent.App.SelectionImage.withSelectionCursorProvider)
local v14 = Roact.PureComponent:extend("GenericSlider")

v14.validateProps = t.strictInterface({
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
v14.defaultProps = {
	knobImagePadding = 0,
	width = UDim.new(1, 0),
	customKnobBorderColor = Color3.new(0, 0, 0)
}

function v14.init(p1) -- line: 103
	-- upvalues: Roact (copy)
	p1.rootRef = p1.props.imageButtonRef or Roact.createRef()
	p1.lowerKnobRef = Roact.createRef()
	p1.upperKnobRef = Roact.createRef()
	p1.moveDirection = 0
	p1.lowerKnobDrag = false
	p1.upperKnobDrag = false
	p1.totalMoveTime = 0
	p1.isFirstMove = true
	p1.unhandledTime = 0
	p1.state = {
		lowerKnobIsSelected = false,
		upperKnobIsSelected = false
	}
end
function v14.getKnobVisibleHeight(p2) -- line: 121
	if p2.props.customKnobHeight then
		return (44 - p2.props.knobImagePadding * 2) / 44 * p2.props.customKnobHeight
	end

	return 44 - p2.props.knobImagePadding * 2
end
function v14.getKnobHeight(p3) -- line: 130
	if p3.props.customKnobHeight then
		return 44 / (44 - p3.props.knobImagePadding * 2) * p3.props.customKnobHeight
	end

	return 44
end
function v14.onMoveStep(p4, p5, p6) -- line: 140
	if not p4.state.lowerKnobIsSelected and not p4.state.upperKnobIsSelected then
		return
	end

	local Position = p5[Enum.KeyCode.Thumbstick1].Position
	local v22 = Position.Magnitude > 0.2
	local n1 = 0

	p4.totalMoveTime = p4.totalMoveTime + p6

	local v24, n2, n3

	if v22 then
		v24 = not (Position.x > 0) and -1 or 1
		n2 = 0.2
		n3 = 12
	else
		v24 = (p5[Enum.KeyCode.DPadLeft].UserInputState ~= Enum.UserInputState.Begin and 0 or -1) + (p5[Enum.KeyCode.DPadRight].UserInputState ~= Enum.UserInputState.Begin and 0 or 1)
		n2 = 0.5
		n3 = 8
	end

	if v24 ~= 0 then
		if p4.isFirstMove then
			p4.isFirstMove = false
			p4.totalMoveTime = 0
			p4.unhandledTime = 0
			n1 = 1
		elseif n2 < p4.totalMoveTime then
			local v27 = p6 - math.max(n2 - p4.totalMoveTime - p6, 0) + p4.unhandledTime

			n1 = math.floor(n3 * v27)
			p4.unhandledTime = v27 - n1 / n3
		else
			n1 = 0
			p4.unhandledTime = 0
		end
	else
		p4.totalMoveTime = 0
		p4.isFirstMove = true
	end

	if n1 > 0 then
		p4:processGamepadInput(v24, n1)
	end
end
function v14.processGamepadInput(p7, p8, p9) -- line: 194
	if p7:hasTwoKnobs() then
		p7:processTwoKnobGamepadInput(p8, p9)

		return
	end

	p7:processOneKnobGamepadInput(p8, p9)
end
function v14.processTwoKnobGamepadInput(p10, p11, p12) -- line: 202
	local v34 = p10.props.stepInterval * p11
	local lowerValue = p10.props.lowerValue
	local upperValue = p10.props.upperValue

	if lowerValue == upperValue and not p10.state.processingGamepad then
		if p10.state.lowerKnobIsSelected and p11 == 1 and lowerValue ~= p10.props.max then
			p10:setState({
				lowerKnobIsSelected = false,
				upperKnobIsSelected = true,
				processingGamepad = true
			})
			p10.props.focusController.moveFocusTo(p10.upperKnobRef)
		elseif p10.state.upperKnobIsSelected and p11 == -1 and upperValue ~= p10.props.min then
			p10:setState({
				lowerKnobIsSelected = true,
				upperKnobIsSelected = false,
				processingGamepad = true
			})
			p10.props.focusController.moveFocusTo(p10.lowerKnobRef)
		end
	elseif not p10.state.processingGamepad then
		p10:setState({
			processingGamepad = true
		})
	end

	if p10.state.lowerKnobIsSelected then
		local v37 = math.max(math.min(lowerValue + v34 * p12, p10.props.max), p10.props.min)

		lowerValue = if not (v37 <= upperValue) then upperValue else v37
	elseif p10.state.upperKnobIsSelected then
		local v38 = math.max(math.min(upperValue + v34 * p12, p10.props.max), p10.props.min)

		upperValue = if not (lowerValue <= v38) then lowerValue else v38
	end

	if upperValue ~= p10.props.upperValue or lowerValue ~= p10.props.lowerValue then
		p10.props.onValueChanged(lowerValue, upperValue)
	end
end
function v14.processOneKnobGamepadInput(p13, p14, p15) -- line: 256
	local v42 = p13.props.stepInterval * p14
	local lowerValue = p13.props.lowerValue

	if p13.state.lowerKnobIsSelected then
		lowerValue = math.max(math.min(lowerValue + v42 * p15, p13.props.max), p13.props.min)
	end

	if lowerValue ~= p13.props.lowerValue then
		p13.props.onValueChanged(lowerValue)
	end
end
function v14.renderTrack(p16, p17, p18, p19) -- line: 269
	-- upvalues: Roact (copy), ImageSetComponent (copy)
	if p16.props.customTrack then
		return p16.props.customTrack
	end

	return Roact.createElement(ImageSetComponent.Label, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ImageColor3 = p16.props.trackColor,
		ImageTransparency = p16.props.trackTransparency,
		Image = p16.props.trackImage,
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.fromScale(0.5, 0.5),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = p16.props.trackSliceCenter
	}, {
		TrackFill = Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			ImageColor3 = p16.props.trackFillColor,
			ImageTransparency = p16.props.trackFillTransparency,
			Image = p16.props.trackFillImage,
			Size = p17,
			Position = p18 and UDim2.new(p19, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = p16.props.trackFillSliceCenter
		})
	})
end
function v14.wrapKnobWithBorder(p20, p21, p22) -- line: 298
	-- upvalues: Roact (copy)
	local v51 = if not p20.props.customKnobHeight then p20:getKnobVisibleHeight() else p20.props.customKnobHeight

	return Roact.createElement("Frame", {
		ZIndex = 3,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(v51, v51),
		Position = p22,
		BackgroundColor3 = p20.props.customKnobBorderColor
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		KnobContent = p21
	})
end
function v14.renderUpperKnob(p23, p24, p25, p26, _) -- line: 315
	-- upvalues: Roact (copy), RoactGamepad (copy), ImageSetComponent (copy)
	if not p26 then
		return nil
	end

	local v57 = p23:getKnobHeight()
	local v58 = p24

	if p23.props.customKnobBorderSize and p23.props.customKnobBorderSize > 0 then
		v57 -= 2 * (p23.props.customKnobBorderSize + 2)
		v58 = UDim2.fromScale(0.5, 0.5)
	end

	local v59 = Roact.createElement(RoactGamepad.Focusable[ImageSetComponent.Button], {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ImageColor3 = p23.props.knobColorUpper,
		ImageTransparency = p23.props.knobTransparency,
		Image = p23.props.knobImage,
		Size = UDim2.fromOffset(v57, v57),
		Position = v58,
		ZIndex = 3,
		NextSelectionLeft = not p25 and (p23.props.upperValue ~= p23.props.lowerValue and p23.lowerKnobRef) or nil,
		NextSelectionRight = p25 and p23.upperKnobRef or nil,
		NextSelectionUp = p25 and p23.upperKnobRef or nil,
		NextSelectionDown = p25 and p23.upperKnobRef or nil,
		SelectionImageObject = p25 and p23.props.selectedCursor or p23.props.unselectedCursor,
		[Roact.Ref] = p23.upperKnobRef,
		[Roact.Event.InputBegan] = function(_, p29) -- line: 345
			-- upvalues: p23 (copy)
			if p23.props.isDisabled then
				return
			end

			p23:onInputBegan(p29, true)
		end,
		inputBindings = {
			OnMoveStep = RoactGamepad.Input.onMoveStep(function(p30, p31) -- line: 353
				-- upvalues: p23 (copy)
				p23:onMoveStep(p30, p31)
			end),
			SelectUpperKnob = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 356
				-- upvalues: p23 (copy)
				p23:setState(function(p32) -- line: 357
					return {
						processingGamepad = false,
						upperKnobIsSelected = not p32.upperKnobIsSelected
					}
				end)
			end),
			UnselectUpperKnob = p25 and RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 364
				-- upvalues: p23 (copy)
				p23:setState({
					upperKnobIsSelected = false,
					processingGamepad = false
				})
			end) or nil
		}
	})

	if p23.props.customKnobBorderSize and p23.props.customKnobBorderSize > 0 then
		return p23:wrapKnobWithBorder(v59, p24)
	end

	return v59
end
function v14.renderLowerKnob(p33, p34, p35, p36, _) -- line: 380
	-- upvalues: Roact (copy), RoactGamepad (copy), ImageSetComponent (copy)
	local v65 = p33:getKnobHeight()
	local v66 = p34

	if p33.props.customKnobBorderSize and p33.props.customKnobBorderSize > 0 then
		v65 -= 2 * (p33.props.customKnobBorderSize + 2)
		v66 = UDim2.fromScale(0.5, 0.5)
	end

	local v67 = Roact.createElement(RoactGamepad.Focusable[ImageSetComponent.Button], {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ImageColor3 = p33.props.knobColorLower,
		ImageTransparency = p33.props.knobTransparency,
		Image = p33.props.knobImage,
		Size = UDim2.fromOffset(v65, v65),
		Position = v66,
		ZIndex = 3,
		inputBindings = {
			OnMoveStep = RoactGamepad.Input.onMoveStep(function(p38, p39) -- line: 398
				-- upvalues: p33 (copy)
				p33:onMoveStep(p38, p39)
			end),
			SelectLowerKnob = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 401
				-- upvalues: p33 (copy)
				p33:setState(function(p40) -- line: 402
					return {
						processingGamepad = false,
						lowerKnobIsSelected = not p40.lowerKnobIsSelected
					}
				end)
			end),
			UnselectLowerKnob = p35 and RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 409
				-- upvalues: p33 (copy)
				p33:setState({
					lowerKnobIsSelected = false,
					processingGamepad = false
				})
			end) or nil
		},
		NextSelectionLeft = p35 and p33.lowerKnobRef or nil,
		NextSelectionRight = p36 and (not p35 and (p33.props.upperValue ~= p33.props.lowerValue and p33.upperKnobRef)) or nil,
		NextSelectionUp = p35 and p33.lowerKnobRef or nil,
		NextSelectionDown = p35 and p33.lowerKnobRef or nil,
		SelectionImageObject = p35 and p33.props.selectedCursor or p33.props.unselectedCursor,
		[Roact.Ref] = p33.lowerKnobRef,
		[Roact.Event.InputBegan] = function(_, p42) -- line: 424
			-- upvalues: p33 (copy)
			if p33.props.isDisabled then
				return
			end

			p33:onInputBegan(p42, true)
		end
	})

	if p33.props.customKnobBorderSize and p33.props.customKnobBorderSize > 0 then
		return p33:wrapKnobWithBorder(v67, p34)
	end

	return v67
end
function v14.renderKnobShadow(p43, p44, p45) -- line: 440
	-- upvalues: Roact (copy), ImageSetComponent (copy)
	return Roact.createElement(ImageSetComponent.Label, {
		BackgroundTransparency = 1,
		ZIndex = 2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ImageTransparency = p44,
		Image = p43.props.knobShadowImage,
		Size = UDim2.fromOffset(p43:getKnobHeight(), p43:getKnobHeight()),
		Position = p45
	})
end
function v14.render(p46) -- line: 452
	-- upvalues: lerp (copy), withSelectionCursorProvider (copy), Roact (copy), RoactGamepad (copy), ImageSetComponent (copy)
	local v72 = p46.state.lowerKnobIsSelected or p46.state.upperKnobIsSelected
	local v73 = p46:hasTwoKnobs()
	local v74 = (p46.props.lowerValue - p46.props.min) / (p46.props.max - p46.props.min)
	local v75 = v73 and (p46.props.upperValue - p46.props.min) / (p46.props.max - p46.props.min) or nil
	local v76 = p46:getKnobVisibleHeight()
	local v77 = lerp(v76 / 2, -v76 / 2, v74)
	local v78 = v73 and lerp(v76 / 2, -v76 / 2, v75) or nil
	local uDim2 = UDim2.new(v74, v77, 0.5, 0)
	local v80 = v73 and UDim2.new(v75, v78, 0.5, 0) or nil
	local v81 = v73 and UDim2.fromScale(v75 - v74, 1) or UDim2.fromScale(v74, 1)
	local v82 = p46.state.lowerKnobIsSelected or p46.state.upperKnobIsSelected

	return withSelectionCursorProvider(function(p47) -- line: 467
		-- upvalues: Roact (copy), RoactGamepad (copy), ImageSetComponent (copy), p46 (copy), v82 (copy), v81 (copy), v73 (copy), v74 (copy), uDim2 (copy), v72 (copy), v80 (copy)
		return Roact.createElement(RoactGamepad.Focusable[ImageSetComponent.Button], {
			BackgroundTransparency = 1,
			AnchorPoint = p46.props.anchorPoint,
			Size = UDim2.new(p46.props.width.Scale, p46.props.width.Offset, 0, 36),
			LayoutOrder = p46.props.layoutOrder,
			Position = p46.props.position,
			[Roact.Event.InputBegan] = function(_, p49) -- line: 474
				-- upvalues: p46 (copy)
				if p46.props.isDisabled then
					return
				end

				p46:onInputBegan(p49, false)
			end,
			[Roact.Ref] = p46.rootRef,
			NextSelectionLeft = v82 and p46.rootRef or nil,
			NextSelectionRight = v82 and p46.rootRef or nil,
			NextSelectionUp = not v82 and p46.props.NextSelectionUp or p46.rootRef,
			NextSelectionDown = not v82 and p46.props.NextSelectionDown or p46.rootRef,
			defaultChild = p46.props.upperValue ~= p46.props.min and p46.lowerKnobRef or (p46.upperKnobRef or nil),
			onFocusLost = function() -- line: 491
				-- upvalues: p46 (copy)
				if p46.state.lowerKnobIsSelected or p46.state.upperKnobIsSelected then
					p46:setState({
						lowerKnobIsSelected = false,
						upperKnobIsSelected = false
					})
				end
			end
		}, {
			Track = p46:renderTrack(v81, v73, v74),
			LowerKnob = p46:renderLowerKnob(uDim2, v72, v73, p47),
			LowerKnobShadow = p46:renderKnobShadow(p46.props.knobShadowTransparencyLower, uDim2),
			UpperKnob = p46:renderUpperKnob(v80, v72, v73, p47),
			UpperKnobShadow = v73 and p46:renderKnobShadow(p46.props.knobShadowTransparencyUpper, v80) or nil
		})
	end)
end
function v14.didMount(p50) -- line: 511
	local current = p50.rootRef.current
	local connection = nil

	local function checkAncestry() -- line: 519
		-- upvalues: current (copy), connection (ref), p50 (copy)
		if not current:IsDescendantOf(game) then
			return
		end

		connection:Disconnect()
		p50.canUseUserInputService = current:FindFirstAncestorWhichIsA("PluginGui") == nil
	end

	connection = current.AncestryChanged:Connect(checkAncestry)

	if current:IsDescendantOf(game) then
		connection:Disconnect()
		p50.canUseUserInputService = current:FindFirstAncestorWhichIsA("PluginGui") == nil
	end
end
function v14.didUpdate(p51, _, p53) -- line: 537
	if p51.props.disabled then
		p51:stopListeningForDrag()
	end

	local v90 = p53.lowerKnobIsSelected and not p51.state.lowerKnobIsSelected
	local v91 = p53.upperKnobIsSelected and not p51.state.upperKnobIsSelected

	if p51.props.onDragEnd ~= nil and (v90 or v91) then
		p51.props.onDragEnd()

		return
	end

	if p51.props.onDragStartLower ~= nil and not p53.lowerKnobIsSelected and p51.state.lowerKnobIsSelected then
		p51.props.onDragStartLower()

		return
	end

	if p51.props.onDragStartUpper ~= nil and not p53.upperKnobIsSelected and p51.state.upperKnobIsSelected then
		p51.props.onDragStartUpper()
	end
end
function v14.willUnmount(p54) -- line: 560
	p54:stopListeningForDrag()
end
function v14.onInputBegan(p55, p56, p57) -- line: 564
	if p55.props.disabled then
		return
	end

	if p56.UserInputState ~= Enum.UserInputState.Begin then
		return
	end

	local UserInputType = p56.UserInputType

	if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	if UserInputType == Enum.UserInputType.Touch and not p57 then
		return
	end

	p55:processDrag(p56.Position.X)
	p55:startListeningForDrag()
end
function v14.startListeningForDrag(p58) -- line: 588
	-- upvalues: UserInputService (copy)
	local current = p58.rootRef.current

	if current == nil then
		return
	end

	if p58.dragging then
		return
	end

	if p58.canUseUserInputService then
		local function v99(p59) -- line: 603
			-- upvalues: p58 (copy)
			if not p58.dragging then
				return
			end

			local UserInputType = p59.UserInputType

			if UserInputType ~= Enum.UserInputType.MouseMovement and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if p59.UserInputState ~= Enum.UserInputState.Change then
				return
			end

			p58:processDrag(p59.Position.X)
		end

		if p58.props.containerRef then
			p58.moveConnection = p58.props.containerRef.current.InputChanged:Connect(v99)
		else
			p58.moveConnection = UserInputService.InputChanged:Connect(v99)
		end

		p58.releaseConnection = UserInputService.InputEnded:Connect(function(input) -- line: 632
			-- upvalues: p58 (copy)
			local UserInputType = input.UserInputType

			if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			p58:stopListeningForDrag()

			if not p58.props.containerRef then
				p58:processOneKnobDrag(input.Position.X)
			end
		end)
		p58.focusLostConnection = UserInputService.WindowFocusReleased:Connect(function() -- line: 655
			-- upvalues: p58 (copy)
			p58:stopListeningForDrag()
		end)
	else
		local PluginGui = current:FindFirstAncestorWhichIsA("PluginGui")
		local ImageButton = Instance.new("ImageButton")

		ImageButton.BackgroundTransparency = 1
		ImageButton.Image = ""
		ImageButton.Name = "SliderPluginGuiInputCapturer"
		ImageButton.Size = UDim2.new(1, 0, 1, 0)
		ImageButton.ZIndex = 100000
		p58.moveConnection = ImageButton.MouseMoved:Connect(function(p60) -- line: 675
			-- upvalues: p58 (copy)
			p58:processDrag(p60)
		end)
		p58.releaseConnection = ImageButton.MouseButton1Up:Connect(function(p61) -- line: 679
			-- upvalues: p58 (copy)
			p58:stopListeningForDrag()
			p58:processOneKnobDrag(p61)
		end)
		p58.focusLostConnection = ImageButton.MouseLeave:Connect(function(x) -- line: 684
			-- upvalues: p58 (copy)
			p58:stopListeningForDrag()
			p58:processOneKnobDrag(x)
		end)
		ImageButton.Parent = PluginGui
		p58.inputCapturerButton = ImageButton
	end

	p58.dragging = true

	if p58.lowerKnobDrag and p58.props.onDragStartLower ~= nil then
		p58.props.onDragStartLower()
	end

	if p58.upperKnobDrag and p58.props.onDragStartUpper ~= nil then
		p58.props.onDragStartUpper()
	end
end
function v14.getSteppedValue(p62, p63) -- line: 704
	local current = p62.rootRef.current

	if current == nil then
		return 0
	end

	local min = p62.props.min
	local max = p62.props.max
	local stepInterval = p62.props.stepInterval
	local AbsoluteSizeX = current.AbsoluteSize.X

	return math.floor((math.clamp(p63 - current.AbsolutePosition.X, 0, AbsoluteSizeX) / AbsoluteSizeX * (max - min) + min) / stepInterval + 0.5) * stepInterval
end
function v14.processDrag(p64, p65) -- line: 722
	if p64:hasTwoKnobs() then
		p64:processTwoKnobDrag(p65)

		return
	end

	p64:processOneKnobDrag(p65)
end
function v14.processOneKnobDrag(p66, p67) -- line: 730
	if p66:hasTwoKnobs() then
		return
	end

	local v113 = p66:getSteppedValue(p67)

	p66.lowerKnobDrag = true

	if v113 ~= p66.props.lowerValue then
		p66.props.onValueChanged(v113)
	end
end
function v14.processTwoKnobDrag(p68, p69) -- line: 743
	local v116 = p68:getSteppedValue(p69)
	local lowerValue = p68.props.lowerValue
	local upperValue = p68.props.upperValue

	if not p68.lowerKnobDrag and not p68.upperKnobDrag then
		if v116 == lowerValue then
			p68.lowerKnobDrag = true
		end

		if v116 == upperValue then
			p68.upperKnobDrag = true
		end
	elseif p68.lowerKnobDrag and p68.upperKnobDrag then
		if upperValue <= v116 - p68.props.stepInterval then
			p68.upperKnobDrag = true
			p68.lowerKnobDrag = false
			upperValue = v116
		elseif lowerValue >= v116 + p68.props.stepInterval then
			p68.upperKnobDrag = false
			p68.lowerKnobDrag = true
			lowerValue = v116
		end
	elseif p68.lowerKnobDrag then
		if v116 <= upperValue then
			lowerValue = v116
		end
	elseif p68.upperKnobDrag and lowerValue <= v116 then
		upperValue = v116
	end

	if upperValue ~= p68.props.upperValue or lowerValue ~= p68.props.lowerValue then
		p68.props.onValueChanged(lowerValue, upperValue)
	end
end
function v14.stopListeningForDrag(p70) -- line: 784
	if p70.moveConnection ~= nil then
		p70.moveConnection:Disconnect()
		p70.moveConnection = nil
	end

	if p70.releaseConnection ~= nil then
		p70.releaseConnection:Disconnect()
		p70.releaseConnection = nil
	end

	if p70.focusLostConnection ~= nil then
		p70.focusLostConnection:Disconnect()
		p70.focusLostConnection = nil
	end

	if p70.inputCapturerButton ~= nil then
		p70.inputCapturerButton:Destroy()
		p70.inputCapturerButton = nil
	end

	p70.dragging = false
	p70.lowerKnobDrag = false
	p70.upperKnobDrag = false

	if p70.props.onDragEnd ~= nil then
		p70.props.onDragEnd()
	end
end
function v14.hasTwoKnobs(p71) -- line: 814
	return p71.props.upperValue ~= nil
end

return Roact.forwardRef(function(p72, p73) -- line: 818
	-- upvalues: useCursorByType (copy), CursorType (copy), Cryo (copy), Roact (copy), v14 (copy)
	local v123 = useCursorByType(CursorType.SelectedKnob)
	local v124 = useCursorByType(CursorType.UnselectedKnob)
	local v125 = Cryo.Dictionary.join(p72, {
		selectedCursor = v123,
		unselectedCursor = v124
	})

	return Roact.createElement(v14, Cryo.Dictionary.join(v125, {
		imageButtonRef = p73
	}))
end)
