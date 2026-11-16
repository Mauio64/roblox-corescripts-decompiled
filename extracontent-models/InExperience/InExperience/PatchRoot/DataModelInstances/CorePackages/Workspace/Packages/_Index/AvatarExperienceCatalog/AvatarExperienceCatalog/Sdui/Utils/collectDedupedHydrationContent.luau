local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local v = { Asset = true, Bundle = true, Look = true }

local function collectDedupedHydrationContent(list, list2, p, p2: number?)
	local v2

	if p2 then
		v2 = math.min(p2, #list)
	else
		v2 = #list
	end

	for i = 1, v2 do
		local item = list[i]
		local kind = tostring(item.type)
		local id = tostring(item.id)

		if not v[kind] then
			continue
		end

		local v3 = p[kind] or {}

		if v3[id] then
			continue
		end

		v3[id] = true
		p[kind] = v3

		table.insert(list2, item)
	end
end

return collectDedupedHydrationContent
