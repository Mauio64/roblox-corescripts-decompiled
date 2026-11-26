local function composeRefs(...)
	local v5 = { ... }
	return function(current)
		for k, v6 in v5 do
			if type(v6) == "function" then
				v6(current)
			elseif v6 ~= nil then
				v6.current = current
			end
		end
	end
end

return composeRefs
