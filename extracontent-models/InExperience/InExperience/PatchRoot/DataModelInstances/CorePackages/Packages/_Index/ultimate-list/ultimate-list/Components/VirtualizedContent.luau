local RunService = game:GetService("RunService")
local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(ultimatelist.DataSources)
require(ultimatelist.Dimensions)
local React = require(ultimatelist.Parent.React)
local RendererOverlay = require(script.Parent.RendererOverlay)
require(ultimatelist.Renderers)
local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)
local useVirtualizedList = require(script.Parent.useVirtualizedList)

local createElement = React.createElement

local function getScrollAxis(canvasPosition: Vector2, direction: string) -- 1 equivalent call inferred from this helper
	if direction == "x" then
		return canvasPosition.X
	elseif direction == "y" then
		return canvasPosition.Y
	end

	return (exhaustiveMatch(direction))
end

local function getPosition(scrollAxis: number, direction: string) -- 1 equivalent call inferred from this helper
	if direction == "x" then
		return (UDim2.fromOffset(scrollAxis, 0))
	elseif direction == "y" then
		return (UDim2.fromOffset(0, scrollAxis))
	end

	return (exhaustiveMatch(direction))
end

local function getContentSize(udim: UDim2, direction: string)
	if direction == "x" then
		return (UDim2.new(0, udim.X.Offset, 1, 0))
	elseif direction == "y" then
		return (UDim2.new(1, 0, 0, udim.Y.Offset))
	end

	return (exhaustiveMatch(direction))
end

local function VirtualizedContent(props)
	local v = useVirtualizedList(props)
	local positionBinding, v2 = React.useBinding(UDim2.new())

	React.useEffect(function()
		local current = props.scrollingFrameRef.current
		assert(
			current ~= nil,
			"VirtualizedContent requires scrollingFrameRef.current to point to its ancestor ScrollingFrame"
		)

		local v3 = nil
		local v4 = nil

		local function syncMetrics()
			local absoluteWindowSize = current.AbsoluteWindowSize

			if absoluteWindowSize ~= v3 then
				v3 = absoluteWindowSize
				v.setWindowSize(absoluteWindowSize)

				if props.onAbsoluteWindowSizeChanged ~= nil then
					props.onAbsoluteWindowSizeChanged(absoluteWindowSize)
				end
			end

			local scrollAxis = getScrollAxis(current.CanvasPosition, props.direction) -- inferred equivalent call

			v2(getPosition(scrollAxis, props.direction)) -- inferred equivalent call
			v.setScrollAxis(scrollAxis)

			if scrollAxis ~= v4 then
				v4 = scrollAxis

				if props.onScrollAxisChanged ~= nil then
					props.onScrollAxisChanged(scrollAxis)
				end
			end
		end

		local v5 = {
			current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(syncMetrics),
			current:GetPropertyChangedSignal("CanvasPosition"):Connect(syncMetrics),
			RunService.RenderStepped:Connect(syncMetrics)
		}

		syncMetrics()

		return function()
			for _, connection in v5 do
				connection:Disconnect()
			end
		end
	end, {
		props.scrollingFrameRef,
		props.direction,
		props.onAbsoluteWindowSizeChanged,
		props.onScrollAxisChanged,
		v.setWindowSize,
		v.setScrollAxis
	})

	return createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v.canvasSizeBinding:map(function(udim: UDim2)
			return getContentSize(udim, props.direction)
		end)
	}, {
		RendererOverlay = createElement(RendererOverlay, {
			dimensions = props.dimensions,
			renderer = props.renderer,
			getKey = props.getKey,
			direction = props.direction,
			virtualizedListController = v.virtualizedListController,
			windowSizeBinding = v.windowSizeBinding,
			scrollAxisBinding = v.scrollAxisBinding,
			positionBinding = positionBinding,
			fillNonDominantAxis = true
		})
	})
end

return VirtualizedContent
