require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")

local function getSelectableRecipients(items, items2)
	local idSet = {}

	for k, item in items do
		idSet[item.id] = true
	end

	local clone = table.clone(items)

	for k, item in items2 do
		if not idSet[item.id] then
			table.insert(clone, item)
		end
	end

	return clone
end

return getSelectableRecipients
