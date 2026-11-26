local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SignalsReact").useSignalState
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/DataHydration").DataStatus

local buttonTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UserList").Enums.ButtonTypes

local mapProfileCTAToRowCTA = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Utils/mapProfileCTAToRowCTA")
require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Types")

local function fn(): nil
	return nil
end

local function useCTAForRow(p2, p3, p4, data)
	local v5 = if p2 then p2.data else fn
	local v6 = if p2 then p2.status else fn

	local v7 = useSignalState(v5)
	local v8 = useSignalState(v6)

	return React.useMemo(function()
		if v8 == dataStatus.NotReady then
			return nil
		end

		local v9 = mapProfileCTAToRowCTA(v7, p3, p4)

		if not v9 or v9.type ~= buttonTypes.Join or not data then
			return v9
		end

		local onActivated = v9.onActivated
		return {
			type = v9.type,
			onActivated = function()
				if onActivated then
					onActivated()
				end

				data.joinExperience()
			end,
			isDisabled = not data.isInExperience,
			isLoading = data.isLoading
		}
	end, { v7, v8, p3, p4, data })
end

return useCTAForRow
