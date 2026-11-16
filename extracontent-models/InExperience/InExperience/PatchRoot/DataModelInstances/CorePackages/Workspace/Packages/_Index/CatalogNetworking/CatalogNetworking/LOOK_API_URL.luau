local parent = script.Parent.Parent
local SocialCommon = require(parent.SocialCommon)
return SocialCommon.Utils.buildApiSiteUrl("apis") .. "/look-api/v1/looks/purchase-details"
