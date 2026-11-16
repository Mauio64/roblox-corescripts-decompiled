local CommonUtil = {}

function CommonUtil.TableConcat(list, list2)
	for i = 1, #list2 do
		list[#list + 1] = list2[i]
	end

	return list
end

function CommonUtil.SortByName(list)
	local function compareInstanceNames(p, p2): boolean
		return p.Name < p2.Name
	end

	table.sort(list, compareInstanceNames)
	return list
end

return CommonUtil
