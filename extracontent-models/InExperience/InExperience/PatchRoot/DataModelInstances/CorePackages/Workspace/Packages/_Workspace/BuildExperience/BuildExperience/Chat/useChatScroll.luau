local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local chatScroll = require(script.Parent.chatScroll)

local function useChatScroll() -- line: 27
	-- upvalues: React (copy), chatScroll (copy)
	local v5 = React.useRef(nil)
	local v6 = React.useRef(nil)
	local v7 = React.useRef(true)
	local v8 = React.useRef(true)
	local v9 = React.useRef(0)
	local v10 = React.useRef(nil)
	local v11 = React.useCallback(function() -- line: 35
		-- upvalues: v8 (copy), v10 (copy)
		if v8.current and v10.current ~= nil then
			v10.current()
		end
	end, {})
	local v12 = React.useCallback(function() -- line: 41
		-- upvalues: v6 (copy)
		local current = v6.current

		if current then
			current.canvasPosition:Disconnect()
			current.canvasSize:Disconnect()
			current.windowSize:Disconnect()
			v6.current = nil
		end
	end, {})
	local v13 = React.useCallback(function() -- line: 51
		-- upvalues: v5 (copy), v9 (copy), chatScroll (copy), v7 (copy), v8 (copy)
		local current = v5.current

		if current then
			v9.current = chatScroll.getDistanceFromBottom(current)
			v7.current = chatScroll.isScrolledToBottom(current)
			v8.current = chatScroll.isScrolledToTop(current)
		end
	end, {})
	local v14 = React.useCallback(function() -- line: 60
		-- upvalues: v13 (copy), v11 (copy)
		v13()
		v11()
	end, {
		v11,
		v13
	})
	local v15 = React.useCallback(function() -- line: 65
		-- upvalues: v5 (copy)
		local current = v5.current

		return current ~= nil and current.AbsoluteCanvasSize.Y <= current.AbsoluteWindowSize.Y
	end, {})
	local v16 = React.useCallback(function() -- line: 70
		-- upvalues: v5 (copy), chatScroll (copy), v9 (copy), v13 (copy)
		local current = v5.current

		if current then
			chatScroll.syncScrollFromBottom(current, v9.current)
			v13()
		end
	end, { v13 })
	local v17 = React.useCallback(function() -- line: 78
		-- upvalues: v7 (copy), v16 (copy)
		if v7.current then
			v16()
		end
	end, { v16 })
	local v18 = React.useCallback(function() -- line: 84
		-- upvalues: v13 (copy)
		v13()
	end, { v13 })
	local v19 = React.useCallback(function(p1) -- line: 89
		-- upvalues: v5 (copy), v12 (copy), v13 (copy), v16 (copy), v6 (copy), v14 (copy)
		if p1 == v5.current then
			return
		end

		v12()
		v5.current = p1

		if not p1 then
			return
		end

		v13()
		v16()
		task.defer(v16)

		local function onScrollViewportChanged() -- line: 105
			-- upvalues: v16 (copy)
			v16()
			task.defer(v16)
		end

		v6.current = {
			canvasPosition = p1:GetPropertyChangedSignal("CanvasPosition"):Connect(v14),
			canvasSize = p1:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(onScrollViewportChanged),
			windowSize = p1:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(onScrollViewportChanged)
		}
	end, {
		v12,
		v16,
		v13,
		v14
	})
	local v20 = React.useCallback(function() -- line: 130
		-- upvalues: v13 (copy)
		v13()
	end, { v13 })
	local v21 = React.useCallback(function() -- line: 134
		-- upvalues: v7 (copy), v9 (copy), v16 (copy)
		if v7.current then
			v9.current = 0
			v16()
		end
	end, { v16 })
	local v22 = React.useCallback(function() -- line: 141
		-- upvalues: v9 (copy), v7 (copy), v16 (copy)
		v9.current = 0
		v7.current = true
		v16()
		task.defer(v16)
	end, { v16 })
	local v23 = React.useCallback(function(p2: ((...any) -> ...any)?) -- line: 148
		-- upvalues: v10 (copy), v11 (copy)
		v10.current = p2
		task.defer(v11)
	end, { v11 })

	React.useEffect(function() -- line: 153
		-- upvalues: v12 (copy)
		return v12
	end, { v12 })

	return React.useMemo(function() -- line: 158
		-- upvalues: v19 (copy), v17 (copy), v18 (copy), v20 (copy), v21 (copy), v22 (copy), v15 (copy), v7 (copy), v8 (copy), v23 (copy)
		return {
			setScrollingFrame = v19,
			scrollToBottomIfNeeded = v17,
			captureDistanceFromBottom = v18,
			captureStickToBottomForSend = v20,
			scrollToBottomAfterSend = v21,
			scrollToBottomUnconditionally = v22,
			isViewportUnderfilled = v15,
			isAtBottomRef = v7,
			isAtTopRef = v8,
			setOnScrolledToTop = v23
		}
	end, {
		v19,
		v17,
		v18,
		v20,
		v21,
		v22,
		v15,
		v23
	})
end

return useChatScroll
