local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local internalProviders = require(script.Parent.internalProviders)
local t1 = {
	activated = false,
	selectedIndex = 0,
	keyboardIndex = 0,
	currentMatch = nil,
	results = {}
}

local function useChatAutocompleteEngine(t2: {[any]: any}, t3: {[any]: any}?) -- line: 40
	-- upvalues: React (copy), internalProviders (copy), t1 (copy), UserInputService (copy), ContextActionService (copy), Cryo (copy)
	local v11 = if not t3 then nil else t3.commands
	local v12 = not not t3 and not not t3.emojis
	local v13 = React.useMemo(function() -- line: 48
		-- upvalues: v11 (copy), v12 (copy), internalProviders (copy)
		if not v11 and not v12 then
			return nil
		end

		return internalProviders.buildTrie(v11, v12)
	end, {
		v11 or false,
		v12
	})
	local v14, v15 = React.useState(t1)
	local v16 = React.useRef(0)
	local v17 = React.useRef(false)
	local v18 = React.useRef(v14)

	v18.current = v14

	local v19 = React.useRef(v13)

	v19.current = v13

	local v20 = "ChatAutocompleteSink_" .. tostring(t2)

	React.useEffect(function() -- line: 69
		-- upvalues: t2 (copy), t3 (copy), v16 (copy)
		local current = t2.current

		if not current or not t3 then
			return
		end

		local connection = current:GetPropertyChangedSignal("CursorPosition"):Connect(function() -- line: 74
			-- upvalues: current (copy), v16 (copy)
			local CursorPosition = current.CursorPosition

			if CursorPosition >= 0 then
				v16.current = CursorPosition
			end
		end)

		return function() -- line: 80
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		t2.current,
		t3
	})

	local function spliceResult(n1: number) -- line: 85
		-- upvalues: v18 (copy), t2 (copy), internalProviders (copy), v15 (copy), t1 (copy)
		local current = v18.current
		local v30 = current.results[n1]
		local current2 = t2.current
		local currentMatch = current.currentMatch

		if not v30 or (not current2 or not currentMatch) then
			return
		end

		local v33 = internalProviders.formatReplacement(v30)
		local current2Text = current2.Text

		current2.Text = string.sub(current2Text, 1, currentMatch.replaceStart - 1) .. v33 .. string.sub(current2Text, currentMatch.replaceFinish + 1)
		current2.CursorPosition = currentMatch.replaceStart + #v33
		v15(t1)
	end

	React.useEffect(function() -- line: 121
		-- upvalues: t3 (copy), UserInputService (copy), v18 (copy), v15 (copy), t1 (copy), t2 (copy), v16 (copy)
		if not t3 then
			return
		end

		local connection = UserInputService.InputBegan:Connect(function(input) -- line: 125
			-- upvalues: v18 (copy), v15 (copy), t1 (copy), t2 (copy), v16 (copy)
			local current = v18.current

			if not current.activated or #current.results == 0 then
				return
			end

			if input.KeyCode == Enum.KeyCode.Up then
				v15(function(p1) -- line: 132
					local v54 = if not (p1.selectedIndex <= 0) then if p1.selectedIndex ~= 1 then p1.selectedIndex - 1 else #p1.results else 1

					return {
						activated = p1.activated,
						results = p1.results,
						selectedIndex = v54,
						keyboardIndex = v54,
						currentMatch = p1.currentMatch
					}
				end)

				return
			end

			if input.KeyCode == Enum.KeyCode.Down then
				v15(function(p2) -- line: 150
					local v56 = p2.selectedIndex + 1

					if v56 > #p2.results then
						v56 = 1
					end

					return {
						activated = p2.activated,
						results = p2.results,
						selectedIndex = v56,
						keyboardIndex = v56,
						currentMatch = p2.currentMatch
					}
				end)

				return
			end

			if input.KeyCode == Enum.KeyCode.Escape then
				v15(t1)

				local current3 = t2.current

				task.defer(function() -- line: 166
					-- upvalues: current3 (copy), v16 (copy)
					if current3 then
						current3:CaptureFocus()
						current3.CursorPosition = v16.current
					end
				end)
			end
		end)

		return function() -- line: 174
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { t3 })
	React.useEffect(function() -- line: 179
		-- upvalues: v14 (copy), ContextActionService (copy), v20 (copy)
		if not v14.activated or #v14.results == 0 then
			return
		end

		ContextActionService:BindCoreAction(v20, function() -- line: 183
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Escape)

		return function() -- line: 186
			-- upvalues: ContextActionService (copy), v20 (copy)
			ContextActionService:UnbindCoreAction(v20)
		end
	end, {
		v14.activated,
		#v14.results
	})

	local v22 = React.useCallback(function(s1: string) -- line: 191
		-- upvalues: v17 (copy), v19 (copy), t2 (copy), v16 (copy), internalProviders (copy), Cryo (copy), v15 (copy), v18 (copy), t1 (copy)
		if v17.current then
			return
		end

		local current = v19.current

		if not current then
			return
		end

		local current4 = t2.current
		local v40 = if not current4 or not (current4.CursorPosition >= 0) then v16.current else current4.CursorPosition
		local v41 = internalProviders.matchTrigger(s1, v40)

		if v41 then
			local v42 = internalProviders.search(current, v41.query)

			if #v42 > 20 then
				v42 = Cryo.List.getRange(v42, 1, 20)
			end

			v15({
				selectedIndex = 0,
				keyboardIndex = 0,
				activated = #v42 > 0,
				results = v42,
				currentMatch = v41
			})

			return
		end

		if v18.current.activated then
			v15(t1)
		end
	end, {})
	local v23 = React.useCallback(function(p3, b1: boolean) -- line: 223
		-- upvalues: v18 (copy), v17 (copy), spliceResult (copy)
		if not b1 then
			return false
		end

		local current = v18.current

		if not current.activated or #current.results == 0 then
			return false
		end

		if current.selectedIndex < 1 then
			return false
		end

		v17.current = true
		spliceResult(current.selectedIndex)
		task.defer(function() -- line: 236
			-- upvalues: v17 (copy), p3 (copy)
			v17.current = false

			if p3 then
				p3:CaptureFocus()
			end
		end)

		return true
	end, {})
	local v24 = React.useCallback(function() -- line: 249
		-- upvalues: v15 (copy), t1 (copy)
		v15(t1)
	end, {})
	local v25 = React.useCallback(function(n2: number) -- line: 256
		-- upvalues: v15 (copy)
		v15(function(p4) -- line: 257
			-- upvalues: n2 (copy)
			return {
				activated = p4.activated,
				results = p4.results,
				selectedIndex = math.clamp(n2, 1, (math.max(1, #p4.results))),
				keyboardIndex = p4.keyboardIndex,
				currentMatch = p4.currentMatch
			}
		end)
	end, {})

	return {
		isOpen = v14.activated and #v14.results > 0,
		results = v14.results,
		selectedIndex = v14.selectedIndex,
		keyboardIndex = v14.keyboardIndex,
		renderEntry = internalProviders.renderEntry,
		onTextChanged = v22,
		setSelectedIndex = v25,
		commitSelection = function(n3: number) -- line: 106
			-- upvalues: v17 (copy), spliceResult (copy), t2 (copy)
			v17.current = true
			spliceResult(n3)
			task.defer(function() -- line: 109
				-- upvalues: v17 (copy), t2 (copy)
				v17.current = false

				local current = t2.current

				if current then
					current:CaptureFocus()
				end
			end)
		end,
		interceptSend = v23,
		dismiss = v24
	}
end

return useChatAutocompleteEngine
