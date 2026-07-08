local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local SignalsReact = require(Parent.SignalsReact)

require(Parent.SduiCompat)

local CollectionViews = require(Parent.CollectionViews)
local useCollectionLayout = CollectionViews.useCollectionLayout
local calculateItemWidth = CollectionViews.calculateItemWidth
local SduiPlaceholder = require(Parent.SduiSharedContent).SduiPlaceholder
local FFlagSduiCollectionCarouselPlaceholderItem = require(Parent.SharedFlags).FFlagSduiCollectionCarouselPlaceholderItem
local v10 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderHeightPx", 30)
local v11 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMinWidthPct", 30)
local v12 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMaxWidthPct", 60)
local uDim = UDim.new(1, 72)

local function SduiCollectionCarouselItemPlaceholderRow(t1: {[any]: any}) -- line: 51
	-- upvalues: React (copy)
	local v17 = React.useMemo(function() -- line: 52
		-- upvalues: t1 (copy)
		return t1.itemSizeBinding:map(function(vector2: Vector2) -- line: 53
			return UDim2.new(0, vector2.X, 0, vector2.Y)
		end)
	end, { t1.itemSizeBinding })
	local t2 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, t1.gutter)
		})
	}

	for i = 1, if not (t1.carouselPeek > 0) then t1.itemsPerRow else t1.itemsPerRow + 1 do
		t2[`Item{ i }`] = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = i,
			Size = v17
		}, {
			ItemPlaceholder = React.cloneElement(t1.itemPlaceholderComponent, {
				transparencyBinding = t1.transparencyBinding
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = t1.layoutOrder,
		Size = t1.rowSizeBinding
	}, t2)
end
local function SduiCollectionCarouselPlaceholder(t3: {[any]: any}) -- line: 115
	-- upvalues: useTokens (copy), useCollectionLayout (copy), SignalsReact (copy), uDim (copy), FFlagSduiCollectionCarouselPlaceholderItem (copy), React (copy), calculateItemWidth (copy), v11 (copy), v12 (copy), SduiPlaceholder (copy), v10 (copy), SduiCollectionCarouselItemPlaceholderRow (copy)
	local v21 = useTokens()
	local UIScale = v21.Config.UI.Scale
	local v23 = useCollectionLayout(t3.collectionItemSize)
	local v24 = SignalsReact.useSignalBinding(v23.getContainerWidth)
	local v25 = t3.itemHeightFromWidth or uDim
	local u26 = nil
	local v27

	if FFlagSduiCollectionCarouselPlaceholderItem then
		u26 = React.useMemo(function() -- line: 129
			-- upvalues: v24 (copy), calculateItemWidth (copy), v23 (copy), v25 (copy), UIScale (copy)
			return v24:map(function(n1: number) -- line: 130
				-- upvalues: calculateItemWidth (copy), v23 (copy), v25 (copy), UIScale (copy)
				local v34 = calculateItemWidth(v23.itemsPerRow, v23.gutter, v23.margin, n1, 0, v23.carouselPeek)
				local v35 = v34 * v25.Scale + v25.Offset * UIScale

				return Vector2.new(v34, (math.max(v35, 0)))
			end)
		end, {
			v24,
			v23.itemsPerRow,
			v23.gutter,
			v23.margin,
			v23.carouselPeek,
			v25,
			UIScale
		})
		v27 = React.useMemo(function() -- line: 155
			-- upvalues: u26 (ref)
			return u26:map(function(vector2: Vector2) -- line: 156
				return UDim2.new(1, 0, 0, vector2.Y)
			end)
		end, { u26 })
	else
		v27 = React.useMemo(function() -- line: 162
			-- upvalues: v24 (copy), calculateItemWidth (copy), v23 (copy), v25 (copy), UIScale (copy)
			return v24:map(function(n2: number) -- line: 163
				-- upvalues: calculateItemWidth (copy), v23 (copy), v25 (copy), UIScale (copy)
				local v38 = calculateItemWidth(v23.itemsPerRow, v23.gutter, v23.margin, n2, 0, v23.carouselPeek) * v25.Scale + v25.Offset * UIScale

				return UDim2.new(1, 0, 0, (math.max(v38, 0)))
			end)
		end, {
			v24,
			v23.itemsPerRow,
			v23.gutter,
			v23.margin,
			v23.carouselPeek,
			v25,
			UIScale
		})
	end

	local v28 = if not FFlagSduiCollectionCarouselPlaceholderItem or not t3.hideHeader then v21.Padding.Medium else 0
	local v29 = React.useMemo(function() -- line: 194
		-- upvalues: v11 (copy), v12 (copy)
		local v30 = v11 / 100
		local v31 = v12 / 100

		return v30 + math.random() * (v31 - v30)
	end, {})

	return React.createElement("Frame", {
		AnchorPoint = t3.anchorPoint,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t3.layoutOrder,
		Position = t3.position,
		Size = UDim2.fromScale(1, 0),
		ZIndex = t3.zIndex,
		[React.Tag] = if not t3.testId then nil else `data-testid={ t3.testId }`
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v28)
		}),
		Header = if not FFlagSduiCollectionCarouselPlaceholderItem or not t3.hideHeader then React.createElement(SduiPlaceholder, {
			layoutOrder = 1,
			backgroundStyle = t3.backgroundStyle,
			cornerRadius = t3.cornerRadius,
			size = UDim2.new(v29, 0, 0, v10 * UIScale),
			transparencyBinding = t3.transparencyBinding
		}) else nil,
		Row = if not FFlagSduiCollectionCarouselPlaceholderItem or not t3.itemPlaceholderComponent then React.createElement(SduiPlaceholder, {
			layoutOrder = 2,
			backgroundStyle = t3.backgroundStyle,
			cornerRadius = t3.cornerRadius,
			size = v27,
			transparencyBinding = t3.transparencyBinding
		}) else React.createElement(SduiCollectionCarouselItemPlaceholderRow, {
			layoutOrder = 2,
			carouselPeek = v23.carouselPeek,
			gutter = v23.gutter,
			itemPlaceholderComponent = t3.itemPlaceholderComponent,
			itemSizeBinding = u26,
			itemsPerRow = v23.itemsPerRow,
			rowSizeBinding = v27,
			transparencyBinding = t3.transparencyBinding
		})
	})
end

return React.memo(SduiCollectionCarouselPlaceholder)
