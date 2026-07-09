local function IsRunningInStudio() -- line: 2
	return game:GetService("RunService"):IsStudio()
end

local v2 = game:GetService("RunService"):IsStudio()

local function PCALL(p1, p2, p3) -- line: 8
	-- upvalues: v2 (copy)
	local v7 = v2

	if p3 ~= nil then
		v7 = p3
	end

	local ok, result = pcall(function() -- line: 15
		-- upvalues: p1 (copy)
		return p1()
	end)

	if ok then
		return result
	end

	if v7 then
		assert(ok, result)

		return p2
	end

	local s1 = "safeCall failed"

	pcall(function() -- line: 26
		-- upvalues: s1 (ref), result (copy)
		s1 = tostring(result)
	end)
	warn(s1)

	return p2
end

return PCALL
