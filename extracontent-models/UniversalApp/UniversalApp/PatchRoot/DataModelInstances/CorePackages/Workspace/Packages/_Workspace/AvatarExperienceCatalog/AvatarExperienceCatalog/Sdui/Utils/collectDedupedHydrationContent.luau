local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local t1 = {
	Asset = true,
	Bundle = true,
	Look = true
}

local function collectDedupedHydrationContent(t2: {[any]: any}, t3: {[any]: any}, t4: {[any]: any}, n1: number?) -- line: 22
	-- upvalues: t1 (copy)
	for i = 1, if not n1 then #t2 else math.min(n1, #t2) do
		local v9 = t2[i]
		local str = tostring(v9.type)
		local str2 = tostring(v9.id)

		if t1[str] then
			local v12 = t4[str] or {}

			if not v12[str2] then
				v12[str2] = true
				t4[str] = v12
				table.insert(t3, v9)
			end
		end
	end
end

return collectDedupedHydrationContent
