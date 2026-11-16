local UserGameSettings = UserSettings():GetService("UserGameSettings")
local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local FFlagAXVirtualizedFeedVerticalPadding = SharedFlags.FFlagAXVirtualizedFeedVerticalPadding

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXSduiFeedBackToTopAndNavClearance = AvatarExperienceFlags.FFlagAXSduiFeedBackToTopAndNavClearance
local FFlagAXFixVirtualizedFeedUpdateDepth = require(script.Parent.FFlagAXFixVirtualizedFeedUpdateDepth)
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local View = Foundation.View
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local VirtualizedList = require(parent.VirtualizedList)
local FlatList = VirtualizedList.FlatList
local isFeedContentScrollable = require(script.Parent.isFeedContentScrollable)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagVirtualizedFeedFooterWrapperProp = SharedFlags2.FFlagVirtualizedFeedFooterWrapperProp
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAXScrollTelemetryIntegration2 = SharedFlags3.FFlagAXScrollTelemetryIntegration2
local useFlatListScrollPerformanceTracker = require(script.Parent.useFlatListScrollPerformanceTracker)

local contentContainerStyle = { BackgroundTransparency = 1, BorderSizePixel = 0 }

local style = {
	Selectable = false,
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	BorderSizePixel = 0,
	ElasticBehavior = Enum.ElasticBehavior.Always,
	ClipsDescendants = false,
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}

local v = { backToTop = "Feature.GamePage.Action.BackToTop" }

local function getNativeScrollingFrameRef(ref) -- 1 equivalent call inferred from this helper
	if ref.current ~= nil then
		local nativeScrollRef = ref.current:getNativeScrollRef()

		if nativeScrollRef ~= nil then
			return nativeScrollRef._nativeRef
		end
	end

	return nil
end

local function VirtualizedFeedBackToTopButton(p)
	local v2 = useLocalization(v)

	return React.createElement(Button, {
		text = p.text or v2.backToTop,
		variant = ButtonVariant.Link,
		onActivated = p.onActivated
	})
end

local tag = FFlagAXSduiFeedBackToTopAndNavClearance
	and "row align-x-center align-y-center size-full-0 auto-y padding-xlarge"
	or "row align-y-center align-x-center padding-xlarge"

local function VirtualizedFeedFooterLayout(p)
	return React.createElement(View, { tag = tag }, p.children)
end

local function createFooterComponent(p) -- 3 equivalent calls inferred from this helper
	if p.shouldWrap then
		return (React.createElement(VirtualizedFeedFooterLayout, {}, p.footerContent))
	end

	return p.footerContent
end

local function VirtualizedFeed(props, ref)
	local horizontalPadding = props.horizontalPadding or 0
	local verticalPadding = FFlagAXVirtualizedFeedVerticalPadding and props.verticalPadding or 0
	local shouldWrap = not FFlagVirtualizedFeedFooterWrapperProp or props.shouldWrapFooter ~= false
	local ref2 = React.useRef(nil)

	local ref5 = React.useCallback(function(current)
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

	if FFlagAXScrollTelemetryIntegration2 then
		useFlatListScrollPerformanceTracker(props.scrollPerformanceIntervalName, ref2)
	end

	local state, setState = React.useState(false)

	local state2 = nil
	local v2 = nil

	local v3 = nil
	local state3, setState2, onContentSizeChange

	if FFlagAXSduiFeedBackToTopAndNavClearance and not FFlagAXFixVirtualizedFeedUpdateDepth then
		local setState3
		state2, setState3 = React.useState(0)
		v2 = setState3
		state3, setState2 = React.useState(0)
		onContentSizeChange = React.useCallback(function(_: number, p: number)
			v2(p)
		end, {})
	else
		setState2 = nil
	end

	if FFlagAXSduiFeedBackToTopAndNavClearance and FFlagAXFixVirtualizedFeedUpdateDepth then
		local ref3 = React.useRef(0)
		local ref4 = React.useRef(0)
		local v4 = React.useCallback(function()
			setState(isFeedContentScrollable(ref3.current, ref4.current, verticalPadding))
		end, { verticalPadding })
		onContentSizeChange = React.useCallback(function(_: number, current: number)
			ref3.current = current
			v4()
		end, { v4 })
		v3 = React.useCallback(function(current: number)
			ref4.current = current
			v4()
		end, { v4 })
	end

	local onActivated = React.useCallback(function()
		if ref2.current then
			ref2.current:scrollToOffset({
				offset = 0,
				animated = not UserGameSettings.ReducedMotion
			})
		end
	end, {})

	if not FFlagAXSduiFeedBackToTopAndNavClearance then
		local nativeScrollingFrameRef = getNativeScrollingFrameRef(ref2) -- inferred equivalent call
		React.useEffect(function()
			local connections = {}

			local function sizeChangeHandler() -- 1 equivalent call inferred from this helper
				if nativeScrollingFrameRef == nil or nativeScrollingFrameRef.current == nil then
					return
				end

				local current = nativeScrollingFrameRef.current
				setState(current.AbsoluteCanvasSize.Y > current.AbsoluteWindowSize.Y)
			end

			if nativeScrollingFrameRef and nativeScrollingFrameRef.current then
				table.insert(
					connections,
					nativeScrollingFrameRef.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(sizeChangeHandler)
				)

				table.insert(
					connections,
					nativeScrollingFrameRef.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(sizeChangeHandler)
				)
				sizeChangeHandler() -- inferred equivalent call
			end

			return function()
				for _, connection in connections do
					connection:Disconnect()
				end
			end
		end, { nativeScrollingFrameRef })
	end

	local listFooterComponent = nil

	if FFlagAXSduiFeedBackToTopAndNavClearance then
		if not FFlagAXFixVirtualizedFeedUpdateDepth then
			state = isFeedContentScrollable(state2 or 0, state3 or 0, verticalPadding)
		end

		local v4 = state and props.isEndOfList == true
		local footerContent

		if props.ListFooterComponent then
			footerContent = props.ListFooterComponent
		elseif v4 then
			footerContent = React.createElement(VirtualizedFeedBackToTopButton, {
				text = props.scrollToTopLabel,
				onActivated = onActivated
			})
		elseif props.isLoading then
			footerContent = React.createElement(Loading, { size = IconSize.Medium })
		end

		local endOfListBottomPadding = props.endOfListBottomPadding or 0
		local padding = React.useMemo(function()
			if endOfListBottomPadding <= 0 then
				return nil
			end

			return {
				bottom = UDim.new(0, endOfListBottomPadding)
			}
		end, { endOfListBottomPadding })

		if padding then
			local createElement = React.createElement
			local footerContent2

			if footerContent then
				if FFlagVirtualizedFeedFooterWrapperProp then
					footerContent2 = createFooterComponent({ -- inferred equivalent call
						footerContent = footerContent,
						shouldWrap = shouldWrap
					})
				else
					footerContent2 = React.createElement(VirtualizedFeedFooterLayout, {}, footerContent)
				end
			end

			listFooterComponent = createElement(View, {
				tag = "size-full-0 auto-y",
				padding = padding
			}, {
				FooterContent = footerContent2
			})
		elseif footerContent then
			if FFlagVirtualizedFeedFooterWrapperProp then
				listFooterComponent = createFooterComponent({ -- inferred equivalent call
					footerContent = footerContent,
					shouldWrap = shouldWrap
				})
			else
				listFooterComponent = React.createElement(VirtualizedFeedFooterLayout, {}, footerContent)
			end
		end
	else
		local footerContent

		if props.ListFooterComponent then
			footerContent = props.ListFooterComponent
		elseif props.isEndOfList and state then
			footerContent = React.createElement(VirtualizedFeedBackToTopButton, {
				text = props.scrollToTopLabel,
				onActivated = onActivated
			})
		elseif props.isLoading then
			footerContent = React.createElement(Loading, { size = IconSize.Medium })
		end

		if footerContent then
			if FFlagVirtualizedFeedFooterWrapperProp then
				listFooterComponent = createFooterComponent({ -- inferred equivalent call
					footerContent = footerContent,
					shouldWrap = shouldWrap
				})
			else
				listFooterComponent = React.createElement(VirtualizedFeedFooterLayout, {}, footerContent)
			end
		end
	end

	local onScroll = React.useCallback(function(p)
		if props.onScroll then
			props.onScroll(p.CanvasPosition.Y)
		end
	end, { props.onScroll })

	local v4 = React.useCallback(function(p)
		if props.onContainerWidthChanged then
			props.onContainerWidthChanged(p.AbsoluteSize.X)
		end

		if FFlagAXSduiFeedBackToTopAndNavClearance and setState2 then
			setState2(p.AbsoluteSize.Y)
		end

		if FFlagAXFixVirtualizedFeedUpdateDepth and v3 then
			v3(p.AbsoluteSize.Y)
		end
	end, { props.onContainerWidthChanged, v3 })

	local createElement = React.createElement
	local v5 = {}
	v5.BackgroundColor3 = props.backgroundColor
	local backgroundTransparency

	if props.backgroundTransparency == nil then
		backgroundTransparency = props.backgroundColor and 0 or 1
	else
		backgroundTransparency = props.backgroundTransparency
	end

	v5.BackgroundTransparency = backgroundTransparency

	v5.BorderSizePixel = 0
	v5.Size = props.Size or UDim2.new(1, 0, 1, 0)
	v5.ClipsDescendants = props.clipsDescendants == nil or props.clipsDescendants
	v5.LayoutOrder = props.LayoutOrder
	v5[React.Change.AbsoluteSize] = v4
	v5.ref = ref
	local uiPadding

	if horizontalPadding > 0 or verticalPadding > 0 then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, horizontalPadding),
			PaddingRight = UDim.new(0, horizontalPadding),
			PaddingTop = UDim.new(0, verticalPadding),
			PaddingBottom = UDim.new(0, verticalPadding)
		})
	end

	local createElement2 = React.createElement
	local v6 = {
		data = props.data,
		renderItem = props.renderItem,
		windowSize = props.windowSize or 21,
		initialNumToRender = props.initialNumToRender or 8,
		maxToRenderPerBatch = props.maxToRenderPerBatch or 1,
		updateCellsBatchingPeriod = props.updateCellsBatchingPeriod or 30,
		scrollEventThrottle = props.scrollEventThrottle or 0,
		UNSTABLE_forceSiblingLayoutUpdate = true,
		ref = ref5,
		contentContainerStyle = contentContainerStyle,
		style = style,
		onScroll = onScroll,
		onContentSizeChange = 0,
		onEndReachedThreshold = 0,
		onEndReached = 0,
		showDefaultLoadingIndicators = true,
		ListHeaderComponent = 0,
		ListFooterComponent = 0,
		scrollEnabled = 0
	}

	if not FFlagAXSduiFeedBackToTopAndNavClearance then
		onContentSizeChange = nil
	end

	v6.onContentSizeChange = onContentSizeChange
	v6.onEndReachedThreshold = props.onEndReachedThreshold
	v6.onEndReached = props.onEndReached

	v6.ListHeaderComponent = props.ListHeaderComponent
	v6.ListFooterComponent = listFooterComponent
	v6.scrollEnabled = props.scrollEnabled
	return createElement("Frame", v5, {
		UIPadding = uiPadding,
		FeedFlatList = createElement2(FlatList, v6)
	})
end

return React.forwardRef(VirtualizedFeed)
