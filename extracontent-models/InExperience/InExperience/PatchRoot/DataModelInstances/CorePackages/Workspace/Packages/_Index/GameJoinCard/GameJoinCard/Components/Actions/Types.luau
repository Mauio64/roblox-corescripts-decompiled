local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

require(parent.Foundation)
require(parent.React)
require(parent.UserCtaCommon)

local v = require(GameJoinCard.Analytics.AnalyticsConstants)
v = v.viewProfileSourceValues

return {}
