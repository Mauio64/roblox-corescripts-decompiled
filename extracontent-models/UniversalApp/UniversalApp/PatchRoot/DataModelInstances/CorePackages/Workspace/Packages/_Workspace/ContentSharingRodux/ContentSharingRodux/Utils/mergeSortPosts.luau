local function v1(p1, p2) -- line: 1
	return p1.uploadedAtTimestamp > p2.uploadedAtTimestamp
end

return function(p3, p4) -- line: 5
	-- upvalues: v1 (copy)
	local n1 = 1
	local n2 = 1
	local t1 = {}
	local t2 = {}

	table.sort(p4, v1)

	while n1 <= #p4 and n2 <= #p3 do
		if p4[n1].uploadedAtTimestamp >= p3[n2].uploadedAtTimestamp then
			if not t2[p4[n1].postId] then
				table.insert(t1, p4[n1])
				t2[p4[n1].postId] = true
			end

			n1 += 1
		else
			if not t2[p3[n2].postId] then
				table.insert(t1, p3[n2])
				t2[p3[n2].postId] = true
			end

			n2 += 1
		end
	end

	if n1 <= #p4 then
		for i = n1, #p4 do
			if not t2[p4[i].postId] then
				table.insert(t1, p4[i])
				t2[p4[i].postId] = true
			end
		end
	end

	if n2 <= #p3 then
		for i = n2, #p3 do
			if not t2[p3[i].postId] then
				table.insert(t1, p3[i])
				t2[p3[i].postId] = true
			end
		end
	end

	return t1
end
