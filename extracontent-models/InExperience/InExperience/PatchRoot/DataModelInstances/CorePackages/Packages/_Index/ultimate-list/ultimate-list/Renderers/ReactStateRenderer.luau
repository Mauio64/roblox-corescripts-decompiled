local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(ultimatelist.Dimensions)
local DimensionsMethods = require(ultimatelist.Dimensions.DimensionsMethods)
local React = require(ultimatelist.Parent.React)
require(ultimatelist.Renderers)
local adjustPositionToScrollAxis = require(ultimatelist.Dimensions.adjustPositionToScrollAxis)
require(ultimatelist.createVirtualizedListController)
local joinAndMapBindings = require(ultimatelist.Util.joinAndMapBindings)

local createElement = React.createElement

local function getKeyDefault(_, p: number)
	return (tostring(p))
end

local function ReactStateRenderer(props)
	local state, setState = React.useState(props.virtualizedListController.get)
	local v, v2 = React.useBinding(nil)

	React.useEffect(function()
		local lockedTo = props.virtualizedListController.get()
		setState(lockedTo)

		return props.virtualizedListController.bindToUpdate(function()
			v2({
				lockedTo = lockedTo,
				scrollAxis = props.scrollAxisBinding:getValue()
			})

			lockedTo = props.virtualizedListController.get()
			setState(lockedTo)
		end)
	end, { props.virtualizedListController, props.scrollAxisBinding })

	local getKey = props.getKey or getKeyDefault
	local range = props.virtualizedListController.getRange()
	local children = {}

	for k, v3 in state do
		local v4 = range.X + (k - 1)

		local udimRect = DimensionsMethods.getUDimRect(
			props.dimensions,
			v3,
			v4,
			props.virtualizedListController.getWindowSize(),
			props.direction
		)

		children[getKey(v3, v4)] = createElement("Frame", {
			BackgroundTransparency = 1,
			Position = joinAndMapBindings(function(p: number, p2)
				if props.config.freezeViewWhileScrolling == false or p2 == nil or p2.lockedTo ~= state then
					return adjustPositionToScrollAxis(udimRect.position, p, props.direction)
				end

				return adjustPositionToScrollAxis(udimRect.position, p2.scrollAxis, props.direction)
			end, props.scrollAxisBinding, v),
			Size = udimRect.size
		}, props.callback(v3))
	end

	return createElement(React.Fragment, nil, children)
end

return ReactStateRenderer
