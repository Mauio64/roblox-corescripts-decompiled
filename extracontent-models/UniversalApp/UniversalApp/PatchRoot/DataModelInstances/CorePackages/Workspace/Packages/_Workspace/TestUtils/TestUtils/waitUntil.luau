local Parent = script:FindFirstAncestor("TestUtils").Parent
local act = require(Parent.ReactRoblox).act

local function waitUntil(p1: ((...any) -> ...any), n1: number?) -- line: 10
	-- upvalues: act (copy)
	local v6 = if n1 ~= nil then n1 else 1
	local v7 = os.clock() + v6
	local v8 = nil

	while v7 > os.clock() do
		local ok, result, v11 = pcall(p1)

		if ok and result then
			return v11
		end

		if not ok then
			v8 = result
		end

		act(function() -- line: 27
			task.wait()
		end)
	end

	local v12 = ("operation has timed out (maximum time allowed was %f seconds)"):format(v6)

	if v8 ~= nil then
		v12 ..= ": " .. tostring(v8)
	end

	error(v12)
end

return waitUntil
