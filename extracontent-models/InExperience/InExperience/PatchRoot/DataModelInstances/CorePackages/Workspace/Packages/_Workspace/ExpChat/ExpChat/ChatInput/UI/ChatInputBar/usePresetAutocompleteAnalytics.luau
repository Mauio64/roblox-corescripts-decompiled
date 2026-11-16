local HttpService = game:GetService("HttpService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)

local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local Constants = require(ExpChat.PresetChat.Constants)
local PresetSearch = require(ExpChat.Autocomplete.PresetSearch)

local getEnableChatInputBarConfigurationAutocompleteEnabled = require(ExpChat.Flags.getEnableChatInputBarConfigurationAutocompleteEnabled)

local ExtendedStandardizedFields = Constants.Analytics.ExtendedStandardizedFields

local v = {}

local function usePresetAutocompleteAnalytics(data)
	local autocompleteDropdownReducer = data.autocompleteDropdownReducer
	local v2

	if autocompleteDropdownReducer == nil then
		v2 = v
	else
		v2 = autocompleteDropdownReducer.results
	end

	local v3

	if autocompleteDropdownReducer == nil then
		v3 = false
	else
		v3 = autocompleteDropdownReducer.activated

		if v3 then
			if autocompleteDropdownReducer.autocompleteType == "presets" and #v2 > 0 then
				v3 = data.isFocused

				if v3 then
					if data.autocompleteEnabled == true then
						v3 = getEnableChatInputBarConfigurationAutocompleteEnabled()
					else
						v3 = false
					end
				end
			else
				v3 = false
			end
		end
	end

	local ref = React.useRef(nil)

	local ref2 = React.useRef({})
	local ref3 = React.useRef({})

	local ref4 = React.useRef({})
	local ref5 = React.useRef(nil)

	local v4 = React.useCallback(function()
		local current = ref.current

		if current == nil then
			return
		end

		local v4 = {}

		for k, v5 in ref4.current do
			v4[v5] = k - 1
		end

		local v5 = {}

		for _, preset_id in ref2.current do
			local v6 = v4[preset_id]
			table.insert(v5, {
				preset_id = preset_id,
				index = v6 == nil and -1 or v6,
				click = ref5.current == preset_id and 1 or 0
			})
		end

		ref.current = nil
		ref2.current = {}
		ref3.current = {}
		ref4.current = {}
		ref5.current = nil

		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Dismiss,
				component = Constants.Analytics.Components.AutocompleteDropdown,
				autocomplete_session_id = current,
				preset_items = HttpService:JSONEncode(v5)
			},
			ExtendedStandardizedFields
		)
	end, {})

	local recordPresetChosen = React.useCallback(function(p: string)
		if ref.current == nil then
			return
		end

		local presetIdForValue = PresetSearch.getPresetIdForValue(GetPresetChatStore(false), p)

		if presetIdForValue == nil then
			return
		end

		ref5.current = presetIdForValue
	end, {})

	React.useEffect(function()
		if not v3 then
			return
		end

		local presetChatStore = GetPresetChatStore(false)
		local presetIdForValues = {}

		for _, v5 in v2 do
			local presetIdForValue = PresetSearch.getPresetIdForValue(presetChatStore, v5)

			if presetIdForValue == nil then
				continue
			end

			table.insert(presetIdForValues, presetIdForValue)

			if ref3.current[presetIdForValue] then
				continue
			end

			ref3.current[presetIdForValue] = true
			table.insert(ref2.current, presetIdForValue)
		end

		ref4.current = presetIdForValues
	end, { v3, v2 })

	React.useEffect(function()
		if not v3 then
			v4()
			return
		end

		if ref.current ~= nil then
			return
		end

		local guid = HttpService:GenerateGUID(false)
		ref.current = guid

		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Show,
				component = Constants.Analytics.Components.AutocompleteDropdown,
				autocomplete_session_id = guid
			},
			ExtendedStandardizedFields
		)
	end, { v3, v4 })

	React.useEffect(function()
		return function()
			v4()
		end
	end, { v4 })

	return { recordPresetChosen = recordPresetChosen }
end

return usePresetAutocompleteAnalytics
