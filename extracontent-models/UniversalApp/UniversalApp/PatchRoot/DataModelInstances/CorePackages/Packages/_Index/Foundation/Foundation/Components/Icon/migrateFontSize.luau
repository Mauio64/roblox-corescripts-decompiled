local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)

local function migrateFontSize(p: number, p2)
	local size_100 = p2.Size.Size_100
	local size_600 = p2.Size.Size_600
	local size_900 = p2.Size.Size_900

	if size_600 <= p and p <= size_900 then
		p = size_600
	end

	return math.round(p / size_100) * size_100
end

return migrateFontSize
