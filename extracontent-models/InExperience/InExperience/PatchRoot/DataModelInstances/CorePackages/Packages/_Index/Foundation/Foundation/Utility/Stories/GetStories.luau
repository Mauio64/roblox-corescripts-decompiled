local Foundation = script:FindFirstAncestor("Foundation")
local lib = require(Foundation)
local children = Foundation.Components:GetChildren()
local children2 = Foundation.Providers:GetChildren()
local children3 = Foundation.Utility:GetChildren()

local function GetStories(b1: boolean) -- line: 7
	-- upvalues: children (copy), lib (copy), children2 (copy), children3 (copy)
	local t1 = {}

	for _, v10 in children do
		local ok, _ = pcall(function() -- line: 10
			-- upvalues: lib (copy), v10 (copy)
			return lib[v10.Name]
		end)

		if ok == b1 then
			table.insert(t1, v10)
		end
	end

	for _, v14 in children2 do
		local ok, _ = pcall(function() -- line: 19
			-- upvalues: lib (copy), v14 (copy)
			return lib[v14.Name .. "Provider"]
		end)

		if ok == b1 then
			table.insert(t1, v14)
		end
	end

	for _, v18 in children3 do
		local ok, _ = pcall(function() -- line: 28
			-- upvalues: lib (copy), v18 (copy)
			return lib.Utility[v18.Name]
		end)

		if b1 and ok == b1 then
			table.insert(t1, v18)
		end
	end

	return t1
end

return GetStories
