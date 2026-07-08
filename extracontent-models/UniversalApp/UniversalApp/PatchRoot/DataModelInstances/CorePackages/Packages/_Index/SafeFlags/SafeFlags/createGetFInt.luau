local function createGetFInt(s1: string, n1: number) -- line: 1
	local ok, result = pcall(function() -- line: 2
		-- upvalues: s1 (copy), n1 (copy)
		game:DefineFastInt(s1, n1)
	end)

	if not ok and result:match("The current thread cannot call") then
		return function() -- line: 7
			-- upvalues: n1 (copy)
			return n1
		end
	end

	return function() -- line: 12
		-- upvalues: s1 (copy)
		return game:GetFastInt(s1)
	end
end

return createGetFInt
