local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local AnimatedFlatList = require(CorePackages.Packages.VirtualizedList).AnimatedFlatList
local MoreSection = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreSection)
local MoreItemsMap = require(Modules.LuaApp.Components.More.MoreItemsMap)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Display = require(CorePackages.Workspace.Packages.Display)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagExtendScrollingFramesBySafeInsets = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExtendScrollingFramesBySafeInsets

local function Section(p1) -- line: 39
	-- upvalues: useLocalization (copy), Dash (copy), MoreItemsMap (copy), React (copy), MoreSection (copy)
	local items = p1.items
	local v19 = useLocalization({
		title = p1.titleKey
	})
	local t1 = {}

	if items ~= nil then
		t1 = Dash.reduce(items, function(p2, p3, p4) -- line: 47
			-- upvalues: MoreItemsMap (copy), React (copy)
			local v36 = MoreItemsMap.getItemComponent(p3.itemType)

			if v36 then
				table.insert(p2, React.createElement(v36, {
					layoutOrder = p4,
					itemData = p3
				}))
			end

			return p2
		end, {})
	end

	return React.createElement(MoreSection, {
		layoutOrder = p1.layoutOrder,
		withDivider = p1.withDivider,
		title = v19.title
	}, t1)
end
local function renderItem(p5) -- line: 69
	return p5.item
end
local function MoreSectionList(t2: {[any]: any}) -- line: 73
	-- upvalues: useDesignTokens (copy), Dash (copy), MoreItemsMap (copy), Section (copy), React (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), FFlagEnableLeftNavOnConsole (copy), AnimatedFlatList (copy), renderItem (copy)
	local itemList = t2.itemList
	local v24 = t2.topbarHeight or 0
	local v25 = useDesignTokens()
	local PageTopMargin = v25.LuaApps.More.PageTopMargin
	local BackgroundGradientOffset = v25.LuaApps.More.BackgroundGradientOffset
	local SafeAreaMargin = v25.LuaApps.More.SafeAreaMargin
	local t3 = {}

	if itemList ~= nil then
		t3 = Dash.reduce(itemList, function(p6, p7) -- line: 84
			-- upvalues: Dash (copy)
			return Dash.append(p6, p7)
		end, {})
	end

	local v30 = Dash.map(t3, function(p8, p9) -- line: 89
		-- upvalues: MoreItemsMap (copy), Section (copy), React (copy), t3 (ref)
		local itemInfo = p8.itemInfo
		local subItems = p8.subItems
		local v43 = MoreItemsMap.getSectionComponent(itemInfo.itemType) or Section

		return React.createElement(v43, {
			layoutOrder = p9,
			withDivider = p9 < #t3,
			titleKey = itemInfo.textKey,
			items = subItems
		})
	end)
	local v31 = React.useCallback(function() -- line: 101
		-- upvalues: React (copy), v25 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 10000000,
			Size = UDim2.new(1, 0, 0, v25.Size.Size_600)
		})
	end, { v25.Size.Size_600 })
	local v32 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, SafeAreaMargin.X, 0, PageTopMargin + v24),
		Size = UDim2.new(1, -2 * SafeAreaMargin.X, 1, ((if not FFlagExtendScrollingFramesBySafeInsets then -SafeAreaMargin.Y else v32.bottom - SafeAreaMargin.Y)) - PageTopMargin - v24)
	}, {
		BackgroundFrame = React.createElement("Frame", {
			ZIndex = -1,
			Position = UDim2.new(0, -SafeAreaMargin.X, 0, -BackgroundGradientOffset),
			Size = UDim2.new(1, SafeAreaMargin.X + SafeAreaMargin.X, 1, BackgroundGradientOffset + SafeAreaMargin.Y),
			BackgroundColor3 = if not FFlagEnableLeftNavOnConsole then nil else v25.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = not FFlagEnableLeftNavOnConsole and 1 or v25.Color.Surface.Surface_0.Transparency
		}, {
			UIGradient = if not FFlagEnableLeftNavOnConsole then React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new(Color3.new(0, 0, 0)),
				Transparency = NumberSequence.new(1, 0.4)
			}) else nil
		}),
		ContentList = React.createElement(AnimatedFlatList, {
			animated = true,
			animationConfig = v25.LuaApps.App.Page.ScrollAnimationConfig,
			initialNumToRender = #v30,
			data = v30,
			renderItem = renderItem,
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			style = {
				Selectable = false,
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingEnabled = false,
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			},
			ItemSeparatorComponent = v31,
			ListHeaderComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, v25.Size.Size_400)
			}),
			ListFooterComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, v25.Size.Size_800)
			})
		})
	})
end

return React.memo(MoreSectionList)
