local CorePackages = game:GetService("CorePackages")

local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.ReactOtter)
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local fFlagLuaAppMediaGalleryPageIndicatorOpacity = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMediaGalleryPageIndicatorOpacity

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

	local v6 = if fFlagLuaAppMediaGalleryPageIndicatorOpacity then v5.Size.Size_600 else v5.Size.Size_800

	local v7 = if fFlagLuaAppMediaGalleryPageIndicatorOpacity then v5.Size.Size_150 else v5.Padding.Small

	local muted = v5.DarkMode.Content.Muted

	local emphasis = if fFlagLuaAppEdpMediaGalleryAutoAdvance then v5.DarkMode.Content.Emphasis else nil

	local white = if fFlagLuaAppMediaGalleryPageIndicatorOpacity then v5.Color.Extended.White else nil

	local state, setState = React.useState(props.mediaGalleryStartIndex)
	local state2, setState2 = React.useState(props.mediaGalleryStartIndex)

	local state3, setState3 = React.useState(1)
	local v8, v9 = React.useBinding(Vector2.new(0, 0))

	local state4, setState4 = React.useState(false)
	local v10, v11 = React.useBinding(0)

	local ref = React.useRef({})

	local v12 = math.min(props.numberOfItems, defineFastInt)

	local v13 = React.useMemo(function()
		return (v12 - 1) * (size_200 + v7) + v6
	end, { v12, size_200, v7, v6 })

	local v14 = React.useCallback(function(p2)
		return Vector2.new((p2 - 1) * (size_200 + v7), 0)
	end, { size_200, v7 })

	local v15 = React.useCallback(function(p2)
		local v16 = math.min(state3 + v12 - 1, props.numberOfItems)
		local v17 = state3 > 1
		local v18 = v16 < props.numberOfItems

		if p2 == state then
			return UDim2.fromOffset(v6, size_200)
		end

		if v17 then
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

		if v18 then
			if v16 < p2 then
				return UDim2.fromOffset(0, 0)
			end

			if p2 == v16 then
				return UDim2.fromOffset(size_100, size_100)
			end

			if p2 == v16 - 1 then
				return UDim2.fromOffset(size_150, size_150)
			end
		end

		return UDim2.fromOffset(size_200, size_200)
	end, { props.numberOfItems, v12, state3, state, size_100, size_150, size_200, v6 })

	React.useEffect(function()
		local numberOfItems = props.numberOfItems
		local mediaGalleryStartIndex = props.mediaGalleryStartIndex
		local v16 = not (defineFastInt < numberOfItems) and 1
			or math.max(1, math.min(mediaGalleryStartIndex, numberOfItems - 2) - defineFastInt + 2 + 1)

		v9(v14(v16))
		setState3(v16)
		v11(1)
		setState(props.mediaGalleryStartIndex)
	end, { props.numberOfItems, props.mediaGalleryStartIndex, v14 })

	React.useEffect(function()
		local function handleMediaGalleryScrolled(p2)
			setState(function(p3)
				local v16

				if p3 < p2 then
					local numberOfItems = props.numberOfItems
					v16 = not (defineFastInt < numberOfItems) and 1
						or math.max(1, math.min(p2, numberOfItems - 2) - defineFastInt + 2 + 1)
				else
					local numberOfItems = props.numberOfItems
					v16 = not (defineFastInt < numberOfItems) and 1
						or math.min(numberOfItems - defineFastInt + 1, math.max(p2, 3) - 2)
				end

				setState2(p3)
				setState3(v16)
				setState4(true)

				return p2
			end)
		end

		local mediaGalleryScrolledSignalConnection = props.mediaGalleryScrolledSignal:connect(function(p2)
			setState(function(p3)
				local v16

				if p3 < p2 then
					local numberOfItems = props.numberOfItems
					v16 = not (defineFastInt < numberOfItems) and 1
						or math.max(1, math.min(p2, numberOfItems - 2) - defineFastInt + 2 + 1)
				else
					local numberOfItems = props.numberOfItems
					v16 = not (defineFastInt < numberOfItems) and 1
						or math.min(numberOfItems - defineFastInt + 1, math.max(p2, 3) - 2)
				end

				setState2(p3)
				setState3(v16)
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
		local v16 = if props.useSpring then Otter.spring(1, props.springConfig) else Otter.instant(1)
		singleMotor:setGoal(v16)

		local value = v8:getValue()
		local v17 = v14(state3)

		singleMotor:onStep(function(p2)
			v11(p2)
			v9(value:Lerp(v17, p2))
		end)

		singleMotor:onComplete(function()
			setState4(false)
		end)
		return function()
			singleMotor:destroy()
		end
	end, { props.useSpring, props.springConfig, state4, state3, v8, v14 })

	local useMemo = React.useMemo
	local function fn()
		local children = {}

		for i = 1, props.numberOfItems do
			local v16 = ref.current[i]
			local v17 = v15(i)
			local v18

			if fFlagLuaAppMediaGalleryPageIndicatorOpacity then
				if i == state then
					if fFlagLuaAppEdpMediaGalleryAutoAdvance and props.currentItemProgressBinding then
						v18 = muted
					else
						v18 = white.White_100
					end
				else
					v18 = white.White_20
				end
			else
				v18 = muted
			end

			local v19 = "Indicator" .. i
			local createElement = React.createElement
			local fromOffset = UDim2.fromOffset
			local v22 = if i == state then v6 else size_200
			local v21 = {
				Size = fromOffset(v22, size_200),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i
			}

			local createElement2 = React.createElement
			local v24 = {
				AnchorPoint = getDotAnchorPointAtIndex(i, state2, state),
				Position = getDotPositionAtIndex(i, state2, state),
				Size = v10:map(function(p2)
					if v16 == nil then
						return v17
					end

					return v16:Lerp(v17, p2)
				end),
				BackgroundColor3 = v18.Color3,
				BackgroundTransparency = v18.Transparency,
				BorderSizePixel = 0
			}

			local v25 = {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				ProgressBar = 0
			}
			local v26

			if
				fFlagLuaAppEdpMediaGalleryAutoAdvance
				and i == state
				and props.currentItemProgressBinding
			then
				v26 = React.createElement("Frame", {
					Size = props.currentItemProgressBinding:map(function(p2)
						return UDim2.fromOffset(size_200 + p2 * (v6 - size_200), size_200)
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

			v25.ProgressBar = v26
			children[v19] = createElement("Frame", v21, {
				Dot = createElement2("Frame", v24, v25)
			})

			ref.current[i] = v17
		end

		return children
	end

	local numberOfItems = props.numberOfItems
	local currentItemProgressBinding = if fFlagLuaAppEdpMediaGalleryAutoAdvance then props.currentItemProgressBinding else nil
	local v17 = if fFlagLuaAppEdpMediaGalleryAutoAdvance then emphasis else nil
	local v19 = useMemo(fn, {
		numberOfItems,
		currentItemProgressBinding,
		state2,
		state,
		v15,
		size_200,
		v6,
		muted,
		v17,
		v10,
		if fFlagLuaAppMediaGalleryPageIndicatorOpacity then white else nil
	})

	return React.createElement("ScrollingFrame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = UDim2.fromOffset(v13, 0),
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
		CanvasPosition = v8,
		Selectable = false
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v7),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Items = React.createElement(React.Fragment, {}, v19)
	})
end

return MediaGalleryPageIndicators
