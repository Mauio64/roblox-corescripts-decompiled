local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(parent.SignalsReact)
require(parent.SduiCompat)

local CollectionViews = require(parent.CollectionViews)
local useCollectionLayout = CollectionViews.useCollectionLayout
local calculateItemWidth = CollectionViews.calculateItemWidth

local SduiSharedContent = require(parent.SduiSharedContent)
local SduiPlaceholder = SduiSharedContent.SduiPlaceholder

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local usePreferredTextSizeLineBudget = SduiSharedUtilities.usePreferredTextSizeLineBudget

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = SharedFlags.FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx
local FFlagSduiCollectionCarouselPlaceholderItem = SharedFlags.FFlagSduiCollectionCarouselPlaceholderItem
local FFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets

local defineFastInt = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMinWidthPct", 30)

local defineFastInt2 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMaxWidthPct", 60)

local udim = UDim.new(1, 72)

local function SduiCollectionCarouselItemPlaceholderRow(props)
	local size = React.useMemo(function()
		return props.itemSizeBinding:map(function(vector2: Vector2)
			return UDim2.new(0, vector2.X, 0, vector2.Y)
		end)
	end, { props.itemSizeBinding })

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, props.gutter)
		})
	}
	local v

	if props.carouselPeek > 0 then
		v = props.itemsPerRow + 1
	else
		v = props.itemsPerRow
	end

	for i = 1, v do
		children[`Item{i}`] = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = i, Size = size },
			{
				ItemPlaceholder = React.cloneElement(props.itemPlaceholderComponent, {
					transparencyBinding = props.transparencyBinding
				})
			}
		)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = props.layoutOrder,
		Size = props.rowSizeBinding
	}, children)
end

local function SduiCollectionCarouselPlaceholder(props)
	local v = useTokens()
	local scale = v.Config.UI.Scale
	local v2

	if FFlagSduiPreferredTextSizeLineBudgets then
		v2 = usePreferredTextSizeLineBudget(props.preferredTextSizeLineCount)
	else
		v2 = nil
	end

	local v3 = useCollectionLayout(props.collectionItemSize)

	local v4 = SignalsReact.useSignalBinding(v3.getContainerWidth)

	local itemHeightFromWidth = props.itemHeightFromWidth or udim
	local itemSizeBinding = nil
	local v5

	if FFlagSduiCollectionCarouselPlaceholderItem then
		local useMemo = React.useMemo
		local function fn()
			return v4:map(function(p: number)
				local v6 = calculateItemWidth(v3.itemsPerRow, v3.gutter, v3.margin, p, 0, v3.carouselPeek)

				local v7 = v6 * itemHeightFromWidth.Scale + itemHeightFromWidth.Offset * scale + (v2 or 0)

				return Vector2.new(v6, (math.max(v7, 0)))
			end)
		end

		local itemsPerRow = v3.itemsPerRow
		local gutter = v3.gutter
		local margin = v3.margin
		local carouselPeek = v3.carouselPeek
		local v6

		if FFlagSduiPreferredTextSizeLineBudgets then
			v6 = v2
		end

		itemSizeBinding = useMemo(fn, {
			v4,
			itemsPerRow,
			gutter,
			margin,
			carouselPeek,
			itemHeightFromWidth,
			scale,
			v6
		})

		v5 = React.useMemo(function()
			return itemSizeBinding:map(function(vector2: Vector2)
				return UDim2.new(1, 0, 0, vector2.Y)
			end)
		end, { itemSizeBinding })
	else
		local useMemo = React.useMemo
		local function fn()
			return v4:map(function(p: number)
				local v6 = calculateItemWidth(v3.itemsPerRow, v3.gutter, v3.margin, p, 0, v3.carouselPeek) * itemHeightFromWidth.Scale + itemHeightFromWidth.Offset * scale + (v2 or 0)
				return UDim2.new(1, 0, 0, (math.max(v6, 0)))
			end)
		end

		local itemsPerRow = v3.itemsPerRow
		local gutter = v3.gutter
		local margin = v3.margin
		local carouselPeek = v3.carouselPeek
		local v6

		if FFlagSduiPreferredTextSizeLineBudgets then
			v6 = v2
		end

		v5 = useMemo(fn, {
			v4,
			itemsPerRow,
			gutter,
			margin,
			carouselPeek,
			itemHeightFromWidth,
			scale,
			v6
		})
	end

	local v6 = FFlagSduiCollectionCarouselPlaceholderItem and props.hideHeader and 0 or v.Padding.Medium

	local v7 = React.useMemo(function()
		local v7 = defineFastInt / 100
		local v8 = defineFastInt2 / 100
		return v7 + math.random() * (v8 - v7)
	end, {})

	local createElement = React.createElement
	local v8 = {
		["AnchorPoint"] = nil,
		AnchorPoint = props.anchorPoint,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Size = UDim2.fromScale(1, 0),
		ZIndex = props.zIndex
	}
	local tag = React.Tag
	local v9

	if props.testId then
		v9 = `data-testid={props.testId}`
	end

	v8[tag] = v9
	local v10 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v6)
		}),
		Header = 0,
		Row = 0
	}
	local header

	if not (FFlagSduiCollectionCarouselPlaceholderItem and props.hideHeader) then
		header = React.createElement(SduiPlaceholder, {
			backgroundStyle = props.backgroundStyle,
			cornerRadius = props.cornerRadius,
			layoutOrder = 1,
			size = UDim2.new(v7, 0, 0, FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx * scale),
			transparencyBinding = props.transparencyBinding
		})
	end

	v10.Header = header
	local row

	if FFlagSduiCollectionCarouselPlaceholderItem and props.itemPlaceholderComponent then
		row = React.createElement(SduiCollectionCarouselItemPlaceholderRow, {
			carouselPeek = v3.carouselPeek,
			gutter = v3.gutter,
			itemPlaceholderComponent = props.itemPlaceholderComponent,
			itemSizeBinding = itemSizeBinding,
			itemsPerRow = v3.itemsPerRow,
			layoutOrder = 2,
			rowSizeBinding = v5,
			transparencyBinding = props.transparencyBinding
		})
	else
		row = React.createElement(SduiPlaceholder, {
			backgroundStyle = props.backgroundStyle,
			cornerRadius = props.cornerRadius,
			layoutOrder = 2,
			size = v5,
			transparencyBinding = props.transparencyBinding
		})
	end

	v10.Row = row
	return createElement("Frame", v8, v10)
end

return React.memo(SduiCollectionCarouselPlaceholder)
