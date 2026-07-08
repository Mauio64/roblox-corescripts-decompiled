local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local createSignal = Signals.createSignal
local FFlagExpChatTransparentFocusSupport = require(ExpChat.Flags.FFlagExpChatTransparentFocusSupport)
local FFlagExpChatDictationFadeOverride = require(ExpChat.Flags.FFlagExpChatDictationFadeOverride)

local function v7() -- line: 30
end

return function() -- line: 32
	-- upvalues: createSignal (copy), FFlagExpChatTransparentFocusSupport (copy), Signals (copy), FFlagExpChatDictationFadeOverride (copy), v7 (copy)
	local v8, v9 = createSignal(0)
	local v10, v11 = createSignal(0)
	local v12, v13 = createSignal(false)
	local v14, v15 = createSignal(false)
	local v16, v17 = createSignal(false)
	local v18, v19 = createSignal(false)
	local v20 = if not FFlagExpChatTransparentFocusSupport then if not FFlagExpChatDictationFadeOverride then nil else Signals.createComputed(function(p1) -- line: 47
		-- upvalues: v12 (copy), v18 (copy)
		return v12(p1) or v18(p1)
	end) else Signals.createComputed(function(p2) -- line: 41
		-- upvalues: v12 (copy), v14 (copy), v16 (copy), FFlagExpChatDictationFadeOverride (copy), v18 (copy)
		return v12(p2) or (v14(p2) or (v16(p2) or FFlagExpChatDictationFadeOverride and v18(p2)))
	end)

	local function withResetAllTransparency(p3) -- line: 57
		-- upvalues: v9 (copy), v11 (copy)
		return function() -- line: 58
			-- upvalues: p3 (copy), v9 (copy), v11 (copy)
			p3()
			v9(os.clock())
			v11(os.clock())
		end
	end

	local t1 = {
		getLastActivity = v8,
		getLastMessageActivity = v10,
		getIsTextBoxFocused = v12,
		getIsFocused = v20,
		resetAllTransparency = function() -- line: 52
			-- upvalues: v9 (copy), v11 (copy)
			v9(os.clock())
			v11(os.clock())
		end,
		resetTextTransparency = function() -- line: 73
			-- upvalues: v11 (copy)
			v11(os.clock())
		end
	}
	local v24

	if FFlagExpChatTransparentFocusSupport then
		local function v23() -- line: 77
			-- upvalues: v13 (copy)
			v13(true)
		end

		function v24() -- line: 58
			-- upvalues: v23 (copy), v9 (copy), v11 (copy)
			v23()
			v9(os.clock())
			v11(os.clock())
		end
	else
		function v24() -- line: 80
			-- upvalues: v13 (copy), v9 (copy), v11 (copy)
			v13(true)
			v9(os.clock())
			v11(os.clock())
		end
	end

	t1.setTextboxFocus = v24

	local function v25() -- line: 84
		-- upvalues: v13 (copy)
		v13(false)
	end

	function t1.clearTextboxFocus() -- line: 58
		-- upvalues: v25 (copy), v9 (copy), v11 (copy)
		v25()
		v9(os.clock())
		v11(os.clock())
	end

	local v27

	if FFlagExpChatTransparentFocusSupport then
		local function v26() -- line: 88
			-- upvalues: v15 (copy)
			v15(true)
		end

		function v27() -- line: 58
			-- upvalues: v26 (copy), v9 (copy), v11 (copy)
			v26()
			v9(os.clock())
			v11(os.clock())
		end
	else
		v27 = v7
	end

	t1.setWindowFocusInput = v27

	local v29

	if FFlagExpChatTransparentFocusSupport then
		local function v28() -- line: 93
			-- upvalues: v15 (copy)
			v15(false)
		end

		function v29() -- line: 58
			-- upvalues: v28 (copy), v9 (copy), v11 (copy)
			v28()
			v9(os.clock())
			v11(os.clock())
		end
	else
		v29 = v7
	end

	t1.clearWindowFocusInput = v29

	local v31

	if FFlagExpChatTransparentFocusSupport then
		local function v30() -- line: 98
			-- upvalues: v17 (copy)
			v17(true)
		end

		function v31() -- line: 58
			-- upvalues: v30 (copy), v9 (copy), v11 (copy)
			v30()
			v9(os.clock())
			v11(os.clock())
		end
	else
		v31 = v7
	end

	t1.setContextMenuOpen = v31

	local v33

	if FFlagExpChatTransparentFocusSupport then
		local function v32() -- line: 103
			-- upvalues: v17 (copy)
			v17(false)
		end

		function v33() -- line: 58
			-- upvalues: v32 (copy), v9 (copy), v11 (copy)
			v32()
			v9(os.clock())
			v11(os.clock())
		end
	else
		v33 = v7
	end

	t1.clearContextMenuOpen = v33

	local v35

	if FFlagExpChatDictationFadeOverride then
		local function v34() -- line: 108
			-- upvalues: v19 (copy)
			v19(true)
		end

		function v35() -- line: 58
			-- upvalues: v34 (copy), v9 (copy), v11 (copy)
			v34()
			v9(os.clock())
			v11(os.clock())
		end
	else
		v35 = v7
	end

	t1.setDictationActive = v35

	local v37

	if FFlagExpChatDictationFadeOverride then
		local function v36() -- line: 113
			-- upvalues: v19 (copy)
			v19(false)
		end

		function v37() -- line: 58
			-- upvalues: v36 (copy), v9 (copy), v11 (copy)
			v36()
			v9(os.clock())
			v11(os.clock())
		end
	else
		v37 = v7
	end

	t1.clearDictationActive = v37

	return t1
end
