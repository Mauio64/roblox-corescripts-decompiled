local module = require("@luauforge/bundled/fHR")
local fFlagLuaEnableGenreLandingDeeplink = module.FFlagLuaEnableGenreLandingDeeplink
local fFlagLuaEnableCustomizedInviteLandingPage = module.FFlagLuaEnableCustomizedInviteLandingPage

local getGenreBackgroundAssetId = require("@luauforge/bundled/fHQ").getGenreBackgroundAssetId

local function isCustomizedInviteLandingPage(p2)
	local shouldShowCustomizedLandingPage = p2.shouldShowCustomizedLandingPage

	local v5 = false

	if fFlagLuaEnableGenreLandingDeeplink and shouldShowCustomizedLandingPage then
		local deepLinkData = p2.deepLinkData

		if deepLinkData and deepLinkData.genre then
			v5 = getGenreBackgroundAssetId(deepLinkData.genre) ~= nil
		end
	end

	return fFlagLuaEnableCustomizedInviteLandingPage and shouldShowCustomizedLandingPage or v5
end

return isCustomizedInviteLandingPage
