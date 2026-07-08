local function composeRefs(...) -- line: 4
	local t1 = { ... }

	return function(p1) -- line: 6
		-- upvalues: t1 (copy)
		for _, v5 in t1 do
			if type(v5) == "function" then
				v5(p1)
			elseif type(v5) == "table" then
				v5.current = p1
			end
		end
	end
end

return composeRefs
