local Leaderboards = script:FindFirstAncestor("Leaderboards")
local parent = Leaderboards.Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local Constants = require(Leaderboards.ExperienceLeaderboardSeeAllPage.Constants)

local v = urlBuilder.new({ base = Url.APIS_URL, path = Constants.Path })

local function getExperienceLeaderboardSeeAllUrl()
	return v()
end

return getExperienceLeaderboardSeeAllUrl
