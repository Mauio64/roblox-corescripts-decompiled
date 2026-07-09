local Parent = script:FindFirstAncestor("GameTile").Parent

require(Parent.UIBlox)

local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens

return {
	getTileHeight = function(p1, n1: number) -- line: 26
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		local v10 = n1 * 0.5625
		local v11 = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_250 else p1.Size.Size_500
		local v12 = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_100 else p1.Size.Size_200
		local v13 = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_50 else p1.Size.Size_100

		return v10 + (v11 + (if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_250 else p1.Size.Size_500) + v12 + v13)
	end,
	getFooterHeight = function(p2) -- line: 13
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		local v5 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_250 else p2.Size.Size_500
		local v6 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_100 else p2.Size.Size_200
		local v7 = if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_50 else p2.Size.Size_100

		return v5 + (if not FFlagRenameDeprecatedUIBloxTokens then p2.Global.Space_250 else p2.Size.Size_500) + v6 + v7
	end,
	getMetadataHeight = function(p3) -- line: 9
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		if FFlagRenameDeprecatedUIBloxTokens then
			return p3.Size.Size_500
		end

		return p3.Global.Space_250
	end,
	getPlayButtonHeight = function(p4) -- line: 30
		-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
		if FFlagRenameDeprecatedUIBloxTokens then
			return p4.Size.Size_900
		end

		return p4.Global.Size_450
	end
}
