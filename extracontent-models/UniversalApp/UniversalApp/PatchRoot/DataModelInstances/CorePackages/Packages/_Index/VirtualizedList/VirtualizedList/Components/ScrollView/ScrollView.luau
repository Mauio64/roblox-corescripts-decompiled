local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local console = LuauPolyfill.console
local setTimeout = LuauPolyfill.setTimeout
local HttpService = game:GetService("HttpService")
local t1 = {
	Value = {
		new = function(...) -- line: 37
			return {
				setOffset = function(_, _) -- line: 40
				end,
				interpolate = function(_, ...) -- line: 43
				end
			}
		end
	},
	attachNativeEvent = function(...) -- line: 49
		return nil
	end
}
local t2 = {
	get = function(...) -- line: 58
		return {
			height = 100
		}
	end
}
local t3 = nil

t3 = {
	OS = "roblox",
	select = function(p4) -- line: 68
		-- upvalues: t3 (ref)
		return p4[t3.OS]
	end
}

local React = require(ParentParentParent.React)
local t4 = {
	findNodeHandle = function(...) -- line: 84
		return nil
	end
}
local ScrollViewStickyHeader = require(script.Parent.ScrollViewStickyHeader)
local StyleSheet = require(ParentParent.StyleSheet.StyleSheet)
local View = require(script.Parent.Parent.View.View)
local t5 = {
	measureLayout = function(...) -- line: 103
	end
}
local t6 = {
	addListener = function(...) -- line: 109
		return nil
	end
}
local t7 = {
	beginScroll = function(...) -- line: 116
		warn("FrameRateLogger.beginScroll not implemented")
	end,
	endScroll = function(...) -- line: 119
		warn("FrameRateLogger.endScroll not implemented")
	end
}
local t8 = {
	blurTextInput = function(...) -- line: 125
		warn("TextInputState.blurTextInput not implemented")
	end,
	currentlyFocusedInput = function(...) -- line: 128
		warn("TextInputState.currentlyFocusedInput not implemented")

		return nil
	end,
	isTextInput = function(...) -- line: 132
		warn("TextInputState.isTextInput not implemented")

		return nil
	end
}
local invariant = require(ParentParent.jsUtils.invariant)
local processDecelerationRate = require(script.Parent.processDecelerationRate)
local setAndForwardRef = require(script.Parent.Parent.Parent.Utilities.setAndForwardRef)
local ScrollViewContext = require(script.Parent.ScrollViewContext)
local default = ScrollViewContext.default
local HORIZONTAL = ScrollViewContext.HORIZONTAL
local VERTICAL = ScrollViewContext.VERTICAL

require(script.Parent.ScrollViewStickyHeader)

local default2 = require(script.Parent.ScrollViewCommands).default
local ScrollContentViewNativeComponent = require(script.Parent.ScrollContentViewNativeComponent)
local ScrollViewNativeComponent = require(script.Parent.ScrollViewNativeComponent)
local u33 = nil
local v34 = if t3.OS ~= "android" then {
	NativeHorizontalScrollViewTuple = {
		ScrollViewNativeComponent,
		ScrollContentViewNativeComponent
	},
	NativeVerticalScrollViewTuple = {
		ScrollViewNativeComponent,
		ScrollContentViewNativeComponent
	}
} else {
	NativeHorizontalScrollViewTuple = {
		"Frame",
		"Frame"
	},
	NativeVerticalScrollViewTuple = {
		ScrollViewNativeComponent,
		View
	}
}
local NativeHorizontalScrollViewTuple = v34.NativeHorizontalScrollViewTuple
local NativeVerticalScrollViewTuple = v34.NativeVerticalScrollViewTuple
local v37 = React.Component:extend("ScrollView")

v37.Context = default

function v37.init(p5, p6) -- line: 953
	-- upvalues: Map (copy), React (copy), setAndForwardRef (copy), t4 (copy), default2 (copy), Boolean (copy), t5 (copy), invariant (copy), t3 (ref), Array (copy), Object (copy), console (copy), t2 (copy), setTimeout (copy), t7 (copy), t8 (copy), t1 (copy)
	p5.props = p6
	p5._scrollAnimatedValueAttachment = nil
	p5._stickyHeaderRefs = Map.new()
	p5._headerLayoutYs = Map.new()
	p5._keyboardWillOpenTo = nil
	p5._additionalScrollOffset = 0
	p5._isTouching = false
	p5._lastMomentumScrollBeginTime = 0
	p5._lastMomentumScrollEndTime = 0
	p5._observedScrollSinceBecomingResponder = false
	p5._becameResponderWhileAnimating = false
	p5._preventNegativeScrollOffset = nil
	p5._animated = nil
	p5._subscriptionKeyboardWillShow = nil
	p5._subscriptionKeyboardWillHide = nil
	p5._subscriptionKeyboardDidShow = nil
	p5._subscriptionKeyboardDidHide = nil
	p5.state = {
		layoutHeight = nil
	}
	p5._listLayoutRef = React.createRef()
	p5._setNativeRef = setAndForwardRef({
		getForwardedRef = function() -- line: 986
			-- upvalues: p5 (copy)
			return p5.props.scrollViewRef
		end,
		setLocalRef = function(p7) -- line: 989
			-- upvalues: p5 (copy)
			p5._scrollViewRef = p7

			if p7 ~= nil then
				p7.getScrollResponder = p5.getScrollResponder
				p7.getScrollableNode = p5.getScrollableNode
				p7.getInnerViewNode = p5.getInnerViewNode
				p7.getInnerViewRef = p5.getInnerViewRef
				p7.getNativeScrollRef = p5.getNativeScrollRef
				p7.scrollTo = p5.scrollTo
				p7.scrollToEnd = p5.scrollToEnd
				p7.flashScrollIndicators = p5.flashScrollIndicators
				p7.scrollResponderZoomTo = p5.scrollResponderZoomTo
				p7.scrollResponderScrollNativeHandleToKeyboard = p5.scrollResponderScrollNativeHandleToKeyboard
			end

			return nil
		end
	})

	function p5.getScrollResponder() -- line: 1023
		-- upvalues: p5 (copy)
		return p5
	end
	function p5.getScrollableNode() -- line: 1028
		-- upvalues: t4 (copy), p5 (copy)
		return t4:findNodeHandle(p5._scrollViewRef)
	end
	function p5.getInnerViewNode() -- line: 1032
		-- upvalues: t4 (copy), p5 (copy)
		return t4:findNodeHandle(p5._innerViewRef)
	end
	function p5.getInnerViewRef() -- line: 1036
		-- upvalues: p5 (copy)
		return p5._innerViewRef
	end
	function p5.getNativeScrollRef() -- line: 1040
		-- upvalues: p5 (copy)
		return p5._scrollViewRef
	end
	function p5.scrollTo(p8) -- line: 1055
		-- upvalues: p5 (copy), default2 (copy), Boolean (copy)
		local x = nil
		local y = nil
		local animated = nil

		if p8 ~= nil then
			y = p8.y
			x = p8.x
			animated = p8.animated
		end

		if p5._scrollViewRef == nil or p5._scrollViewRef._nativeRef.current == nil then
			return
		end

		default2.scrollTo(p5._scrollViewRef, Boolean.toJSBoolean(x) and x or 0, Boolean.toJSBoolean(y) and y or 0, not not animated)
	end
	function p5.scrollToEnd(p9) -- line: 1103
		-- upvalues: p5 (copy), default2 (copy)
		local v101 = (p9 ~= nil and p9.animated) ~= false

		if p5._scrollViewRef == nil then
			return
		end

		default2.scrollToEnd(p5._scrollViewRef, v101)
	end
	function p5.flashScrollIndicators() -- line: 1119
		-- upvalues: p5 (copy), default2 (copy)
		if p5._scrollViewRef == nil then
			return
		end

		default2.flashScrollIndicators(p5._scrollViewRef)
	end
	function p5.scrollResponderScrollNativeHandleToKeyboard(p10, n1: number?, b1: boolean?) -- line: 1136
		-- upvalues: p5 (copy), Boolean (copy), t5 (copy), t4 (copy)
		p5._additionalScrollOffset = Boolean.toJSBoolean(n1) and n1 or 0
		p5._preventNegativeScrollOffset = Boolean.toJSBoolean(b1)

		if p5._innerViewRef == nil then
			return
		end

		if typeof(p10) == "number" then
			t5:measureLayout(p10, t4:findNodeHandle(p5), p5._textInputFocusError, p5._inputMeasureAndScrollToKeyboard)

			return
		end

		p10:measureLayout(p5._innerViewRef, p5._inputMeasureAndScrollToKeyboard, p5._textInputFocusError)
	end
	function p5.scrollResponderZoomTo(t9: {[any]: any}, b2: boolean?) -- line: 1172
		-- upvalues: invariant (copy), t3 (ref), Array (copy), Object (copy), p5 (copy), console (copy), default2 (copy)
		invariant(t3.OS == "ios", "zoomToRect is not implemented")

		if Array.indexOf(Object.keys(t9), "animated") ~= -1 then
			p5._animated = t9.animated
			t9.animated = nil
		elseif typeof(b2) ~= "nil" then
			console.warn("`scrollResponderZoomTo` `animated` argument is deprecated. Use `options.animated` instead")
		end

		if p5._scrollViewRef == nil then
			return
		end

		default2.zoomToRect(p5._scrollViewRef, t9, b2 ~= false)
	end
	function p5._inputMeasureAndScrollToKeyboard(_: number, n3: number, _: number, n5: number) -- line: 1206
		-- upvalues: t2 (copy), p5 (copy), setTimeout (copy)
		local height = t2:get("window").height

		local function scrollTextInputIntoVisibleRect() -- line: 1208
			-- upvalues: p5 (copy), height (ref), n3 (copy), n5 (copy)
			if p5._keyboardWillOpenTo ~= nil then
				height = p5._keyboardWillOpenTo.endCoordinates.screenY
			end

			local v157 = n3 - height + n5 + p5._additionalScrollOffset

			if p5._preventNegativeScrollOffset == true then
				v157 = math.max(0, v157)
			end

			p5.scrollTo({
				x = 0,
				animated = true,
				y = v157
			})
			p5._additionalScrollOffset = 0
			p5._preventNegativeScrollOffset = false
		end

		if p5._keyboardWillOpenTo == nil then
			setTimeout(function() -- line: 1234
				-- upvalues: scrollTextInputIntoVisibleRect (copy)
				scrollTextInputIntoVisibleRect()
			end, 0)
		else
			scrollTextInputIntoVisibleRect()
		end
	end
	function p5._handleScroll(p11) -- line: 1242
		-- upvalues: p5 (copy), t3 (ref), console (copy)
		if _G.__DEV__ and (p5.props.onScroll and p5.props.scrollEventThrottle == nil and t3.OS == "ios") then
			console.log("You specified `onScroll` on a <ScrollView> but not `scrollEventThrottle`. You will only receive one event. Using `16` you get all the events but be aware that it may cause frame drops, use a bigger number if you don't need as much precision.")
		end

		p5._observedScrollSinceBecomingResponder = true

		if p5.props.onScroll then
			p5.props.onScroll(p11)
		end
	end
	function p5._handleLayout(p12) -- line: 1261
		-- upvalues: p5 (copy)
		if p5.props.invertStickyHeaders == true then
			p5:setState({
				layoutHeight = p12.AbsoluteWindowSize.Y
			})
		end

		if p5.props.onLayout then
			p5.props.onLayout(p12)
		end
	end
	function p5._overrideAutomaticCanvasSize(p13, p14) -- line: 1275
		-- upvalues: p5 (copy)
		if p5._scrollViewRef == nil then
			return
		end

		local current = p5._scrollViewRef._nativeRef.current

		if current == nil then
			return
		end

		if p5.props.AutomaticCanvasSize == Enum.AutomaticSize.XY or p5.props.AutomaticCanvasSize == nil then
			current.CanvasSize = UDim2.new(0, p13, 0, p14)

			return
		end

		if p5.props.AutomaticCanvasSize == Enum.AutomaticSize.X then
			current.CanvasSize = UDim2.new(0, p13, 0, current.AbsoluteCanvasSize.Y)

			return
		end

		if p5.props.AutomaticCanvasSize == Enum.AutomaticSize.Y then
			current.CanvasSize = UDim2.new(0, current.AbsoluteCanvasSize.X, 0, p14)
		end
	end
	function p5._handleContentOnLayout(p15) -- line: 1294
		-- upvalues: p5 (copy)
		local AbsoluteSizeX = p15.AbsoluteSize.X
		local AbsoluteSizeY = p15.AbsoluteSize.Y

		if p5.props.overrideAutomaticCanvasSize then
			p5._overrideAutomaticCanvasSize(AbsoluteSizeX, AbsoluteSizeY)
		end

		if p5.props.onContentSizeChange then
			p5.props.onContentSizeChange(AbsoluteSizeX, AbsoluteSizeY)
		end
	end

	p5._scrollViewRef = nil
	p5._innerViewRef = nil
	p5._setInnerViewRef = setAndForwardRef({
		getForwardedRef = function() -- line: 1309
			-- upvalues: p5 (copy)
			return p5.props.innerViewRef
		end,
		setLocalRef = function(p16) -- line: 1312
			-- upvalues: p5 (copy)
			p5._innerViewRef = p16

			return nil
		end
	})

	function p5.scrollResponderKeyboardWillShow(p17) -- line: 1348
		-- upvalues: p5 (copy)
		p5._keyboardWillOpenTo = p17

		if p5.props.onKeyboardWillShow then
			p5.props.onKeyboardWillShow(p17)
		end
	end
	function p5.scrollResponderKeyboardWillHide(p18) -- line: 1355
		-- upvalues: p5 (copy)
		p5._keyboardWillOpenTo = nil

		if p5.props.onKeyboardWillHide then
			p5.props.onKeyboardWillHide(p18)
		end
	end
	function p5.scrollResponderKeyboardDidShow(p19) -- line: 1362
		-- upvalues: Boolean (copy), p5 (copy)
		if Boolean.toJSBoolean(p19) then
			p5._keyboardWillOpenTo = p19
		end

		if p5.props.onKeyboardDidShow then
			p5.props.onKeyboardDidShow(p19)
		end
	end
	function p5.scrollResponderKeyboardDidHide(p20) -- line: 1373
		-- upvalues: p5 (copy)
		p5._keyboardWillOpenTo = nil

		if p5.props.onKeyboardDidHide then
			p5.props.onKeyboardDidHide(p20)
		end
	end
	function p5._handleMomentumScrollBegin(p21) -- line: 1383
		-- upvalues: p5 (copy)
		p5._lastMomentumScrollBeginTime = os.clock() * 1000

		if p5.props.onMomentumScrollBegin then
			p5.props.onMomentumScrollBegin(p21)
		end
	end
	function p5._handleMomentumScrollEnd(p22) -- line: 1393
		-- upvalues: t7 (copy), p5 (copy)
		t7:endScroll()
		p5._lastMomentumScrollEndTime = os.clock() * 1000

		if p5.props.onMomentumScrollEnd then
			p5.props.onMomentumScrollEnd(p22)
		end
	end
	function p5._handleScrollBeginDrag(p23) -- line: 1408
		-- upvalues: t7 (copy), t3 (ref), p5 (copy)
		t7:beginScroll()

		if t3.OS == "android" and p5.props.keyboardDismissMode == "on-drag" then
			warn("dismissKeyboard not implemented")
		end

		if p5.props.onScrollBeginDrag then
			p5.props.onScrollBeginDrag(p23)
		end
	end
	function p5._handleScrollEndDrag(p24, p25) -- line: 1421
		-- upvalues: p5 (copy), Boolean (copy), t7 (copy)
		if not p5:_isAnimating() and (not Boolean.toJSBoolean(nil) or (nil).x == 0 and (nil).y == 0) then
			t7:endScroll()
		end

		if p5.props.onScrollEndDrag then
			p5.props.onScrollEndDrag(p24, p25)
		end
	end
	function p5._isAnimating() -- line: 1441
		-- upvalues: p5 (copy)
		return os.clock() * 1000 - p5._lastMomentumScrollEndTime < 16
	end
	function p5._handleResponderGrant(p26) -- line: 1451
		-- upvalues: p5 (copy)
		p5._observedScrollSinceBecomingResponder = false

		if p5.props.onResponderGrant then
			p5.props.onResponderGrant(p26)
		end

		p5._becameResponderWhileAnimating = p5:_isAnimating()
	end
	function p5._handleResponderReject() -- line: 1469
	end
	function p5._handleResponderRelease(p27) -- line: 1474
		-- upvalues: p5 (copy), console (copy), t8 (copy)
		p5._isTouching = #p27.nativeEvent.touches ~= 0

		if p5.props.onResponderRelease then
			p5.props.onResponderRelease(p27)
		end

		if typeof(p27.target) == "number" then
			if _G.__DEV__ then
				console.error("Did not expect event target to be a number. Should have been a native component")
			end

			return
		end

		local v133 = t8:currentlyFocusedInput()

		if p5.props.keyboardShouldPersistTaps ~= true and p5.props.keyboardShouldPersistTaps ~= "always" and p5:_keyboardIsDismissible() and v133 ~= p27.target and not p5._observedScrollSinceBecomingResponder and not p5._becameResponderWhileAnimating then
			t8:blurTextInput(v133)
		end
	end
	function p5._handleResponderTerminationRequest() -- line: 1517
		-- upvalues: p5 (copy)
		return not p5._observedScrollSinceBecomingResponder
	end
	function p5._handleScrollShouldSetResponder() -- line: 1524
		-- upvalues: p5 (copy)
		if p5.props.disableScrollViewPanResponder == true then
			return false
		end

		return p5._isTouching
	end
	function p5._handleStartShouldSetResponder(p28) -- line: 1557
		-- upvalues: p5 (copy), t8 (copy)
		if p5.props.disableScrollViewPanResponder == true then
			return false
		end

		local v135 = t8:currentlyFocusedInput()

		if p5.props.keyboardShouldPersistTaps == "handled" and p5:_keyboardIsDismissible() and v135 ~= p28.target then
			return true
		end

		return false
	end
	function p5._handleStartShouldSetResponderCapture(p29) -- line: 1586
		-- upvalues: p5 (copy), Boolean (copy), console (copy), t8 (copy)
		if p5:_isAnimating() then
			return true
		end

		if p5.props.disableScrollViewPanResponder == true then
			return false
		end

		local keyboardShouldPersistTaps = p5.props.keyboardShouldPersistTaps
		local v138 = not Boolean.toJSBoolean(keyboardShouldPersistTaps) or keyboardShouldPersistTaps == "never"

		if typeof(p29.target) == "number" then
			if _G.__DEV__ then
				console.error("Did not expect event target to be a number. Should have been a native component")
			end

			return false
		end

		if v138 and p5:_keyboardIsDismissible() and p29.target ~= nil and not Boolean.toJSBoolean(t8:isTextInput(p29.target)) then
			return true
		end

		return false
	end
	function p5._keyboardIsDismissible() -- line: 1629
		-- upvalues: t8 (copy), p5 (copy), t3 (ref)
		local v139 = t8:currentlyFocusedInput()
		local v140 = v139 ~= nil and t8:isTextInput(v139)
		local v141 = p5._keyboardWillOpenTo ~= nil or t3.OS == "android"

		return v140 and v141
	end
	function p5._handleTouchEnd(p30, p31) -- line: 1652
		-- upvalues: p5 (copy)
		p5._isTouching = false

		if p5.props.onTouchEnd then
			p5.props.onTouchEnd(p30, p31)
		end
	end
	function p5._handleTouchCancel(p32, p33) -- line: 1668
		-- upvalues: p5 (copy)
		p5._isTouching = false

		if p5.props.onTouchCancel then
			p5.props.onTouchCancel(p32, p33)
		end
	end
	function p5._handleTouchStart(p34, p35) -- line: 1687
		-- upvalues: p5 (copy)
		p5._isTouching = true

		if p5.props.onTouchStart then
			p5.props.onTouchStart(p34, p35)
		end
	end
	function p5._handleTouchMove(p36, p37) -- line: 1705
		-- upvalues: p5 (copy)
		if p5.props.onTouchMove then
			p5.props.onTouchMove(p36, p37)
		end
	end

	p5._scrollAnimatedValue = t1.Value.new((not p5.props.contentOffset or not Boolean.toJSBoolean(p5.props.contentOffset.y)) and 0 or p5.props.contentOffset.y)
	p5._scrollAnimatedValue:setOffset((not p5.props.contentInset or not Boolean.toJSBoolean(p5.props.contentInset.top)) and 0 or p5.props.contentInset.top)
end
function v37.componentDidMount(p38) -- line: 1723
	-- upvalues: console (copy), Boolean (copy), t6 (copy)
	if typeof(p38.props.keyboardShouldPersistTaps) == "boolean" then
		console.warn(("'keyboardShouldPersistTaps={%s}' is deprecated. "):format(p38.props.keyboardShouldPersistTaps ~= true and "false" or "true") .. ("Use 'keyboardShouldPersistTaps=\"%s\"' instead"):format(not Boolean.toJSBoolean(p38.props.keyboardShouldPersistTaps) and "never" or "always"))
	end

	p38._keyboardWillOpenTo = nil
	p38._additionalScrollOffset = 0
	p38._subscriptionKeyboardWillShow = t6:addListener("keyboardWillShow", p38.scrollResponderKeyboardWillShow)
	p38._subscriptionKeyboardWillHide = t6:addListener("keyboardWillHide", p38.scrollResponderKeyboardWillHide)
	p38._subscriptionKeyboardDidShow = t6:addListener("keyboardDidShow", p38.scrollResponderKeyboardDidShow)
	p38._subscriptionKeyboardDidHide = t6:addListener("keyboardDidHide", p38.scrollResponderKeyboardDidHide)
	p38:_updateAnimatedNodeAttachment()
end
function v37.componentDidUpdate(p39, p40) -- line: 1745
	-- upvalues: Boolean (copy)
	local v48 = not p40.contentInset and 0 or p40.contentInset.top
	local v49 = not p39.props.contentInset and 0 or p39.props.contentInset.top

	if v48 ~= v49 then
		p39._scrollAnimatedValue:setOffset(Boolean.toJSBoolean(v49) and v49 or 0)
	end

	p39:_updateAnimatedNodeAttachment()
end
function v37.componentWillUnmount(p41) -- line: 1755
	if p41._subscriptionKeyboardWillShow ~= nil then
		p41._subscriptionKeyboardWillShow:remove()
	end

	if p41._subscriptionKeyboardWillHide ~= nil then
		p41._subscriptionKeyboardWillHide:remove()
	end

	if p41._subscriptionKeyboardDidShow ~= nil then
		p41._subscriptionKeyboardDidShow:remove()
	end

	if p41._subscriptionKeyboardDidHide ~= nil then
		p41._subscriptionKeyboardDidHide:remove()
	end

	if p41._scrollAnimatedValueAttachment then
		p41._scrollAnimatedValueAttachment:detach()
	end
end
function v37._textInputFocusError() -- line: 1774
	-- upvalues: console (copy)
	console.warn("Error measuring text field.")
end
function v37._getKeyForIndex(p42, p43) -- line: 1778
	local v53 = p43[p42]

	if v53 then
		return v53.key
	end

	return v53
end
function v37._updateAnimatedNodeAttachment(p44) -- line: 1783
	-- upvalues: t1 (copy)
	if p44._scrollAnimatedValueAttachment then
		p44._scrollAnimatedValueAttachment:detach()
	end

	if p44.props.stickyHeaderIndices and #p44.props.stickyHeaderIndices > 0 then
		p44._scrollAnimatedValueAttachment = t1:attachNativeEvent(p44._scrollViewRef, "onScroll", {{
			nativeEvent = {
				contentOffset = {
					y = p44._scrollAnimatedValue
				}
			}
		}})
	end
end
function v37._setStickyHeaderRef(t10: {[any]: any}, s1: string, p45) -- line: 1796
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p45) then
		t10._stickyHeaderRefs:set(s1, p45)

		return
	end

	t10._stickyHeaderRefs:delete(s1)
end
function v37._onStickyHeaderLayout(p46, p47, p48, p49) -- line: 1804
	-- upvalues: React (copy), Array (copy), Boolean (copy)
	local stickyHeaderIndices = p46.props.stickyHeaderIndices

	if not stickyHeaderIndices then
		return
	end

	local v63 = React.Children.toArray(p46.props.children)

	if p49 ~= p46._getKeyForIndex(p47, v63) then
		return
	end

	local y = p48.nativeEvent.layout.y

	p46._headerLayoutYs:set(p49, y)

	local v65 = stickyHeaderIndices[Array.indexOf(stickyHeaderIndices, p47) - 1]

	if v65 ~= nil then
		local v66 = p46._stickyHeaderRefs:get(p46._getKeyForIndex(v65, v63))

		if Boolean.toJSBoolean(v66) and v66.setNextHeaderY then
			v66:setNextHeaderY(y)
		end
	end
end
function v37.render(p50) -- line: 1827
	-- upvalues: NativeHorizontalScrollViewTuple (ref), NativeVerticalScrollViewTuple (ref), Array (copy), invariant (copy), HttpService (copy), React (copy), Boolean (copy), ScrollViewStickyHeader (copy), default (copy), HORIZONTAL (copy), VERTICAL (copy), Object (copy), t3 (ref), u33 (ref), StyleSheet (copy), processDecelerationRate (copy)
	local v68, v69 = table.unpack(if p50.props.horizontal ~= true then NativeVerticalScrollViewTuple else NativeHorizontalScrollViewTuple, 1, 2)
	local contentContainerStyle = p50.props.contentContainerStyle

	if _G.__DEV__ and p50.props.style ~= nil then
		local style = p50.props.style
		local v72 = Array.filter({
			"alignItems",
			"justifyContent"
		}, function(p51) -- line: 1839
			-- upvalues: style (copy)
			return type(style) == "table" and style[p51] ~= nil
		end)

		invariant(#v72 == 0, "ScrollView child layout (" .. HttpService:JSONEncode(v72) .. ") must be applied through the contentContainerStyle prop.")
	end

	local v73 = if p50.props.onContentSizeChange ~= nil then {
		onLayout = p50._handleContentOnLayout
	} else nil
	local stickyHeaderIndices = p50.props.stickyHeaderIndices
	local children = p50.props.children

	if stickyHeaderIndices ~= nil and #stickyHeaderIndices > 0 then
		local v76 = React.Children.toArray(p50.props.children)

		children = Array.map(v76, function(p52, p53) -- line: 1863
			-- upvalues: Boolean (copy), Array (copy), stickyHeaderIndices (copy), p50 (copy), ScrollViewStickyHeader (copy), React (copy), v76 (copy)
			local v153 = not Boolean.toJSBoolean(p52) and -1 or Array.indexOf(stickyHeaderIndices, p53)

			if v153 > -1 then
				local key = p52.key
				local v155 = stickyHeaderIndices[v153 + 1]
				local v156 = if not p50.props.StickyHeaderComponent then ScrollViewStickyHeader else p50.props.StickyHeaderComponent

				return (React.createElement(v156, {
					Name = "StickyHeaderComponent",
					key = key,
					nativeID = "StickyHeader-" .. tostring(key),
					ref = function(p54) -- line: 1875
						-- upvalues: p50 (copy), key (copy)
						return p50:_setStickyHeaderRef(key, p54)
					end,
					nextHeaderLayoutY = p50._headerLayoutYs:get(p50._getKeyForIndex(v155, v76)),
					onLayout = function(p55) -- line: 1879
						-- upvalues: p50 (copy), p53 (copy), key (copy)
						return p50:_onStickyHeaderLayout(p53, p55, key)
					end,
					scrollAnimatedValue = p50._scrollAnimatedValue,
					inverted = p50.props.invertStickyHeaders,
					hiddenOnScroll = p50.props.stickyHeaderHiddenOnScroll,
					scrollViewHeight = p50.state.layoutHeight
				}, p52))
			end

			return p52
		end)
	end

	local v77 = React.createElement(default.Provider, {
		value = if p50.props.horizontal ~= true then VERTICAL else HORIZONTAL
	}, React.createElement("UIListLayout", {
		key = "layout",
		ref = p50._listLayoutRef,
		Name = not p50.props.horizontal and "VerticalLayout" or "HorizontalLayout",
		FillDirection = if not p50.props.horizontal then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal,
		VerticalAlignment = if not p50.props.horizontal then if not p50.props.layoutStyle then Enum.VerticalAlignment.Top else p50.props.layoutStyle.VerticalAlignment else Enum.VerticalAlignment.Center,
		HorizontalAlignment = if not p50.props.horizontal then Enum.HorizontalAlignment.Center else if not p50.props.layoutStyle then Enum.HorizontalAlignment.Left else p50.props.layoutStyle.HorizontalAlignment,
		SortOrder = Enum.SortOrder.LayoutOrder
	}), children)
	local v78 = Array.isArray(stickyHeaderIndices) and #stickyHeaderIndices > 0
	local v79 = React.createElement(v69, Object.assign({}, v73, {
		ref = p50._setInnerViewRef
	}, {
		collapsable = false,
		style = contentContainerStyle,
		Size = if not p50.props.horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0),
		AutomaticSize = if not p50.props.horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X,
		removeClippedSubviews = (t3.OS ~= "android" or not v78) and p50.props.removeClippedSubviews
	}), v77)
	local v80 = if p50.props.alwaysBounceHorizontal == nil then p50.props.horizontal else p50.props.alwaysBounceHorizontal
	local v81 = if p50.props.alwaysBounceVertical == nil then not p50.props.horizontal else p50.props.alwaysBounceVertical
	local v82 = if p50.props.horizontal ~= true then u33.baseVertical else u33.baseHorizontal
	local v83 = Object.assign(table.clone(p50.props), {
		alwaysBounceHorizontal = v80,
		alwaysBounceVertical = v81,
		style = StyleSheet.compose(v82, p50.props.style),
		onContentSizeChange = Object.None,
		onLayout = p50._handleLayout,
		onMomentumScrollBegin = p50._handleMomentumScrollBegin,
		onMomentumScrollEnd = p50._handleMomentumScrollEnd,
		onResponderGrant = p50._handleResponderGrant,
		onResponderReject = p50._handleResponderReject,
		onResponderRelease = p50._handleResponderRelease,
		onResponderTerminationRequest = p50._handleResponderTerminationRequest,
		onScrollBeginDrag = p50._handleScrollBeginDrag,
		onScrollEndDrag = p50._handleScrollEndDrag,
		onScrollShouldSetResponder = p50._handleScrollShouldSetResponder,
		onStartShouldSetResponder = p50._handleStartShouldSetResponder,
		onStartShouldSetResponderCapture = p50._handleStartShouldSetResponderCapture,
		onTouchEnd = p50._handleTouchEnd,
		onTouchMove = p50._handleTouchMove,
		onTouchStart = p50._handleTouchStart,
		onTouchCancel = p50._handleTouchCancel,
		onScroll = p50._handleScroll,
		scrollEventThrottle = if not v78 then p50.props.scrollEventThrottle else 1,
		sendMomentumEvents = p50.props.onMomentumScrollBegin and true or not not p50.props.onMomentumScrollEnd,
		snapToStart = p50.props.snapToStart ~= false,
		snapToEnd = p50.props.snapToEnd ~= false,
		pagingEnabled = t3.select({
			ios = p50.props.pagingEnabled == true and (p50.props.snapToInterval == nil and p50.props.snapToOffsets == nil),
			android = p50.props.pagingEnabled == true or (p50.props.snapToInterval ~= nil or p50.props.snapToOffsets ~= nil)
		}),
		AutomaticCanvasSize = if not p50.props.overrideAutomaticCanvasSize then nil else Enum.AutomaticSize.None
	})
	local decelerationRate = p50.props.decelerationRate

	if decelerationRate ~= nil then
		v83.decelerationRate = processDecelerationRate(decelerationRate)
	end

	local refreshControl = p50.props.refreshControl

	if Boolean.toJSBoolean(refreshControl) then
		if t3.OS == "ios" or t3.OS == "roblox" then
			return React.createElement(v68, Object.assign(table.clone(v83), {
				ref = p50._setNativeRef
			}), refreshControl, v79)
		end

		if t3.OS == "android" then
			local style = v83.style
			local t11 = {
				outer = style,
				inner = style
			}
			local outer = t11.outer
			local inner = t11.inner

			return React.cloneElement(refreshControl, Object.assign({
				style = StyleSheet.compose(v82, outer)
			}), React.createElement(v68, Object.assign({}, v83, {
				style = StyleSheet.compose(v82, inner),
				ref = p50._setNativeRef
			}), v79))
		end
	end

	v83.ref = p50._setNativeRef

	return React.createElement(v68, v83, v79)
end

u33 = StyleSheet.create({
	baseVertical = {
		ScrollingDirection = Enum.ScrollingDirection.Y
	},
	baseHorizontal = {
		ScrollingDirection = Enum.ScrollingDirection.X
	}
})

local function Wrapper(p56, p57) -- line: 2058
	-- upvalues: React (copy), v37 (copy), Object (copy)
	return React.createElement(v37, Object.assign(table.clone(p56), {
		scrollViewRef = p57
	}))
end

local v39 = React.forwardRef(Wrapper)

v39.Context = default
v39.displayName = "ScrollView"

return v39
