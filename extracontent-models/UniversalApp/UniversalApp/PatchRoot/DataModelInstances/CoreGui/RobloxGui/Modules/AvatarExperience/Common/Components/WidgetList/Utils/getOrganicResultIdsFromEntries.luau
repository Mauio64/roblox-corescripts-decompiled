local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Components.WidgetList.Types)

local function getOrganicResultIdsFromEntries(t1: {[any]: any}) -- line: 5
	local t2 = {}

	for _, v6 in t1 do
		if v6.id and v6.type then
			table.insert(t2, v6.type .. v6.id)
		end
	end

	return t2
end

return getOrganicResultIdsFromEntries
