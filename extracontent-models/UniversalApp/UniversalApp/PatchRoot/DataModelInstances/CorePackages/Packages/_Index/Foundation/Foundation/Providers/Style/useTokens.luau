local parent = script.Parent
local parent2 = script:FindFirstAncestor("Foundation").Parent

require(parent.Tokens)
local TokensContext = require(parent.TokensContext)

local React = require(parent2.React)

local function useTokens()
	return (React.useContext(TokensContext))
end

return useTokens
