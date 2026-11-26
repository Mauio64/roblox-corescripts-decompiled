require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local function buildHydrationReduxPayload(items, items2)
	local hydrationReduxPayload = {}

	for k, item in items do
		local kind = item.type
		local id = tostring(item.id)

		if not hydrationReduxPayload[kind] then
			hydrationReduxPayload[kind] = {}
		end

		local clone = table.clone(item)
		clone.id = id
		hydrationReduxPayload[kind][id] = clone
	end

	for k, item in items2 do
		local kind = item.type
		local id = tostring(item.id)

		if not hydrationReduxPayload[kind] then
			hydrationReduxPayload[kind] = {}
		end

		if not hydrationReduxPayload[kind][id] then
			hydrationReduxPayload[kind][id] = {
				id = id,
				type = kind,
				failedToHydrate = true
			}
		end
	end

	return hydrationReduxPayload
end

return buildHydrationReduxPayload
