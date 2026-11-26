local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCompat")

local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews")
local useCollectionLayout = CollectionViews.useCollectionLayout
local calculateItemWidth = CollectionViews.calculateItemWidth

local sduiPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiPlaceholder

local usePreferredTextSizeLineBudget = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").usePreferredTextSizeLineBudget

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = SharedFlags.FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx
local fFlagSduiCollectionCarouselPlaceholderItem = SharedFlags.FFlagSduiCollectionCarouselPlaceholderItem
local fFlagSduiPreferredTextSizeLineBudgets = SharedFlags.FFlagSduiPreferredTextSizeLineBudgets

local defineFastInt = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMinWidthPct", 30)

local defineFastInt2 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMaxWidthPct", 60)

local udim = UDim.new(1, 72)

local function SduiCollectionCarouselItemPlaceholderRow(props)
	local v5 = React.useMemo(function()
		return props.itemSizeBinding:map(function(p2)
			return UDim2.new(0, p2.X, 0, p2.Y)
		end)
	end, { props.itemSizeBinding })

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, props.gutter)
		})
	}

	local v6 = if props.carouselPeek > 0 then props.itemsPerRow + 1 else props.itemsPerRow

	for i = 1, v6 do
		children[`Item{i}`] = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = i,
				Size = v5
			},
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
	local v5 = useTokens()
	local scale = v5.Config.UI.Scale
	local v6

	if fFlagSduiPreferredTextSizeLineBudgets then
		v6 = usePreferredTextSizeLineBudget(props.preferredTextSizeLineCount)
	else
		v6 = nil
	end

	local v7 = useCollectionLayout(props.collectionItemSize)

	local v8 = SignalsReact.useSignalBinding(v7.getContainerWidth)

	local itemHeightFromWidth = props.itemHeightFromWidth or udim
	local v9 = nil
	local v10

	if fFlagSduiCollectionCarouselPlaceholderItem then
		local function fn()
			return v8:map(function(p2)
				local v11 = calculateItemWidth(v7.itemsPerRow, v7.gutter, v7.margin, p2, 0, v7.carouselPeek)

				local v12 = v11 * itemHeightFromWidth.Scale + itemHeightFromWidth.Offset * scale + (v6 or 0)

				return Vector2.new(v11, (math.max(v12, 0)))
			end)
		end

		v9 = React.useMemo(fn, {
			v8,
			v7.itemsPerRow,
			v7.gutter,
			v7.margin,
			v7.carouselPeek,
			itemHeightFromWidth,
			scale,
			if fFlagSduiPreferredTextSizeLineBudgets then v6 else nil
		})

		v10 = React.useMemo(function()
			return v9:map(function(p2)
				return UDim2.new(1, 0, 0, p2.Y)
			end)
		end, { v9 })
	else
		local function fn()
			return v8:map(function(p2)
				local v11 = calculateItemWidth(v7.itemsPerRow, v7.gutter, v7.margin, p2, 0, v7.carouselPeek) * itemHeightFromWidth.Scale + itemHeightFromWidth.Offset * scale + (v6 or 0)
				return UDim2.new(1, 0, 0, (math.max(v11, 0)))
			end)
		end

		v10 = React.useMemo(fn, {
			v8,
			v7.itemsPerRow,
			v7.gutter,
			v7.margin,
			v7.carouselPeek,
			itemHeightFromWidth,
			scale,
			if fFlagSduiPreferredTextSizeLineBudgets then v6 else nil
		})
	end

	local v11 = fFlagSduiCollectionCarouselPlaceholderItem and props.hideHeader and 0 or v5.Padding.Medium

	local v12 = React.useMemo(function()
		local v13 = defineFastInt / 100
		local v14 = defineFastInt2 / 100
		return v13 + math.random() * (v14 - v13)
	end, {})

	local createElement = React.createElement
	local v14 = {
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
	local v15 = if props.testId then `data-testid={props.testId}` else nil
	v14[tag] = v15
	local v16 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v11)
		}),
		Header = 0,
		Row = 0
	}

	local v17 = if not (fFlagSduiCollectionCarouselPlaceholderItem and props.hideHeader) then React.createElement(sduiPlaceholder, {
		backgroundStyle = props.backgroundStyle,
		cornerRadius = props.cornerRadius,
		layoutOrder = 1,
		size = UDim2.new(v12, 0, 0, fIntLuaAppSduiCarouselPlaceholderHeaderHeightPx * scale),
		transparencyBinding = props.transparencyBinding
	}) else nil
	v16.Header = v17

	local v18 = if fFlagSduiCollectionCarouselPlaceholderItem and props.itemPlaceholderComponent then React.createElement(
		SduiCollectionCarouselItemPlaceholderRow,
		{
			carouselPeek = v7.carouselPeek,
			gutter = v7.gutter,
			itemPlaceholderComponent = props.itemPlaceholderComponent,
			itemSizeBinding = v9,
			itemsPerRow = v7.itemsPerRow,
			layoutOrder = 2,
			rowSizeBinding = v10,
			transparencyBinding = props.transparencyBinding
		}
	) else React.createElement(sduiPlaceholder, {
		backgroundStyle = props.backgroundStyle,
		cornerRadius = props.cornerRadius,
		layoutOrder = 2,
		size = v10,
		transparencyBinding = props.transparencyBinding
	})
	v16.Row = v18
	return createElement("Frame", v14, v16)
end

return React.memo(SduiCollectionCarouselPlaceholder)
