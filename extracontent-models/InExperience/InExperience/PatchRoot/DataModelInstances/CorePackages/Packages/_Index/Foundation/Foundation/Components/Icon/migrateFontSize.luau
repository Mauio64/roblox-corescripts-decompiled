local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Providers.Style.Tokens)

local function migrateFontSize(n1: number, p1) -- line: 6
	local Size_100 = p1.Size.Size_100
	local Size_600 = p1.Size.Size_600
	local Size_900 = p1.Size.Size_900

	if Size_600 <= n1 and n1 <= Size_900 then
		n1 = Size_600
	end

	return math.round(n1 / Size_100) * Size_100
end

return migrateFontSize
