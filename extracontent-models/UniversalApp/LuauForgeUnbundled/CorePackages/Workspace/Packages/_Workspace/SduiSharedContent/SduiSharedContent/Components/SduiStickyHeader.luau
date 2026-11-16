local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local view = Foundation.View
local divider = Foundation.Divider
local orientation = Foundation.Enums.Orientation
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local useScrollAwayHeaderPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedUtilities").useScrollAwayHeaderPosition

local buildSduiFeedChildren = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/buildSduiFeedChildren")

local function buildWrappedItems(props)
	return buildSduiFeedChildren({
		configs = props.stickyItems,
		sduiContext = props.sduiContext,
		debugName = props.debugName or "StickyHeader",
		componentType = "StickyHeader",
		extraLocalProps = props.extraLocalProps,
		impressionsTag = props.impressionsTag,
		negateImpressionIndex = true,
		selectionBehaviorLeft = props.selectionBehaviorLeft,
		selectionBehaviorRight = props.selectionBehaviorRight
	})
end

local function SduiStickyHeader(props)
	local wrappedItems = buildWrappedItems(props)

	local v5, v6 = React.useBinding(UDim2.new(1, 0, 0, 0))
	local scrollAway = props.sduiContext.scrollAway
	local scrollAwayHeight = if scrollAway then scrollAway.scrollAwayHeight else nil
	local v8 = {
		enabled = scrollAway ~= nil,
		scrollAwayHeight = scrollAwayHeight,
		headerHeightBinding = 0
	}

	local v9 = if scrollAway then scrollAway.headerHeightBinding else nil
	v8.headerHeightBinding = v9
	local v10 = useScrollAwayHeaderPosition(v8)

	local v11 = React.useCallback(function(p2)
		v6(UDim2.new(1, 0, 0, p2.AbsoluteSize.Y))
	end, {})

	local v12 = not scrollAwayHeight and 0 or math.max(0, scrollAwayHeight)
	local v13 = React.useMemo(function()
		return v5:map(function(p2)
			return UDim2.new(1, 0, 0, p2.Y.Offset + v12)
		end)
	end, { v5, v12 })

	if next(wrappedItems) == nil then
		return nil
	end

	local backgroundStyle = props.backgroundStyle
	local createElement = React.createElement
	local v15 = {
		Size = v5,
		LayoutOrder = props.layoutOrder or 1,
		ZIndex = props.zIndex or 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v20 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = v13,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 0
	}

	local v21 = if backgroundStyle then backgroundStyle.Color3 else nil
	v20.BackgroundColor3 = v21
	v20.BackgroundTransparency = (not backgroundStyle or backgroundStyle.Transparency == nil) and 0
		or backgroundStyle.Transparency
	local children = { Background = createElement3("Frame", v20), Content = 0 }

	local createElement4 = React.createElement
	local v23 = {
		tag = props.contentTag,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onAbsoluteSizeChanged = v11,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}

	local v24 = if props.paddingTop and props.paddingTop > 0 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, props.paddingTop),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}) else nil
	local children2 = {
		TopSpacer = v24,
		StickyContent = React.createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, props.gapBetweenItems)
			}
		}, wrappedItems),
		BottomSpacer = 0,
		StickyDivider = 0
	}

	local v25 = if props.paddingBottom and props.paddingBottom > 0 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, props.paddingBottom),
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}) else nil
	children2.BottomSpacer = v25

	children2.StickyDivider = React.createElement(divider, {
		orientation = orientation.Horizontal,
		LayoutOrder = 4
	})
	children.Content = createElement4(view, v23, children2)
	return createElement("Frame", v15, {
		Translation = createElement2("Frame", {
			Size = v5,
			Position = v10,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false
		}, children)
	})
end

return React.memo(SduiStickyHeader)
