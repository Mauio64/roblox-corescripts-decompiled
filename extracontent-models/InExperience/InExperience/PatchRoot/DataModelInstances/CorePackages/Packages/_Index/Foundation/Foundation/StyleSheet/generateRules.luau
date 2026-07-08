local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)

require(Foundation.Providers.Style.Tokens)
require(script.Parent.Rules.Types)

local formatTokens = require(script.Parent.formatTokens)

local function generateRules(p1, p2) -- line: 11
	-- upvalues: formatTokens (copy), Dash (copy)
	local v8, v9, v10 = p2(p1, (formatTokens(p1)))

	return Dash.joinArrays(v8, v9, v10), v8, v9, v10
end

return generateRules
