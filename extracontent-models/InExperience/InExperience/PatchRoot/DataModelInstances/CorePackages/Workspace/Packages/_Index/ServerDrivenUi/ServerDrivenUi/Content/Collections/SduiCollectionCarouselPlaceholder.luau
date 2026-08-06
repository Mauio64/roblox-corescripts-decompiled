local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local SignalsReact = require(Parent.SignalsReact)

require(Parent.SduiCompat)

local CollectionViews = require(Parent.CollectionViews)
local useCollectionLayout = CollectionViews.useCollectionLayout
local calculateItemWidth = CollectionViews.calculateItemWidth
local SduiPlaceholder = require(Parent.SduiSharedContent).SduiPlaceholder
local SharedFlags = require(Parent.SharedFlags)
local FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx = SharedFlags.FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx
local FFlagSduiCollectionCarouselPlaceholderItem = SharedFlags.FFlagSduiCollectionCarouselPlaceholderItem
local v12 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMinWidthPct", 30)
local v13 = game:DefineFastInt("LuaAppSduiCarouselPlaceholderHeaderMaxWidthPct", 60)
local uDim = UDim.new(1, 72)

local function SduiCollectionCarouselItemPlaceholderRow(t1: {[any]: any}) -- line: 50
	-- upvalues: React (copy)
	local v18 = React.useMemo(function() -- line: 51
		-- upvalues: t1 (copy)
		return t1.itemSizeBinding:map(function(vector2: Vector2) -- line: 52
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
			Size = v18
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
local function SduiCollectionCarouselPlaceholder(t3: {[any]: any}) -- line: 114
	-- upvalues: useTokens (copy), useCollectionLayout (copy), SignalsReact (copy), uDim (copy), FFlagSduiCollectionCarouselPlaceholderItem (copy), React (copy), calculateItemWidth (copy), v12 (copy), v13 (copy), SduiPlaceholder (copy), FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx (copy), SduiCollectionCarouselItemPlaceholderRow (copy)
	local v22 = useTokens()
	local UIScale = v22.Config.UI.Scale
	local v24 = useCollectionLayout(t3.collectionItemSize)
	local v25 = SignalsReact.useSignalBinding(v24.getContainerWidth)
	local v26 = t3.itemHeightFromWidth or uDim
	local u27 = nil
	local v28

	if FFlagSduiCollectionCarouselPlaceholderItem then
		u27 = React.useMemo(function() -- line: 128
			-- upvalues: v25 (copy), calculateItemWidth (copy), v24 (copy), v26 (copy), UIScale (copy)
			return v25:map(function(n1: number) -- line: 129
				-- upvalues: calculateItemWidth (copy), v24 (copy), v26 (copy), UIScale (copy)
				local v35 = calculateItemWidth(v24.itemsPerRow, v24.gutter, v24.margin, n1, 0, v24.carouselPeek)
				local v36 = v35 * v26.Scale + v26.Offset * UIScale

				return Vector2.new(v35, (math.max(v36, 0)))
			end)
		end, {
			v25,
			v24.itemsPerRow,
			v24.gutter,
			v24.margin,
			v24.carouselPeek,
			v26,
			UIScale
		})
		v28 = React.useMemo(function() -- line: 154
			-- upvalues: u27 (ref)
			return u27:map(function(vector2: Vector2) -- line: 155
				return UDim2.new(1, 0, 0, vector2.Y)
			end)
		end, { u27 })
	else
		v28 = React.useMemo(function() -- line: 161
			-- upvalues: v25 (copy), calculateItemWidth (copy), v24 (copy), v26 (copy), UIScale (copy)
			return v25:map(function(n2: number) -- line: 162
				-- upvalues: calculateItemWidth (copy), v24 (copy), v26 (copy), UIScale (copy)
				local v39 = calculateItemWidth(v24.itemsPerRow, v24.gutter, v24.margin, n2, 0, v24.carouselPeek) * v26.Scale + v26.Offset * UIScale

				return UDim2.new(1, 0, 0, (math.max(v39, 0)))
			end)
		end, {
			v25,
			v24.itemsPerRow,
			v24.gutter,
			v24.margin,
			v24.carouselPeek,
			v26,
			UIScale
		})
	end

	local v29 = if not FFlagSduiCollectionCarouselPlaceholderItem or not t3.hideHeader then v22.Padding.Medium else 0
	local v30 = React.useMemo(function() -- line: 193
		-- upvalues: v12 (copy), v13 (copy)
		local v31 = v12 / 100
		local v32 = v13 / 100

		return v31 + math.random() * (v32 - v31)
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
			Padding = UDim.new(0, v29)
		}),
		Header = if not FFlagSduiCollectionCarouselPlaceholderItem or not t3.hideHeader then React.createElement(SduiPlaceholder, {
			layoutOrder = 1,
			backgroundStyle = t3.backgroundStyle,
			cornerRadius = t3.cornerRadius,
			size = UDim2.new(v30, 0, 0, FIntLuaAppSduiCarouselPlaceholderHeaderHeightPx * UIScale),
			transparencyBinding = t3.transparencyBinding
		}) else nil,
		Row = if not FFlagSduiCollectionCarouselPlaceholderItem or not t3.itemPlaceholderComponent then React.createElement(SduiPlaceholder, {
			layoutOrder = 2,
			backgroundStyle = t3.backgroundStyle,
			cornerRadius = t3.cornerRadius,
			size = v28,
			transparencyBinding = t3.transparencyBinding
		}) else React.createElement(SduiCollectionCarouselItemPlaceholderRow, {
			layoutOrder = 2,
			carouselPeek = v24.carouselPeek,
			gutter = v24.gutter,
			itemPlaceholderComponent = t3.itemPlaceholderComponent,
			itemSizeBinding = u27,
			itemsPerRow = v24.itemsPerRow,
			rowSizeBinding = v28,
			transparencyBinding = t3.transparencyBinding
		})
	})
end

return React.memo(SduiCollectionCarouselPlaceholder)
