local Parent = script:FindFirstAncestor("GameTile").Parent

require(Parent.UIBlox)

return {
	getTileHeight = function(p1, n1: number) -- line: 18
		local v9 = n1 * 0.5625
		local Size_500 = p1.Size.Size_500
		local Size_200 = p1.Size.Size_200
		local Size_100 = p1.Size.Size_100

		return v9 + (Size_500 + p1.Size.Size_500 + Size_200 + Size_100)
	end,
	getFooterHeight = function(p2) -- line: 11
		local Size_500 = p2.Size.Size_500
		local Size_200 = p2.Size.Size_200
		local Size_100 = p2.Size.Size_100

		return Size_500 + p2.Size.Size_500 + Size_200 + Size_100
	end,
	getMetadataHeight = function(p3) -- line: 7
		return p3.Size.Size_500
	end,
	getPlayButtonHeight = function(p4) -- line: 22
		return p4.Size.Size_900
	end
}
