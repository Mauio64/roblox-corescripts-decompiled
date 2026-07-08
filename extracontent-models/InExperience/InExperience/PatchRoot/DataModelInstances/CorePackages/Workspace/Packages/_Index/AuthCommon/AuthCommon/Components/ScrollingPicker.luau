local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local Cryo = require(AuthCommonParent.Cryo)
local withStyle = require(AuthCommonParent.UIBlox).Style.withStyle
local ScrollingPickerDirection = require(AuthCommon.Enums.ScrollingPickerDirection)
local Otter = require(AuthCommonParent.Otter)
local FitChildren = require(AuthCommon.Components.FitChildren)
local t1 = {
	[ScrollingPickerDirection.Horizontal] = "X",
	[ScrollingPickerDirection.Vertical] = "Y"
}
local t2 = {
	[ScrollingPickerDirection.Horizontal] = "Y",
	[ScrollingPickerDirection.Vertical] = "X"
}
local v11 = game:DefineFastInt("ScrollingPickerSlowScrollStepWaitMs", 100)
local v12 = game:DefineFastInt("ScrollingPickerMaximumPickerChangePerInput", 1)
local v13 = game:DefineFastInt("ScrollingPickerSmallInputDecayFactor", 3)
local _ = {
	spring = "spring",
	instant = "instant"
}
local v15 = Roact.PureComponent:extend("ScrollingPicker")

v15.MOUSE_WHEEL_STEP_THRESHOLD = 0.1
v15.defaultProps = {
	layoutOrder = 0,
	parentSpecifiedTarget = 1,
	entrySizeOnScrollingAxis = 10,
	clipsDescendants = true,
	shouldExpandTapTarget = false,
	tapTargetExpansionSize = 0,
	minTargetIndex = 1,
	entries = {},
	scrollDirection = ScrollingPickerDirection.Vertical
}

local v16 = setmetatable({
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.Touch] = true
}, {
	__index = function(_, _) -- line: 82
		return false
	end
})

function v15.init(p3) -- line: 87
	-- upvalues: t1 (copy), t2 (copy), Roact (copy), Otter (copy), v16 (copy), v12 (copy), v15 (copy), v13 (copy), v11 (copy)
	local parentSpecifiedTarget = p3.props.parentSpecifiedTarget
	local scrollDirection = p3.props.scrollDirection
	local shouldExpandTapTarget = p3.props.shouldExpandTapTarget

	p3.state = {
		scrollDirection = scrollDirection,
		scrollingAxis = t1[scrollDirection],
		subAxis = t2[scrollDirection]
	}
	p3.isMounted = false
	p3.currentIndex = 1
	p3.targetEntryRef = Roact.createRef()
	p3.targetIndex = parentSpecifiedTarget
	p3.isEntrySelected = false
	p3.isTargetIndexSetByUserInput = false
	p3.timeInputBegan = tick()
	p3.recognizedInputBegan = false
	p3.inputChanged = false
	p3.inputPositionAtInputBegan = 0
	p3.inputPreviousPositionScrollingAxis = 0
	p3.scrollRef = Roact.createRef()
	p3.shouldExpandTapTarget = shouldExpandTapTarget
	p3.tapTargetExpansionSize = p3.props.tapTargetExpansionSize
	p3.scrollDeltaAccumulator = 0

	function p3.getCenterIndexByPosition(p4) -- line: 136
		-- upvalues: p3 (copy)
		local entrySizeOnScrollingAxis = p3.props.entrySizeOnScrollingAxis

		return math.floor(-p4 / entrySizeOnScrollingAxis) + 1
	end
	function p3.getCenterIndexByScrollPosition(p5) -- line: 142
		-- upvalues: p3 (copy)
		local v33 = p5 - p3.props.entrySizeOnScrollingAxis / 2

		return p3.getCenterIndexByPosition(v33)
	end
	function p3.updateParent() -- line: 153
		-- upvalues: p3 (copy)
		local onCurrentIndexChanged = p3.props.onCurrentIndexChanged
		local onSelectedIndexChanged = p3.props.onSelectedIndexChanged

		if onCurrentIndexChanged then
			onCurrentIndexChanged(p3.currentIndex)
		end

		if onSelectedIndexChanged and p3.currentIndex == p3.targetIndex then
			onSelectedIndexChanged(p3.currentIndex, p3.isTargetIndexSetByUserInput)
		end
	end
	function p3.onScrollPositionChanged() -- line: 166
		-- upvalues: p3 (copy)
		if p3.scrollRef.current then
			local scrollingAxis = p3.state.scrollingAxis
			local Offset = p3.scrollRef.current.Position[scrollingAxis].Offset
			local v38 = p3.getCenterIndexByScrollPosition(Offset)

			if v38 ~= p3.currentIndex then
				p3.currentIndex = v38
				p3.updateParent()
			end
		end
	end
	function p3.updateTargetIndex(t3: {[any]: any}) -- line: 181
		-- upvalues: p3 (copy), Otter (copy)
		local newTargetIndex = t3.newTargetIndex
		local isSetByUserInput = t3.isSetByUserInput
		local otterAnimationType = t3.otterAnimationType

		if otterAnimationType == nil then
			otterAnimationType = "spring"
		end

		local entries = p3.props.entries
		local entrySizeOnScrollingAxis = p3.props.entrySizeOnScrollingAxis

		p3.targetIndex = if not (#entries < 1) then math.clamp(newTargetIndex, math.max(1, p3.props.minTargetIndex or 1), #entries) else 0
		p3.isTargetIndexSetByUserInput = isSetByUserInput
		p3.motor:setGoal(Otter[otterAnimationType](-(entrySizeOnScrollingAxis * (p3.targetIndex - 1)), {
			frequency = 2
		}))

		if p3.currentIndex == p3.targetIndex then
			p3.updateParent()
		end
	end
	function p3.updateIndexByInputPosition(p6) -- line: 216
		-- upvalues: p3 (copy)
		if p3.scrollRef.current then
			local scrollingAxis = p3.state.scrollingAxis
			local AbsolutePosition = p3.scrollRef.current.AbsolutePosition
			local AbsoluteSize = p3.scrollRef.current.AbsoluteSize
			local entrySizeOnScrollingAxis = p3.props.entrySizeOnScrollingAxis
			local v50 = if not (p6.X > AbsolutePosition.X) or (not (p6.X < AbsolutePosition.X + AbsoluteSize.X) or (not (p6.Y > AbsolutePosition.Y) or not (p6.Y < AbsolutePosition.Y + AbsoluteSize.Y))) then -(p3.targetIndex - 1) * entrySizeOnScrollingAxis else AbsolutePosition[scrollingAxis] - p6[scrollingAxis]
			local v51 = p3.getCenterIndexByPosition(v50)

			p3.updateTargetIndex({
				isSetByUserInput = true,
				newTargetIndex = v51
			})
		end
	end
	function p3.updateIndexByScrollPositionAndOffset(p7) -- line: 247
		-- upvalues: p3 (copy)
		local v53 = p7 or 0

		if p3.scrollRef.current then
			local scrollingAxis = p3.state.scrollingAxis
			local v55 = p3.scrollRef.current.Position[scrollingAxis].Offset + v53
			local v56 = p3.getCenterIndexByScrollPosition(v55)

			p3.updateTargetIndex({
				isSetByUserInput = true,
				newTargetIndex = v56
			})
		end
	end
	function p3.onInputBegan(_, p9) -- line: 266
		-- upvalues: p3 (copy), v16 (copy)
		local entries = p3.props.entries
		local scrollingAxis = p3.state.scrollingAxis

		if p3.isMounted and (v16[p9.UserInputType] and #entries > 0 and p9.UserInputState == Enum.UserInputState.Begin) then
			p3.recognizedInputBegan = true
			p3.timeInputBegan = tick()
			p3.inputPositionAtInputBegan = p9.Position[scrollingAxis]
			p3.inputPreviousPositionScrollingAxis = p9.Position[scrollingAxis]
			p3.motor:stop()
		end
	end
	function v15.restrictInputChangeDelta(_: {[any]: any}, n1: number) -- line: 292
		-- upvalues: v12 (copy), v15 (copy), v13 (copy)
		local v63 = not (n1 > 0) and -1 or 1
		local v64 = math.min(math.abs(n1), v12 * v15.MOUSE_WHEEL_STEP_THRESHOLD)

		if v64 < v15.MOUSE_WHEEL_STEP_THRESHOLD then
			return math.pow(v64 / v15.MOUSE_WHEEL_STEP_THRESHOLD, v13) * v15.MOUSE_WHEEL_STEP_THRESHOLD
		end

		return v64 * v63
	end
	function p3.onInputChanged(_, p11) -- line: 313
		-- upvalues: p3 (copy), v15 (copy), v11 (copy), Otter (copy)
		local entries = p3.props.entries
		local entrySizeOnScrollingAxis = p3.props.entrySizeOnScrollingAxis
		local scrollingAxis = p3.state.scrollingAxis

		if p11.UserInputType == Enum.UserInputType.MouseWheel then
			local PositionZ = p11.Position.Z
			local v71 = v15:restrictInputChangeDelta(PositionZ)

			if PositionZ < 0 ~= (p3.scrollDeltaAccumulator < 0) then
				p3.scrollDeltaAccumulator = 0
			end

			p3.scrollDeltaAccumulator = p3.scrollDeltaAccumulator + v71

			local v72 = math.abs(p3.scrollDeltaAccumulator) <= 4 * v15.MOUSE_WHEEL_STEP_THRESHOLD

			while math.abs(p3.scrollDeltaAccumulator) >= v15.MOUSE_WHEEL_STEP_THRESHOLD do
				local v73 = not (p3.scrollDeltaAccumulator > 0) and -1 or 1

				p3.updateTargetIndex({
					isSetByUserInput = true,
					OtterAnimationType = "spring",
					newTargetIndex = p3.targetIndex - v73
				})
				p3.scrollDeltaAccumulator = p3.scrollDeltaAccumulator - v15.MOUSE_WHEEL_STEP_THRESHOLD * v73

				if v72 then
					task.wait(v11)
				end
			end

			return
		end

		if p3.recognizedInputBegan then
			local v74 = p11.Position[scrollingAxis] - p3.inputPreviousPositionScrollingAxis

			if p3.scrollRef.current then
				local v75 = p3.scrollRef.current.Position[scrollingAxis].Offset + v74
				local v76 = math.max(math.min(-(entrySizeOnScrollingAxis * (math.max(1, p3.props.minTargetIndex or 1) - 1)), v75), -(entrySizeOnScrollingAxis * (#entries - 1)))

				p3.motor:setGoal(Otter.instant(v76))
			end

			p3.inputChanged = true
			p3.inputPreviousPositionScrollingAxis = p11.Position[scrollingAxis]
		end
	end
	function p3.onInputEnded(_, p13) -- line: 369
		-- upvalues: p3 (copy)
		local scrollingAxis = p3.state.scrollingAxis

		if p3.recognizedInputBegan then
			local v80 = p13.Position[scrollingAxis] - p3.inputPositionAtInputBegan

			if p3.inputChanged and math.abs(v80) > 1.5 then
				local v81 = tick() - p3.timeInputBegan

				if v81 < 0.3 then
					local v82 = p13.Delta[scrollingAxis] / v81

					p3.updateIndexByScrollPositionAndOffset(v82)
				else
					p3.updateIndexByScrollPositionAndOffset(0)
				end
			else
				p3.updateIndexByInputPosition(p13.Position)
			end
		end

		p3.recognizedInputBegan = false
		p3.inputChanged = false
	end
	function p3.onSelectionGained(n2: number) -- line: 395
		-- upvalues: p3 (copy)
		p3.isEntrySelected = true
		p3.updateTargetIndex({
			isSetByUserInput = true,
			otterAnimationType = "instant",
			newTargetIndex = n2
		})
	end
	function p3.onSelectionLost() -- line: 404
		-- upvalues: p3 (copy)
		p3.isEntrySelected = false
	end
end
function v15.didMount(p14) -- line: 409
	-- upvalues: Otter (copy), ScrollingPickerDirection (copy)
	p14.updateParent()
	p14.motor = Otter.createSingleMotor(0)
	p14.motor:onStep(function(p15) -- line: 413
		-- upvalues: p14 (copy), ScrollingPickerDirection (copy)
		if p14.scrollRef.current then
			local scrollingAxis = p14.state.scrollingAxis
			local subAxis = p14.state.subAxis
			local scrollDirection = p14.state.scrollDirection
			local currentPosition = p14.scrollRef.current.Position
			local v89 = if scrollDirection ~= ScrollingPickerDirection.Horizontal then UDim2.new(currentPosition[subAxis], UDim.new(currentPosition[scrollingAxis].Scale, p15)) else UDim2.new(UDim.new(currentPosition[scrollingAxis].Scale, p15), currentPosition[subAxis])

			p14.scrollRef.current.Position = v89
		end
	end)
	p14.motor:onComplete(function() -- line: 431
		-- upvalues: p14 (copy)
		if p14.props.onAnimationComplete then
			p14.props.onAnimationComplete()
		end
	end)
	p14.updateTargetIndex({
		isSetByUserInput = false,
		otterAnimationType = "instant",
		newTargetIndex = p14.targetIndex
	})
	p14.isMounted = true
end
function v15.willUnmount(p16) -- line: 446
	p16.isMounted = false
	p16.motor:destroy()
end
function v15.didUpdate(p17, p18) -- line: 451
	local parentSpecifiedTarget = p17.props.parentSpecifiedTarget

	if p17.props.entrySizeOnScrollingAxis ~= p18.entrySizeOnScrollingAxis or parentSpecifiedTarget ~= p17.targetIndex and parentSpecifiedTarget ~= p18.parentSpecifiedTarget then
		local v28 = parentSpecifiedTarget or p17.targetIndex

		p17.updateTargetIndex({
			isSetByUserInput = false,
			newTargetIndex = v28
		})
	end
end
function v15.render(p19) -- line: 473
	-- upvalues: withStyle (copy), ScrollingPickerDirection (copy), FitChildren (copy), Roact (copy), Cryo (copy)
	return withStyle(function(_) -- line: 474
		-- upvalues: p19 (copy), ScrollingPickerDirection (copy), FitChildren (copy), Roact (copy), Cryo (copy)
		local layoutOrder = p19.props.layoutOrder
		local size = p19.props.size
		local entries = p19.props.entries
		local entrySizeOnScrollingAxis = p19.props.entrySizeOnScrollingAxis
		local clipsDescendants = p19.props.clipsDescendants
		local scrollDirection = p19.state.scrollDirection
		local getEntryWrapperProps = p19.props.getEntryWrapperProps
		local Width, Horizontal, uDim2, uDim2_2, uDim2_3

		if scrollDirection == ScrollingPickerDirection.Horizontal then
			Width = FitChildren.FitAxis.Width
			Horizontal = Enum.FillDirection.Horizontal
			uDim2 = UDim2.new(0, entrySizeOnScrollingAxis, 1, 0)
			uDim2_2 = UDim2.new(0, 0, 1, 0)
			uDim2_3 = UDim2.new(0.5, -entrySizeOnScrollingAxis / 2, 0, 0)
		else
			Width = FitChildren.FitAxis.Height
			Horizontal = Enum.FillDirection.Vertical
			uDim2 = UDim2.new(1, 0, 0, entrySizeOnScrollingAxis)
			uDim2_2 = UDim2.new(1, 0, 0, 0)
			uDim2_3 = UDim2.new(0, 0, 0.5, -entrySizeOnScrollingAxis / 2)
		end

		local t5 = {}

		for i, v in ipairs(entries) do
			local t6 = {
				Interactable = i == p19.targetIndex and p19.isEntrySelected,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				Selectable = math.abs(p19.targetIndex - i) < 2,
				[Roact.Ref] = if i ~= p19.targetIndex then nil else p19.targetEntryRef,
				[Roact.Event.SelectionGained] = function() -- line: 514
					-- upvalues: p19 (copy), i (copy)
					p19.onSelectionGained(i)
				end,
				[Roact.Event.SelectionLost] = p19.onSelectionLost,
				[Roact.Event.Activated] = p19.props.onEntryActivated
			}

			if getEntryWrapperProps then
				t6 = Cryo.Dictionary.join(t6, getEntryWrapperProps(v))
			end

			local v107 = Cryo.Dictionary.join(t6, {
				Size = uDim2,
				LayoutOrder = i
			})

			table.insert(t5, Roact.createElement("TextButton", v107, { p19.props.renderEntry(v) }))
		end

		table.insert(t5, Roact.createElement("UIListLayout", {
			FillDirection = Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}))

		return Roact.createElement("Frame", {
			LayoutOrder = layoutOrder,
			Size = if not p19.shouldExpandTapTarget then size else size + UDim2.new(0, 0, 0, p19.tapTargetExpansionSize),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = clipsDescendants,
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			[Roact.Event.InputBegan] = p19.onInputBegan,
			[Roact.Event.InputChanged] = p19.onInputChanged,
			[Roact.Event.InputEnded] = p19.onInputEnded
		}, {
			CenterPosition = if not p19.shouldExpandTapTarget then Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = uDim2_2,
				Position = uDim2_3
			}, {
				AnimatedSlidingList = Roact.createElement(FitChildren.FitFrame, {
					Size = uDim2_2,
					fitAxis = Width,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					[Roact.Ref] = p19.scrollRef,
					[Roact.Change.AbsolutePosition] = p19.onScrollPositionChanged
				}, t5)
			}) else Roact.createElement("Frame", {
				ClipsDescendants = true,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = size,
				AutomaticSize = Enum.AutomaticSize.X
			}, {
				CenterPosition = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = uDim2_2,
					Position = uDim2_3
				}, {
					AnimatedSlidingList = Roact.createElement(FitChildren.FitFrame, {
						Size = uDim2_2,
						fitAxis = Width,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						[Roact.Ref] = p19.scrollRef,
						[Roact.Change.AbsolutePosition] = p19.onScrollPositionChanged
					}, t5)
				})
			})
		})
	end)
end

return v15
