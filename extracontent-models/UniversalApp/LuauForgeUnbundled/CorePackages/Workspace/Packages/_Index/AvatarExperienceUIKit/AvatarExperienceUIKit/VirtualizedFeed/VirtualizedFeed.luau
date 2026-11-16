local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Localization").Hooks.useLocalization
local fFlagAXVirtualizedFeedVerticalPadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/SharedFlags").FFlagAXVirtualizedFeedVerticalPadding

local fFlagAXSduiFeedBackToTopAndNavClearance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags").FFlagAXSduiFeedBackToTopAndNavClearance
local FFlagAXFixVirtualizedFeedUpdateDepth = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/VirtualizedFeed/FFlagAXFixVirtualizedFeedUpdateDepth")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local view = Foundation.View
local loading = Foundation.Loading
local iconSize = Foundation.Enums.IconSize
local flatList = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/VirtualizedList").FlatList
local isFeedContentScrollable = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/VirtualizedFeed/isFeedContentScrollable")
local fFlagVirtualizedFeedFooterWrapperProp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/SharedFlags").FFlagVirtualizedFeedFooterWrapperProp
local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/SharedFlags").FFlagAXScrollTelemetryIntegration2
local useFlatListScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/VirtualizedFeed/useFlatListScrollPerformanceTracker")

local v5 = { BackgroundTransparency = 1, BorderSizePixel = 0 }

local v6 = {
	Selectable = false,
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	BorderSizePixel = 0,
	ElasticBehavior = Enum.ElasticBehavior.Always,
	ClipsDescendants = false,
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}

local v7 = { backToTop = "Feature.GamePage.Action.BackToTop" }

local function getNativeScrollingFrameRef(p2)
	if p2.current ~= nil then
		local nativeScrollRef = p2.current:getNativeScrollRef()

		if nativeScrollRef ~= nil then
			return nativeScrollRef._nativeRef
		end
	end

	return nil
end

local function VirtualizedFeedBackToTopButton(p2)
	local v8 = useLocalization(v7)

	return React.createElement(button, {
		text = p2.text or v8.backToTop,
		variant = buttonVariant.Link,
		onActivated = p2.onActivated
	})
end

local v8 = fFlagAXSduiFeedBackToTopAndNavClearance
	and "row align-x-center align-y-center size-full-0 auto-y padding-xlarge"
	or "row align-y-center align-x-center padding-xlarge"

local function VirtualizedFeedFooterLayout(p2)
	return React.createElement(view, { tag = v8 }, p2.children)
end

local function createFooterComponent(p2)
	if p2.shouldWrap then
		return (React.createElement(VirtualizedFeedFooterLayout, {}, p2.footerContent))
	end

	return p2.footerContent
end

local function VirtualizedFeed(props, ref)
	local horizontalPadding = props.horizontalPadding or 0
	local verticalPadding = fFlagAXVirtualizedFeedVerticalPadding and props.verticalPadding or 0
	local v9 = not fFlagVirtualizedFeedFooterWrapperProp or props.shouldWrapFooter ~= false
	local ref2 = React.useRef(nil)

	local v10 = React.useCallback(function(current)
		ref2.current = current
		local flatListRef = props.flatListRef

		if flatListRef then
			if typeof(flatListRef) == "function" then
				flatListRef(current)
			elseif typeof(flatListRef) == "table" then
				flatListRef.current = current
			end
		end
	end, { props.flatListRef })

	if fFlagAXScrollTelemetryIntegration2 then
		useFlatListScrollPerformanceTracker(props.scrollPerformanceIntervalName, ref2)
	end

	local state, setState = React.useState(false)

	local state2 = nil
	local v11 = nil

	local v12 = nil
	local state3, setState2, v13

	if fFlagAXSduiFeedBackToTopAndNavClearance and not FFlagAXFixVirtualizedFeedUpdateDepth then
		local setState3
		state2, setState3 = React.useState(0)
		v11 = setState3
		state3, setState2 = React.useState(0)
		v13 = React.useCallback(function(p2, p3)
			v11(p3)
		end, {})
	else
		setState2 = nil
	end

	if fFlagAXSduiFeedBackToTopAndNavClearance and FFlagAXFixVirtualizedFeedUpdateDepth then
		local ref3 = React.useRef(0)
		local ref4 = React.useRef(0)
		local v14 = React.useCallback(function()
			setState(isFeedContentScrollable(ref3.current, ref4.current, verticalPadding))
		end, { verticalPadding })
		v13 = React.useCallback(function(p2, current)
			ref3.current = current
			v14()
		end, { v14 })
		v12 = React.useCallback(function(current)
			ref4.current = current
			v14()
		end, { v14 })
	end

	local v14 = React.useCallback(function()
		if ref2.current then
			ref2.current:scrollToOffset({
				offset = 0,
				animated = not UserGameSettings.ReducedMotion
			})
		end
	end, {})

	if not fFlagAXSduiFeedBackToTopAndNavClearance then
		local nativeRef

		if ref2.current == nil then
			nativeRef = nil
		else
			local nativeScrollRef = ref2.current:getNativeScrollRef()

			nativeRef = if nativeScrollRef ~= nil then nativeScrollRef._nativeRef else nil
		end

		React.useEffect(function()
			local connections = {}

			local function sizeChangeHandler()
				if nativeRef == nil or nativeRef.current == nil then
					return
				end

				local current = nativeRef.current
				setState(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
			end

			if nativeRef and nativeRef.current then
				table.insert(
					connections,
					nativeRef.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(sizeChangeHandler)
				)

				table.insert(
					connections,
					nativeRef.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(sizeChangeHandler)
				)

				if nativeRef ~= nil and nativeRef.current ~= nil then
					local current = nativeRef.current
					setState(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
				end
			end

			return function()
				for k, connection in connections do
					connection:Disconnect()
				end
			end
		end, { nativeRef })
	end

	local v15 = nil

	if fFlagAXSduiFeedBackToTopAndNavClearance then
		if not FFlagAXFixVirtualizedFeedUpdateDepth then
			state = isFeedContentScrollable(state2 or 0, state3 or 0, verticalPadding)
		end

		local v16 = state and props.isEndOfList == true
		local v17

		if props.ListFooterComponent then
			v17 = props.ListFooterComponent
		elseif v16 then
			v17 = React.createElement(VirtualizedFeedBackToTopButton, {
				text = props.scrollToTopLabel,
				onActivated = v14
			})
		elseif props.isLoading then
			v17 = React.createElement(loading, { size = iconSize.Medium })
		end

		local endOfListBottomPadding = props.endOfListBottomPadding or 0
		local v18 = React.useMemo(function()
			if endOfListBottomPadding <= 0 then
				return nil
			end

			return {
				bottom = UDim.new(0, endOfListBottomPadding)
			}
		end, { endOfListBottomPadding })

		if v18 then
			local createElement = React.createElement
			local v22

			if v17 then
				if fFlagVirtualizedFeedFooterWrapperProp then
					local v23 = { footerContent = v17, shouldWrap = v9 }

					if v23.shouldWrap then
						v22 = React.createElement(VirtualizedFeedFooterLayout, {}, v23.footerContent)
					else
						v22 = v23.footerContent
					end
				else
					v22 = React.createElement(VirtualizedFeedFooterLayout, {}, v17)
				end
			end

			v15 = createElement(view, { tag = "size-full-0 auto-y", padding = v18 }, {
				FooterContent = v22
			})
		elseif v17 then
			if fFlagVirtualizedFeedFooterWrapperProp then
				local v19 = { footerContent = v17, shouldWrap = v9 }

				if v19.shouldWrap then
					v15 = React.createElement(VirtualizedFeedFooterLayout, {}, v19.footerContent)
				else
					v15 = v19.footerContent
				end
			else
				v15 = React.createElement(VirtualizedFeedFooterLayout, {}, v17)
			end
		end
	else
		local v16

		if props.ListFooterComponent then
			v16 = props.ListFooterComponent
		elseif props.isEndOfList and state then
			v16 = React.createElement(VirtualizedFeedBackToTopButton, {
				text = props.scrollToTopLabel,
				onActivated = v14
			})
		elseif props.isLoading then
			v16 = React.createElement(loading, { size = iconSize.Medium })
		end

		if v16 then
			if fFlagVirtualizedFeedFooterWrapperProp then
				local v17 = { footerContent = v16, shouldWrap = v9 }

				if v17.shouldWrap then
					v15 = React.createElement(VirtualizedFeedFooterLayout, {}, v17.footerContent)
				else
					v15 = v17.footerContent
				end
			else
				v15 = React.createElement(VirtualizedFeedFooterLayout, {}, v16)
			end
		end
	end

	local v16 = React.useCallback(function(p2)
		if props.onScroll then
			props.onScroll(p2.CanvasPosition.Y)
		end
	end, { props.onScroll })

	local v17 = React.useCallback(function(p2)
		if props.onContainerWidthChanged then
			props.onContainerWidthChanged(p2.AbsoluteSize.X)
		end

		if fFlagAXSduiFeedBackToTopAndNavClearance and setState2 then
			setState2(p2.AbsoluteSize.Y)
		end

		if FFlagAXFixVirtualizedFeedUpdateDepth and v12 then
			v12(p2.AbsoluteSize.Y)
		end
	end, { props.onContainerWidthChanged, v12 })

	local createElement = React.createElement
	local v19 = {}
	v19.BackgroundColor3 = props.backgroundColor
	local v20 = if props.backgroundTransparency == nil then props.backgroundColor and 0 or 1 else props.backgroundTransparency
	v19.BackgroundTransparency = v20

	v19.BorderSizePixel = 0
	v19.Size = props.Size or UDim2.new(1, 0, 1, 0)
	v19.ClipsDescendants = props.clipsDescendants == nil or props.clipsDescendants
	v19.LayoutOrder = props.LayoutOrder
	v19[React.Change.AbsoluteSize] = v17
	v19.ref = ref

	local v22 = if horizontalPadding > 0 or verticalPadding > 0 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, horizontalPadding),
		PaddingRight = UDim.new(0, horizontalPadding),
		PaddingTop = UDim.new(0, verticalPadding),
		PaddingBottom = UDim.new(0, verticalPadding)
	}) else nil

	local createElement2 = React.createElement
	local v24 = {
		data = props.data,
		renderItem = props.renderItem,
		windowSize = props.windowSize or 21,
		initialNumToRender = props.initialNumToRender or 8,
		maxToRenderPerBatch = props.maxToRenderPerBatch or 1,
		updateCellsBatchingPeriod = props.updateCellsBatchingPeriod or 30,
		scrollEventThrottle = props.scrollEventThrottle or 0,
		UNSTABLE_forceSiblingLayoutUpdate = true,
		ref = v10,
		contentContainerStyle = v5,
		style = v6,
		onScroll = v16,
		onContentSizeChange = 0,
		onEndReachedThreshold = 0,
		onEndReached = 0,
		showDefaultLoadingIndicators = true,
		ListHeaderComponent = 0,
		ListFooterComponent = 0,
		scrollEnabled = 0
	}

	if not fFlagAXSduiFeedBackToTopAndNavClearance then
		v13 = nil
	end

	v24.onContentSizeChange = v13
	v24.onEndReachedThreshold = props.onEndReachedThreshold
	v24.onEndReached = props.onEndReached

	v24.ListHeaderComponent = props.ListHeaderComponent
	v24.ListFooterComponent = v15
	v24.scrollEnabled = props.scrollEnabled
	return createElement("Frame", v19, {
		UIPadding = v22,
		FeedFlatList = createElement2(flatList, v24)
	})
end

return React.forwardRef(VirtualizedFeed)
