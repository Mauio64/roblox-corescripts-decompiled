local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local chatScroll = require(script.Parent.chatScroll)

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)
local FFlagBuildExperienceChatHistoryPrefetch = require(BuildExperience.Flags.FFlagBuildExperienceChatHistoryPrefetch)

local FFlagBuildExperienceChatSheetReversedContent = require(BuildExperience.Flags.FFlagBuildExperienceChatSheetReversedContent)

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

	local v2 = not FFlagBuildExperienceChatSheetReversedContent and { current = nil } or React.useRef(nil)

	local v3 = React.useCallback(function()
		if FFlagBuildExperienceChatHistoryPrefetch then
			local current = ref5.current

			if current and not ref9.current and ref8.current ~= nil then
				ref8.current()
			end

			ref9.current = current
		elseif ref4.current and ref8.current ~= nil then
			ref8.current()
		end
	end, {})

	local v4 = React.useCallback(function()
		local current = ref2.current

		if current then
			current.canvasPosition:Disconnect()
			current.canvasSize:Disconnect()
			current.windowSize:Disconnect()
			ref2.current = nil
		end

		v.current = nil

		if FFlagBuildExperienceChatSheetReversedContent then
			v2.current = nil
		end

		ref5.current = false
		ref9.current = false
	end, {})

	local v5 = React.useCallback(function()
		local current = ref.current

		if current then
			if flag then
				ref10.current = current.AbsoluteCanvasSize
				ref11.current = current.AbsoluteWindowSize
			end

			ref6.current = chatScroll.getDistanceFromBottom(current)

			if FFlagBuildExperienceChatSheetReversedContent then
				v2.current = Vector2.new(current.AbsoluteCanvasSize.Y, current.AbsoluteWindowSize.Y)
			end

			ref3.current = chatScroll.isScrolledToBottom(current)
			ref4.current = chatScroll.isScrolledToTop(current)

			if FFlagBuildExperienceChatHistoryPrefetch then
				ref5.current = chatScroll.isScrolledNearTop(current)
			end
		end
	end, { flag })

	local v6 = React.useCallback(function()
		local current = ref.current

		if FFlagBuildExperienceChatSheetReversedContent and current ~= nil then
			local current2 = v2.current

			if
				current2 ~= nil
				and (current2.X ~= current.AbsoluteCanvasSize.Y or current2.Y ~= current.AbsoluteWindowSize.Y)
			then
				return
			end
		end

		local v6 = flag

		if v6 then
			if current == nil then
				v6 = false
			else
				v6 = current.AbsoluteCanvasSize ~= ref10.current or current.AbsoluteWindowSize ~= ref11.current
			end
		end

		local v7 = flag

		if v7 then
			if current == nil then
				v7 = false
			else
				v7 = current.CanvasPosition == ref12.current
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

		v5()

		if ref7.current and not (ref3.current or v6 or v7) then
			ref7.current = false
		end

		v3()
	end, { v3, v5, flag })

	local isViewportUnderfilled = React.useCallback(function(): boolean
		local current = ref.current
		return current ~= nil and current.AbsoluteCanvasSize.Y <= current.AbsoluteWindowSize.Y
	end, {})

	local v7 = React.useCallback(function(ancestor): boolean
		local current = v.current

		if current == nil then
			return false
		end

		if not current.instance:IsDescendantOf(ancestor) then
			v.current = nil
			return false
		end

		local v7 = chatScroll.getOffsetInViewport(ancestor, current.instance) - current.offsetY

		if v7 == 0 then
			return true
		end

		local canvasPositionY = ancestor.CanvasPosition.Y + v7
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

	local v8 = React.useCallback(function()
		local current = ref.current

		if current then
			if not (FFlagBuildExperienceChatAccordionScrollAnchor and v7(current)) then
				chatScroll.syncScrollFromBottom(current, ref6.current)
			end

			v5()
		end
	end, { v7, v5 })

	local v9 = React.useCallback(function()
		local current = ref.current

		if current then
			current.CanvasPosition = Vector2.new(0, 9007199254740992)

			if flag then
				ref12.current = current.CanvasPosition
				v5()
			end
		end
	end, { flag, v5 })

	local scrollToBottomIfNeeded = React.useCallback(function()
		if ref3.current then
			v8()
		end
	end, { v8 })

	local captureDistanceFromBottom = React.useCallback(function()
		v5()
	end, { v5 })

	local setScrollingFrame = React.useCallback(function(current)
		if ref.current == current then
			return
		end

		v4()
		ref.current = current

		if not current then
			return
		end

		if ref7.current then
			v9()
		else
			v5()
			v8()
			task.defer(v8)
		end

		local function onScrollViewportChanged() -- 1 equivalent call inferred from this helper
			if ref7.current then
				v9()
			else
				v8()
				task.defer(v8)
			end

			if FFlagBuildExperienceChatSheetReversedContent then
				v5()
			end

			if FFlagBuildExperienceChatHistoryPrefetch then
				v3()
			end
		end

		local fn = FFlagBuildExperienceChatAccordionScrollAnchor and function()
			v.current = nil
			onScrollViewportChanged() -- inferred equivalent call
		end or onScrollViewportChanged

		ref2.current = {
			canvasPosition = current:GetPropertyChangedSignal("CanvasPosition"):Connect(v6),
			canvasSize = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(onScrollViewportChanged),
			windowSize = current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fn)
		}

		if FFlagBuildExperienceChatHistoryPrefetch then
			v3()
		end
	end, { v4, v9, v8, v3, v5, v6 })

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
		v9()
	end, { v9 })

	local captureStickToBottomForSend = React.useCallback(function()
		v5()
	end, { v5 })

	local scrollToBottomAfterSend = React.useCallback(function()
		if ref3.current then
			v.current = nil
			ref6.current = 0
			v8()
		end
	end, { v8 })

	local scrollToBottomUnconditionally = React.useCallback(function()
		v.current = nil
		ref6.current = 0
		ref3.current = true
		v8()
		task.defer(v8)
	end, { v8 })

	local setOnScrolledToTop = React.useCallback(function(current)
		ref8.current = current

		if FFlagBuildExperienceChatHistoryPrefetch then
			ref9.current = false
		end

		task.defer(v3)
	end, { v3 })

	React.useEffect(function()
		return v4
	end, { v4 })

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
