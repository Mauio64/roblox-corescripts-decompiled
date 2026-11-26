local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Leaderboards/Http").Url
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Leaderboards/Leaderboards/ExperienceLeaderboardSeeAllPage/Constants")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = Constants.Path })

local function getExperienceLeaderboardSeeAllUrl()
	return v5()
end

return getExperienceLeaderboardSeeAllUrl
