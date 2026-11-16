local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local function isAutocompleteSelectionFresh(p: string?, p2: string, p3: number, p4: string): boolean
	local v

	if p then
		v = SduiSharedUtilities.getSduiApiStore().getInputData(p, "suggestions")
	end

	local v2

	if v and v.suggestions then
		v2 = v.suggestions[p3]
	end

	return v ~= nil and v.prefix == p2 and v2 ~= nil and v2.search_query == p4
end

return isAutocompleteSelectionFresh
