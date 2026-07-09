local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local function getWidgetItemIdsFromWidgetInfo(p1, n1: number) -- line: 9
	local t1 = {}

	if p1 and p1.content then
		for _, v7 in p1.content do
			if v7.id then
				table.insert(t1, v7.id)
			end
		end
	end

	if n1 < #t1 then
		t1 = table.move(t1, 1, n1, 1, {})
	end

	return t1
end

return getWidgetItemIdsFromWidgetInfo
