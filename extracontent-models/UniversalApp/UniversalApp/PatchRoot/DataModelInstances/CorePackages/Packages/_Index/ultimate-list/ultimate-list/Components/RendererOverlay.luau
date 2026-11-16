local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(ultimatelist.Dimensions)
local React = require(ultimatelist.Parent.React)
local ReactBindingsRenderer = require(ultimatelist.Renderers.ReactBindingsRenderer)
local ReactStateRenderer = require(ultimatelist.Renderers.ReactStateRenderer)
require(ultimatelist.Renderers)
require(ultimatelist.createVirtualizedListController)
local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)

local createElement = React.createElement

local function RendererOverlay(props)
	local v = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = props.positionBinding,
		Size = props.windowSizeBinding:map(function(vector2: Vector2)
			if props.fillNonDominantAxis ~= true then
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end

			if props.direction == "x" then
				return (UDim2.new(0, vector2.X, 1, 0))
			end

			if props.direction == "y" then
				return (UDim2.new(1, 0, 0, vector2.Y))
			end

			return (exhaustiveMatch(props.direction))
		end),
		ZIndex = 2
	}
	local renderer

	if props.renderer.type == "byState" then
		renderer = createElement(ReactStateRenderer, {
			virtualizedListController = props.virtualizedListController,
			config = props.renderer.config,
			dimensions = props.dimensions,
			direction = props.direction,
			callback = props.renderer.callback,
			getKey = props.getKey,
			scrollAxisBinding = props.scrollAxisBinding
		})
	elseif props.renderer.type == "byBinding" then
		renderer = createElement(ReactBindingsRenderer, {
			virtualizedListController = props.virtualizedListController,
			scrollAxisBinding = props.scrollAxisBinding,
			dimensions = props.dimensions,
			direction = props.direction,
			callback = props.renderer.callback,
			getKey = props.getKey
		})
	else
		renderer = exhaustiveMatch(props.renderer.type)
	end

	return createElement("Frame", v, { Renderer = renderer })
end

return RendererOverlay
