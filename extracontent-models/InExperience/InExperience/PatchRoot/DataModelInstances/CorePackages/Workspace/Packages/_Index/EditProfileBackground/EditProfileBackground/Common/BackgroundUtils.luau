local Constants = require(script.Parent.Constants)

local v = Constants.DEFAULT_BACKGROUND_ASSET_IDS[1]
local v2 = Constants.DEFAULT_BACKGROUND_ASSET_IDS[2]

return {
	getDisplayBackgroundId = function(p: number?, p2: string)
		if p and p ~= -1 then
			return p
		end

		return if p2 == "dark" then v else v2
	end
}
