local Constants = require(script.Parent.Constants)
local v2 = Constants.DEFAULT_BACKGROUND_ASSET_IDS[1]
local v3 = Constants.DEFAULT_BACKGROUND_ASSET_IDS[2]

return {
	getDisplayBackgroundId = function(n1: number?, s1: string) -- line: 8
		-- upvalues: v2 (copy), v3 (copy)
		if not n1 or n1 == -1 then
			if s1 == "dark" then
				return v2
			end

			return v3
		end

		return n1
	end
}
