local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
require(parent.AppCommonLib)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local CollectionViews = require(parent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local CollectionLayoutStoreContext = CollectionViews.CollectionLayoutStoreContext
local createColumnSpanCollectionLayoutStore = CollectionViews.createColumnSpanCollectionLayoutStore
local getMainCollectionLayoutStore = CollectionViews.getMainCollectionLayoutStore
local useCollectionLayout = CollectionViews.useCollectionLayout

require(parent.SduiCoreSystem)

local getCollectionSlotsLayout = require(script.Parent.getCollectionSlotsLayout)

local function LayoutSlot(props)
	local v, v2 = React.useMemo(function()
		return Signals.createSignal(0)
	end, {})
	local v3, v4 = React.useBinding(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v2(p.AbsoluteSize.X)
		v4(p.AbsoluteSize.Y)
	end, { v2 })

	local getColumnFraction = props.getColumnFraction
	local v5 = React.useMemo(function()
		if getColumnFraction then
			return createColumnSpanCollectionLayoutStore(props.parentStore, getColumnFraction, v)
		end

		return props.parentStore
	end, { props.parentStore, getColumnFraction, v })

	local name = props.name
	local verticalOverflow = props.verticalOverflow
	local function getSlotLayout(p) -- 6 equivalent calls inferred from this helper
		return p[name]
	end

	local element = React.createElement(View, {
		Position = props.layoutBinding:map(function(p)
			local position = getSlotLayout(p).position -- inferred equivalent call

			if verticalOverflow then
				return position + UDim2.fromOffset(0, verticalOverflow)
			end

			return position
		end),
		Size = props.layoutBinding:map(function(p)
			return getSlotLayout(p).size -- inferred equivalent call
		end),
		tag = props.tag,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		testId = `--sdui-collection-slots-layout-{name}`
	}, {
		Provider = React.createElement(CollectionLayoutStoreContext.Provider, { value = v5 }, props.children)
	})

	if verticalOverflow then
		return React.createElement(View, {
			Position = props.layoutBinding:map(function(p)
				return getSlotLayout(p).clipPosition -- inferred equivalent call
			end),
			Size = props.layoutBinding:map(function(p)
				return UDim2.fromScale(getSlotLayout(p).clipSize.X.Scale, 0) -- inferred equivalent call
			end),
			tag = "col auto-y",
			testId = `--sdui-collection-slots-layout-{name}-overflow`
		}, {
			Box = React.createElement(View, {
				Size = v3:map(function(p: number)
					return UDim2.new(1, 0, 0, p)
				end)
			}, {
				Clip = React.createElement(View, {
					Position = UDim2.fromOffset(0, -verticalOverflow),
					Size = v3:map(function(p: number)
						return UDim2.new(1, 0, 0, p + 2 * verticalOverflow)
					end),
					tag = props.overflowClipTag,
					testId = `--sdui-collection-slots-layout-{name}-clip`
				}, { Slot = element })
			})
		})
	end

	return React.createElement(View, {
		Position = props.layoutBinding:map(function(p)
			return getSlotLayout(p).clipPosition -- inferred equivalent call
		end),
		Size = props.layoutBinding:map(function(p)
			return getSlotLayout(p).clipSize -- inferred equivalent call
		end),
		tag = props.clipTag,
		testId = `--sdui-collection-slots-layout-{name}-clip`
	}, { Slot = element })
end

local function cloneSlotElement(p, extraLocalProps) -- 3 equivalent calls inferred from this helper
	if p then
		return (React.cloneElement(p, { extraLocalProps = extraLocalProps }))
	end

	return nil
end

local function SduiCollectionSlotsLayout(props)
	local v, v2 = React.useBinding(Vector2.zero)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v2(p.AbsoluteSize)
	end, {})
	local ref = React.useCallback(function(p)
		if p then
			v2(p.AbsoluteSize)
		end
	end, {})
	local v3

	if props.leadingCollectionItemSize and CollectionItemSize[props.leadingCollectionItemSize] then
		v3 = props.leadingCollectionItemSize
	else
		v3 = CollectionItemSize.Small
	end

	local v4

	if props.trailingCollectionItemSize and CollectionItemSize[props.trailingCollectionItemSize] then
		v4 = props.trailingCollectionItemSize
	else
		v4 = CollectionItemSize.Small
	end

	local parentStore = React.useContext(CollectionLayoutStoreContext) or getMainCollectionLayoutStore(false)
	local v5 = useCollectionLayout(v3)
	local v6 = useCollectionLayout(v4)
	local itemsPerRow = v5.itemsPerRow
	local itemsPerRow2 = v6.itemsPerRow
	local gutter = v5.gutter
	local carouselPeek = v5.carouselPeek or 0
	local margin = v5.margin

	local v7 = props.leading ~= nil
	local v8 = props.trailing ~= nil
	local v9 = not v7 and 0 or math.floor(props.leadingColumns or 0)
	local v10 = not v8 and 0 or math.floor(props.trailingColumns or 0)
	local v11 = v9 / itemsPerRow + v10 / itemsPerRow2
	local v12 = 1 / math.max(itemsPerRow, itemsPerRow2)

	if v7 or v8 then
		if v7 and not (v9 >= 1) or v8 and not (v10 >= 1) then
			v8 = false
		else
			v8 = v11 <= 1 - v12 + 1e-6
		end
	end

	local mapped = v:map(function(vector2: Vector2)
		return getCollectionSlotsLayout(vector2.X, {
			leadingColumns = not v8 and 0 or v9,
			leadingNumColumns = itemsPerRow,
			trailingColumns = not v8 and 0 or v10,
			trailingNumColumns = itemsPerRow2,
			columnGap = gutter,
			sideMargin = 0,
			fractionalItemAmount = 0,
			carouselPeek = carouselPeek,
			bleed = margin,
			hoverOverflow = not props.enableHoverOverflow and 0 or gutter / 2
		})
	end)

	local getColumnFraction = React.useCallback(function(p)
		return v9 / parentStore.getItemsPerRow[v3](p)
	end, { parentStore, v3, v9 })
	local getColumnFraction2 = React.useCallback(function(p)
		return v10 / parentStore.getItemsPerRow[v4](p)
	end, { parentStore, v4, v10 })
	local getColumnFraction3 = React.useCallback(function(p)
		return 1 - getColumnFraction(p) - getColumnFraction2(p)
	end, { getColumnFraction, getColumnFraction2 })

	local v13 = React.useMemo(function()
		local function getExtraLocalProps(sideMargin: number?)
			local extraLocalProps = {
				appCompositionEnabled = true,
				scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				startRow = props.startRow,
				numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions,
				index = props.index,
				selectionOrderBase = props.selectionOrderBase,
				sideMargin = sideMargin,
				pageSideMargin = 0,
				shouldUseFrameBoundsForImpressions = 0,
				respectClipAncestors = 0
			}
			local pageSideMargin

			if not v8 then
				pageSideMargin = props.pageSideMargin
			end

			extraLocalProps.pageSideMargin = pageSideMargin
			extraLocalProps.shouldUseFrameBoundsForImpressions = v8 and true or nil
			extraLocalProps.respectClipAncestors = v8 and true or nil
			return extraLocalProps
		end

		local leading

		if v8 then
			leading = cloneSlotElement(props.leading, getExtraLocalProps(0)) -- inferred equivalent call
		end

		local v13 = {
			leading = leading,
			content = cloneSlotElement(props.content, getExtraLocalProps(nil)), -- inferred equivalent call
			trailing = 0
		}
		local trailing

		if v8 then
			trailing = cloneSlotElement(props.trailing, getExtraLocalProps(0)) -- inferred equivalent call
		end

		v13.trailing = trailing
		return v13
	end, {
		props.leading,
		props.content,
		props.trailing,
		v8,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.index,
		props.selectionOrderBase,
		props.pageSideMargin
	})

	local createElement = React.createElement
	local leading

	if v8 and v9 > 0 then
		leading = React.createElement(LayoutSlot, {
			name = "leading",
			layoutBinding = mapped,
			parentStore = parentStore,
			getColumnFraction = getColumnFraction,
			clipTag = "clip",
			tag = "col align-y-center"
		}, { Item = v13.leading })
	end

	local createElement2 = React.createElement
	local v14 = {
		name = "content",
		layoutBinding = mapped,
		parentStore = parentStore,
		getColumnFraction = nil,
		clipTag = nil,
		overflowClipTag = nil,
		tag = "col auto-y",
		verticalOverflow = 0
	}

	if not v8 then
		getColumnFraction3 = nil
	end

	v14.getColumnFraction = getColumnFraction3
	v14.clipTag = v8 and "auto-y clip" or "auto-y"
	v14.overflowClipTag = v8 and "clip" or nil

	v14.verticalOverflow = props.enableHoverOverflow and 500 or nil
	local v15 = {
		Leading = leading,
		Content = createElement2(LayoutSlot, v14, { Item = v13.content }),
		Trailing = 0
	}
	local trailing

	if v8 and v10 > 0 then
		trailing = React.createElement(LayoutSlot, {
			name = "trailing",
			layoutBinding = mapped,
			parentStore = parentStore,
			getColumnFraction = getColumnFraction2,
			clipTag = "clip",
			tag = "col align-y-center"
		}, { Item = v13.trailing })
	end

	v15.Trailing = trailing
	local v16 = {
		Row = createElement(
			View,
			{ tag = "size-full-0 auto-y", ref = ref, onAbsoluteSizeChanged = onAbsoluteSizeChanged },
			v15
		)
	}

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		testId = props.testId or "--sdui-collection-slots-layout"
	}, v16)
end

return React.memo(SduiCollectionSlotsLayout)
