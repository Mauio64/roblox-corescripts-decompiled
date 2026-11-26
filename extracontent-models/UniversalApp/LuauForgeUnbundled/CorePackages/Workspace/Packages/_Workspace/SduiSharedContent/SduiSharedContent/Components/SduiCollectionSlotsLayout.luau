local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation").View
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/CollectionViews")
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local collectionLayoutStoreContext = CollectionViews.CollectionLayoutStoreContext
local createColumnSpanCollectionLayoutStore = CollectionViews.createColumnSpanCollectionLayoutStore
local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore
local useCollectionLayout = CollectionViews.useCollectionLayout

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")

local getCollectionSlotsLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/getCollectionSlotsLayout")

local function LayoutSlot(props)
	local v5, v6 = React.useMemo(function()
		return Signals.createSignal(0)
	end, {})
	local v7, v8 = React.useBinding(0)
	local v9 = React.useCallback(function(p2)
		v6(p2.AbsoluteSize.X)
		v8(p2.AbsoluteSize.Y)
	end, { v6 })

	local getColumnFraction = props.getColumnFraction
	local v10 = React.useMemo(function()
		if getColumnFraction then
			return createColumnSpanCollectionLayoutStore(props.parentStore, getColumnFraction, v5)
		end

		return props.parentStore
	end, { props.parentStore, getColumnFraction, v5 })

	local name = props.name
	local verticalOverflow = props.verticalOverflow
	local function getSlotLayout(p2)
		return p2[name]
	end

	local element = React.createElement(view, {
		Position = props.layoutBinding:map(function(p2)
			local position = p2[name].position

			if verticalOverflow then
				return position + UDim2.fromOffset(0, verticalOverflow)
			end

			return position
		end),
		Size = props.layoutBinding:map(function(p2)
			return p2[name].size
		end),
		tag = props.tag,
		onAbsoluteSizeChanged = v9,
		testId = `--sdui-collection-slots-layout-{name}`
	}, {
		Provider = React.createElement(
			collectionLayoutStoreContext.Provider,
			{ value = v10 },
			props.children
		)
	})

	if verticalOverflow then
		return React.createElement(view, {
			Position = props.layoutBinding:map(function(p2)
				return p2[name].clipPosition
			end),
			Size = props.layoutBinding:map(function(p2)
				return UDim2.fromScale(p2[name].clipSize.X.Scale, 0)
			end),
			tag = "col auto-y",
			testId = `--sdui-collection-slots-layout-{name}-overflow`
		}, {
			Box = React.createElement(view, {
				Size = v7:map(function(p2)
					return UDim2.new(1, 0, 0, p2)
				end)
			}, {
				Clip = React.createElement(view, {
					Position = UDim2.fromOffset(0, -verticalOverflow),
					Size = v7:map(function(p2)
						return UDim2.new(1, 0, 0, p2 + 2 * verticalOverflow)
					end),
					tag = props.overflowClipTag,
					testId = `--sdui-collection-slots-layout-{name}-clip`
				}, { Slot = element })
			})
		})
	end

	return React.createElement(view, {
		Position = props.layoutBinding:map(function(p2)
			return p2[name].clipPosition
		end),
		Size = props.layoutBinding:map(function(p2)
			return p2[name].clipSize
		end),
		tag = props.clipTag,
		testId = `--sdui-collection-slots-layout-{name}-clip`
	}, { Slot = element })
end

local function cloneSlotElement(p2, p3)
	if p2 then
		return (React.cloneElement(p2, { extraLocalProps = p3 }))
	end

	return nil
end

local function SduiCollectionSlotsLayout(props)
	local v5, v6 = React.useBinding(Vector2.zero)
	local v7 = React.useCallback(function(p2)
		v6(p2.AbsoluteSize)
	end, {})
	local v8 = React.useCallback(function(p2)
		if p2 then
			v6(p2.AbsoluteSize)
		end
	end, {})
	local v9

	if props.leadingCollectionItemSize and collectionItemSize[props.leadingCollectionItemSize] then
		v9 = props.leadingCollectionItemSize
	else
		v9 = collectionItemSize.Small
	end

	local v10

	if props.trailingCollectionItemSize and collectionItemSize[props.trailingCollectionItemSize] then
		v10 = props.trailingCollectionItemSize
	else
		v10 = collectionItemSize.Small
	end

	local v11 = React.useContext(collectionLayoutStoreContext) or getMainCollectionLayoutStore(false)
	local v12 = useCollectionLayout(v9)
	local v13 = useCollectionLayout(v10)
	local itemsPerRow = v12.itemsPerRow
	local itemsPerRow2 = v13.itemsPerRow
	local gutter = v12.gutter
	local carouselPeek = v12.carouselPeek or 0
	local margin = v12.margin

	local v14 = props.leading ~= nil
	local v15 = props.trailing ~= nil
	local v16 = not v14 and 0 or math.floor(props.leadingColumns or 0)
	local v17 = not v15 and 0 or math.floor(props.trailingColumns or 0)
	local v18 = v16 / itemsPerRow + v17 / itemsPerRow2
	local v19 = 1 / math.max(itemsPerRow, itemsPerRow2)

	if v14 or v15 then
		v15 = not (v14 and not (v16 >= 1) or v15 and not (v17 >= 1)) and v18 <= 1 - v19 + 1e-6
	end

	local mapped = v5:map(function(p2)
		return getCollectionSlotsLayout(p2.X, {
			leadingColumns = not v15 and 0 or v16,
			leadingNumColumns = itemsPerRow,
			trailingColumns = not v15 and 0 or v17,
			trailingNumColumns = itemsPerRow2,
			columnGap = gutter,
			sideMargin = 0,
			fractionalItemAmount = 0,
			carouselPeek = carouselPeek,
			bleed = margin,
			hoverOverflow = not props.enableHoverOverflow and 0 or gutter / 2
		})
	end)

	local v20 = React.useCallback(function(p2)
		return v16 / v11.getItemsPerRow[v9](p2)
	end, { v11, v9, v16 })
	local v21 = React.useCallback(function(p2)
		return v17 / v11.getItemsPerRow[v10](p2)
	end, { v11, v10, v17 })
	local v22 = React.useCallback(function(p2)
		return 1 - v20(p2) - v21(p2)
	end, { v20, v21 })

	local v23 = React.useMemo(function()
		local function getExtraLocalProps(p2)
			local extraLocalProps = {
				appCompositionEnabled = true,
				scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				startRow = props.startRow,
				numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions,
				index = props.index,
				selectionOrderBase = props.selectionOrderBase,
				sideMargin = p2,
				pageSideMargin = 0,
				shouldUseFrameBoundsForImpressions = 0,
				respectClipAncestors = 0
			}

			local v24 = if not v15 then props.pageSideMargin else nil
			extraLocalProps.pageSideMargin = v24
			extraLocalProps.shouldUseFrameBoundsForImpressions = v15 and true or nil
			extraLocalProps.respectClipAncestors = v15 and true or nil
			return extraLocalProps
		end

		local v25

		if v15 then
			local leading = props.leading
			local extraLocalProps = getExtraLocalProps(0)

			if leading then
				v25 = React.cloneElement(leading, { extraLocalProps = extraLocalProps })
			end
		end

		local content = props.content
		local extraLocalProps = getExtraLocalProps(nil)
		local v26 = if content then React.cloneElement(content, {
			extraLocalProps = extraLocalProps
		}) else nil
		local v27

		if v15 then
			local trailing = props.trailing
			local extraLocalProps2 = getExtraLocalProps(0)

			if trailing then
				v27 = React.cloneElement(trailing, {
					extraLocalProps = extraLocalProps2
				})
			end
		end

		return { leading = v25, content = v26, trailing = v27 }
	end, {
		props.leading,
		props.content,
		props.trailing,
		v15,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.index,
		props.selectionOrderBase,
		props.pageSideMargin
	})

	local createElement = React.createElement

	local v28 = if v15 and v16 > 0 then React.createElement(LayoutSlot, {
		name = "leading",
		layoutBinding = mapped,
		parentStore = v11,
		getColumnFraction = v20,
		clipTag = "clip",
		tag = "col align-y-center"
	}, { Item = v23.leading }) else nil

	local createElement2 = React.createElement
	local v30 = {
		name = "content",
		layoutBinding = mapped,
		parentStore = v11,
		getColumnFraction = nil,
		clipTag = nil,
		overflowClipTag = nil,
		tag = "col auto-y",
		verticalOverflow = 0
	}

	if not v15 then
		v22 = nil
	end

	v30.getColumnFraction = v22
	v30.clipTag = v15 and "auto-y clip" or "auto-y"
	v30.overflowClipTag = v15 and "clip" or nil

	v30.verticalOverflow = props.enableHoverOverflow and 500 or nil
	local v27 = {
		Leading = v28,
		Content = createElement2(LayoutSlot, v30, { Item = v23.content }),
		Trailing = 0
	}

	local v31 = if v15 and v17 > 0 then React.createElement(LayoutSlot, {
		name = "trailing",
		layoutBinding = mapped,
		parentStore = v11,
		getColumnFraction = v21,
		clipTag = "clip",
		tag = "col align-y-center"
	}, { Item = v23.trailing }) else nil
	v27.Trailing = v31
	local v24 = {
		Row = createElement(view, {
			tag = "size-full-0 auto-y",
			ref = v8,
			onAbsoluteSizeChanged = v7
		}, v27)
	}

	return React.createElement(view, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--sdui-collection-slots-layout"
	}, v24)
end

return React.memo(SduiCollectionSlotsLayout)
