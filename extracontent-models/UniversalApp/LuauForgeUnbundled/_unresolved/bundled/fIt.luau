local module = require("@luauforge/bundled/ehz")

local module2 = require("@luauforge/bundled/fIu")
local module3 = require("@luauforge/bundled/fIv")
require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
require("@luauforge/bundled/fIj")

return function(p2, p3)
	local v5 = module.Stopwatch.stop(module.Events.ShareLinkOpened)

	local v7 = if v5 then v5.timeElapsed else nil
	module3(module2.ShareLinkLatency, { linkStatus = p3, linkType = p2, statValue = v7 })
end
