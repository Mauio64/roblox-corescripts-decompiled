local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local VirtualizedList = require(CorePackages.Packages.VirtualizedList)
local animatedFlatList = VirtualizedList.AnimatedFlatList
local module = require("@luauforge/bundled/hHN")
local module2 = require("@luauforge/deferred/hHP")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module3 = require("@luauforge/bundled/dUd")

local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagExtendScrollingFramesBySafeInsets

local function Section(props)
	local items = props.items
	local v5 = useLocalization({ title = props.titleKey })

	local v6 = items == nil and {} or Dash.reduce(items, function(list, p2, p3)
		local itemComponent = module2.getItemComponent(p2.itemType)

		if itemComponent then
			table.insert(list, React.createElement(itemComponent, {
				layoutOrder = p3,
				itemData = p2
			}))
		end

		return list
	end, {})

	return React.createElement(
		module,
		{
			layoutOrder = props.layoutOrder,
			withDivider = props.withDivider,
			title = v5.title
		},
		v6
	)
end

local function renderItem(p2)
	return p2.item
end

local function MoreSectionList(props)
	local itemList = props.itemList
	local topbarHeight = props.topbarHeight or 0

	local v5 = useDesignTokens()
	local pageTopMargin = v5.LuaApps.More.PageTopMargin
	local backgroundGradientOffset = v5.LuaApps.More.BackgroundGradientOffset
	local safeAreaMargin = v5.LuaApps.More.SafeAreaMargin

	local v6 = itemList == nil and {} or Dash.reduce(itemList, function(p2, p3)
		return Dash.append(p2, p3)
	end, {})

	local mapped = Dash.map(v6, function(p2, p3)
		local itemInfo = p2.itemInfo
		local subItems = p2.subItems
		local v7 = module2.getSectionComponent(itemInfo.itemType) or Section
		return React.createElement(v7, {
			layoutOrder = p3,
			withDivider = p3 < #v6,
			titleKey = itemInfo.textKey,
			items = subItems
		})
	end)

	local v7 = React.useCallback(function()
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 10000000
		})
	end, { v5.Size.Size_600 })
	local v8

	if fFlagExtendScrollingFramesBySafeInsets then
		v8 = useSignalState(module3.GetDisplayStore().getDeviceSafePadding)
	end

	local createElement = React.createElement
	local v10 = {
		Position = UDim2.new(0, safeAreaMargin.X, 0, pageTopMargin + topbarHeight),
		Size = 0,
		BackgroundTransparency = 1
	}
	local newUDim2 = UDim2.new

	local v12 = -2 * safeAreaMargin.X
	local v14

	if fFlagExtendScrollingFramesBySafeInsets then
		v14 = v8.bottom - safeAreaMargin.Y
	else
		v14 = -safeAreaMargin.Y
	end

	v10.Size = newUDim2(1, v12, 1, v14 - pageTopMargin - topbarHeight)
	return createElement("Frame", v10, {
		BackgroundFrame = React.createElement("Frame", {
			Position = UDim2.new(0, -safeAreaMargin.X, 0, -backgroundGradientOffset),
			Size = UDim2.new(
				1,
				safeAreaMargin.X + safeAreaMargin.X,
				1,
				backgroundGradientOffset + safeAreaMargin.Y
			),
			BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = props.transparentBackground and 1 or v5.Color.Surface.Surface_0.Transparency,
			ZIndex = -1
		}),
		ContentList = React.createElement(animatedFlatList, {
			animated = true,
			animationConfig = v5.LuaApps.App.Page.ScrollAnimationConfig,
			initialNumToRender = #mapped,
			data = mapped,
			renderItem = renderItem,
			contentContainerStyle = { BackgroundTransparency = 1 },
			style = {
				Selectable = false,
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				VerticalScrollBarInset = Enum.ScrollBarInset.None,
				ScrollingEnabled = false
			},
			ItemSeparatorComponent = v7,
			ListHeaderComponent = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v5.Size.Size_400),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}),
			ListFooterComponent = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v5.Size.Size_800),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			})
		})
	})
end

return React.memo(MoreSectionList)
