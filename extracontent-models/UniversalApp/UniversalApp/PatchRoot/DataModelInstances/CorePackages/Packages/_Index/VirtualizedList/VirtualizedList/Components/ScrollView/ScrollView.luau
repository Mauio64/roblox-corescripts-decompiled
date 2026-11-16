local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
local setTimeout = LuauPolyfill.setTimeout

local HttpService = game:GetService("HttpService")

local v = {
	Value = {
		new = function(...)
			return {
				setOffset = function(self, _) end,
				interpolate = function(_, ...) end
			}
		end
	},
	attachNativeEvent = function(...): nil
		return nil
	end
}

local v2 = {
	get = function(...)
		return { height = 100 }
	end
}

local v3 = nil
v3 = {
	OS = "roblox",
	select = function(p)
		return p[v3.OS]
	end
}

local React = require(parent2.React)

local v4 = {
	findNodeHandle = function(...): nil
		return nil
	end
}

local ScrollViewStickyHeader = require(script.Parent.ScrollViewStickyHeader)
local StyleSheet = require(parent.StyleSheet.StyleSheet)

local View = require(script.Parent.Parent.View.View)

local v5 = {
	measureLayout = function(...) end
}

local v6 = {
	addListener = function(...): nil
		return nil
	end
}

local v7 = {
	beginScroll = function(...)
		warn("FrameRateLogger.beginScroll not implemented")
	end,
	endScroll = function(...)
		warn("FrameRateLogger.endScroll not implemented")
	end
}

local v8 = {
	blurTextInput = function(...)
		warn("TextInputState.blurTextInput not implemented")
	end,
	currentlyFocusedInput = function(...): nil
		warn("TextInputState.currentlyFocusedInput not implemented")
		return nil
	end,
	isTextInput = function(...): nil
		warn("TextInputState.isTextInput not implemented")
		return nil
	end
}

local invariant = require(parent.jsUtils.invariant)
local processDecelerationRate = require(script.Parent.processDecelerationRate)

local setAndForwardRef = require(script.Parent.Parent.Parent.Utilities.setAndForwardRef)

local ScrollViewContext = require(script.Parent.ScrollViewContext)
local default = ScrollViewContext.default
local horizontal = ScrollViewContext.HORIZONTAL
local vertical = ScrollViewContext.VERTICAL
require(script.Parent.ScrollViewStickyHeader)

local ScrollViewCommands = require(script.Parent.ScrollViewCommands)
local default2 = ScrollViewCommands.default

local ScrollContentViewNativeComponent = require(script.Parent.ScrollContentViewNativeComponent)
local ScrollViewNativeComponent = require(script.Parent.ScrollViewNativeComponent)

local v9 = nil

local v10 = v3.OS == "android" and {
	NativeHorizontalScrollViewTuple = { "Frame", "Frame" },
	NativeVerticalScrollViewTuple = { ScrollViewNativeComponent, View }
} or {
	NativeHorizontalScrollViewTuple = { ScrollViewNativeComponent, ScrollContentViewNativeComponent },
	NativeVerticalScrollViewTuple = { ScrollViewNativeComponent, ScrollContentViewNativeComponent }
}

local nativeHorizontalScrollViewTuple = v10.NativeHorizontalScrollViewTuple
local nativeVerticalScrollViewTuple = v10.NativeVerticalScrollViewTuple

local extended = React.Component:extend("ScrollView")
extended.Context = default

local function fn() -- 1 equivalent call inferred from this helper
	warn("dismissKeyboard not implemented")
end

function extended:init(props)
	self.props = props

	self._scrollAnimatedValueAttachment = nil
	self._stickyHeaderRefs = Map.new()
	self._headerLayoutYs = Map.new()

	self._keyboardWillOpenTo = nil
	self._additionalScrollOffset = 0
	self._isTouching = false
	self._lastMomentumScrollBeginTime = 0
	self._lastMomentumScrollEndTime = 0

	self._observedScrollSinceBecomingResponder = false
	self._becameResponderWhileAnimating = false
	self._preventNegativeScrollOffset = nil

	self._animated = nil

	self._subscriptionKeyboardWillShow = nil
	self._subscriptionKeyboardWillHide = nil
	self._subscriptionKeyboardDidShow = nil
	self._subscriptionKeyboardDidHide = nil

	self.state = { layoutHeight = nil }
	self._listLayoutRef = React.createRef()

	self._setNativeRef = setAndForwardRef({
		getForwardedRef = function()
			return self.props.scrollViewRef
		end,
		setLocalRef = function(scrollViewRef): nil
			self._scrollViewRef = scrollViewRef

			if scrollViewRef == nil then
				return nil
			end

			scrollViewRef.getScrollResponder = self.getScrollResponder
			scrollViewRef.getScrollableNode = self.getScrollableNode
			scrollViewRef.getInnerViewNode = self.getInnerViewNode
			scrollViewRef.getInnerViewRef = self.getInnerViewRef
			scrollViewRef.getNativeScrollRef = self.getNativeScrollRef
			scrollViewRef.scrollTo = self.scrollTo
			scrollViewRef.scrollToEnd = self.scrollToEnd
			scrollViewRef.flashScrollIndicators = self.flashScrollIndicators
			scrollViewRef.scrollResponderZoomTo = self.scrollResponderZoomTo
			scrollViewRef.scrollResponderScrollNativeHandleToKeyboard = self.scrollResponderScrollNativeHandleToKeyboard

			return nil
		end
	})

	function self.getScrollResponder()
		return self
	end

	function self.getScrollableNode()
		return v4:findNodeHandle(self._scrollViewRef)
	end

	function self.getInnerViewNode()
		return v4:findNodeHandle(self._innerViewRef)
	end

	function self.getInnerViewRef()
		return self._innerViewRef
	end

	function self.getNativeScrollRef()
		return self._scrollViewRef
	end

	function self.scrollTo(data)
		local x, y, animated

		if data ~= nil then
			y = data.y
			x = data.x
			animated = data.animated
		end

		if self._scrollViewRef == nil or self._scrollViewRef._nativeRef.current == nil then
			return
		end

		default2.scrollTo(
			self._scrollViewRef,
			Boolean.toJSBoolean(x) and x or 0,
			Boolean.toJSBoolean(y) and y or 0,
			animated and true or false
		)
	end

	function self.scrollToEnd(p)
		local v11 = (p ~= nil and p.animated) ~= false

		if self._scrollViewRef == nil then
			return
		end

		default2.scrollToEnd(self._scrollViewRef, v11)
	end

	function self.flashScrollIndicators()
		if self._scrollViewRef == nil then
			return
		end

		default2.flashScrollIndicators(self._scrollViewRef)
	end

	function self.scrollResponderScrollNativeHandleToKeyboard(value, p: number?, flag: boolean?)
		self._additionalScrollOffset = Boolean.toJSBoolean(p) and p or 0
		self._preventNegativeScrollOffset = Boolean.toJSBoolean(flag)

		if self._innerViewRef == nil then
			return
		end

		if typeof(value) == "number" then
			v5:measureLayout(
				value,
				v4:findNodeHandle(self),
				self._textInputFocusError,
				self._inputMeasureAndScrollToKeyboard
			)
		else
			value:measureLayout(self._innerViewRef, self._inputMeasureAndScrollToKeyboard, self._textInputFocusError)
		end
	end

	function self.scrollResponderZoomTo(p, flag: boolean?)
		invariant(v3.OS == "ios", "zoomToRect is not implemented")

		if Array.indexOf(Object.keys(p), "animated") == -1 then
			if typeof(flag) ~= "nil" then
				console.warn("`scrollResponderZoomTo` `animated` argument is deprecated. Use `options.animated` instead")
			end
		else
			self._animated = p.animated
			p.animated = nil
		end

		if self._scrollViewRef == nil then
			return
		end

		default2.zoomToRect(self._scrollViewRef, p, flag ~= false)
	end

	function self._inputMeasureAndScrollToKeyboard(_: number, p: number, _: number, p2: number)
		local v11 = v2:get("window").height
		local function scrollTextInputIntoVisibleRect()
			if self._keyboardWillOpenTo ~= nil then
				v11 = self._keyboardWillOpenTo.endCoordinates.screenY
			end

			local v12 = p - v11 + p2 + self._additionalScrollOffset

			if self._preventNegativeScrollOffset == true then
				v12 = math.max(0, v12)
			end

			self.scrollTo({ x = 0, y = v12, animated = true })

			self._additionalScrollOffset = 0
			self._preventNegativeScrollOffset = false
		end

		if self._keyboardWillOpenTo == nil then
			setTimeout(function()
				scrollTextInputIntoVisibleRect()
			end, 0)
		else
			scrollTextInputIntoVisibleRect()
		end
	end

	function self._handleScroll(p)
		if _G.__DEV__ and self.props.onScroll and self.props.scrollEventThrottle == nil and v3.OS == "ios" then
			console.log("You specified `onScroll` on a <ScrollView> but not `scrollEventThrottle`. You will only receive one event. Using `16` you get all the events but be aware that it may cause frame drops, use a bigger number if you don't need as much precision.")
		end

		self._observedScrollSinceBecomingResponder = true

		if self.props.onScroll then
			self.props.onScroll(p)
		end
	end

	function self._handleLayout(p)
		if self.props.invertStickyHeaders == true then
			self:setState({ layoutHeight = p.AbsoluteWindowSize.Y })
		end

		if self.props.onLayout then
			self.props.onLayout(p)
		end
	end

	function self._overrideAutomaticCanvasSize(p, p2)
		if self._scrollViewRef == nil then
			return
		end

		local current = self._scrollViewRef._nativeRef.current

		if current == nil then
			return
		end

		if self.props.AutomaticCanvasSize == Enum.AutomaticSize.XY or self.props.AutomaticCanvasSize == nil then
			current.CanvasSize = UDim2.new(0, p, 0, p2)
		elseif self.props.AutomaticCanvasSize == Enum.AutomaticSize.X then
			current.CanvasSize = UDim2.new(0, p, 0, current.AbsoluteCanvasSize.Y)
		elseif self.props.AutomaticCanvasSize == Enum.AutomaticSize.Y then
			current.CanvasSize = UDim2.new(0, current.AbsoluteCanvasSize.X, 0, p2)
		end
	end

	function self._handleContentOnLayout(p)
		local x = p.AbsoluteSize.X
		local y = p.AbsoluteSize.Y

		if self.props.overrideAutomaticCanvasSize then
			self._overrideAutomaticCanvasSize(x, y)
		end

		if self.props.onContentSizeChange then
			self.props.onContentSizeChange(x, y)
		end
	end

	self._scrollViewRef = nil

	self._innerViewRef = nil
	self._setInnerViewRef = setAndForwardRef({
		getForwardedRef = function()
			return self.props.innerViewRef
		end,
		setLocalRef = function(innerViewRef): nil
			self._innerViewRef = innerViewRef

			return nil
		end
	})

	function self.scrollResponderKeyboardWillShow(keyboardWillOpenTo)
		self._keyboardWillOpenTo = keyboardWillOpenTo

		if self.props.onKeyboardWillShow then
			self.props.onKeyboardWillShow(keyboardWillOpenTo)
		end
	end

	function self.scrollResponderKeyboardWillHide(p)
		self._keyboardWillOpenTo = nil

		if self.props.onKeyboardWillHide then
			self.props.onKeyboardWillHide(p)
		end
	end

	function self.scrollResponderKeyboardDidShow(keyboardWillOpenTo)
		if Boolean.toJSBoolean(keyboardWillOpenTo) then
			self._keyboardWillOpenTo = keyboardWillOpenTo
		end

		if self.props.onKeyboardDidShow then
			self.props.onKeyboardDidShow(keyboardWillOpenTo)
		end
	end

	function self.scrollResponderKeyboardDidHide(p)
		self._keyboardWillOpenTo = nil

		if self.props.onKeyboardDidHide then
			self.props.onKeyboardDidHide(p)
		end
	end

	function self._handleMomentumScrollBegin(p)
		self._lastMomentumScrollBeginTime = os.clock() * 1000

		if self.props.onMomentumScrollBegin then
			self.props.onMomentumScrollBegin(p)
		end
	end

	function self._handleMomentumScrollEnd(p)
		v7:endScroll()
		self._lastMomentumScrollEndTime = os.clock() * 1000

		if self.props.onMomentumScrollEnd then
			self.props.onMomentumScrollEnd(p)
		end
	end

	function self._handleScrollBeginDrag(p)
		v7:beginScroll()

		if v3.OS == "android" and self.props.keyboardDismissMode == "on-drag" then
			fn() -- inferred equivalent call
		end

		if self.props.onScrollBeginDrag then
			self.props.onScrollBeginDrag(p)
		end
	end

	function self._handleScrollEndDrag(p, p2)
		if not self:_isAnimating() and (not Boolean.toJSBoolean(nil) or (nil).x == 0 and (nil).y == 0) then
			v7:endScroll()
		end

		if self.props.onScrollEndDrag then
			self.props.onScrollEndDrag(p, p2)
		end
	end

	function self._isAnimating(): boolean
		return os.clock() * 1000 - self._lastMomentumScrollEndTime < 16
	end

	function self._handleResponderGrant(p)
		self._observedScrollSinceBecomingResponder = false

		if self.props.onResponderGrant then
			self.props.onResponderGrant(p)
		end

		self._becameResponderWhileAnimating = self:_isAnimating()
	end

	function self._handleResponderReject() end

	function self._handleResponderRelease(p)
		self._isTouching = #p.nativeEvent.touches ~= 0

		if self.props.onResponderRelease then
			self.props.onResponderRelease(p)
		end

		if typeof(p.target) == "number" then
			if _G.__DEV__ then
				console.error("Did not expect event target to be a number. Should have been a native component")
			end
		else
			local currentlyFocusedInput = v8:currentlyFocusedInput()

			if
				self.props.keyboardShouldPersistTaps ~= true
				and self.props.keyboardShouldPersistTaps ~= "always"
				and self:_keyboardIsDismissible()
				and p.target ~= currentlyFocusedInput
				and not (self._observedScrollSinceBecomingResponder or self._becameResponderWhileAnimating)
			then
				v8:blurTextInput(currentlyFocusedInput)
			end
		end
	end

	function self._handleResponderTerminationRequest(): boolean
		return not self._observedScrollSinceBecomingResponder
	end

	function self._handleScrollShouldSetResponder()
		return self.props.disableScrollViewPanResponder ~= true and self._isTouching
	end

	function self._handleStartShouldSetResponder(p): boolean
		if self.props.disableScrollViewPanResponder == true then
			return false
		end

		local currentlyFocusedInput = v8:currentlyFocusedInput()

		if
			self.props.keyboardShouldPersistTaps == "handled"
			and self:_keyboardIsDismissible()
			and p.target ~= currentlyFocusedInput
		then
			return true
		end

		return false
	end

	function self._handleStartShouldSetResponderCapture(p): boolean
		if self:_isAnimating() then
			return true
		end

		if self.props.disableScrollViewPanResponder == true then
			return false
		end

		local keyboardShouldPersistTaps = self.props.keyboardShouldPersistTaps
		local v11 = not Boolean.toJSBoolean(keyboardShouldPersistTaps) or keyboardShouldPersistTaps == "never"

		if typeof(p.target) == "number" then
			if _G.__DEV__ then
				console.error("Did not expect event target to be a number. Should have been a native component")
			end

			return false
		elseif
			v11
			and self:_keyboardIsDismissible()
			and p.target ~= nil
			and not Boolean.toJSBoolean(v8:isTextInput(p.target))
		then
			return true
		else
			return false
		end
	end

	function self._keyboardIsDismissible()
		local currentlyFocusedInput = v8:currentlyFocusedInput()
		local v11

		if currentlyFocusedInput == nil then
			v11 = false
		else
			v11 = v8:isTextInput(currentlyFocusedInput)
		end

		local v12 = self._keyboardWillOpenTo ~= nil or v3.OS == "android"
		return v11 and v12
	end

	function self._handleTouchEnd(p, p2)
		self._isTouching = false

		if self.props.onTouchEnd then
			self.props.onTouchEnd(p, p2)
		end
	end

	function self._handleTouchCancel(p, p2)
		self._isTouching = false

		if self.props.onTouchCancel then
			self.props.onTouchCancel(p, p2)
		end
	end

	function self._handleTouchStart(p, p2)
		self._isTouching = true

		if self.props.onTouchStart then
			self.props.onTouchStart(p, p2)
		end
	end

	function self._handleTouchMove(p, p2)
		if self.props.onTouchMove then
			self.props.onTouchMove(p, p2)
		end
	end

	self._scrollAnimatedValue = v.Value.new(not (self.props.contentOffset and Boolean.toJSBoolean(self.props.contentOffset.y)) and 0 or self.props.contentOffset.y)

	self._scrollAnimatedValue:setOffset(not (self.props.contentInset and Boolean.toJSBoolean(self.props.contentInset.top)) and 0 or self.props.contentInset.top)
end

function extended:componentDidMount()
	if typeof(self.props.keyboardShouldPersistTaps) == "boolean" then
		console.warn(("'keyboardShouldPersistTaps={%s}' is deprecated. "):format(self.props.keyboardShouldPersistTaps == true and "true" or "false") .. ("Use 'keyboardShouldPersistTaps=\"%s\"' instead"):format(Boolean.toJSBoolean(self.props.keyboardShouldPersistTaps) and "always" or "never"))
	end

	self._keyboardWillOpenTo = nil
	self._additionalScrollOffset = 0

	self._subscriptionKeyboardWillShow = v6:addListener("keyboardWillShow", self.scrollResponderKeyboardWillShow)
	self._subscriptionKeyboardWillHide = v6:addListener("keyboardWillHide", self.scrollResponderKeyboardWillHide)
	self._subscriptionKeyboardDidShow = v6:addListener("keyboardDidShow", self.scrollResponderKeyboardDidShow)
	self._subscriptionKeyboardDidHide = v6:addListener("keyboardDidHide", self.scrollResponderKeyboardDidHide)
	self:_updateAnimatedNodeAttachment()
end

function extended:componentDidUpdate(p)
	local v11 = not p.contentInset and 0 or p.contentInset.top
	local v12 = not self.props.contentInset and 0 or self.props.contentInset.top

	if v11 ~= v12 then
		self._scrollAnimatedValue:setOffset(Boolean.toJSBoolean(v12) and v12 or 0)
	end

	self:_updateAnimatedNodeAttachment()
end

function extended:componentWillUnmount()
	if self._subscriptionKeyboardWillShow ~= nil then
		self._subscriptionKeyboardWillShow:remove()
	end

	if self._subscriptionKeyboardWillHide ~= nil then
		self._subscriptionKeyboardWillHide:remove()
	end

	if self._subscriptionKeyboardDidShow ~= nil then
		self._subscriptionKeyboardDidShow:remove()
	end

	if self._subscriptionKeyboardDidHide ~= nil then
		self._subscriptionKeyboardDidHide:remove()
	end

	if self._scrollAnimatedValueAttachment then
		self._scrollAnimatedValueAttachment:detach()
	end
end

function extended._textInputFocusError()
	console.warn("Error measuring text field.")
end

function extended._getKeyForIndex(p, p2)
	local v11 = p2[p]
	return v11 and v11.key
end

function extended:_updateAnimatedNodeAttachment()
	if self._scrollAnimatedValueAttachment then
		self._scrollAnimatedValueAttachment:detach()
	end

	if self.props.stickyHeaderIndices and #self.props.stickyHeaderIndices > 0 then
		self._scrollAnimatedValueAttachment = v:attachNativeEvent(self._scrollViewRef, "onScroll", {
			{
				nativeEvent = {
					contentOffset = { y = self._scrollAnimatedValue }
				}
			}
		})
	end
end

function extended:_setStickyHeaderRef(p: string, p2)
	if Boolean.toJSBoolean(p2) then
		self._stickyHeaderRefs:set(p, p2)
	else
		self._stickyHeaderRefs:delete(p)
	end
end

function extended:_onStickyHeaderLayout(p, p2, p3)
	local stickyHeaderIndices = self.props.stickyHeaderIndices

	if not stickyHeaderIndices then
		return
	end

	local array = React.Children.toArray(self.props.children)

	if p3 ~= self._getKeyForIndex(p, array) then
		return
	end

	local y = p2.nativeEvent.layout.y
	self._headerLayoutYs:set(p3, y)

	local stickyHeaderIndice = stickyHeaderIndices[Array.indexOf(stickyHeaderIndices, p) - 1]

	if stickyHeaderIndice ~= nil then
		local v11 = self._stickyHeaderRefs:get(self._getKeyForIndex(stickyHeaderIndice, array))

		if Boolean.toJSBoolean(v11) and v11.setNextHeaderY then
			v11:setNextHeaderY(y)
		end
	end
end

local function fn2(style) -- 1 equivalent call inferred from this helper
	return { outer = style, inner = style }
end

function extended:render()
	local v11

	if self.props.horizontal == true then
		v11 = nativeHorizontalScrollViewTuple
	else
		v11 = nativeVerticalScrollViewTuple
	end

	local v12, v13 = table.unpack(v11, 1, 2)

	local contentContainerStyle = self.props.contentContainerStyle

	if _G.__DEV__ and self.props.style ~= nil then
		local style = self.props.style
		local filtered = Array.filter({ "alignItems", "justifyContent" }, function(p): boolean
			return type(style) == "table" and style[p] ~= nil
		end)

		invariant(
			#filtered == 0,
			"ScrollView child layout (" .. HttpService:JSONEncode(filtered) .. ") must be applied through the contentContainerStyle prop."
		)
	end

	local v14 = self.props.onContentSizeChange ~= nil and { onLayout = self._handleContentOnLayout } or nil

	local stickyHeaderIndices = self.props.stickyHeaderIndices

	local v15 = self.props.children

	if stickyHeaderIndices ~= nil and #stickyHeaderIndices > 0 then
		local array = React.Children.toArray(self.props.children)

		v15 = Array.map(array, function(p, p2)
			local v16 = not Boolean.toJSBoolean(p) and -1 or Array.indexOf(stickyHeaderIndices, p2)

			if not (v16 > -1) then
				return p
			end

			local key = p.key
			local stickyHeaderIndice = stickyHeaderIndices[v16 + 1]
			local v17

			if self.props.StickyHeaderComponent then
				v17 = self.props.StickyHeaderComponent
			else
				v17 = ScrollViewStickyHeader
			end

			return (React.createElement(v17, {
				Name = "StickyHeaderComponent",
				key = key,
				nativeID = "StickyHeader-" .. tostring(key),
				ref = function(p3)
					return self:_setStickyHeaderRef(key, p3)
				end,
				nextHeaderLayoutY = self._headerLayoutYs:get(self._getKeyForIndex(stickyHeaderIndice, array)),
				onLayout = function(p3)
					return self:_onStickyHeaderLayout(p2, p3, key)
				end,
				scrollAnimatedValue = self._scrollAnimatedValue,
				inverted = self.props.invertStickyHeaders,
				hiddenOnScroll = self.props.stickyHeaderHiddenOnScroll,
				scrollViewHeight = self.state.layoutHeight
			}, p))
		end)
	end

	local createElement = React.createElement
	local provider = default.Provider
	local v16

	if self.props.horizontal == true then
		v16 = horizontal
	else
		v16 = vertical
	end

	local createElement2 = React.createElement
	local v17 = {
		ref = self._listLayoutRef,
		key = "layout",
		Name = self.props.horizontal and "HorizontalLayout" or "VerticalLayout",
		FillDirection = 0,
		VerticalAlignment = 0,
		HorizontalAlignment = 0,
		SortOrder = 0
	}
	local fillDirection

	if self.props.horizontal then
		fillDirection = Enum.FillDirection.Horizontal
	else
		fillDirection = Enum.FillDirection.Vertical
	end

	v17.FillDirection = fillDirection
	local verticalAlignment

	if self.props.horizontal then
		verticalAlignment = Enum.VerticalAlignment.Center
	elseif self.props.layoutStyle then
		verticalAlignment = self.props.layoutStyle.VerticalAlignment
	else
		verticalAlignment = Enum.VerticalAlignment.Top
	end

	v17.VerticalAlignment = verticalAlignment
	local horizontalAlignment

	if self.props.horizontal then
		if self.props.layoutStyle then
			horizontalAlignment = self.props.layoutStyle.HorizontalAlignment
		else
			horizontalAlignment = Enum.HorizontalAlignment.Left
		end
	else
		horizontalAlignment = Enum.HorizontalAlignment.Center
	end

	v17.HorizontalAlignment = horizontalAlignment

	v17.SortOrder = Enum.SortOrder.LayoutOrder
	local element = createElement(provider, { value = v16 }, createElement2("UIListLayout", v17), v15)

	local v18 = Array.isArray(stickyHeaderIndices) and #stickyHeaderIndices > 0

	local createElement3 = React.createElement

	local assign = Object.assign
	local v19 = { ref = self._setInnerViewRef }
	local size

	if self.props.horizontal then
		size = UDim2.new(0, 0, 1, 0)
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	local automaticSize

	if self.props.horizontal then
		automaticSize = Enum.AutomaticSize.X
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	local element2 = createElement3(v13, assign({}, v14, v19, {
		style = contentContainerStyle,
		Size = size,
		AutomaticSize = automaticSize,
		removeClippedSubviews = (v3.OS ~= "android" or not v18) and self.props.removeClippedSubviews,
		collapsable = false
	}), element)
	local alwaysBounceHorizontal

	if self.props.alwaysBounceHorizontal == nil then
		alwaysBounceHorizontal = self.props.horizontal
	else
		alwaysBounceHorizontal = self.props.alwaysBounceHorizontal
	end

	local alwaysBounceVertical

	if self.props.alwaysBounceVertical == nil then
		alwaysBounceVertical = not self.props.horizontal
	else
		alwaysBounceVertical = self.props.alwaysBounceVertical
	end

	local v20

	if self.props.horizontal == true then
		v20 = v9.baseHorizontal
	else
		v20 = v9.baseVertical
	end

	local assign2 = Object.assign
	local clone = table.clone(self.props)
	local v21 = {
		alwaysBounceHorizontal = alwaysBounceHorizontal,
		alwaysBounceVertical = alwaysBounceVertical,
		style = StyleSheet.compose(v20, self.props.style),
		onContentSizeChange = Object.None,
		onLayout = self._handleLayout,
		onMomentumScrollBegin = self._handleMomentumScrollBegin,
		onMomentumScrollEnd = self._handleMomentumScrollEnd,
		onResponderGrant = self._handleResponderGrant,
		onResponderReject = self._handleResponderReject,
		onResponderRelease = self._handleResponderRelease,
		onResponderTerminationRequest = self._handleResponderTerminationRequest,
		onScrollBeginDrag = self._handleScrollBeginDrag,
		onScrollEndDrag = self._handleScrollEndDrag,
		onScrollShouldSetResponder = self._handleScrollShouldSetResponder,
		onStartShouldSetResponder = self._handleStartShouldSetResponder,
		onStartShouldSetResponderCapture = self._handleStartShouldSetResponderCapture,
		onTouchEnd = self._handleTouchEnd,
		onTouchMove = self._handleTouchMove,
		onTouchStart = self._handleTouchStart,
		onTouchCancel = self._handleTouchCancel,
		onScroll = self._handleScroll,
		scrollEventThrottle = v18 and 1 or self.props.scrollEventThrottle,
		sendMomentumEvents = (self.props.onMomentumScrollBegin or self.props.onMomentumScrollEnd) and true or false,
		snapToStart = self.props.snapToStart ~= false,
		snapToEnd = self.props.snapToEnd ~= false,
		pagingEnabled = v3.select({
			ios = self.props.pagingEnabled == true and self.props.snapToInterval == nil and self.props.snapToOffsets == nil,
			android = self.props.pagingEnabled == true or self.props.snapToInterval ~= nil or self.props.snapToOffsets ~= nil
		}),
		AutomaticCanvasSize = 0
	}
	local automaticCanvasSize

	if self.props.overrideAutomaticCanvasSize then
		automaticCanvasSize = Enum.AutomaticSize.None
	end

	v21.AutomaticCanvasSize = automaticCanvasSize
	local v22 = assign2(clone, v21)

	local decelerationRate = self.props.decelerationRate

	if decelerationRate ~= nil then
		v22.decelerationRate = processDecelerationRate(decelerationRate)
	end

	local refreshControl = self.props.refreshControl

	if Boolean.toJSBoolean(refreshControl) then
		if v3.OS == "ios" or v3.OS == "roblox" then
			return React.createElement(
				v12,
				Object.assign(table.clone(v22), { ref = self._setNativeRef }),
				refreshControl,
				element2
			)
		end

		if v3.OS == "android" then
			local v23 = fn2(v22.style) -- inferred equivalent call
			local outer = v23.outer
			local inner = v23.inner

			return React.cloneElement(
				refreshControl,
				Object.assign({ style = StyleSheet.compose(v20, outer) }),
				React.createElement(
					v12,
					Object.assign({}, v22, {
						style = StyleSheet.compose(v20, inner),
						ref = self._setNativeRef
					}),
					element2
				)
			)
		end
	end

	v22.ref = self._setNativeRef

	return React.createElement(v12, v22, element2)
end

v9 = StyleSheet.create({
	baseVertical = { ScrollingDirection = Enum.ScrollingDirection.Y },
	baseHorizontal = { ScrollingDirection = Enum.ScrollingDirection.X }
})

local function Wrapper(p, scrollViewRef)
	return React.createElement(extended, Object.assign(table.clone(p), {
		scrollViewRef = scrollViewRef
	}))
end

local forwardRef = React.forwardRef(Wrapper)

forwardRef.Context = default

forwardRef.displayName = "ScrollView"

return forwardRef
