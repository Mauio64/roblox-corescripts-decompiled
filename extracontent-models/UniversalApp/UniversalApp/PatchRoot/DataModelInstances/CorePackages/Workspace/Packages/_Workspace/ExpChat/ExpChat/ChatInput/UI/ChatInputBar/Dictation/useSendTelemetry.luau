local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

require(script.Parent.DictationMode)

local DictationAnalytics = require(script.Parent.DictationAnalytics)

local function classifyEditType(s1: string, s2: string) -- line: 29
	-- upvalues: DictationAnalytics (copy)
	if #s2 == 0 then
		return DictationAnalytics.EditTypes.FullClear
	end

	if #s2 > #s1 and s1 == string.sub(s2, 1, #s1) then
		return DictationAnalytics.EditTypes.Addition
	end

	if #s2 < #s1 and s2 == string.sub(s1, 1, #s2) then
		return DictationAnalytics.EditTypes.Deletion
	end

	return DictationAnalytics.EditTypes.Mixed
end
local function useSendTelemetry(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), DictationAnalytics (copy), classifyEditType (copy)
	local enabled = t1.enabled
	local textBoxRef = t1.textBoxRef
	local customTextBoxRef = t1.customTextBoxRef
	local v12 = React.useRef(nil)
	local v13 = React.useRef(nil)
	local v14 = React.useRef(false)
	local v15 = React.useCallback(function(s3: string, p1) -- line: 57
		-- upvalues: enabled (copy), v13 (copy), v12 (copy), DictationAnalytics (copy)
		if not enabled then
			return
		end

		v13.current = s3
		v12.current = {
			mode = p1,
			outcome = DictationAnalytics.Outcomes.Full,
			textStt = s3
		}
	end, { enabled })
	local v16 = React.useCallback(function(s4: string) -- line: 69
		-- upvalues: enabled (copy), v12 (copy), v14 (copy)
		if not enabled then
			return nil
		end

		local current = v12.current

		v12.current = nil

		if current == nil then
			return nil
		end

		v14.current = true
		current.textSent = s4

		return current
	end, { enabled })

	React.useEffect(function() -- line: 83
		-- upvalues: enabled (copy), customTextBoxRef (copy), textBoxRef (copy), v13 (copy), v14 (copy), v12 (copy), DictationAnalytics (copy), classifyEditType (copy)
		if not enabled then
			return
		end

		local v21 = customTextBoxRef.current or textBoxRef.current

		if v21 == nil then
			return
		end

		local connection = v21:GetPropertyChangedSignal("Text"):Connect(function() -- line: 91
			-- upvalues: v13 (copy), v14 (copy), v21 (copy), v12 (copy), DictationAnalytics (copy), classifyEditType (copy)
			local current = v13.current

			if current == nil then
				return
			end

			if v14.current then
				v14.current = false
				v13.current = nil

				return
			end

			local Text = v21.Text

			if Text == current then
				return
			end

			if v12.current then
				v12.current.outcome = DictationAnalytics.Outcomes.Partial
			end

			DictationAnalytics.fire(DictationAnalytics.Events.TextEdit, {
				[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Standard,
				[DictationAnalytics.Properties.EditType] = classifyEditType(current, Text)
			})
		end)

		return function() -- line: 113
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		enabled,
		textBoxRef,
		customTextBoxRef
	})

	return {
		stageTranscription = v15,
		consumeOnSend = v16
	}
end

return useSendTelemetry
