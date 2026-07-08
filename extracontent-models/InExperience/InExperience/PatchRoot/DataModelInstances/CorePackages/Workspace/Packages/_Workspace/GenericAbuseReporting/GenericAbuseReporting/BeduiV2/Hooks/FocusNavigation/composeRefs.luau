local function composeRefs(...) -- line: 3
	local t1 = { ... }

	return function(p1) -- line: 5
		-- upvalues: t1 (copy)
		for _, v5 in t1 do
			if type(v5) == "function" then
				v5(p1)
			elseif v5 ~= nil then
				v5.current = p1
			end
		end
	end
end

return composeRefs
