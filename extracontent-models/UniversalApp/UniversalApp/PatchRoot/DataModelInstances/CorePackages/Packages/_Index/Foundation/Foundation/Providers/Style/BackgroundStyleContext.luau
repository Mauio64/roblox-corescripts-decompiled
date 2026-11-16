local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)

local context = React.createContext(nil)

function useBackgroundStyle()
	local v = React.useContext(context)
	local v2 = useTokens()
	return if v == nil then v2.Color.Surface.Surface_0 else v
end

return { useBackgroundStyle = useBackgroundStyle, Provider = context.Provider }
