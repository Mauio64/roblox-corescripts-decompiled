local parent = script.Parent
local parent2 = script:FindFirstAncestor("Foundation").Parent

local React = require(parent2.React)

require(parent.Tokens)
local TokensContext = require(parent.TokensContext)

local function withTokens_DEPRECATED(render)
	return React.createElement(TokensContext.Consumer, { render = render })
end

return withTokens_DEPRECATED
