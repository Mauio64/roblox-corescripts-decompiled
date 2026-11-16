local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local FFlagExpChatDictationFadeOverride = require(ExpChat.Flags.FFlagExpChatDictationFadeOverride)

local function fn() end

return function()
	local signal, v = createSignal(0)
	local signal2, v2 = createSignal(0)
	local signal3, v3 = createSignal(false)
	local signal4, v4 = createSignal(false)
	local signal5, v5 = createSignal(false)
	local signal6, v6 = createSignal(false)

	local function resetAllTransparency() -- 1 equivalent call inferred from this helper
		v(os.clock())
		v2(os.clock())
	end

	local function withResetAllTransparency(fn2) -- 8 equivalent calls inferred from this helper
		return function()
			fn2()
			resetAllTransparency() -- inferred equivalent call
		end
	end

	local v7 = {
		getLastActivity = signal,
		getLastMessageActivity = signal2,
		getIsTextBoxFocused = signal3,
		getIsFocused = Signals.createComputed(function(p)
			return signal3(p) or signal4(p) or signal5(p) or FFlagExpChatDictationFadeOverride and signal6(p)
		end),
		resetAllTransparency = resetAllTransparency,
		resetTextTransparency = function()
			v2(os.clock())
		end,
		setTextboxFocus = 0,
		clearTextboxFocus = 0,
		setWindowFocusInput = 0,
		clearWindowFocusInput = 0,
		setContextMenuOpen = 0,
		clearContextMenuOpen = 0,
		setDictationActive = 0,
		clearDictationActive = 0
	}
	local function fn2()
		v3(true)
	end

	v7.setTextboxFocus = withResetAllTransparency(fn2) -- inferred equivalent call

	local function fn3()
		v3(false)
	end

	v7.clearTextboxFocus = withResetAllTransparency(fn3) -- inferred equivalent call

	local function fn4()
		v4(true)
	end

	v7.setWindowFocusInput = withResetAllTransparency(fn4) -- inferred equivalent call

	local function fn5()
		v4(false)
	end

	v7.clearWindowFocusInput = withResetAllTransparency(fn5) -- inferred equivalent call

	local function fn6()
		v5(true)
	end

	v7.setContextMenuOpen = withResetAllTransparency(fn6) -- inferred equivalent call

	local function fn7()
		v5(false)
	end

	v7.clearContextMenuOpen = withResetAllTransparency(fn7) -- inferred equivalent call
	local setDictationActive

	if FFlagExpChatDictationFadeOverride then
		local function fn8()
			v6(true)
		end

		setDictationActive = withResetAllTransparency(fn8) -- inferred equivalent call
	else
		setDictationActive = fn
	end

	v7.setDictationActive = setDictationActive
	local clearDictationActive

	if FFlagExpChatDictationFadeOverride then
		local function fn8()
			v6(false)
		end

		clearDictationActive = withResetAllTransparency(fn8) -- inferred equivalent call
	else
		clearDictationActive = fn
	end

	v7.clearDictationActive = clearDictationActive
	return v7
end
