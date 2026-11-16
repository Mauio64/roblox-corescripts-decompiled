local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local internalProviders = require(script.Parent.internalProviders)

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatAutocompleteOptimization = SharedFlags.FFlagExpChatAutocompleteOptimization

local FFlagExpChatAutocompleteLazyBuild = require(ChatUIPrimitives.Flags.FFlagExpChatAutocompleteLazyBuild)

local v = {
	activated = false,
	results = {},
	selectedIndex = 0,
	keyboardIndex = 0,
	currentMatch = nil
}

local function spliceInto(current, replaceStart: number, replaceFinish: number, list: string) -- 2 equivalent calls inferred from this helper
	local text = current.Text
	current.Text = string.sub(text, 1, replaceStart - 1) .. list .. string.sub(text, replaceFinish + 1)
	current.CursorPosition = replaceStart + #list
end

local function useChatAutocompleteEngine(p, p2)
	local commands

	if p2 then
		commands = p2.commands
	else
		commands = nil
	end

	local current4 = p2 and p2.emojis and true or false

	local current5 = React.useMemo(function()
		if not (commands or current4) then
			return nil
		end

		if not FFlagExpChatAutocompleteOptimization then
			return internalProviders.buildTrie(commands, current4)
		end

		local emoji

		if current4 and not FFlagExpChatAutocompleteLazyBuild then
			emoji = internalProviders.getEmojiStructure()
		end

		local command

		if commands then
			command = internalProviders.buildCommandTrie(commands)
		end

		return { emoji = emoji, command = command }
	end, { commands or false, current4 })

	local state, setState = React.useState(v)
	local ref = React.useRef(0)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(state)
	ref3.current = state
	local ref4 = React.useRef(current5)
	ref4.current = current5
	local ref5 = React.useRef(current4)
	ref5.current = current4

	local v2 = "ChatAutocompleteSink_" .. tostring(p)

	React.useEffect(function()
		local current = p.current

		if current and p2 then
			local cursorPositionChangedConnection = current:GetPropertyChangedSignal("CursorPosition"):Connect(function()
				local cursorPosition = current.CursorPosition

				if cursorPosition >= 0 then
					ref.current = cursorPosition
				end
			end)
			return function()
				cursorPositionChangedConnection:Disconnect()
			end
		end
	end, { p.current, p2 })

	local function spliceResult(p3: number) -- 2 equivalent calls inferred from this helper
		local current = ref3.current
		local result = current.results[p3]
		local current2 = p.current
		local currentMatch = current.currentMatch

		if not (result and current2 and currentMatch) then
			return
		end

		spliceInto( -- inferred equivalent call
			current2,
			currentMatch.replaceStart,
			currentMatch.replaceFinish,
			internalProviders.formatReplacement(result)
		)
		setState(v)
	end

	local function commitSelection(p3: number)
		ref2.current = true
		spliceResult(p3) -- inferred equivalent call
		task.defer(function()
			ref2.current = false
			local current = p.current

			if current then
				current:CaptureFocus()
			end
		end)
	end

	React.useEffect(function()
		if not p2 then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			local current = ref3.current

			if not current.activated or #current.results == 0 then
				return
			end

			if input.KeyCode == Enum.KeyCode.Up then
				setState(function(data)
					local v3

					if data.selectedIndex <= 0 then
						v3 = 1
					elseif data.selectedIndex == 1 then
						v3 = #data.results
					else
						v3 = data.selectedIndex - 1
					end

					return {
						activated = data.activated,
						results = data.results,
						selectedIndex = v3,
						keyboardIndex = v3,
						currentMatch = data.currentMatch
					}
				end)
			elseif input.KeyCode == Enum.KeyCode.Down then
				setState(function(data)
					local v3 = data.selectedIndex + 1
					local v4 = #data.results < v3 and 1 or v3

					return {
						activated = data.activated,
						results = data.results,
						selectedIndex = v4,
						keyboardIndex = v4,
						currentMatch = data.currentMatch
					}
				end)
			elseif input.KeyCode == Enum.KeyCode.Escape then
				setState(v)
				local current2 = p.current
				task.defer(function()
					if current2 then
						current2:CaptureFocus()
						current2.CursorPosition = ref.current
					end
				end)
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { p2 })

	React.useEffect(function()
		if not state.activated or #state.results == 0 then
			return
		end

		ContextActionService:BindCoreAction(v2, function()
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Escape)
		return function()
			ContextActionService:UnbindCoreAction(v2)
		end
	end, { state.activated, #state.results })

	local onTextChanged = React.useCallback(function(p3: string)
		if ref2.current then
			return
		end

		local current = ref4.current

		if not current then
			return
		end

		local current2 = p.current
		local v3

		if current2 and current2.CursorPosition >= 0 then
			v3 = current2.CursorPosition
		else
			v3 = ref.current
		end

		local v4 = ref5.current and current2 and internalProviders.matchColonCompletion(p3, v3)

		if v4 then
			ref2.current = true
			spliceInto(current2, v4.replaceStart, v4.replaceFinish, v4.replacement) -- inferred equivalent call
			task.defer(function()
				ref2.current = false
				local current3 = p.current

				if current3 then
					current3:CaptureFocus()
				end
			end)

			if ref3.current.activated then
				setState(v)
			end
		else
			local matchTrigger = internalProviders.matchTrigger(p3, v3)

			if matchTrigger then
				if
					FFlagExpChatAutocompleteOptimization
					and FFlagExpChatAutocompleteLazyBuild
					and ref5.current
					and not current.emoji
					and string.sub(matchTrigger.query, 1, 1) == ":"
				then
					current.emoji = internalProviders.getEmojiStructure()
				end

				local results

				if FFlagExpChatAutocompleteOptimization then
					results = internalProviders.searchStructures(current, matchTrigger.query)
				else
					results = internalProviders.search(current, matchTrigger.query)
				end

				if #results > 20 then
					results = Cryo.List.getRange(results, 1, 20)
				end

				setState({
					activated = #results > 0,
					results = results,
					selectedIndex = 0,
					keyboardIndex = 0,
					currentMatch = matchTrigger
				})
			elseif ref3.current.activated then
				setState(v)
			end
		end
	end, {})

	local interceptSend = React.useCallback(function(object, flag: boolean): boolean
		if not flag then
			return false
		end

		local current = ref3.current

		if not current.activated or #current.results == 0 or current.selectedIndex < 1 then
			return false
		end

		ref2.current = true
		spliceResult(current.selectedIndex) -- inferred equivalent call
		task.defer(function()
			ref2.current = false

			if object then
				object:CaptureFocus()
			end
		end)
		return true
	end, {})

	local dismiss = React.useCallback(function()
		setState(v)
	end, {})

	local setSelectedIndex = React.useCallback(function(value: number)
		setState(function(data)
			return {
				activated = data.activated,
				results = data.results,
				selectedIndex = math.clamp(value, 1, (math.max(1, #data.results))),
				keyboardIndex = data.keyboardIndex,
				currentMatch = data.currentMatch
			}
		end)
	end, {})

	return {
		isOpen = state.activated and #state.results > 0,
		results = state.results,
		selectedIndex = state.selectedIndex,
		keyboardIndex = state.keyboardIndex,
		renderEntry = internalProviders.renderEntry,
		onTextChanged = onTextChanged,
		setSelectedIndex = setSelectedIndex,
		commitSelection = commitSelection,
		interceptSend = interceptSend,
		dismiss = dismiss
	}
end

return useChatAutocompleteEngine
