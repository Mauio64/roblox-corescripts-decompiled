local GameCollections = script:FindFirstAncestor("GameCollections")
local useNavigateToSeeAll = require(GameCollections.useNavigateToSeeAll)
local useNavigateToSortLinkWebView = require(GameCollections.useNavigateToSortLinkWebView)

local parent = GameCollections.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
require(parent.DiscoveryTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHeaderButtonText = SharedFlags.FFlagLuaAppHeaderButtonText

local function useGameSortHeaderButtonParams(callback, data, flag: boolean, p: number?, p2: string?, p3: string?, p4: string, p5: string?, p6: string?, p7: string?, callback2)
	local v = useNavigateToSeeAll(data, flag, p, p2, p3, p4)
	local v2 = React.useCallback(function()
		v()
		callback()
	end, { v, callback })

	local v3 = useNavigateToSortLinkWebView()
	local v4 = React.useCallback(function()
		local v4

		if data then
			v4 = if flag then data.topicId else data.gameSetTypeId
		end

		if p5 then
			v3(p5, p4, data and data.displayName or "", v4)
		end
	end, { v3, p5, p4, data, flag })

	if not p5 then
		v4 = v2
	end

	local v5 = useLocalization({ learnMore = "Feature.GameDetails.Label.LearnMore" })

	if not (FFlagLuaAppHeaderButtonText and p7) then
		p7 = if p5 then v5.learnMore else nil
	end

	return v4, p7, (React.useCallback(function()
		if callback2 then
			callback2()
			return
		end

		if not (data and p6) then
			v4()

			return
		end

		local v6

		if flag then
			v6 = data.topicId
		else
			v6 = data.gameSetTypeId
		end

		v3(p6, p4, data and data.displayName or "", v6)
	end, { v3, p6, p4, data, flag, v4, callback2 }))
end

return useGameSortHeaderButtonParams
