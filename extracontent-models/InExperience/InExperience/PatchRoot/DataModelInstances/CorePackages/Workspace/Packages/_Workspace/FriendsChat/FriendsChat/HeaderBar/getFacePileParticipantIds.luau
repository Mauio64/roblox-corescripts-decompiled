local function getFacePileParticipantIds(t1: {[any]: any}, n1: number) -- line: 13
	if #t1 <= 1 then
		return { n1 }
	end

	local t2 = {}

	for _, v6 in t1 do
		if v6 ~= n1 then
			table.insert(t2, v6)
		end
	end

	if #t2 == 0 then
		return { n1 }
	end

	return t2
end

return getFacePileParticipantIds
