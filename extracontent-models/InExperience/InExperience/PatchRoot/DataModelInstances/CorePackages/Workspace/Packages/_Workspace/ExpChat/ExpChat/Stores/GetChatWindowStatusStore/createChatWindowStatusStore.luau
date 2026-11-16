local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local FFlagExpChatWindowStatusEventFixes = require(ExpChat.Flags.FFlagExpChatWindowStatusEventFixes)

return function()
	local signal, setBackgroundTimerStarted = createSignal(0)
	local signal2, setTextTimerStarted = createSignal(0)
	local signal3, setOpenTimerStarted = createSignal(0)
	local signal4, setClosedTimerStarted = createSignal(0)
	local signal5, setPreviousChatWindowStateTimerExpired = createSignal(0)

	local signal6, setCurrentChatWindowState = createSignal("unknown")
	local signal7, setPreviousChatWindowState = createSignal("unknown")
	local v = 0
	local v2 = 0
	local v3 = 0
	local v4 = 0

	local signal8, setDurationUpdates = createSignal({
		openDuration = 0,
		closedDuration = 0,
		textIdleDuration = 0,
		backgroundIdleDuration = 0
	})

	local v5 = nil

	local function getStateStartTime(p: string)
		if p == "open" then
			return signal3(false)
		elseif p == "closed" then
			return signal4(false)
		elseif p == "textIdle" then
			return signal2(false)
		elseif p == "backgroundIdle" then
			return signal(false)
		end

		return 0
	end

	local function addDurationDelta(p: string, p2: number) -- 2 equivalent calls inferred from this helper
		if p == "unknown" then
			return
		end

		local v6

		if p == "open" then
			v6 = signal3(false)
		elseif p == "closed" then
			v6 = signal4(false)
		elseif p == "textIdle" then
			v6 = signal2(false)
		else
			v6 = p ~= "backgroundIdle" and 0 or signal(false)
		end

		local v7 = p2 - v6

		if v7 <= 0 then
			return
		end

		setDurationUpdates(function(data)
			if p == "open" then
				return {
					openDuration = data.openDuration + v7,
					closedDuration = data.closedDuration,
					textIdleDuration = data.textIdleDuration,
					backgroundIdleDuration = data.backgroundIdleDuration
				}
			elseif p == "closed" then
				return {
					openDuration = data.openDuration,
					closedDuration = data.closedDuration + v7,
					textIdleDuration = data.textIdleDuration,
					backgroundIdleDuration = data.backgroundIdleDuration
				}
			elseif p == "textIdle" then
				return {
					openDuration = data.openDuration,
					closedDuration = data.closedDuration,
					textIdleDuration = data.textIdleDuration + v7,
					backgroundIdleDuration = data.backgroundIdleDuration
				}
			elseif p == "backgroundIdle" then
				return {
					openDuration = data.openDuration,
					closedDuration = data.closedDuration,
					textIdleDuration = data.textIdleDuration,
					backgroundIdleDuration = data.backgroundIdleDuration + v7
				}
			end

			return data
		end)
	end

	local effect = Signals.createEffect(function(p)
		local v6 = signal(p)
		local v7 = signal2(p)
		local v8 = signal3(p)
		local v9 = signal4(p)
		setPreviousChatWindowState(signal6(false))

		if v9 < v8 and v7 < v8 and v6 < v8 then
			setCurrentChatWindowState("open")
			setPreviousChatWindowStateTimerExpired(v8)
		elseif v7 < v9 and v6 < v9 then
			setCurrentChatWindowState("closed")
			setPreviousChatWindowStateTimerExpired(v9)
		elseif v6 < v7 then
			setCurrentChatWindowState("textIdle")
			setPreviousChatWindowStateTimerExpired(v7)
		elseif v6 > 0 then
			setCurrentChatWindowState("backgroundIdle")
			setPreviousChatWindowStateTimerExpired(v6)
		else
			setCurrentChatWindowState("unknown")
		end
	end)

	local effect2 = Signals.createEffect(function(p)
		local v6 = signal7(p)
		local v7 = signal5(p)

		if FFlagExpChatWindowStatusEventFixes then
			addDurationDelta(v6, v7) -- inferred equivalent call
		else
			if v6 == "open" then
				v = v7 - signal3(p)
			elseif v6 == "closed" then
				v2 = v7 - signal4(p)
			elseif v6 == "textIdle" then
				v3 = v7 - signal2(p)
			elseif v6 == "backgroundIdle" then
				v4 = v7 - signal(p)
			end

			setDurationUpdates(function(data)
				return {
					openDuration = data.openDuration + v,
					closedDuration = data.closedDuration + v2,
					textIdleDuration = data.textIdleDuration + v3,
					backgroundIdleDuration = data.backgroundIdleDuration + v4
				}
			end)
		end
	end)

	local function flushFinalDuration(p: number?)
		if v5 then
			return v5, false
		end

		local v6 = signal6(false)

		if v6 == "unknown" then
			return signal8(false), false
		end

		addDurationDelta(v6, p or os.clock()) -- inferred equivalent call

		local v7 = signal8(false)
		v5 = v7
		return v7, true
	end

	return {
		getBackgroundTimerStarted = signal,
		getTextTimerStarted = signal2,
		getOpenTimerStarted = signal3,
		getClosedTimerStarted = signal4,
		getPreviousChatWindowStateTimerExpired = signal5,
		getCurrentChatWindowState = signal6,
		getPreviousChatWindowState = signal7,
		getDurationUpdates = signal8,
		setBackgroundTimerStarted = setBackgroundTimerStarted,
		setTextTimerStarted = setTextTimerStarted,
		setOpenTimerStarted = setOpenTimerStarted,
		setClosedTimerStarted = setClosedTimerStarted,
		setPreviousChatWindowStateTimerExpired = setPreviousChatWindowStateTimerExpired,
		setCurrentChatWindowState = setCurrentChatWindowState,
		setPreviousChatWindowState = setPreviousChatWindowState,
		setDurationUpdates = setDurationUpdates,
		flushFinalDuration = flushFinalDuration,
		newStateEffect = effect,
		changingWindowStateEffect = effect2
	}
end
