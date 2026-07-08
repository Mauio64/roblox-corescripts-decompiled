local scriptParent = script.Parent
local Parent = script:FindFirstAncestor("Foundation").Parent

require(scriptParent.Tokens)

local TokensContext = require(scriptParent.TokensContext)
local React = require(Parent.React)

local function useTokens() -- line: 10
	-- upvalues: React (copy), TokensContext (copy)
	return (React.useContext(TokensContext))
end

return useTokens
