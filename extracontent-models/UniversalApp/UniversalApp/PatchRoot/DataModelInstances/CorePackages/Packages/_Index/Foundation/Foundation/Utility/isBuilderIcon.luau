local parent = script:FindFirstAncestor("Foundation").Parent

local Dash = require(parent.Dash)

local function isBuilderIcon(value: string?): boolean
	return value ~= nil and value ~= "" and value:find("[^%l%d%-]") == nil
end

return Dash.memoize(isBuilderIcon)
