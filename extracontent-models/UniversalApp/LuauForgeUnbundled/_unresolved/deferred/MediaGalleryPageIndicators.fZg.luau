local CorePackages = game:GetService("CorePackages")

local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.ReactOtter)
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local defineFastInt = game:DefineFastInt("LuaAppEdpMediaGalleryPageIndicatorsMaxVisibleCount", 5)

local function getFirstVisibleIndexOnScrollingRight(p2, p3)
	if defineFastInt < p2 then
		return (math.max(1, math.min(p3, p2 - 2) - defineFastInt + 2 + 1))
	end

	return 1
end

local function getFirstVisibleIndexOnScrollingLeft(p2, p3)
	if defineFastInt < p2 then
		return (math.min(p2 - defineFastInt + 1, math.max(p3, 3) - 2))
	end

	return 1
end

local function getDotAnchorPointAtIndex(i, state, state2)
	if state2 < state then
		if i == state then
			return Vector2.new(1, 0.5)
		end

		if i == state2 then
			return Vector2.new(0, 0.5)
		end
	elseif state < state2 then
		if i == state then
			return Vector2.new(0, 0.5)
		end

		if i == state2 then
			return Vector2.new(1, 0.5)
		end
	end

	return Vector2.new(0.5, 0.5)
end

local function getDotPositionAtIndex(i, state, state2)
	if state2 < state then
		if i == state then
			return UDim2.fromScale(1, 0.5)
		end

		if i == state2 then
			return UDim2.fromScale(0, 0.5)
		end
	elseif state < state2 then
		if i == state then
			return UDim2.fromScale(0, 0.5)
		end

		if i == state2 then
			return UDim2.fromScale(1, 0.5)
		end
	end

	return UDim2.fromScale(0.5, 0.5)
end

local function MediaGalleryPageIndicators(props)
	local v5 = useTokens()

	local size_100 = v5.Size.Size_100
	local size_150 = v5.Size.Size_150
	local size_200 = v5.Size.Size_200
	local size_800 = v5.Size.Size_800
	local small = v5.Padding.Small

	local muted = v5.DarkMode.Content.Muted

	local emphasis = if fFlagLuaAppEdpMediaGalleryAutoAdvance then v5.DarkMode.Content.Emphasis else nil

	local state, setState = React.useState(props.mediaGalleryStartIndex)
	local state2, setState2 = React.useState(props.mediaGalleryStartIndex)

	local state3, setState3 = React.useState(1)
	local v6, v7 = React.useBinding(Vector2.new(0, 0))

	local state4, setState4 = React.useState(false)
	local v8, v9 = React.useBinding(0)

	local ref = React.useRef({})

	local v10 = math.min(props.numberOfItems, defineFastInt)

	local v11 = React.useMemo(function()
		return (v10 - 1) * (size_200 + small) + size_800
	end, { v10, size_200, small, size_800 })

	local v12 = React.useCallback(function(p2)
		return Vector2.new((p2 - 1) * (size_200 + small), 0)
	end, { size_200, small })

	local v13 = React.useCallback(function(p2)
		local v14 = math.min(state3 + v10 - 1, props.numberOfItems)
		local v15 = state3 > 1
		local v16 = v14 < props.numberOfItems

		if p2 == state then
			return UDim2.fromOffset(size_800, size_200)
		end

		if v15 then
			if p2 < state3 then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == state3 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == state3 + 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		if v16 then
			if v14 < p2 then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == v14 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == v14 - 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		return UDim2.fromOffset(size_200, size_200)
	end, {
		props.numberOfItems,
		v10,
		state3,
		state,
		size_100,
		size_150,
		size_200,
		size_800
	})

	React.useEffect(function()
		local numberOfItems = props.numberOfItems
		local mediaGalleryStartIndex = props.mediaGalleryStartIndex
		local v14 = not (defineFastInt < numberOfItems) and 1
			or math.max(1, math.min(mediaGalleryStartIndex, numberOfItems - 2) - defineFastInt + 2 + 1)

		v7(v12(v14))
		setState3(v14)
		v9(1)
		setState(props.mediaGalleryStartIndex)
	end, { props.numberOfItems, props.mediaGalleryStartIndex, v12 })

	React.useEffect(function()
		local function handleMediaGalleryScrolled(p2)
			setState(function(p3)
				local v14

				if p3 < p2 then
					local numberOfItems = props.numberOfItems
					v14 = not (defineFastInt < numberOfItems) and 1
						or math.max(1, math.min(p2, numberOfItems - 2) - defineFastInt + 2 + 1)
				else
					local numberOfItems = props.numberOfItems
					v14 = not (defineFastInt < numberOfItems) and 1
						or math.min(numberOfItems - defineFastInt + 1, math.max(p2, 3) - 2)
				end

				setState2(p3)
				setState3(v14)
				setState4(true)

				return p2
			end)
		end

		local mediaGalleryScrolledSignalConnection = props.mediaGalleryScrolledSignal:connect(function(p2)
			setState(function(p3)
				local v14

				if p3 < p2 then
					local numberOfItems = props.numberOfItems
					v14 = not (defineFastInt < numberOfItems) and 1
						or math.max(1, math.min(p2, numberOfItems - 2) - defineFastInt + 2 + 1)
				else
					local numberOfItems = props.numberOfItems
					v14 = not (defineFastInt < numberOfItems) and 1
						or math.min(numberOfItems - defineFastInt + 1, math.max(p2, 3) - 2)
				end

				setState2(p3)
				setState3(v14)
				setState4(true)

				return p2
			end)
		end)

		return function()
			if mediaGalleryScrolledSignalConnection ~= nil then
				mediaGalleryScrolledSignalConnection:disconnect()
				mediaGalleryScrolledSignalConnection = nil
			end
		end
	end, { props.numberOfItems, props.mediaGalleryScrolledSignal })

	React.useEffect(function()
		if not state4 then
			return
		end

		local singleMotor = Otter.createSingleMotor(0)
		local v14 = if props.useSpring then Otter.spring(1, props.springConfig) else Otter.instant(1)
		singleMotor:setGoal(v14)

		local value = v6:getValue()
		local v15 = v12(state3)

		singleMotor:onStep(function(p2)
			v9(p2)
			v7(value:Lerp(v15, p2))
		end)

		singleMotor:onComplete(function()
			setState4(false)
		end)
		return function()
			singleMotor:destroy()
		end
	end, { props.useSpring, props.springConfig, state4, state3, v6, v12 })

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for i = 1, props.numberOfItems do
			local v14 = ref.current[i]
			local v15 = v13(i)

			local v16 = "Indicator" .. i
			local createElement = React.createElement
			local fromOffset = UDim2.fromOffset
			local v19 = if i == state then size_800 else size_200
			local v18 = {
				Size = fromOffset(v19, size_200),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i
			}

			local createElement2 = React.createElement
			local v21 = {
				AnchorPoint = getDotAnchorPointAtIndex(i, state2, state),
				Position = getDotPositionAtIndex(i, state2, state),
				Size = v8:map(function(p2)
					if v14 == nil then
						return v15
					end

					return v14:Lerp(v15, p2)
				end),
				BackgroundColor3 = muted.Color3,
				BackgroundTransparency = muted.Transparency,
				BorderSizePixel = 0
			}

			local v22 = {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				ProgressBar = 0
			}
			local v23

			if
				fFlagLuaAppEdpMediaGalleryAutoAdvance
				and i == state
				and props.currentItemProgressBinding
			then
				v23 = React.createElement("Frame", {
					Size = props.currentItemProgressBinding:map(function(p2)
						return UDim2.fromOffset(size_200 + p2 * (size_800 - size_200), size_200)
					end),
					BackgroundColor3 = emphasis.Color3,
					BackgroundTransparency = emphasis.Transparency,
					BorderSizePixel = 0
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0)
					})
				})
			end

			v22.ProgressBar = v23
			children[v16] = createElement("Frame", v18, {
				Dot = createElement2("Frame", v21, v22)
			})

			ref.current[i] = v15
		end

		return children
	end

	local numberOfItems = props.numberOfItems
	local currentItemProgressBinding = if fFlagLuaAppEdpMediaGalleryAutoAdvance then props.currentItemProgressBinding else nil
	local v16 = useMemo(fn, {
		numberOfItems,
		currentItemProgressBinding,
		state2,
		state,
		v13,
		size_200,
		size_800,
		muted,
		if fFlagLuaAppEdpMediaGalleryAutoAdvance then emphasis else nil,
		v8
	})

	return React.createElement("ScrollingFrame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = UDim2.fromOffset(v11, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		ClipsDescendants = true,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollingEnabled = false,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.fromOffset(0, size_200),
		AutomaticCanvasSize = Enum.AutomaticSize.X,
		CanvasPosition = v6,
		Selectable = false
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, small),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v16)
	})
end

return MediaGalleryPageIndicators
