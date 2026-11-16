local Foundation = script:FindFirstAncestor("Foundation")

local Flags = require(Foundation.Utility.Flags)
require(Foundation.Components.Types)
local devAssert = require(Foundation.Utility.devAssert)

local function getFormattedTags(value)
	if value == nil then
		return nil
	end

	if typeof(value) == "table" then
		local v = {}

		for k, item in value do
			if item then
				table.insert(v, k)
			end
		end

		return table.concat(v, " ")
	end

	if typeof(value) == "string" then
		return value
	end

	if Flags.FoundationDevOnlyPropAsserts then
		devAssert(false, "Invalid argument to useStyleTags. Expected a table or string, got " .. typeof(value))
	else
		assert(false, "Invalid argument to useStyleTags. Expected a table or string, got " .. typeof(value))
	end

	return nil
end

return getFormattedTags
