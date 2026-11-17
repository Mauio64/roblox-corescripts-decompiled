local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local chatScroll = require(script.Parent.chatScroll)

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)

local function useChatScroll(flag: boolean?)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(true)
	local ref4 = React.useRef(true)
	local ref5 = React.useRef(false)
	local ref6 = React.useRef(0)
	local ref7 = React.useRef(false)
	local ref8 = React.useRef(nil)
	local ref9 = React.useRef(false)
	local ref10 = React.useRef(Vector2.zero)
	local ref11 = React.useRef(Vector2.zero)
	local ref12 = React.useRef(nil)
	local v = not FFlagBuildExperienceChatAccordionScrollAnchor and { current = nil } or React.useRef(nil)

	local ref13 = React.useRef(nil)

	local v2 = React.useCallback(function()
		local current = ref5.current

		if current and not ref9.current and ref8.current ~= nil then
			ref8.current()
		end

		ref9.current = current
	end, {})

	local v3 = React.useCallback(function()
		local current = ref2.current

		if current then
			current.canvasPosition:Disconnect()
			current.canvasSize:Disconnect()
			current.windowSize:Disconnect()
			ref2.current = nil
		end

		v.current = nil
		ref13.current = nil
		ref5.current = false
		ref9.current = false
	end, {})

	local v4 = React.useCallback(function()
		local current = ref.current

		if current then
			if flag then
				ref10.current = current.AbsoluteCanvasSize
				ref11.current = current.AbsoluteWindowSize
			end

			ref6.current = chatScroll.getDistanceFromBottom(current)
			ref13.current = Vector2.new(current.AbsoluteCanvasSize.Y, current.AbsoluteWindowSize.Y)
			ref3.current = chatScroll.isScrolledToBottom(current)
			ref4.current = chatScroll.isScrolledToTop(current)
			ref5.current = chatScroll.isScrolledNearTop(current)
		end
	end, { flag })

	local v5 = React.useCallback(function()
		local current = ref.current

		if current ~= nil then
			local current2 = ref13.current

			if
				current2 ~= nil
				and (current2.X ~= current.AbsoluteCanvasSize.Y or current2.Y ~= current.AbsoluteWindowSize.Y)
			then
				return
			end
		end

		local v5 = flag

		if v5 then
			if current == nil then
				v5 = false
			else
				v5 = current.AbsoluteCanvasSize ~= ref10.current or current.AbsoluteWindowSize ~= ref11.current
			end
		end

		local v6 = flag

		if v6 then
			if current == nil then
				v6 = false
			else
				v6 = current.CanvasPosition == ref12.current
			end
		end

		local current2 = v.current

		if
			FFlagBuildExperienceChatAccordionScrollAnchor
			and current2 ~= nil
			and current ~= nil
			and math.abs(current.CanvasPosition.Y - current2.canvasPositionY) > 0.5
		then
			v.current = nil
		end

		v4()

		if ref7.current and not (ref3.current or v5 or v6) then
			ref7.current = false
		end

		v2()
	end, { v2, v4, flag })

	local isViewportUnderfilled = React.useCallback(function(): boolean
		local current = ref.current
		return current ~= nil and current.AbsoluteCanvasSize.Y <= current.AbsoluteWindowSize.Y
	end, {})

	local v6 = React.useCallback(function(ancestor): boolean
		local current = v.current

		if current == nil then
			return false
		end

		if not current.instance:IsDescendantOf(ancestor) then
			v.current = nil
			return false
		end

		local v6 = chatScroll.getOffsetInViewport(ancestor, current.instance) - current.offsetY

		if v6 == 0 then
			return true
		end

		local canvasPositionY = ancestor.CanvasPosition.Y + v6
		local bottomCanvasPosition = chatScroll.getBottomCanvasPosition(ancestor)

		if canvasPositionY < 0 or bottomCanvasPosition < canvasPositionY then
			v.current = nil
			ancestor.CanvasPosition = Vector2.new(0, (math.clamp(canvasPositionY, 0, bottomCanvasPosition)))
		else
			current.canvasPositionY = canvasPositionY
			ancestor.CanvasPosition = Vector2.new(0, canvasPositionY)
		end

		return true
	end, {})

	local v7 = React.useCallback(function()
		local current = ref.current

		if current then
			if not (FFlagBuildExperienceChatAccordionScrollAnchor and v6(current)) then
				chatScroll.syncScrollFromBottom(current, ref6.current)
			end

			v4()
		end
	end, { v6, v4 })

	local v8 = React.useCallback(function()
		local current = ref.current

		if current then
			current.CanvasPosition = Vector2.new(0, 9007199254740992)

			if flag then
				ref12.current = current.CanvasPosition
				v4()
			end
		end
	end, { flag, v4 })

	local scrollToBottomIfNeeded = React.useCallback(function()
		if ref3.current then
			v7()
		end
	end, { v7 })

	local captureDistanceFromBottom = React.useCallback(function()
		v4()
	end, { v4 })

	local setScrollingFrame = React.useCallback(function(current)
		if ref.current == current then
			return
		end

		v3()
		ref.current = current

		if not current then
			return
		end

		if ref7.current then
			v8()
		else
			v4()
			v7()
			task.defer(v7)
		end

		local function onScrollViewportChanged() -- 1 equivalent call inferred from this helper
			if ref7.current then
				v8()
			else
				v7()
				task.defer(v7)
			end

			v4()
			v2()
		end

		local fn = FFlagBuildExperienceChatAccordionScrollAnchor and function()
			v.current = nil
			onScrollViewportChanged() -- inferred equivalent call
		end or onScrollViewportChanged

		ref2.current = {
			canvasPosition = current:GetPropertyChangedSignal("CanvasPosition"):Connect(v5),
			canvasSize = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(onScrollViewportChanged),
			windowSize = current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fn)
		}

		v2()
	end, { v3, v8, v7, v2, v4, v5 })

	local anchorToInstance = React.useCallback(function(instance)
		local current = ref.current

		if current == nil or instance == nil or not instance:IsDescendantOf(current) then
			return
		end

		ref7.current = false
		local current2 = {
			instance = instance,
			offsetY = chatScroll.getOffsetInViewport(current, instance),
			canvasPositionY = current.CanvasPosition.Y
		}

		v.current = current2
		task.delay(0.25, function()
			if v.current == current2 then
				v.current = nil
			end
		end)
	end, {})

	local lockToBottom = React.useCallback(function()
		v.current = nil
		ref6.current = 0
		ref3.current = true
		ref7.current = true
		v8()
	end, { v8 })

	local captureStickToBottomForSend = React.useCallback(function()
		v4()
	end, { v4 })

	local scrollToBottomAfterSend = React.useCallback(function()
		if ref3.current then
			v.current = nil
			ref6.current = 0
			v7()
		end
	end, { v7 })

	local scrollToBottomUnconditionally = React.useCallback(function()
		v.current = nil
		ref6.current = 0
		ref3.current = true
		v7()
		task.defer(v7)
	end, { v7 })

	local setOnScrolledToTop = React.useCallback(function(current)
		ref8.current = current
		ref9.current = false
		task.defer(v2)
	end, { v2 })

	React.useEffect(function()
		return v3
	end, { v3 })

	return React.useMemo(function()
		return {
			setScrollingFrame = setScrollingFrame,
			anchorToInstance = anchorToInstance,
			lockToBottom = lockToBottom,
			scrollToBottomIfNeeded = scrollToBottomIfNeeded,
			captureDistanceFromBottom = captureDistanceFromBottom,
			captureStickToBottomForSend = captureStickToBottomForSend,
			scrollToBottomAfterSend = scrollToBottomAfterSend,
			scrollToBottomUnconditionally = scrollToBottomUnconditionally,
			isViewportUnderfilled = isViewportUnderfilled,
			isAtBottomRef = ref3,
			isAtTopRef = ref4,
			isNearTopRef = ref5,
			setOnScrolledToTop = setOnScrolledToTop
		}
	end, {
		setScrollingFrame,
		anchorToInstance,
		lockToBottom,
		scrollToBottomIfNeeded,
		captureDistanceFromBottom,
		captureStickToBottomForSend,
		scrollToBottomAfterSend,
		scrollToBottomUnconditionally,
		isViewportUnderfilled,
		setOnScrolledToTop
	})
end

return useChatScroll
