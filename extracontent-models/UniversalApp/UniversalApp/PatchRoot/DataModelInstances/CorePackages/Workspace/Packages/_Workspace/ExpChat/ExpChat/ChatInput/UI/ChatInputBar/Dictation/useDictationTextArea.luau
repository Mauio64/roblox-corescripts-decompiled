local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local Localization = require(ExpChat.Localization)

require(script.Parent.useDictationInputBar)

local function lerp(n1: number, n2: number, n3: number) -- line: 26
	return n1 + (n2 - n1) * n3
end
local function useDictationTextArea(p1, t1: {[any]: any}) -- line: 40
	-- upvalues: Localization (copy), React (copy)
	local v12 = Localization.useLocalization({
		transcribingText = "CoreScripts.TextChat.ChatWindow.Transcribing"
	})
	local v13 = (not v12.transcribingText or v12.transcribingText == "") and "Transcribing..." or v12.transcribingText
	local v14 = if not p1 then nil else p1.dictation.bindings.isAudioActive
	local v15 = if not p1 then nil else p1.chatInputBarSettings
	local v16 = if not p1 then nil else p1.state
	local v17 = not not p1 and p1.isTranscribing
	local v18 = not t1.showPlaceholderText and 0 or 0.5
	local v19 = React.useMemo(function() -- line: 60
		-- upvalues: v14 (copy), t1 (copy), v18 (copy), React (copy)
		if v14 == nil then
			return t1.transparencyValue:map(function(n4: number) -- line: 62
				-- upvalues: v18 (copy)
				local v28 = v18

				return v28 + (1 - v28) * n4
			end)
		end

		return React.joinBindings({
			fade = t1.transparencyValue,
			hide = v14
		}):map(function(p2) -- line: 69
			-- upvalues: v18 (copy)
			local v30 = if not p2.hide then v18 else 1
			local fade = p2.fade

			return v30 + (1 - v30) * fade
		end)
	end, {
		t1.transparencyValue,
		v14,
		v18
	})
	local v20 = not v15 and 0 or v15.TextStrokeTransparency
	local v21 = React.useMemo(function() -- line: 76
		-- upvalues: v14 (copy), t1 (copy), v20 (copy), React (copy)
		if v14 == nil then
			return t1.transparencyValue:map(function(n5: number) -- line: 78
				-- upvalues: v20 (copy)
				local v33 = v20

				return v33 + (1 - v33) * n5
			end)
		end

		return React.joinBindings({
			fade = t1.transparencyValue,
			hide = v14
		}):map(function(p3) -- line: 85
			-- upvalues: v20 (copy)
			local v35 = if not p3.hide then v20 else 1
			local fade = p3.fade

			return v35 + (1 - v35) * fade
		end)
	end, {
		t1.transparencyValue,
		v14,
		v20
	})
	local v22 = if not p1 then nil else p1.customTextBoxRef
	local v23 = if not p1 then nil else p1.textBoxRef
	local v24 = if not v15 then nil else v15.PlaceholderColor3
	local v25 = if not v15 then nil else v15.TextColor3

	React.useEffect(function() -- line: 99
		-- upvalues: v22 (copy), v23 (copy), v17 (copy), v13 (copy), v24 (copy), v25 (copy)
		if v22 == nil or v23 == nil then
			return
		end

		local v26 = if not v22.current then v23.current else v22.current

		if v26 == nil then
			return
		end

		if v17 then
			v26.Text = v13
			v26.TextEditable = false
			v26.TextColor3 = v24

			return
		end

		v26.TextEditable = true
		v26.TextColor3 = v25

		if v26.Text == v13 then
			v26.Text = ""
		end
	end, {
		v16,
		v17,
		v13,
		v22,
		v23,
		v24,
		v25
	})

	return {
		textTransparency = v19,
		textStrokeTransparency = v21
	}
end

return useDictationTextArea
