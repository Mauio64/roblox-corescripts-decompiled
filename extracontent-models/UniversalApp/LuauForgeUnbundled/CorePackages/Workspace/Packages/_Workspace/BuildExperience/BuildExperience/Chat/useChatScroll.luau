local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local chatScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatScroll")

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")
local FFlagBuildExperienceChatHistoryPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatHistoryPrefetch")

local FFlagBuildExperienceChatSheetReversedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatSheetReversedContent")

local function useChatScroll(p2)
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
	local v5 = not FFlagBuildExperienceChatAccordionScrollAnchor and { current = nil } or React.useRef(nil)

	local v6 = not FFlagBuildExperienceChatSheetReversedContent and { current = nil } or React.useRef(nil)

	local v7 = React.useCallback(function()
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

	local v8 = React.useCallback(function()
		local current = ref2.current

		if current then
			current.canvasPosition:Disconnect()
			current.canvasSize:Disconnect()
			current.windowSize:Disconnect()
			ref2.current = nil
		end

		v5.current = nil

		if FFlagBuildExperienceChatSheetReversedContent then
			v6.current = nil
		end

		ref5.current = false
		ref9.current = false
	end, {})

	local v9 = React.useCallback(function()
		local current = ref.current

		if current then
			if p2 then
				ref10.current = current.AbsoluteCanvasSize
				ref11.current = current.AbsoluteWindowSize
			end

			ref6.current = chatScroll.getDistanceFromBottom(current)

			if FFlagBuildExperienceChatSheetReversedContent then
				v6.current = Vector2.new(current.AbsoluteCanvasSize.Y, current.AbsoluteWindowSize.Y)
			end

			ref3.current = chatScroll.isScrolledToBottom(current)
			ref4.current = chatScroll.isScrolledToTop(current)

			if FFlagBuildExperienceChatHistoryPrefetch then
				ref5.current = chatScroll.isScrolledNearTop(current)
			end
		end
	end, { p2 })

	local v10 = React.useCallback(function()
		local current = ref.current

		if FFlagBuildExperienceChatSheetReversedContent and current ~= nil then
			local current2 = v6.current

			if
				current2 ~= nil
				and (current2.X ~= current.AbsoluteCanvasSize.Y or current2.Y ~= current.AbsoluteWindowSize.Y)
			then
				return
			end
		end

		local v11 = p2

		if v11 then
			if current == nil then
				v11 = false
			else
				v11 = current.AbsoluteCanvasSize ~= ref10.current
					or current.AbsoluteWindowSize ~= ref11.current
			end
		end

		local v12 = p2

		if v12 then
			v12 = not (current == nil) and current.CanvasPosition == ref12.current
		end

		local current2 = v5.current

		if
			FFlagBuildExperienceChatAccordionScrollAnchor
			and current2 ~= nil
			and current ~= nil
			and math.abs(current.CanvasPosition.Y - current2.canvasPositionY) > 0.5
		then
			v5.current = nil
		end

		v9()

		if ref7.current and not (ref3.current or v11 or v12) then
			ref7.current = false
		end

		v7()
	end, { v7, v9, p2 })

	local v11 = React.useCallback(function(): boolean
		local current = ref.current
		return current ~= nil and current.AbsoluteCanvasSize.Y <= current.AbsoluteWindowSize.Y
	end, {})

	local v12 = React.useCallback(function(ancestor): boolean
		local current = v5.current

		if current == nil then
			return false
		end

		if not current.instance:IsDescendantOf(ancestor) then
			v5.current = nil
			return false
		end

		local v13 = chatScroll.getOffsetInViewport(ancestor, current.instance) - current.offsetY

		if v13 == 0 then
			return true
		end

		local v14 = ancestor.CanvasPosition.Y + v13
		local bottomCanvasPosition = chatScroll.getBottomCanvasPosition(ancestor)

		if v14 < 0 or bottomCanvasPosition < v14 then
			v5.current = nil
			ancestor.CanvasPosition = Vector2.new(0, (math.clamp(v14, 0, bottomCanvasPosition)))
		else
			current.canvasPositionY = v14
			ancestor.CanvasPosition = Vector2.new(0, v14)
		end

		return true
	end, {})

	local v13 = React.useCallback(function()
		local current = ref.current

		if current then
			if not (FFlagBuildExperienceChatAccordionScrollAnchor and v12(current)) then
				chatScroll.syncScrollFromBottom(current, ref6.current)
			end

			v9()
		end
	end, { v12, v9 })

	local v14 = React.useCallback(function()
		local current = ref.current

		if current then
			current.CanvasPosition = Vector2.new(0, 9007199254740992)

			if p2 then
				ref12.current = current.CanvasPosition
				v9()
			end
		end
	end, { p2, v9 })

	local v15 = React.useCallback(function()
		if ref3.current then
			v13()
		end
	end, { v13 })

	local v16 = React.useCallback(function()
		v9()
	end, { v9 })

	local v17 = React.useCallback(function(current)
		if ref.current == current then
			return
		end

		v8()
		ref.current = current

		if not current then
			return
		end

		if ref7.current then
			v14()
		else
			v9()
			v13()
			task.defer(v13)
		end

		local function onScrollViewportChanged()
			if ref7.current then
				v14()
			else
				v13()
				task.defer(v13)
			end

			if FFlagBuildExperienceChatSheetReversedContent then
				v9()
			end

			if FFlagBuildExperienceChatHistoryPrefetch then
				v7()
			end
		end

		local fn = FFlagBuildExperienceChatAccordionScrollAnchor and function()
			v5.current = nil

			if ref7.current then
				v14()
			else
				v13()
				task.defer(v13)
			end

			if FFlagBuildExperienceChatSheetReversedContent then
				v9()
			end

			if FFlagBuildExperienceChatHistoryPrefetch then
				v7()
			end
		end or onScrollViewportChanged

		ref2.current = {
			canvasPosition = current:GetPropertyChangedSignal("CanvasPosition"):Connect(v10),
			canvasSize = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(onScrollViewportChanged),
			windowSize = current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fn)
		}

		if FFlagBuildExperienceChatHistoryPrefetch then
			v7()
		end
	end, { v8, v14, v13, v7, v9, v10 })

	local v18 = React.useCallback(function(instance)
		local current = ref.current

		if current == nil or instance == nil or not instance:IsDescendantOf(current) then
			return
		end

		ref7.current = false
		local v19 = {
			instance = instance,
			offsetY = chatScroll.getOffsetInViewport(current, instance),
			canvasPositionY = current.CanvasPosition.Y
		}

		v5.current = v19
		task.delay(0.25, function()
			if v5.current == v19 then
				v5.current = nil
			end
		end)
	end, {})

	local v19 = React.useCallback(function()
		v5.current = nil
		ref6.current = 0
		ref3.current = true
		ref7.current = true
		v14()
	end, { v14 })

	local v20 = React.useCallback(function()
		v9()
	end, { v9 })

	local v21 = React.useCallback(function()
		if ref3.current then
			v5.current = nil
			ref6.current = 0
			v13()
		end
	end, { v13 })

	local v22 = React.useCallback(function()
		v5.current = nil
		ref6.current = 0
		ref3.current = true
		v13()
		task.defer(v13)
	end, { v13 })

	local v23 = React.useCallback(function(current)
		ref8.current = current

		if FFlagBuildExperienceChatHistoryPrefetch then
			ref9.current = false
		end

		task.defer(v7)
	end, { v7 })

	React.useEffect(function()
		return v8
	end, { v8 })

	return React.useMemo(function()
		return {
			setScrollingFrame = v17,
			anchorToInstance = v18,
			lockToBottom = v19,
			scrollToBottomIfNeeded = v15,
			captureDistanceFromBottom = v16,
			captureStickToBottomForSend = v20,
			scrollToBottomAfterSend = v21,
			scrollToBottomUnconditionally = v22,
			isViewportUnderfilled = v11,
			isAtBottomRef = ref3,
			isAtTopRef = ref4,
			isNearTopRef = ref5,
			setOnScrolledToTop = v23
		}
	end, {
		v17,
		v18,
		v19,
		v15,
		v16,
		v20,
		v21,
		v22,
		v11,
		v23
	})
end

return useChatScroll
