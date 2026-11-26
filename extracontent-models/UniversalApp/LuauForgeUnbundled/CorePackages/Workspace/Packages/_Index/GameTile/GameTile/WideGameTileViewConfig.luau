require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")

return {
	getTileHeight = function(p2, p3)
		local v5 = p3 * 0.5625
		local size_500 = p2.Size.Size_500
		local size_200 = p2.Size.Size_200
		local size_100 = p2.Size.Size_100
		return v5 + (size_500 + p2.Size.Size_500 + size_200 + size_100)
	end,
	getFooterHeight = function(p2)
		local size_500 = p2.Size.Size_500
		local size_200 = p2.Size.Size_200
		local size_100 = p2.Size.Size_100
		return size_500 + p2.Size.Size_500 + size_200 + size_100
	end,
	getMetadataHeight = function(p2)
		return p2.Size.Size_500
	end,
	getPlayButtonHeight = function(p2)
		return p2.Size.Size_900
	end
}
