local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal

return function() -- line: 38
	-- upvalues: createSignal (copy), Signals (copy)
	local v4, v5 = createSignal(0)
	local v6, v7 = createSignal(0)
	local v8, v9 = createSignal(0)
	local v10, v11 = createSignal(0)
	local v12, v13 = createSignal(0)
	local v14, v15 = createSignal("unknown")
	local v16, v17 = createSignal("unknown")
	local n1 = 0
	local n2 = 0
	local n3 = 0
	local n4 = 0
	local v22, v23 = createSignal({
		openDuration = 0,
		closedDuration = 0,
		textIdleDuration = 0,
		backgroundIdleDuration = 0
	})
	local v24 = Signals.createEffect(function(p1) -- line: 63
		-- upvalues: v4 (copy), v6 (copy), v8 (copy), v10 (copy), v17 (copy), v14 (copy), v15 (copy), v13 (copy)
		local v27 = v4(p1)
		local v28 = v6(p1)
		local v29 = v8(p1)
		local v30 = v10(p1)

		v17(v14(false))

		if v30 < v29 and (v28 < v29 and v27 < v29) then
			v15("open")
			v13(v29)

			return
		end

		if v28 < v30 and v27 < v30 then
			v15("closed")
			v13(v30)

			return
		end

		if v27 < v28 then
			v15("textIdle")
			v13(v28)

			return
		end

		if v27 > 0 then
			v15("backgroundIdle")
			v13(v27)

			return
		end

		v15("unknown")
	end)
	local v25 = Signals.createEffect(function(p2) -- line: 93
		-- upvalues: v16 (copy), v12 (copy), n1 (ref), v8 (copy), n2 (ref), v10 (copy), n3 (ref), v6 (copy), n4 (ref), v4 (copy), v23 (copy)
		local v32 = v16(p2)
		local v33 = v12(p2)

		if v32 == "open" then
			n1 = v33 - v8(p2)
		elseif v32 == "closed" then
			n2 = v33 - v10(p2)
		elseif v32 == "textIdle" then
			n3 = v33 - v6(p2)
		elseif v32 == "backgroundIdle" then
			n4 = v33 - v4(p2)
		end

		v23(function(p3) -- line: 105
			-- upvalues: n1 (ref), n2 (ref), n3 (ref), n4 (ref)
			return {
				openDuration = p3.openDuration + n1,
				closedDuration = p3.closedDuration + n2,
				textIdleDuration = p3.textIdleDuration + n3,
				backgroundIdleDuration = p3.backgroundIdleDuration + n4
			}
		end)
	end)

	return {
		getBackgroundTimerStarted = v4,
		getTextTimerStarted = v6,
		getOpenTimerStarted = v8,
		getClosedTimerStarted = v10,
		getPreviousChatWindowStateTimerExpired = v12,
		getCurrentChatWindowState = v14,
		getPreviousChatWindowState = v16,
		getDurationUpdates = v22,
		setBackgroundTimerStarted = v5,
		setTextTimerStarted = v7,
		setOpenTimerStarted = v9,
		setClosedTimerStarted = v11,
		setPreviousChatWindowStateTimerExpired = v13,
		setCurrentChatWindowState = v15,
		setPreviousChatWindowState = v17,
		setDurationUpdates = v23,
		newStateEffect = v24,
		changingWindowStateEffect = v25
	}
end
