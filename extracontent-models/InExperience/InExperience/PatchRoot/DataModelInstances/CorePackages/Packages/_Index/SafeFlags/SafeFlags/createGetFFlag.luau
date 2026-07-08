local function createGetFFlag(s1: string, b1: boolean?) -- line: 1
	local ok, result = pcall(function() -- line: 2
		-- upvalues: s1 (copy), b1 (copy)
		game:DefineFastFlag(s1, not not b1 and b1)
	end)

	if not ok and result:match("The current thread cannot call") then
		return function() -- line: 7
			-- upvalues: s1 (copy)
			return s1:match("^Debug") == nil
		end
	end

	return function() -- line: 13
		-- upvalues: s1 (copy)
		return game:GetFastFlag(s1)
	end
end

return createGetFFlag
