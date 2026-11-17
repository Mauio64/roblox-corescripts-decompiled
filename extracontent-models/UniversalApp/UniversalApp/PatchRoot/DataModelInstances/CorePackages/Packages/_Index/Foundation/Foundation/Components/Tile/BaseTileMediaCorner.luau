local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local getBaseTileMediaCorners = require(script.Parent.getBaseTileMediaCorners)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function BaseTileMediaCorner(p)
	local v = useTokens()
	return React.createElement("UICorner", getBaseTileMediaCorners(v, p.isContained))
end

return React.memo(BaseTileMediaCorner)
