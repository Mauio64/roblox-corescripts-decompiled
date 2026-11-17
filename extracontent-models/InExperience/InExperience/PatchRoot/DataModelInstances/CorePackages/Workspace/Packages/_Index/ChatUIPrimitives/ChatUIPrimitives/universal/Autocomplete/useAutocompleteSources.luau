local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)

require(script.Parent.AutocompleteTypes)
local assertUniqueSourceIds = require(script.Parent.assertUniqueSourceIds)
local textBoxRange = require(script.Parent.textBoxRange)
local useAutocompleteKeyboardNavigation = require(script.Parent.useAutocompleteKeyboardNavigation)
local FFlagExpChatAutocompleteRematchOnCursorMove = require(ChatUIPrimitives.Flags.FFlagExpChatAutocompleteRematchOnCursorMove)

local v = {
	activated = false,
	sections = {},
	rows = {},
	selectedIndex = 0,
	keyboardIndex = 0
}

local function nextIndex(p, selectedIndex: number, p2: number) -- 2 equivalent calls inferred from this helper
	if p == Enum.KeyCode.Up then
		if selectedIndex <= 0 then
			return 1
		end

		if selectedIndex == 1 then
			return p2
		end

		return selectedIndex - 1
	else
		if p ~= Enum.KeyCode.Down then
			return nil
		end

		local v2 = selectedIndex + 1
		return if p2 < v2 then 1 else v2
	end
end

local function indexSources(current) -- 1 equivalent call inferred from this helper
	local sourcesById = {}

	if current == nil then
		return sourcesById
	end

	assertUniqueSourceIds(current.sources)

	for _, source in current.sources do
		sourcesById[source.id] = source
	end

	return sourcesById
end

local function capResults(list, p: number) -- 1 equivalent call inferred from this helper
	if #list <= p then
		return list
	end

	local result = {}

	for i = 1, p do
		result[i] = list[i]
	end

	return result
end

local function useAutocompleteSources(p, current, p2)
	local state, setState = React.useState(v)
	local ref = React.useRef(state)
	ref.current = state

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef({})
	local ref4 = React.useRef(current)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef("")
	local ref7 = React.useRef(false)
	local ref8 = React.useRef(0)
	local ref9 = React.useRef(0)

	local function readCursor() -- 4 equivalent calls inferred from this helper
		local current2 = p.current

		if current2 ~= nil then
			local cursor = textBoxRange.readCursor(current2)

			if cursor ~= nil then
				return cursor
			end
		end

		return ref5.current
	end

	local function restoreFocus(p3: number?) -- 7 equivalent calls inferred from this helper
		task.defer(function()
			ref7.current = false

			if FFlagExpChatAutocompleteRematchOnCursorMove then
				ref8.current = 0
			end

			local current2 = p.current

			if current2 == nil then
				return
			end

			current2:CaptureFocus()

			if p3 ~= nil then
				textBoxRange.placeCursor(current2, p3)
			end
		end)
	end

	local function commitRow(p3: number): boolean
		local current2 = ref.current
		local row = current2.rows[p3]
		local current3 = p.current

		if row == nil or current3 == nil then
			ref7.current = true
			restoreFocus(nil) -- inferred equivalent call
			return false
		else
			local section = current2.sections[row.sectionIndex]
			local v2 = ref3.current[row.sourceId]

			if section == nil or v2 == nil then
				ref7.current = true
				restoreFocus(nil) -- inferred equivalent call
				return false
			else
				local v3 = v2.select(row.item)

				if v3 == nil then
					restoreFocus(readCursor()) -- inferred equivalent call
					return true
				elseif v3.kind == "insert" then
					ref7.current = true

					local splice, v4 = textBoxRange.splice(
						current3,
						section.replaceStart,
						section.replaceFinish,
						v3.text
					)

					if splice then
						setState(v)
					end

					restoreFocus(v4) -- inferred equivalent call
					return splice == true
				else
					if v3.kind == "sendDraft" then
						local current4 = ref2.current
						local onAction

						if current4 ~= nil then
							onAction = current4.onAction
						end

						if onAction ~= nil and onAction(v3) then
							ref7.current = true
							current3.Text = ""
							setState(v)
							restoreFocus(1) -- inferred equivalent call
							return true
						end
					end

					restoreFocus(readCursor()) -- inferred equivalent call
					return true
				end
			end
		end
	end

	local v2 = React.useCallback(function(p3: string)
		if ref7.current then
			return
		end

		local current2 = ref2.current

		if current2 == nil then
			return
		end

		if utf8.len(p3) == nil then
			if ref.current.activated then
				setState(v)
			end
		else
			local cursor = readCursor() -- inferred equivalent call
			local current3 = p.current

			if current3 ~= nil then
				for _, source in current2.sources do
					if source.matchCompletion == nil then
						continue
					end

					local matchCompletion = source.matchCompletion(p3, cursor)

					if matchCompletion == nil then
						continue
					end

					ref7.current = true
					local splice, v2 = textBoxRange.splice(
						current3,
						matchCompletion.replaceStart,
						matchCompletion.replaceFinish,
						matchCompletion.replacement
					)

					if splice then
						if ref.current.activated then
							setState(v)
						end

						restoreFocus(v2) -- inferred equivalent call
						return
					end

					ref7.current = false
				end
			end

			local sections = {}
			local rows = {}

			for _, source in current2.sources do
				local matchTrigger = source.matchTrigger(p3, cursor)

				if matchTrigger == nil then
					continue
				end

				local v2 = source.maxResults == nil and 20 or source.maxResults
				local results = capResults(source.search(matchTrigger.query), v2) -- inferred equivalent call

				if not (#results > 0) then
					continue
				end

				table.insert(sections, {
					sourceId = source.id,
					results = results,
					replaceStart = matchTrigger.replaceStart,
					replaceFinish = matchTrigger.replaceFinish
				})

				local sectionIndex = #sections

				for k, v3 in results do
					table.insert(rows, {
						sourceId = source.id,
						item = v3,
						sectionIndex = sectionIndex,
						rowIndex = k
					})
				end
			end

			if #rows > 0 then
				setState({
					activated = true,
					sections = sections,
					rows = rows,
					selectedIndex = 0,
					keyboardIndex = 0
				})
			elseif ref.current.activated then
				setState(v)
			end
		end
	end, {})

	React.useEffect(function()
		local current2 = p.current

		if current2 == nil or current == nil then
			return
		end

		local cursorPositionChangedConnection = current2:GetPropertyChangedSignal("CursorPosition"):Connect(function()
			local cursor = textBoxRange.readCursor(current2)

			if cursor ~= nil then
				ref5.current = cursor

				if FFlagExpChatAutocompleteRematchOnCursorMove and os.clock() <= ref8.current then
					ref8.current = 0

					if current2:IsFocused() and current2.Text == ref6.current and cursor ~= ref9.current then
						v2(current2.Text)
					end
				end
			end
		end)
		return function()
			cursorPositionChangedConnection:Disconnect()
		end
	end, { p.current, current })

	local v3 = React.useCallback(function(p3)
		local current2 = ref.current

		if not current2.activated or #current2.rows == 0 then
			return
		end

		if p3 == Enum.KeyCode.Escape then
			setState(v)

			if FFlagExpChatAutocompleteRematchOnCursorMove then
				ref8.current = 0
			end

			local current3 = p.current
			local current4 = ref5.current
			task.defer(function()
				if current3 then
					current3:CaptureFocus()
					textBoxRange.placeCursor(current3, current4)
				end
			end)
		else
			if nextIndex(p3, current2.selectedIndex, #current2.rows) == nil then -- inferred equivalent call
				return
			end

			setState(function(data)
				local v3 = nextIndex(p3, data.selectedIndex, #data.rows) -- inferred equivalent call

				if v3 == nil then
					return data
				end

				return {
					activated = data.activated,
					sections = data.sections,
					rows = data.rows,
					selectedIndex = v3,
					keyboardIndex = v3
				}
			end)
		end
	end, {})

	local v4 = state.activated and #state.rows > 0

	if current == nil then
		v3 = nil
	end

	useAutocompleteKeyboardNavigation(v4, v3, p2)

	React.useEffect(function()
		local current2 = ref2.current

		if current2 == nil then
			return
		end

		local flag = false
		local v5 = {}

		for _, source in current2.sources do
			if source.subscribe ~= nil then
				table.insert(v5, (source.subscribe(function()
					if flag then
						return
					end

					v2(ref6.current)
				end)))
			end
		end

		local current3 = p.current
		local current4

		if current3 == nil then
			current4 = ref6.current
		else
			current4 = current3.Text
		end

		ref6.current = current4
		v2(current4)
		return function()
			flag = true

			for _, v6 in v5 do
				v6()
			end

			setState(v)
		end
	end, { current, v2 })

	local onTextChanged = React.useCallback(function(current2: string)
		ref6.current = current2

		if FFlagExpChatAutocompleteRematchOnCursorMove and not ref7.current then
			ref8.current = os.clock() + 0.5
			ref9.current = readCursor() -- inferred equivalent call
		end

		v2(current2)
	end, { v2 })

	local commitSelection = React.useCallback(function(p3: number)
		commitRow(p3)
	end, {})

	local interceptSend = React.useCallback(function(_, flag: boolean)
		if not flag then
			return false
		end

		local current2 = ref.current

		if current2.activated and #current2.rows ~= 0 and not (current2.selectedIndex < 1) then
			return commitRow(current2.selectedIndex)
		end

		return false
	end, {})

	local dismiss = React.useCallback(function()
		setState(v)
	end, {})

	local setSelectedIndex = React.useCallback(function(value: number)
		setState(function(data)
			return {
				activated = data.activated,
				sections = data.sections,
				rows = data.rows,
				selectedIndex = math.clamp(value, 1, (math.max(1, #data.rows))),
				keyboardIndex = data.keyboardIndex
			}
		end)
	end, {})

	local renderEntry = React.useCallback(function(p3, flag: boolean)
		local v5 = ref3.current[p3.sourceId]

		if v5 == nil then
			return nil
		end

		return v5.renderEntry(p3.item, flag)
	end, {})
	local current2 = indexSources(current) -- inferred equivalent call

	if ref4.current ~= current then
		ref4.current = current

		if state.activated then
			setState(v)
		end
	end

	ref2.current = current
	ref3.current = current2

	return {
		isOpen = state.activated and #state.rows > 0,
		results = state.rows,
		selectedIndex = state.selectedIndex,
		keyboardIndex = state.keyboardIndex,
		renderEntry = renderEntry,
		onTextChanged = onTextChanged,
		setSelectedIndex = setSelectedIndex,
		commitSelection = commitSelection,
		interceptSend = interceptSend,
		dismiss = dismiss
	}
end

return useAutocompleteSources
