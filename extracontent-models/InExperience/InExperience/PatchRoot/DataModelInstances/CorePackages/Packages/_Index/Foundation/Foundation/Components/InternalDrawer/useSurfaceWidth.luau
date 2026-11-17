local Foundation = script:FindFirstAncestor("Foundation")

local useScreenSize = require(Foundation.Components.Sheet.useScreenSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useSurfaceWidth(p: number, p2: number, value: number?)
	local v = useTokens()
	local v2 = math.min(p, (math.max(useScreenSize().X - v.Size.Size_1200 - p2, 0)))
	return v2, v2 + p2 + (value or 0)
end

return useSurfaceWidth
