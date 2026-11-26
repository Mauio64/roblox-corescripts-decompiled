local useNavigateToSeeAll = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useNavigateToSeeAll")
local useNavigateToSortLinkWebView = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useNavigateToSortLinkWebView")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Localization").Hooks.useLocalization
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")
local fFlagLuaAppHeaderButtonText = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppHeaderButtonText

local function useGameSortHeaderButtonParams(callback, data, p2, p3, p4, p5, p6, p7, p8, p9, callback2)
	local v5 = useNavigateToSeeAll(data, p2, p3, p4, p5, p6)
	local v6 = React.useCallback(function()
		v5()
		callback()
	end, { v5, callback })

	local v7 = useNavigateToSortLinkWebView()
	local v8 = React.useCallback(function()
		local v9 = if data then (if p2 then data.topicId else data.gameSetTypeId) else nil

		if p7 then
			v7(p7, p6, data and data.displayName or "", v9)
		end
	end, { v7, p7, p6, data, p2 })

	if not p7 then
		v8 = v6
	end

	local v9 = useLocalization({ learnMore = "Feature.GameDetails.Label.LearnMore" })

	if not (fFlagLuaAppHeaderButtonText and p9) then
		p9 = if p7 then v9.learnMore else nil
	end

	return v8, p9, (React.useCallback(function()
		if callback2 then
			callback2()
			return
		end

		if not (data and p8) then
			v8()

			return
		end

		local v10 = if p2 then data.topicId else data.gameSetTypeId
		v7(p8, p6, data and data.displayName or "", v10)
	end, { v7, p8, p6, data, p2, v8, callback2 }))
end

return useGameSortHeaderButtonParams
