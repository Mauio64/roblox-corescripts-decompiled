return function(p1, p2) -- line: 1
	local LocalUserId = p1.LocalUserId

	for _, v in ipairs(p2) do
		if v ~= LocalUserId then
			return v
		end
	end
end
