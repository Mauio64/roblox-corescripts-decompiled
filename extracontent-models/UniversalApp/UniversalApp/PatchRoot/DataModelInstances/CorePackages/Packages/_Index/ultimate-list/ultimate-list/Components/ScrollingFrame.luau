local RunService = game:GetService("RunService")
local ancestor = script:FindFirstAncestor("ultimate-list")

require(ancestor.DataSources)
require(ancestor.Dimensions)

local React = require(ancestor.Parent.React)
local ReactBindingsRenderer = require(ancestor.Renderers.ReactBindingsRenderer)
local ReactStateRenderer = require(ancestor.Renderers.ReactStateRenderer)

require(ancestor.Renderers)

local createVirtualizedListController = require(ancestor.createVirtualizedListController)
local exhaustiveMatch = require(ancestor.Util.exhaustiveMatch)
local createElement = React.createElement

local function ScrollingFrame(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), createVirtualizedListController (copy), exhaustiveMatch (copy), RunService (copy), createElement (copy), ReactStateRenderer (copy), ReactBindingsRenderer (copy)
	local v11 = React.useState(function() -- line: 34
		-- upvalues: createVirtualizedListController (copy), t1 (copy)
		return createVirtualizedListController(t1.dataSource, t1.dimensions, t1.direction)
	end)

	React.useEffect(function() -- line: 38
		-- upvalues: v11 (copy)
		return function() -- line: 39
			-- upvalues: v11 (copy)
			return v11.destroy()
		end
	end, {})

	local v12, v13 = React.useBinding(v11.getCanvasSize())
	local v14, v15 = React.useBinding(Vector2.zero)
	local v16, v17 = React.useBinding(0)

	React.useEffect(function() -- line: 48
		-- upvalues: v11 (copy), v13 (copy)
		return v11.bindToUpdate(function() -- line: 49
			-- upvalues: v13 (copy), v11 (copy)
			v13(v11.getCanvasSize())
		end)
	end, {})

	local v18 = React.useCallback(function(p1) -- line: 54
		-- upvalues: v15 (copy), v11 (copy), t1 (copy)
		v15(p1.AbsoluteWindowSize)
		v11.setWindowSize(p1.AbsoluteWindowSize)

		if t1.onAbsoluteWindowSizeChanged ~= nil then
			t1.onAbsoluteWindowSizeChanged(p1.AbsoluteWindowSize)
		end
	end, {
		t1.direction,
		t1.onAbsoluteWindowSizeChanged
	})
	local v19 = React.useCallback(function(p2) -- line: 63
		-- upvalues: t1 (copy), exhaustiveMatch (copy), RunService (copy), v11 (copy), v17 (copy)
		local v25 = if t1.direction ~= "x" then if t1.direction ~= "y" then exhaustiveMatch(t1.direction) else p2.CanvasPosition.Y else p2.CanvasPosition.X

		RunService.Heartbeat:Once(function() -- line: 71
			-- upvalues: v11 (copy), v25 (copy), v17 (copy), t1 (copy)
			v11.setScrollAxis(v25)
			v17(v25)

			if t1.onScrollAxisChanged ~= nil then
				t1.onScrollAxisChanged(v25)
			end
		end)
	end, {
		t1.direction,
		t1.onScrollAxisChanged
	})

	React.useEffect(function() -- line: 81
		-- upvalues: v11 (copy), t1 (copy)
		v11.setDataSource(t1.dataSource)
	end, { t1.dataSource })
	React.useEffect(function() -- line: 85
		-- upvalues: v11 (copy), t1 (copy)
		v11.setDimensions(t1.dimensions)
	end, { t1.dimensions })

	local t2 = {
		Size = UDim2.fromScale(1, 1),
		CanvasSize = v12,
		[React.Change.AbsoluteWindowSize] = v18,
		[React.Change.CanvasPosition] = v19,
		[React.Tag] = t1.tag,
		ref = t1.scrollingFrameRef
	}

	if t1.native ~= nil then
		for v21, v22 in t1.native do
			if t2[v21] ~= nil then
				error(`{ v21 } is already used by UltimateList`)
			end

			t2[v21] = v22
		end
	end

	return createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		ScrollingFrame = createElement("ScrollingFrame", t2),
		RendererOverlay = createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			ZIndex = 2,
			Size = v14:map(function(vector2: Vector2) -- line: 124
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end)
		}, {
			Renderer = if t1.renderer.type ~= "byState" then if t1.renderer.type ~= "byBinding" then exhaustiveMatch(t1.renderer.type) else createElement(ReactBindingsRenderer, {
				virtualizedListController = v11,
				scrollAxisBinding = v16,
				dimensions = t1.dimensions,
				direction = t1.direction,
				callback = t1.renderer.callback,
				getKey = t1.getKey
			}) else createElement(ReactStateRenderer, {
				virtualizedListController = v11,
				config = t1.renderer.config,
				dimensions = t1.dimensions,
				direction = t1.direction,
				callback = t1.renderer.callback,
				getKey = t1.getKey,
				scrollAxisBinding = v16
			})
		})
	})
end

return ScrollingFrame
