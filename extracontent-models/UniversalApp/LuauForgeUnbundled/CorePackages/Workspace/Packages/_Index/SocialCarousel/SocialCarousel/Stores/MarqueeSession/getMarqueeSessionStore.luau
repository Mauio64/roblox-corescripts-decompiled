local createMarqueeSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Stores/MarqueeSession/createMarqueeSessionStore")

local v5 = {}

return {
	getMarqueeSessionStore = function(p2)
		local v6 = v5[p2]

		if v6 ~= nil then
			return v6
		end

		local v7 = createMarqueeSessionStore()
		v5[p2] = v7
		return v7
	end,
	resetMarqueeSessionStores = function()
		table.clear(v5)
	end
}
