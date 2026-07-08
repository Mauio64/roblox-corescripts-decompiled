local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local v5 = React.createContext(nil)

function useBackgroundStyle() -- line: 11
	-- upvalues: React (copy), v5 (copy), useTokens (copy)
	local v6 = React.useContext(v5)
	local v7 = useTokens()

	if v6 == nil then
		return v7.Color.Surface.Surface_0
	end

	return v6
end

return {
	useBackgroundStyle = useBackgroundStyle,
	Provider = v5.Provider
}
