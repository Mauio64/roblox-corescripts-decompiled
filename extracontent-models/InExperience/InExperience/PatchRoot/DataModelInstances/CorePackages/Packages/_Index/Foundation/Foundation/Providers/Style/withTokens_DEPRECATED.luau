local scriptParent = script.Parent
local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

require(scriptParent.Tokens)

local TokensContext = require(scriptParent.TokensContext)

local function withTokens_DEPRECATED(p1: ((...any) -> ...any)) -- line: 17
	-- upvalues: React (copy), TokensContext (copy)
	return React.createElement(TokensContext.Consumer, {
		render = p1
	})
end

return withTokens_DEPRECATED
