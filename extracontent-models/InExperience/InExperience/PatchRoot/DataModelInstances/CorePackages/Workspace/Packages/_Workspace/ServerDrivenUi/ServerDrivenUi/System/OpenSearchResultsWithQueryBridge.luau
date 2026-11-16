local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete

local v = Signal.new()

local v2 = {}

local function connectAutocompleteHost(confirmSearch, suggestionClicked)
	local v3 = { confirmSearch = confirmSearch, suggestionClicked = suggestionClicked }
	table.insert(v2, v3)
	return {
		disconnect = function(_)
			local index = table.find(v2, v3)

			if index then
				table.remove(v2, index)
			end
		end
	}
end

local function runSuggestionClicked(p: string, p2: string, p3: string, p4: number)
	for i = #v2, 1, -1 do
		local suggestionClicked = v2[i].suggestionClicked

		if suggestionClicked and suggestionClicked(p, p2, p3, p4) then
			break
		end
	end
end

local OpenSearchResultsWithQueryBridge = {
	run = function(p: string, p2: string, flag: boolean?, p3: string?)
		if not FFlagLuaAppSduiSearchAutocomplete then
			v:fire(p, p2)

			return
		end

		if flag and p3 then
			for i = #v2, 1, -1 do
				if v2[i].confirmSearch(p, p2, p3) then
					return
				end
			end
		end

		v:fire(p, p2, flag == true, p3)
	end,
	connect = function(self)
		return v:connect(self)
	end,
	connectAutocompleteHost = 0,
	runSuggestionClicked = 0
}

if not FFlagLuaAppSduiSearchAutocomplete then
	connectAutocompleteHost = nil
end

OpenSearchResultsWithQueryBridge.connectAutocompleteHost = connectAutocompleteHost

if not FFlagLuaAppSduiSearchAutocomplete then
	runSuggestionClicked = nil
end

OpenSearchResultsWithQueryBridge.runSuggestionClicked = runSuggestionClicked
return OpenSearchResultsWithQueryBridge
