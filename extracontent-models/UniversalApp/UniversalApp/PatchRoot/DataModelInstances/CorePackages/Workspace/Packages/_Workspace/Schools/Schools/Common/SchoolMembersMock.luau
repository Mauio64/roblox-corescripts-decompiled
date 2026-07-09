local t1 = {
	ALL_YEARS = "allYears"
}
local t2 = {
	{
		userId = "8315650029",
		graduationYear = 2025
	},
	{
		userId = "8040950308",
		graduationYear = 2026
	},
	{
		userId = "1",
		graduationYear = 2024
	},
	{
		userId = "156",
		graduationYear = 2025
	},
	{
		userId = "261",
		graduationYear = 2024
	},
	{
		userId = "24813339",
		graduationYear = 2026
	},
	{
		userId = "13268404",
		graduationYear = 2025
	},
	{
		userId = "2470023",
		graduationYear = 2026
	},
	{
		userId = "21441956",
		graduationYear = 2024
	},
	{
		userId = "1995870730",
		graduationYear = 2027
	}
}

function t1.listGroupMemberships() -- line: 34
	-- upvalues: t2 (copy)
	return t2
end
function t1.listMembershipsByClassYear(n1: number) -- line: 39
	-- upvalues: t2 (copy)
	local t3 = {}

	for _, v6 in t2 do
		if n1 == v6.graduationYear then
			table.insert(t3, v6)
		end
	end

	return t3
end
function t1.getClassYears() -- line: 50
	-- upvalues: t2 (copy)
	local t4 = {}
	local t5 = {}

	for _, v10 in t2 do
		if not t4[v10.graduationYear] then
			t4[v10.graduationYear] = true
			table.insert(t5, v10.graduationYear)
		end
	end

	table.sort(t5)

	return t5
end

return t1
