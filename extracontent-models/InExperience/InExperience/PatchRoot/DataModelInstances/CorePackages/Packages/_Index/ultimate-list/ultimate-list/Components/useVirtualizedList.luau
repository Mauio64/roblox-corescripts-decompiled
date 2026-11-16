local ultimatelist = script:FindFirstAncestor("ultimate-list")

require(ultimatelist.DataSources)
require(ultimatelist.Dimensions)
local React = require(ultimatelist.Parent.React)
local createVirtualizedListController = require(ultimatelist.createVirtualizedListController)

local function useVirtualizedList(data)
	local virtualizedListController = React.useState(function()
		return createVirtualizedListController(data.dataSource, data.dimensions, data.direction)
	end)

	React.useEffect(function()
		return function()
			virtualizedListController.destroy()
		end
	end, {})

	local canvasSizeBinding, v = React.useBinding(virtualizedListController.getCanvasSize())
	local windowSizeBinding, v2 = React.useBinding(Vector2.zero)
	local scrollAxisBinding, v3 = React.useBinding(0)

	React.useEffect(function()
		return virtualizedListController.bindToUpdate(function()
			v(virtualizedListController.getCanvasSize())
		end)
	end, { virtualizedListController })

	local setWindowSize = React.useCallback(function(vector2: Vector2)
		v2(vector2)
		virtualizedListController.setWindowSize(vector2)
	end, { virtualizedListController })

	local setScrollAxis = React.useCallback(function(p: number)
		virtualizedListController.setScrollAxis(p)
		v3(p)
	end, { virtualizedListController })

	React.useEffect(function()
		virtualizedListController.setDataSource(data.dataSource)
	end, { data.dataSource })

	React.useEffect(function()
		virtualizedListController.setDimensions(data.dimensions)
	end, { data.dimensions })

	React.useEffect(function()
		virtualizedListController.setOverscan(data.overscan or 0)
	end, { data.overscan })

	return {
		virtualizedListController = virtualizedListController,
		canvasSizeBinding = canvasSizeBinding,
		windowSizeBinding = windowSizeBinding,
		scrollAxisBinding = scrollAxisBinding,
		setWindowSize = setWindowSize,
		setScrollAxis = setScrollAxis
	}
end

return useVirtualizedList
