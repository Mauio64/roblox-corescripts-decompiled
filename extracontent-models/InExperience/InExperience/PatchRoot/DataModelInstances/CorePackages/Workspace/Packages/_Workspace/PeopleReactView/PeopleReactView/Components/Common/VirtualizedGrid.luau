local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local Signals = require(PeopleReactViewParent.Signals)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local View = require(PeopleReactViewParent.Foundation).View
local PeopleService = require(PeopleReactViewParent.PeopleService)
local VirtualizedItem = require(script.Parent.VirtualizedItem)

require(PeopleReactView.Stores.GetScrollingFrameStore)

local GetVirtualizedGridStore = require(PeopleReactView.Stores.GetVirtualizedGridStore)
local FFlagFixVirtualizedGridNumItems = PeopleService.getService("Flags").FFlagFixVirtualizedGridNumItems

local function VirtualizedGrid(t1: {[any]: any}) -- line: 38
	-- upvalues: SignalsReact (copy), GetVirtualizedGridStore (copy), React (copy), Signals (copy), FFlagFixVirtualizedGridNumItems (copy), VirtualizedItem (copy), View (copy)
	local v13 = SignalsReact.useSignalState(GetVirtualizedGridStore)
	local v14 = SignalsReact.useSignalState(v13.getNumVirtualizedItems)
	local v15 = React.useRef(nil)
	local v16 = React.joinBindings({
		itemWidth = t1.itemWidth,
		itemHeight = t1.itemHeight,
		numColumns = t1.numColumns
	})
	local v17 = React.useMemo(function() -- line: 51
		-- upvalues: v16 (copy), t1 (copy)
		return v16:map(function(t2: {[any]: any}) -- line: 52
			-- upvalues: t1 (copy)
			return UDim2.new(1, 0, 0, math.ceil(t1.numItems / t2.numColumns) * (t2.itemHeight + t1.gapSize) - t1.gapSize)
		end)
	end, {
		t1.numItems,
		t1.gapSize
	})

	React.useEffect(function() -- line: 62
		-- upvalues: t1 (copy), v15 (copy), v13 (copy), Signals (copy)
		local u20 = nil
		local connection = nil

		if t1.scrollingFrameStore and v15.current then
			local function handleCalculateVirtualizedGridLimits() -- line: 68
				-- upvalues: v13 (copy), t1 (copy)
				v13.calculateVirtualizedGridLimits(t1.scrollingFrameStore.getCanvasPositionY(), t1.scrollingFrameStore.getAbsoluteSizeY(), t1.itemWidth:getValue(), t1.itemHeight:getValue(), t1.numColumns:getValue(), t1.gapSize)
			end

			if t1.onContainerWidthChanged then
				t1.onContainerWidthChanged(v15.current.AbsoluteSize.X)
			end

			handleCalculateVirtualizedGridLimits()
			u20 = Signals.createEffect(function(p1) -- line: 85
				-- upvalues: t1 (copy), handleCalculateVirtualizedGridLimits (copy)
				t1.scrollingFrameStore.getCanvasPositionY(p1)
				t1.scrollingFrameStore.getAbsoluteSizeY(p1)
				handleCalculateVirtualizedGridLimits()
			end)
			connection = v15.current:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 93
				-- upvalues: t1 (copy), v15 (copy), handleCalculateVirtualizedGridLimits (copy)
				if t1.onContainerWidthChanged then
					t1.onContainerWidthChanged(v15.current.AbsoluteSize.X)
				end

				handleCalculateVirtualizedGridLimits()
			end)
		end

		return function() -- line: 102
			-- upvalues: u20 (ref), connection (ref)
			if u20 then
				u20()
			end

			if connection then
				connection:Disconnect()
			end
		end
	end, {
		t1.onContainerWidthChanged,
		t1.scrollingFrameStore,
		t1.gapSize
	})

	local t3 = {}

	for i = 1, if not FFlagFixVirtualizedGridNumItems then v14 else math.min(v14, t1.numItems) do
		t3["VirtualizedItem_" .. i] = React.createElement(VirtualizedItem, {
			relativeIndex = i,
			getMinVirtualizedIndex = v13.getMinVirtualizedIndex,
			getMaxVirtualizedIndex = v13.getMaxVirtualizedIndex,
			itemWidth = t1.itemWidth,
			itemHeight = t1.itemHeight,
			numColumns = t1.numColumns,
			gapSize = t1.gapSize,
			getElement = t1.getElement
		})
	end

	return React.createElement(View, {
		Size = v17,
		LayoutOrder = t1.layoutOrder,
		ref = v15
	}, t3)
end

return React.memo(VirtualizedGrid)
