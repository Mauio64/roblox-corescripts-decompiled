local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/GameDetailRodux").FetchGamePlayabilityAndProductInfo
local GetFFlagLuaAppFetchPlayabilityKillSwitch = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags/GetFFlagLuaAppFetchPlayabilityKillSwitch")

local v5 = {}

local function LaunchUnlessNotPlayable(p2, p3, callback, callback2)
	return function(object)
		local function routeByPlayability()
			local v6 = object:getState().PlayabilityStatus[p3]

			if v6 and v6.isPlayable == false then
				callback2()
			else
				callback()
			end
		end

		local function settle()
			v5[p3] = nil
			local v6 = object:getState().PlayabilityStatus[p3]

			if v6 and v6.isPlayable == false then
				callback2()
			else
				callback()
			end
		end

		if v5[p3] then
			return
		end

		if object:getState().PlayabilityStatus[p3] == nil then
			if GetFFlagLuaAppFetchPlayabilityKillSwitch() then
				callback()
				return
			end

			v5[p3] = true

			object:dispatch(fetchGamePlayabilityAndProductInfo.Fetch(p2, p3)):andThen(settle, settle)
		else
			local v6 = object:getState().PlayabilityStatus[p3]

			if v6 and v6.isPlayable == false then
				callback2()
			else
				callback()
			end
		end
	end
end

return LaunchUnlessNotPlayable
