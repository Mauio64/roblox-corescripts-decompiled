local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local PeopleService = require(parent.PeopleService)

local VirtualizedItem = require(script.Parent.VirtualizedItem)

require(PeopleReactView.Stores.GetScrollingFrameStore)
local GetVirtualizedGridStore = require(PeopleReactView.Stores.GetVirtualizedGridStore)

local fFlagFixVirtualizedGridNumItems = PeopleService.getService("Flags").FFlagFixVirtualizedGridNumItems

local function VirtualizedGrid(props)
	local v = SignalsReact.useSignalState(GetVirtualizedGridStore)
	local v2 = SignalsReact.useSignalState(v.getNumVirtualizedItems)

	local ref = React.useRef(nil)

	local joinBindings = React.joinBindings({
		itemWidth = props.itemWidth,
		itemHeight = props.itemHeight,
		numColumns = props.numColumns
	})

	local size = React.useMemo(function()
		return joinBindings:map(function(p)
			return UDim2.new(
				1,
				0,
				0,
				math.ceil(props.numItems / p.numColumns) * (p.itemHeight + props.gapSize) - props.gapSize
			)
		end)
	end, { props.numItems, props.gapSize })

	React.useEffect(function()
		local v3, absoluteSizeChangedConnection

		if props.scrollingFrameStore and ref.current then
			local function handleCalculateVirtualizedGridLimits()
				v.calculateVirtualizedGridLimits(
					props.scrollingFrameStore.getCanvasPositionY(),
					props.scrollingFrameStore.getAbsoluteSizeY(),
					props.itemWidth:getValue(),
					props.itemHeight:getValue(),
					props.numColumns:getValue(),
					props.gapSize
				)
			end

			if props.onContainerWidthChanged then
				props.onContainerWidthChanged(ref.current.AbsoluteSize.X)
			end

			handleCalculateVirtualizedGridLimits()

			v3 = Signals.createEffect(function(p)
				props.scrollingFrameStore.getCanvasPositionY(p)
				props.scrollingFrameStore.getAbsoluteSizeY(p)
				handleCalculateVirtualizedGridLimits()
			end)

			absoluteSizeChangedConnection = ref.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if props.onContainerWidthChanged then
					props.onContainerWidthChanged(ref.current.AbsoluteSize.X)
				end

				handleCalculateVirtualizedGridLimits()
			end)
		else
			v3 = nil
			absoluteSizeChangedConnection = nil
		end

		return function()
			if v3 then
				v3()
			end

			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { props.onContainerWidthChanged, props.scrollingFrameStore, props.gapSize })

	local children = {}

	if fFlagFixVirtualizedGridNumItems then
		v2 = math.min(v2, props.numItems)
	end

	for i = 1, v2 do
		children["VirtualizedItem_" .. i] = React.createElement(VirtualizedItem, {
			relativeIndex = i,
			getMinVirtualizedIndex = v.getMinVirtualizedIndex,
			getMaxVirtualizedIndex = v.getMaxVirtualizedIndex,
			itemWidth = props.itemWidth,
			itemHeight = props.itemHeight,
			numColumns = props.numColumns,
			gapSize = props.gapSize,
			getElement = props.getElement
		})
	end

	return React.createElement(View, { Size = size, LayoutOrder = props.layoutOrder, ref = ref }, children)
end

return React.memo(VirtualizedGrid)
