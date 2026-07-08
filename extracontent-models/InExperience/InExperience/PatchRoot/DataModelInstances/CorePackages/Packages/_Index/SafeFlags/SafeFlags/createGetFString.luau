local function createGetFString(s1: string, s2: string) -- line: 1
	local ok, result = pcall(function() -- line: 2
		-- upvalues: s1 (copy), s2 (copy)
		game:DefineFastString(s1, s2)
	end)

	if not ok and result:match("The current thread cannot call") then
		return function() -- line: 7
			-- upvalues: s2 (copy)
			return s2
		end
	end

	return function() -- line: 12
		-- upvalues: s1 (copy)
		return game:GetFastString(s1)
	end
end

return createGetFString
