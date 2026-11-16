local function composeRefs(...)
	local v = { ... }
	return function(current)
		for _, v2 in v do
			if type(v2) == "function" then
				v2(current)
			elseif type(v2) == "table" then
				v2.current = current
			end
		end
	end
end

return composeRefs
