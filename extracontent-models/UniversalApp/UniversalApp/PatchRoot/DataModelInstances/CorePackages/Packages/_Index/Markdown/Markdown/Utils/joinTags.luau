local parent = script:FindFirstAncestor("Markdown").Parent
local Dash = require(parent.Dash)
local forEachArgs = Dash.forEachArgs
local concat = table.concat

local function joinTags(...)
	local v = {}
	forEachArgs(function(value)
		if typeof(value) == "string" then
			table.insert(v, value)
		elseif typeof(value) == "table" then
			for k, item in value do
				if item then
					table.insert(v, k)
				end
			end
		end
	end, ...)

	return concat(v, " ")
end

return joinTags
