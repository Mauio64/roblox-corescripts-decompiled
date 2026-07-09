local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.Components.WidgetList.Types)

local function getEntriesAsRows(t1: {[any]: any}, n1: number, n2: number) -- line: 5
	local t2 = {}

	for i = 1, n1 do
		t2[i] = {}
	end

	for v8, v9 in t1 do
		local v10 = t2[math.ceil(v8 / n2)]

		if v10 then
			table.insert(v10, v9)
		end
	end

	return t2
end

return getEntriesAsRows
