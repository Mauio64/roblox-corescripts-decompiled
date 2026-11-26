local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local withStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox").Style.withStyle

local ScrollingPickerDirection = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/ScrollingPickerDirection")

local Otter = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Otter")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitChildren")

local v5 = { [ScrollingPickerDirection.Horizontal] = "X", [ScrollingPickerDirection.Vertical] = "Y" }

local v6 = { [ScrollingPickerDirection.Horizontal] = "Y", [ScrollingPickerDirection.Vertical] = "X" }

local defineFastInt = game:DefineFastInt("ScrollingPickerSlowScrollStepWaitMs", 100)

local defineFastInt2 = game:DefineFastInt("ScrollingPickerMaximumPickerChangePerInput", 1)
local defineFastInt3 = game:DefineFastInt("ScrollingPickerSmallInputDecayFactor", 3)

local v7 = { spring = "spring", instant = "instant" }

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

local set = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.Touch] = true
}
local object = setmetatable(set, {
	__index = function(p2, p3): boolean
		return false
	end
})

function extended:init()
	local parentSpecifiedTarget = self.props.parentSpecifiedTarget
	local scrollDirection = self.props.scrollDirection
	local shouldExpandTapTarget = self.props.shouldExpandTapTarget

	self.state = {
		scrollDirection = scrollDirection,
		scrollingAxis = v5[scrollDirection],
		subAxis = v6[scrollDirection]
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

	function self.getCenterIndexByPosition(p2)
		local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis

		return math.floor(-p2 / entrySizeOnScrollingAxis) + 1
	end

	function self.getCenterIndexByScrollPosition(p2)
		local v8 = p2 - self.props.entrySizeOnScrollingAxis / 2
		return self.getCenterIndexByPosition(v8)
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

		local v8 = otterAnimationType == nil and "spring" or otterAnimationType

		local entries = self.props.entries
		local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis

		self.targetIndex = #entries < 1 and 0
			or math.clamp(newTargetIndex, math.max(1, self.props.minTargetIndex or 1), #entries)
		self.isTargetIndexSetByUserInput = isSetByUserInput

		self.motor:setGoal(Otter[v8](-(entrySizeOnScrollingAxis * (self.targetIndex - 1)), {
			frequency = 2
		}))

		if self.currentIndex == self.targetIndex then
			self.updateParent()
		end
	end

	function self.updateIndexByInputPosition(p2)
		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis

			local absolutePosition = self.scrollRef.current.AbsolutePosition
			local absoluteSize = self.scrollRef.current.AbsoluteSize
			local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis
			local v8

			if
				p2.X > absolutePosition.X
				and p2.X < absolutePosition.X + absoluteSize.X
				and p2.Y > absolutePosition.Y
				and p2.Y < absolutePosition.Y + absoluteSize.Y
			then
				v8 = absolutePosition[scrollingAxis] - p2[scrollingAxis]
			else
				v8 = -(self.targetIndex - 1) * entrySizeOnScrollingAxis
			end

			local centerIndexByPosition = self.getCenterIndexByPosition(v8)

			self.updateTargetIndex({
				newTargetIndex = centerIndexByPosition,
				isSetByUserInput = true
			})
		end
	end

	function self.updateIndexByScrollPositionAndOffset(value)
		local v8 = value or 0

		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis
			local v9 = self.scrollRef.current.Position[scrollingAxis].Offset + v8
			local centerIndexByScrollPosition = self.getCenterIndexByScrollPosition(v9)

			self.updateTargetIndex({
				newTargetIndex = centerIndexByScrollPosition,
				isSetByUserInput = true
			})
		end
	end

	function self.onInputBegan(p2, data)
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

	function extended:restrictInputChangeDelta(p3)
		local v8 = p3 > 0 and 1 or -1
		local v9 = math.min(math.abs(p3), defineFastInt2 * extended.MOUSE_WHEEL_STEP_THRESHOLD)

		if v9 < extended.MOUSE_WHEEL_STEP_THRESHOLD then
			return math.pow(v9 / extended.MOUSE_WHEEL_STEP_THRESHOLD, defineFastInt3) * extended.MOUSE_WHEEL_STEP_THRESHOLD
		end

		return v9 * v8
	end

	function self.onInputChanged(p2, p3)
		local entries = self.props.entries
		local entrySizeOnScrollingAxis = self.props.entrySizeOnScrollingAxis
		local scrollingAxis = self.state.scrollingAxis

		if p3.UserInputType == Enum.UserInputType.MouseWheel then
			local z = p3.Position.Z
			local restrictInputChangeDelta = extended:restrictInputChangeDelta(z)

			if (z < 0) ~= (self.scrollDeltaAccumulator < 0) then
				self.scrollDeltaAccumulator = 0
			end

			self.scrollDeltaAccumulator += restrictInputChangeDelta

			local v8 = math.abs(self.scrollDeltaAccumulator) <= 4 * extended.MOUSE_WHEEL_STEP_THRESHOLD

			while math.abs(self.scrollDeltaAccumulator) >= extended.MOUSE_WHEEL_STEP_THRESHOLD do
				local v9 = self.scrollDeltaAccumulator > 0 and 1 or -1
				self.updateTargetIndex({
					newTargetIndex = self.targetIndex - v9,
					isSetByUserInput = true,
					OtterAnimationType = "spring"
				})

				self.scrollDeltaAccumulator -= extended.MOUSE_WHEEL_STEP_THRESHOLD * v9

				if v8 then
					task.wait(defineFastInt)
				end
			end
		elseif self.recognizedInputBegan then
			local v8 = p3.Position[scrollingAxis] - self.inputPreviousPositionScrollingAxis

			if self.scrollRef.current then
				local v9 = self.scrollRef.current.Position[scrollingAxis].Offset + v8
				local v10 = math.max(
					math.min(
						-(entrySizeOnScrollingAxis * (math.max(1, self.props.minTargetIndex or 1) - 1)),
						v9
					),
					-(entrySizeOnScrollingAxis * (#entries - 1))
				)

				self.motor:setGoal(Otter.instant(v10))
			end

			self.inputChanged = true
			self.inputPreviousPositionScrollingAxis = p3.Position[scrollingAxis]
		end
	end

	function self.onInputEnded(p2, p3)
		local scrollingAxis = self.state.scrollingAxis

		if self.recognizedInputBegan then
			local v8 = p3.Position[scrollingAxis] - self.inputPositionAtInputBegan

			if self.inputChanged and math.abs(v8) > 1.5 then
				local v9 = tick() - self.timeInputBegan

				if v9 < 0.3 then
					local v10 = p3.Delta[scrollingAxis] / v9
					self.updateIndexByScrollPositionAndOffset(v10)
				else
					self.updateIndexByScrollPositionAndOffset(0)
				end
			else
				self.updateIndexByInputPosition(p3.Position)
			end
		end

		self.recognizedInputBegan = false
		self.inputChanged = false
	end

	function self.onSelectionGained(p2)
		self.isEntrySelected = true
		self.updateTargetIndex({
			newTargetIndex = p2,
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
	self.motor:onStep(function(p2)
		if self.scrollRef.current then
			local scrollingAxis = self.state.scrollingAxis
			local subAxis = self.state.subAxis

			local scrollDirection = self.state.scrollDirection
			local position = self.scrollRef.current.Position

			local v8 = if scrollDirection == ScrollingPickerDirection.Horizontal then UDim2.new(
				UDim.new(position[scrollingAxis].Scale, p2),
				position[subAxis]
			) else UDim2.new(position[subAxis], UDim.new(position[scrollingAxis].Scale, p2))

			self.scrollRef.current.Position = v8
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

function extended.didUpdate(data, p2)
	local parentSpecifiedTarget = data.props.parentSpecifiedTarget
	local v8

	if data.props.entrySizeOnScrollingAxis == p2.entrySizeOnScrollingAxis then
		if parentSpecifiedTarget == data.targetIndex then
			v8 = false
		else
			v8 = parentSpecifiedTarget ~= p2.parentSpecifiedTarget
		end
	else
		v8 = true
	end

	if v8 then
		local v9 = parentSpecifiedTarget or data.targetIndex

		data.updateTargetIndex({ newTargetIndex = v9, isSetByUserInput = false })
	end
end

function extended.render(data)
	return withStyle(function(p2)
		local layoutOrder = data.props.layoutOrder
		local size = data.props.size
		local entries = data.props.entries
		local entrySizeOnScrollingAxis = data.props.entrySizeOnScrollingAxis
		local clipsDescendants = data.props.clipsDescendants
		local scrollDirection = data.state.scrollDirection
		local getEntryWrapperProps = data.props.getEntryWrapperProps
		local v8, v9, udim, udim2, udim3

		if scrollDirection == ScrollingPickerDirection.Horizontal then
			v8 = FitChildren.FitAxis.Width
			v9 = Enum.FillDirection.Horizontal
			udim = UDim2.new(0, entrySizeOnScrollingAxis, 1, 0)
			udim2 = UDim2.new(0, 0, 1, 0)
			udim3 = UDim2.new(0.5, -entrySizeOnScrollingAxis / 2, 0, 0)
		else
			v8 = FitChildren.FitAxis.Height
			v9 = Enum.FillDirection.Vertical
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
			local v11 = if i == data.targetIndex then data.targetEntryRef else nil
			joined[ref] = v11
			joined[Roact.Event.SelectionGained] = function()
				data.onSelectionGained(i)
			end
			joined[Roact.Event.SelectionLost] = data.onSelectionLost
			joined[Roact.Event.Activated] = data.props.onEntryActivated

			if getEntryWrapperProps then
				joined = Cryo.Dictionary.join(joined, getEntryWrapperProps(entry))
			end

			local joined2 = Cryo.Dictionary.join(joined, {
				Size = udim,
				LayoutOrder = i
			})

			table.insert(
				children,
				Roact.createElement("TextButton", joined2, { data.props.renderEntry(entry) })
			)
		end

		table.insert(
			children,
			Roact.createElement("UIListLayout", {
				FillDirection = v9,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		)

		local createElement = Roact.createElement

		local v12 = if data.shouldExpandTapTarget then size + UDim2.new(0, 0, 0, data.tapTargetExpansionSize) else size
		local v11 = {
			LayoutOrder = layoutOrder,
			Size = v12,
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
		local v14

		if data.shouldExpandTapTarget then
			v14 = Roact.createElement("Frame", {
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
							fitAxis = v8,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							[Roact.Ref] = data.scrollRef,
							[Roact.Change.AbsolutePosition] = data.onScrollPositionChanged
						}, children)
					}
				)
			})
		else
			v14 = Roact.createElement(
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
						fitAxis = v8,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						[Roact.Ref] = data.scrollRef,
						[Roact.Change.AbsolutePosition] = data.onScrollPositionChanged
					}, children)
				}
			)
		end

		return createElement("Frame", v11, { CenterPosition = v14 })
	end)
end

return extended
