local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local Orientation = Foundation.Enums.Orientation
require(parent.SduiCompat)
require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local useScrollAwayHeaderPosition = SduiSharedUtilities.useScrollAwayHeaderPosition

local buildSduiFeedChildren = require(SduiSharedContent.Components.buildSduiFeedChildren)

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

	local size, v = React.useBinding(UDim2.new(1, 0, 0, 0))
	local scrollAway = props.sduiContext.scrollAway
	local scrollAwayHeight

	if scrollAway then
		scrollAwayHeight = scrollAway.scrollAwayHeight
	end

	local v2 = {
		enabled = scrollAway ~= nil,
		scrollAwayHeight = scrollAwayHeight,
		headerHeightBinding = 0
	}
	local headerHeightBinding

	if scrollAway then
		headerHeightBinding = scrollAway.headerHeightBinding
	end

	v2.headerHeightBinding = headerHeightBinding
	local position = useScrollAwayHeaderPosition(v2)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v(UDim2.new(1, 0, 0, p.AbsoluteSize.Y))
	end, {})

	local v3 = not scrollAwayHeight and 0 or math.max(0, scrollAwayHeight)
	local size2 = React.useMemo(function()
		return size:map(function(udim: UDim2)
			return UDim2.new(1, 0, 0, udim.Y.Offset + v3)
		end)
	end, { size, v3 })

	if next(wrappedItems) == nil then
		return nil
	end

	local backgroundStyle = props.backgroundStyle
	local createElement = React.createElement
	local v4 = {
		Size = size,
		LayoutOrder = props.layoutOrder or 1,
		ZIndex = props.zIndex or 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = false
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v5 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = size2,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 0
	}
	local backgroundColor

	if backgroundStyle then
		backgroundColor = backgroundStyle.Color3
	end

	v5.BackgroundColor3 = backgroundColor
	v5.BackgroundTransparency = (not backgroundStyle or backgroundStyle.Transparency == nil) and 0
		or backgroundStyle.Transparency
	local children = { Background = createElement3("Frame", v5), Content = 0 }

	local createElement4 = React.createElement
	local v6 = {
		tag = props.contentTag,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
	}
	local topSpacer

	if props.paddingTop and props.paddingTop > 0 then
		topSpacer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, props.paddingTop),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		})
	end

	local children2 = {
		TopSpacer = topSpacer,
		StickyContent = React.createElement(View, {
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
	local bottomSpacer

	if props.paddingBottom and props.paddingBottom > 0 then
		bottomSpacer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, props.paddingBottom),
			BackgroundTransparency = 1,
			LayoutOrder = 3
		})
	end

	children2.BottomSpacer = bottomSpacer

	children2.StickyDivider = React.createElement(Divider, {
		orientation = Orientation.Horizontal,
		LayoutOrder = 4
	})
	children.Content = createElement4(View, v6, children2)
	return createElement("Frame", v4, {
		Translation = createElement2("Frame", {
			Size = size,
			Position = position,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = false
		}, children)
	})
end

return React.memo(SduiStickyHeader)
