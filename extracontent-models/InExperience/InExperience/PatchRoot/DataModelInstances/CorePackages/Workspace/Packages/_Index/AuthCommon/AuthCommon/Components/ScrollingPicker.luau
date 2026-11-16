local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent
local Roact = require(parent.Roact)

local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle

local ScrollingPickerDirection = require(AuthCommon.Enums.ScrollingPickerDirection)

local Otter = require(parent.Otter)

local FitChildren = require(AuthCommon.Components.FitChildren)

local v = { [ScrollingPickerDirection.Horizontal] = "X", [ScrollingPickerDirection.Vertical] = "Y" }

local v2 = {
	[ScrollingPickerDirection.Horizontal] = "Y",
	[ScrollingPickerDirection.Vertical] = "X"
}

local defineFastInt = game:DefineFastInt("ScrollingPickerSlowScrollStepWaitMs", 100)

local defineFastInt2 = game:DefineFastInt("ScrollingPickerMaximumPickerChangePerInput", 1)
local defineFastInt3 = game:DefineFastInt("ScrollingPickerSmallInputDecayFactor", 3)

local _ = { spring = "spring", instant = "instant" }

local extended = Roact.PureComponent:extend("ScrollingPicker")

extended.MOUSE_WHEEL_STEP_THRESHOLD = 0.1

extended.defaultProps = {
	layoutOrder = 0,
	parentSpecifiedTarget = 1,
	entries = {},
	entrySizeOnScrollingAxis = 10,
	scrollDirection = ScrollingPickerDirection.Vertical,
	clipsDescendants = true,
	shouldExpandTapTarget = false,
	tapTargetExpansionSize = 0,
	minTargetIndex = 1
}

local set = { [Enum.UserInputType.MouseButton1] = true, [Enum.UserInputType.Touch] = true }
local object = setmetatable(set, {
	__index = function(_, _): boolean
		return false
	end
})

function extended:init()
	local parentSpecifiedTarget = self.props.parentSpecifiedTarget
	local scrollDirection = self.props.scrollDirection
	local shouldExpandTapTarget = self.props.shouldExpandTapTarget

	self.state = {
		scrollDirection = scrollDirection,
		scrollingAxis = v[scrollDirection],
		subAxis = v2[scrollDirection]
	}

	self.isMounted = false

	self.currentIndex = 1
	self.targetEntryRef = Roact.createRef()
	self.targetIndex = parentSpecifiedTarget
	self.isEntrySelected = false

	self.isTargetIndexSetByUserInput = false
	self.timeInputBegan = tick()

	self.recognizedInputBegan = false
	self.inputChanged = false
	self.inputPositionAtInputBegan = 0
	self.inputPreviousPositionScrollingAxis = 0
	self.scrollRef = Roact.createRef()
	self.shouldExpandTapTarget = shouldExpandTapTarget
	self.tapTargetExpansionSize = self.props.tapTargetExpansionSize

	self.scrollDeltaAccumulator = 0

	function self.getCenterIndexByPosition(p)
		local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis

		return math.floor(-p / entrySizeOnScrollingAxis) + 1
	end

	function self.getCenterIndexByScrollPosition(p)
		local v3 = p - self.props.entrySizeOnScrollingAxis / 2
		return self.getCenterIndexByPosition(v3)
	end

	function self.updateParent()
		local onCurrentIndexChanged = self.props.onCurrentIndexChanged
		local onSelectedIndexChanged = self.props.onSelectedIndexChanged

		if onCurrentIndexChanged then
			onCurrentIndexChanged(self.currentIndex)
		end

		if onSelectedIndexChanged and self.currentIndex == self.targetIndex then
			onSelectedIndexChanged(self.currentIndex, self.isTargetIndexSetByUserInput)
		end
	end

	function self.onScrollPositionChanged()
		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis
			local offset = self.scrollRef.current.Position[scrollingAxis].Offset
			local centerIndexByScrollPosition = self.getCenterIndexByScrollPosition(offset)

			if centerIndexByScrollPosition ~= self.currentIndex then
				self.currentIndex = centerIndexByScrollPosition
				self.updateParent()
			end
		end
	end

	function self.updateTargetIndex(data)
		local newTargetIndex = data.newTargetIndex
		local isSetByUserInput = data.isSetByUserInput
		local otterAnimationType = data.otterAnimationType

		local v3 = otterAnimationType == nil and "spring" or otterAnimationType

		local entries = self.props.entries
		local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis

		self.targetIndex = #entries < 1 and 0
			or math.clamp(newTargetIndex, math.max(1, self.props.minTargetIndex or 1), #entries)
		self.isTargetIndexSetByUserInput = isSetByUserInput

		self.motor:setGoal(Otter[v3](-(entrySizeOnScrollingAxis * (self.targetIndex - 1)), {
			frequency = 2
		}))

		if self.currentIndex == self.targetIndex then
			self.updateParent()
		end
	end

	function self.updateIndexByInputPosition(p)
		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis

			local absolutePosition = self.scrollRef.current.AbsolutePosition
			local absoluteSize = self.scrollRef.current.AbsoluteSize
			local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis
			local v3

			if
				p.X > absolutePosition.X
				and p.X < absolutePosition.X + absoluteSize.X
				and p.Y > absolutePosition.Y
				and p.Y < absolutePosition.Y + absoluteSize.Y
			then
				v3 = absolutePosition[scrollingAxis] - p[scrollingAxis]
			else
				v3 = -(self.targetIndex - 1) * entrySizeOnScrollingAxis
			end

			local centerIndexByPosition = self.getCenterIndexByPosition(v3)

			self.updateTargetIndex({
				newTargetIndex = centerIndexByPosition,
				isSetByUserInput = true
			})
		end
	end

	function self.updateIndexByScrollPositionAndOffset(value)
		local v3 = value or 0

		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis
			local v4 = self.scrollRef.current.Position[scrollingAxis].Offset + v3
			local centerIndexByScrollPosition = self.getCenterIndexByScrollPosition(v4)

			self.updateTargetIndex({
				newTargetIndex = centerIndexByScrollPosition,
				isSetByUserInput = true
			})
		end
	end

	function self.onInputBegan(_, data)
		local entries = self.props.entries
		local scrollingAxis = self.state.scrollingAxis

		if
			self.isMounted
			and object[data.UserInputType]
			and #entries > 0
			and data.UserInputState == Enum.UserInputState.Begin
		then
			self.recognizedInputBegan = true
			self.timeInputBegan = tick()
			self.inputPositionAtInputBegan = data.Position[scrollingAxis]
			self.inputPreviousPositionScrollingAxis = data.Position[scrollingAxis]

			self.motor:stop()
		end
	end

	function extended:restrictInputChangeDelta(p: number)
		local v3 = p > 0 and 1 or -1
		local v4 = math.min(math.abs(p), defineFastInt2 * extended.MOUSE_WHEEL_STEP_THRESHOLD)

		if v4 < extended.MOUSE_WHEEL_STEP_THRESHOLD then
			return math.pow(v4 / extended.MOUSE_WHEEL_STEP_THRESHOLD, defineFastInt3) * extended.MOUSE_WHEEL_STEP_THRESHOLD
		end

		return v4 * v3
	end

	function self.onInputChanged(_, p)
		local entries = self.props.entries
		local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis
		local scrollingAxis = self.state.scrollingAxis

		if p.UserInputType == Enum.UserInputType.MouseWheel then
			local z = p.Position.Z
			local restrictInputChangeDelta = extended:restrictInputChangeDelta(z)

			if (z < 0) ~= (self.scrollDeltaAccumulator < 0) then
				self.scrollDeltaAccumulator = 0
			end

			self.scrollDeltaAccumulator += restrictInputChangeDelta

			local v3 = math.abs(self.scrollDeltaAccumulator) <= 4 * extended.MOUSE_WHEEL_STEP_THRESHOLD

			while math.abs(self.scrollDeltaAccumulator) >= extended.MOUSE_WHEEL_STEP_THRESHOLD do
				local v4 = self.scrollDeltaAccumulator > 0 and 1 or -1
				self.updateTargetIndex({
					newTargetIndex = self.targetIndex - v4,
					isSetByUserInput = true,
					OtterAnimationType = "spring"
				})

				self.scrollDeltaAccumulator -= extended.MOUSE_WHEEL_STEP_THRESHOLD * v4

				if v3 then
					task.wait(defineFastInt)
				end
			end
		elseif self.recognizedInputBegan then
			local v3 = p.Position[scrollingAxis] - self.inputPreviousPositionScrollingAxis

			if self.scrollRef.current then
				local v4 = self.scrollRef.current.Position[scrollingAxis].Offset + v3
				local v5 = math.max(
					math.min(-(entrySizeOnScrollingAxis * (math.max(1, self.props.minTargetIndex or 1) - 1)), v4),
					-(entrySizeOnScrollingAxis * (#entries - 1))
				)

				self.motor:setGoal(Otter.instant(v5))
			end

			self.inputChanged = true
			self.inputPreviousPositionScrollingAxis = p.Position[scrollingAxis]
		end
	end

	function self.onInputEnded(_, p)
		local scrollingAxis = self.state.scrollingAxis

		if self.recognizedInputBegan then
			local v3 = p.Position[scrollingAxis] - self.inputPositionAtInputBegan

			if self.inputChanged and math.abs(v3) > 1.5 then
				local v4 = tick() - self.timeInputBegan

				if v4 < 0.3 then
					local v5 = p.Delta[scrollingAxis] / v4
					self.updateIndexByScrollPositionAndOffset(v5)
				else
					self.updateIndexByScrollPositionAndOffset(0)
				end
			else
				self.updateIndexByInputPosition(p.Position)
			end
		end

		self.recognizedInputBegan = false
		self.inputChanged = false
	end

	function self.onSelectionGained(newTargetIndex: number)
		self.isEntrySelected = true
		self.updateTargetIndex({
			newTargetIndex = newTargetIndex,
			isSetByUserInput = true,
			otterAnimationType = "instant"
		})
	end

	function self.onSelectionLost()
		self.isEntrySelected = false
	end
end

function extended:didMount()
	self.updateParent()

	self.motor = Otter.createSingleMotor(0)
	self.motor:onStep(function(p)
		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis
			local subAxis = self.state.subAxis

			local scrollDirection = self.state.scrollDirection
			local position = self.scrollRef.current.Position
			local position2

			if scrollDirection == ScrollingPickerDirection.Horizontal then
				position2 = UDim2.new(UDim.new(position[scrollingAxis].Scale, p), position[subAxis])
			else
				position2 = UDim2.new(position[subAxis], UDim.new(position[scrollingAxis].Scale, p))
			end

			self.scrollRef.current.Position = position2
		end
	end)

	self.motor:onComplete(function()
		if self.props.onAnimationComplete then
			self.props.onAnimationComplete()
		end
	end)

	self.updateTargetIndex({
		newTargetIndex = self.targetIndex,
		isSetByUserInput = false,
		otterAnimationType = "instant"
	})

	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
	self.motor:destroy()
end

function extended.didUpdate(data, p)
	local parentSpecifiedTarget = data.props.parentSpecifiedTarget
	local v3

	if data.props.entrySizeOnScrollingAxis == p.entrySizeOnScrollingAxis then
		if parentSpecifiedTarget == data.targetIndex then
			v3 = false
		else
			v3 = parentSpecifiedTarget ~= p.parentSpecifiedTarget
		end
	else
		v3 = true
	end

	if v3 then
		local newTargetIndex = parentSpecifiedTarget or data.targetIndex

		data.updateTargetIndex({ newTargetIndex = newTargetIndex, isSetByUserInput = false })
	end
end

function extended.render(data)
	return withStyle(function(_)
		local layoutOrder = data.props.layoutOrder
		local size = data.props.size
		local entries = data.props.entries
		local entrySizeOnScrollingAxis = data.props.entrySizeOnScrollingAxis
		local clipsDescendants = data.props.clipsDescendants
		local scrollDirection = data.state.scrollDirection
		local getEntryWrapperProps = data.props.getEntryWrapperProps
		local fitAxis, fillDirection, udim, udim2, udim3

		if scrollDirection == ScrollingPickerDirection.Horizontal then
			fitAxis = FitChildren.FitAxis.Width
			fillDirection = Enum.FillDirection.Horizontal
			udim = UDim2.new(0, entrySizeOnScrollingAxis, 1, 0)
			udim2 = UDim2.new(0, 0, 1, 0)
			udim3 = UDim2.new(0.5, -entrySizeOnScrollingAxis / 2, 0, 0)
		else
			fitAxis = FitChildren.FitAxis.Height
			fillDirection = Enum.FillDirection.Vertical
			udim = UDim2.new(1, 0, 0, entrySizeOnScrollingAxis)
			udim2 = UDim2.new(1, 0, 0, 0)
			udim3 = UDim2.new(0, 0, 0.5, -entrySizeOnScrollingAxis / 2)
		end

		local children = {}

		for i, entry in ipairs(entries) do
			local joined = {
				["Interactable"] = nil,
				["Interactable"] = nil,
				["Interactable"] = nil,
				["Interactable"] = nil,
				Interactable = i == data.targetIndex and data.isEntrySelected,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				Selectable = math.abs(data.targetIndex - i) < 2
			}
			local ref = Roact.Ref
			local v3

			if i == data.targetIndex then
				v3 = data.targetEntryRef
			end

			joined[ref] = v3
			joined[Roact.Event.SelectionGained] = function()
				data.onSelectionGained(i)
			end
			joined[Roact.Event.SelectionLost] = data.onSelectionLost
			joined[Roact.Event.Activated] = data.props.onEntryActivated

			if getEntryWrapperProps then
				joined = Cryo.Dictionary.join(joined, getEntryWrapperProps(entry))
			end

			local joined2 = Cryo.Dictionary.join(joined, { Size = udim, LayoutOrder = i })

			table.insert(children, Roact.createElement("TextButton", joined2, { data.props.renderEntry(entry) }))
		end

		table.insert(
			children,
			Roact.createElement("UIListLayout", {
				FillDirection = fillDirection,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		)

		local createElement = Roact.createElement
		local size2

		if data.shouldExpandTapTarget then
			size2 = size + UDim2.new(0, 0, 0, data.tapTargetExpansionSize)
		else
			size2 = size
		end

		local v3 = {
			LayoutOrder = layoutOrder,
			Size = size2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = clipsDescendants,
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			[Roact.Event.InputBegan] = data.onInputBegan,
			[Roact.Event.InputChanged] = data.onInputChanged,
			[Roact.Event.InputEnded] = data.onInputEnded
		}
		local centerPosition

		if data.shouldExpandTapTarget then
			centerPosition = Roact.createElement("Frame", {
				Size = size,
				AutomaticSize = Enum.AutomaticSize.X,
				ClipsDescendants = true,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				CenterPosition = Roact.createElement(
					"Frame",
					{
						Size = udim2,
						Position = udim3,
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					},
					{
						AnimatedSlidingList = Roact.createElement(FitChildren.FitFrame, {
							Size = udim2,
							fitAxis = fitAxis,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							[Roact.Ref] = data.scrollRef,
							[Roact.Change.AbsolutePosition] = data.onScrollPositionChanged
						}, children)
					}
				)
			})
		else
			centerPosition = Roact.createElement(
				"Frame",
				{ Size = udim2, Position = udim3, BorderSizePixel = 0, BackgroundTransparency = 1 },
				{
					AnimatedSlidingList = Roact.createElement(FitChildren.FitFrame, {
						Size = udim2,
						fitAxis = fitAxis,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						[Roact.Ref] = data.scrollRef,
						[Roact.Change.AbsolutePosition] = data.onScrollPositionChanged
					}, children)
				}
			)
		end

		return createElement("Frame", v3, { CenterPosition = centerPosition })
	end)
end

return extended
