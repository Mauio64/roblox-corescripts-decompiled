local function fn(p2, p3): boolean
	return p2.uploadedAtTimestamp > p3.uploadedAtTimestamp
end

return function(list, list2)
	table.sort(list2, fn)
	local v5 = 1
	local v6 = 1
	local postIdSet = {}
	local result = {}

	while v5 <= #list2 and v6 <= #list do
		if list2[v5].uploadedAtTimestamp >= list[v6].uploadedAtTimestamp then
			if not postIdSet[list2[v5].postId] then
				table.insert(result, list2[v5])
				postIdSet[list2[v5].postId] = true
			end

			v5 += 1
		else
			if not postIdSet[list[v6].postId] then
				table.insert(result, list[v6])
				postIdSet[list[v6].postId] = true
			end

			v6 += 1
		end
	end

	if v5 <= #list2 then
		for i = v5, #list2 do
			if postIdSet[list2[i].postId] then
				continue
			end

			table.insert(result, list2[i])
			postIdSet[list2[i].postId] = true
		end
	end

	if v6 <= #list then
		for i = v6, #list do
			if postIdSet[list[i].postId] then
				continue
			end

			table.insert(result, list[i])
			postIdSet[list[i].postId] = true
		end
	end

	return result
end
