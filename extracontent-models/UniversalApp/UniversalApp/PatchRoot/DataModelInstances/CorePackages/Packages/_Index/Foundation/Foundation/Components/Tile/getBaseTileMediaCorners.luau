local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)

local udim = UDim.new(0, 0)

local function getBaseTileMediaCorners(p, flag: boolean?)
	local udim2 = UDim.new(0, p.Radius.Medium)
	local v = if flag then udim else udim2
	return {
		TopLeftRadius = udim2,
		TopRightRadius = udim2,
		BottomLeftRadius = v,
		BottomRightRadius = v
	}
end

return getBaseTileMediaCorners
