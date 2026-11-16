local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities")

local function isAutocompleteSelectionFresh(p2, p3, p4, p5): boolean
	local v5 = if p2 then SduiSharedUtilities.getSduiApiStore().getInputData(p2, "suggestions") else nil

	local v6 = if v5 and v5.suggestions then v5.suggestions[p4] else nil
	return v5 ~= nil and v5.prefix == p3 and v6 ~= nil and v6.search_query == p5
end

return isAutocompleteSelectionFresh
