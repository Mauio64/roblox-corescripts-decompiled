local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local chatScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatScroll")

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")

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

	local ref13 = React.useRef(nil)

	local v6 = React.useCallback(function()
		local current = ref5.current

		if current and not ref9.current and ref8.current ~= nil then
			ref8.current()
		end

		ref9.current = current
	end, {})

	local v7 = React.useCallback(function()
		local current = ref2.current

		if current then
			current.canvasPosition:Disconnect()
			current.canvasSize:Disconnect()
			current.windowSize:Disconnect()
			ref2.current = nil
		end

		v5.current = nil
		ref13.current = nil
		ref5.current = false
		ref9.current = false
	end, {})

	local v8 = React.useCallback(function()
		local current = ref.current

		if current then
			if p2 then
				ref10.current = current.AbsoluteCanvasSize
				ref11.current = current.AbsoluteWindowSize
			end

			ref6.current = chatScroll.getDistanceFromBottom(current)
			ref13.current = Vector2.new(current.AbsoluteCanvasSize.Y, current.AbsoluteWindowSize.Y)
			ref3.current = chatScroll.isScrolledToBottom(current)
			ref4.current = chatScroll.isScrolledToTop(current)
			ref5.current = chatScroll.isScrolledNearTop(current)
		end
	end, { p2 })

	local v9 = React.useCallback(function()
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

		local v10 = p2

		if v10 then
			if current == nil then
				v10 = false
			else
				v10 = current.AbsoluteCanvasSize ~= ref10.current
					or current.AbsoluteWindowSize ~= ref11.current
			end
		end

		local v11 = p2

		if v11 then
			v11 = not (current == nil) and current.CanvasPosition == ref12.current
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

		v8()

		if ref7.current and not (ref3.current or v10 or v11) then
			ref7.current = false
		end

		v6()
	end, { v6, v8, p2 })

	local v10 = React.useCallback(function(): boolean
		local current = ref.current
		return current ~= nil and current.AbsoluteCanvasSize.Y <= current.AbsoluteWindowSize.Y
	end, {})

	local v11 = React.useCallback(function(ancestor): boolean
		local current = v5.current

		if current == nil then
			return false
		end

		if not current.instance:IsDescendantOf(ancestor) then
			v5.current = nil
			return false
		end

		local v12 = chatScroll.getOffsetInViewport(ancestor, current.instance) - current.offsetY

		if v12 == 0 then
			return true
		end

		local v13 = ancestor.CanvasPosition.Y + v12
		local bottomCanvasPosition = chatScroll.getBottomCanvasPosition(ancestor)

		if v13 < 0 or bottomCanvasPosition < v13 then
			v5.current = nil
			ancestor.CanvasPosition = Vector2.new(0, (math.clamp(v13, 0, bottomCanvasPosition)))
		else
			current.canvasPositionY = v13
			ancestor.CanvasPosition = Vector2.new(0, v13)
		end

		return true
	end, {})

	local v12 = React.useCallback(function()
		local current = ref.current

		if current then
			if not (FFlagBuildExperienceChatAccordionScrollAnchor and v11(current)) then
				chatScroll.syncScrollFromBottom(current, ref6.current)
			end

			v8()
		end
	end, { v11, v8 })

	local v13 = React.useCallback(function()
		local current = ref.current

		if current then
			current.CanvasPosition = Vector2.new(0, 9007199254740992)

			if p2 then
				ref12.current = current.CanvasPosition
				v8()
			end
		end
	end, { p2, v8 })

	local v14 = React.useCallback(function()
		if ref3.current then
			v12()
		end
	end, { v12 })

	local v15 = React.useCallback(function()
		v8()
	end, { v8 })

	local v16 = React.useCallback(function(current)
		if ref.current == current then
			return
		end

		v7()
		ref.current = current

		if not current then
			return
		end

		if ref7.current then
			v13()
		else
			v8()
			v12()
			task.defer(v12)
		end

		local function onScrollViewportChanged()
			if ref7.current then
				v13()
			else
				v12()
				task.defer(v12)
			end

			v8()
			v6()
		end

		local fn = FFlagBuildExperienceChatAccordionScrollAnchor and function()
			v5.current = nil

			if ref7.current then
				v13()
			else
				v12()
				task.defer(v12)
			end

			v8()
			v6()
		end or onScrollViewportChanged

		ref2.current = {
			canvasPosition = current:GetPropertyChangedSignal("CanvasPosition"):Connect(v9),
			canvasSize = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(onScrollViewportChanged),
			windowSize = current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fn)
		}

		v6()
	end, { v7, v13, v12, v6, v8, v9 })

	local v17 = React.useCallback(function(instance)
		local current = ref.current

		if current == nil or instance == nil or not instance:IsDescendantOf(current) then
			return
		end

		ref7.current = false
		local v18 = {
			instance = instance,
			offsetY = chatScroll.getOffsetInViewport(current, instance),
			canvasPositionY = current.CanvasPosition.Y
		}

		v5.current = v18
		task.delay(0.25, function()
			if v5.current == v18 then
				v5.current = nil
			end
		end)
	end, {})

	local v18 = React.useCallback(function()
		v5.current = nil
		ref6.current = 0
		ref3.current = true
		ref7.current = true
		v13()
	end, { v13 })

	local v19 = React.useCallback(function()
		v8()
	end, { v8 })

	local v20 = React.useCallback(function()
		if ref3.current then
			v5.current = nil
			ref6.current = 0
			v12()
		end
	end, { v12 })

	local v21 = React.useCallback(function()
		v5.current = nil
		ref6.current = 0
		ref3.current = true
		v12()
		task.defer(v12)
	end, { v12 })

	local v22 = React.useCallback(function(current)
		ref8.current = current
		ref9.current = false
		task.defer(v6)
	end, { v6 })

	React.useEffect(function()
		return v7
	end, { v7 })

	return React.useMemo(function()
		return {
			setScrollingFrame = v16,
			anchorToInstance = v17,
			lockToBottom = v18,
			scrollToBottomIfNeeded = v14,
			captureDistanceFromBottom = v15,
			captureStickToBottomForSend = v19,
			scrollToBottomAfterSend = v20,
			scrollToBottomUnconditionally = v21,
			isViewportUnderfilled = v10,
			isAtBottomRef = ref3,
			isAtTopRef = ref4,
			isNearTopRef = ref5,
			setOnScrolledToTop = v22
		}
	end, {
		v16,
		v17,
		v18,
		v14,
		v15,
		v19,
		v20,
		v21,
		v10,
		v22
	})
end

return useChatScroll
