local fFlagLuaEnableGenreLandingDeeplink = require("@luauforge/bundled/gml").FFlagLuaEnableGenreLandingDeeplink
local v5

if fFlagLuaEnableGenreLandingDeeplink then
	local defineFastString = game:DefineFastString(
		"LandingPageGenreBackgroundAssetIdMap",
		"rpg,90754439723067;simulation,82204668514040;sports,95472945314001;strategy,111044680425731;survival,133883166686292;fps,72055167390311"
	)

	v5 = {}

	for k, v6 in string.split(defineFastString, ";") do
		local v7 = string.split(v6, ",")
		local v8 = v7[1]
		local v9 = v7[2]

		if v8 and v8 ~= "" and v9 and v9 ~= "" then
			v5[v8] = v9
		end
	end
else
	v5 = nil
end

return {
	getGenreBackgroundAssetId = function(p2)
		if fFlagLuaEnableGenreLandingDeeplink and v5 and p2 then
			return v5[p2]
		end

		return nil
	end,
	genreBackgroundAssetIdMap = v5
}
