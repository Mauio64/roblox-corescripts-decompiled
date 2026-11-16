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

local function ScrollingFrame(props)
	local v = useVirtualizedList(props)

	local v2 = React.useCallback(function(p)
		v.setWindowSize(p.AbsoluteWindowSize)

		if props.onAbsoluteWindowSizeChanged ~= nil then
			props.onAbsoluteWindowSizeChanged(p.AbsoluteWindowSize)
		end
	end, { props.direction, props.onAbsoluteWindowSizeChanged })

	local v3 = React.useCallback(function(p)
		local v3

		if props.direction == "x" then
			v3 = p.CanvasPosition.X
		elseif props.direction == "y" then
			v3 = p.CanvasPosition.Y
		else
			v3 = exhaustiveMatch(props.direction)
		end

		RunService.Heartbeat:Once(function()
			v.setScrollAxis(v3)

			if props.onScrollAxisChanged ~= nil then
				props.onScrollAxisChanged(v3)
			end
		end)
	end, { props.direction, props.onScrollAxisChanged })

	local v4 = {
		Size = UDim2.fromScale(1, 1),
		CanvasSize = v.canvasSizeBinding,
		[React.Change.AbsoluteWindowSize] = v2,
		[React.Change.CanvasPosition] = v3,
		[React.Tag] = props.tag,
		ref = props.scrollingFrameRef
	}

	if props.native ~= nil then
		for k, v5 in props.native do
			if v4[k] ~= nil then
				error(`{k} is already used by UltimateList`)
			end

			v4[k] = v5
		end
	end

	return createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, {
		ScrollingFrame = createElement("ScrollingFrame", v4),
		RendererOverlay = createElement(RendererOverlay, {
			dimensions = props.dimensions,
			renderer = props.renderer,
			getKey = props.getKey,
			direction = props.direction,
			virtualizedListController = v.virtualizedListController,
			windowSizeBinding = v.windowSizeBinding,
			scrollAxisBinding = v.scrollAxisBinding
		})
	})
end

return ScrollingFrame
