local parent = script:FindFirstAncestor("UsageTracker").Parent
local ReactIs = require(parent.ReactIs)

local function isReactComponent(value): boolean
	local success, result = pcall(ReactIs.isValidElementType, value)

	if success and result then
		if typeof(value) == "function" then
			local v, v2 = debug.info(value, "a")
			local v3 = string.sub(debug.info(value, "n"), 1, 3) == "use"

			if v == 1 and not (v2 or v3) then
				return true
			end
		elseif typeof(value) == "table" then
			return true
		end
	end

	return false
end

return isReactComponent
