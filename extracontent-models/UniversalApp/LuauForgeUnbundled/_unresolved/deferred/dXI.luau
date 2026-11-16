require("@luauforge/deferred/dXw")

return function(items, p2)
	local v5 = 1

	for k, item in pairs(items) do
		if item.postId == p2 then
			return v5
		end

		v5 += 1
	end

	return nil
end
