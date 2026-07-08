local Parent = script:FindFirstAncestor("UsageTracker").Parent
local ReactIs = require(Parent.ReactIs)

local function isReactComponent(p1) -- line: 5
	-- upvalues: ReactIs (copy)
	local ok, result = pcall(ReactIs.isValidElementType, p1)

	if ok and result then
		if typeof(p1) == "function" then
			local v7, v8 = debug.info(p1, "a")
			local v9 = string.sub(debug.info(p1, "n"), 1, 3) == "use"

			if v7 == 1 and not v8 and not v9 then
				return true
			end
		elseif typeof(p1) == "table" then
			return true
		end
	end

	return false
end

return isReactComponent
