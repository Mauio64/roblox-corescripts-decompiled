local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.Rules.Types)
local formatTokens = require(script.Parent.formatTokens)

local function generateRules(p, callback)
	local v, v2, v3, v4 = callback(p, (formatTokens(p)))
	return Dash.joinArrays(v, v2, v3), v, v2, v3, v4
end

return generateRules
