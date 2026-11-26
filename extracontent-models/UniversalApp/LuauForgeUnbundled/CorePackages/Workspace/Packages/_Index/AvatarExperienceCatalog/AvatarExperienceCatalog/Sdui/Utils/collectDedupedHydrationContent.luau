require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local v5 = { Asset = true, Bundle = true, Look = true }

local function collectDedupedHydrationContent(list, list2, p2, p3)
	local v6 = if p3 then math.min(p3, #list) else #list

	for i = 1, v6 do
		local item = list[i]
		local kind = tostring(item.type)
		local id = tostring(item.id)

		if not v5[kind] then
			continue
		end

		local v7 = p2[kind] or {}

		if v7[id] then
			continue
		end

		v7[id] = true
		p2[kind] = v7

		table.insert(list2, item)
	end
end

return collectDedupedHydrationContent
