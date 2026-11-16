return function(p, list)
	local localUserId = p.LocalUserId

	for _, item in ipairs(list) do
		if item ~= localUserId then
			return item
		end
	end
end
