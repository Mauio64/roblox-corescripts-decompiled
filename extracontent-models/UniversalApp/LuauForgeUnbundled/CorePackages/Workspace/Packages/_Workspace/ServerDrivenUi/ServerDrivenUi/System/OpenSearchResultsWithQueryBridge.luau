local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppCommonLib").Signal
local fFlagLuaAppSduiSearchAutocomplete = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiSearchAutocomplete

local v5 = signal.new()

local v6 = {}

local function connectAutocompleteHost(p2, p3)
	local v7 = { confirmSearch = p2, suggestionClicked = p3 }
	table.insert(v6, v7)
	return {
		disconnect = function(p4)
			local index = table.find(v6, v7)

			if index then
				table.remove(v6, index)
			end
		end
	}
end

local function runSuggestionClicked(p2, p3, p4, p5)
	for i = #v6, 1, -1 do
		local suggestionClicked = v6[i].suggestionClicked

		if suggestionClicked and suggestionClicked(p2, p3, p4, p5) then
			break
		end
	end
end

local v7 = {
	run = function(p2, p3, p4, p5)
		if not fFlagLuaAppSduiSearchAutocomplete then
			v5:fire(p2, p3)

			return
		end

		if p4 and p5 then
			for i = #v6, 1, -1 do
				if v6[i].confirmSearch(p2, p3, p5) then
					return
				end
			end
		end

		v5:fire(p2, p3, p4 == true, p5)
	end,
	connect = function(p2)
		return v5:connect(p2)
	end,
	connectAutocompleteHost = 0,
	runSuggestionClicked = 0
}

if not fFlagLuaAppSduiSearchAutocomplete then
	connectAutocompleteHost = nil
end

v7.connectAutocompleteHost = connectAutocompleteHost

if not fFlagLuaAppSduiSearchAutocomplete then
	runSuggestionClicked = nil
end

v7.runSuggestionClicked = runSuggestionClicked
return v7
