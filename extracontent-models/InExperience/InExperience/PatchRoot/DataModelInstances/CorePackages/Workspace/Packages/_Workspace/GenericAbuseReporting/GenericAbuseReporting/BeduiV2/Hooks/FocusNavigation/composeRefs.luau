local function composeRefs(...)
	local v = { ... }
	return function(current)
		for _, v2 in v do
			if type(v2) == "function" then
				v2(current)
			elseif v2 ~= nil then
				v2.current = current
			end
		end
	end
end

return composeRefs
