local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/Constants")

local v5 = Constants.DEFAULT_BACKGROUND_ASSET_IDS[1]
local v6 = Constants.DEFAULT_BACKGROUND_ASSET_IDS[2]

return {
	getDisplayBackgroundId = function(p2, p3)
		if p2 and p2 ~= -1 then
			return p2
		end

		if p3 == "dark" then
			return v5
		end

		return v6
	end
}
