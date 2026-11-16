local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local parent = GamePlayButton.Parent

local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo
local GetFFlagLuaAppFetchPlayabilityKillSwitch = require(GamePlayButton.Flags.GetFFlagLuaAppFetchPlayabilityKillSwitch)

local v = {}

local function LaunchUnlessNotPlayable(p, p2: string, callback, callback2)
	return function(object)
		local function routeByPlayability() -- 2 equivalent calls inferred from this helper
			local v2 = object:getState().PlayabilityStatus[p2]

			if v2 and v2.isPlayable == false then
				callback2()
			else
				callback()
			end
		end

		local function settle()
			v[p2] = nil
			routeByPlayability() -- inferred equivalent call
		end

		if v[p2] then
			return
		end

		if object:getState().PlayabilityStatus[p2] == nil then
			if GetFFlagLuaAppFetchPlayabilityKillSwitch() then
				callback()
				return
			end

			v[p2] = true

			object:dispatch(FetchGamePlayabilityAndProductInfo.Fetch(p, p2)):andThen(settle, settle)
		else
			routeByPlayability() -- inferred equivalent call
		end
	end
end

return LaunchUnlessNotPlayable
