local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsReact").useSignalState

local getTimeoutStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/TimeoutStatusStore/getTimeoutStatusStore")
local getTimeoutEndTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/getTimeoutEndTime")

local function getEndTimestampMillis(p2)
	if not p2 then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(p2)
	end)

	if success and result then
		return result.UnixTimestampMillis
	end

	return nil
end

local function useIsAvatarChangeTimeoutActive()
	local v6 = useSignalState(getTimeoutStatusStore().getStatus)

	local endDate = if v6.details then v6.details.endDate else nil
	local v8 = if v6.timeoutAction then v6.timeoutAction.endTime else nil
	local v9 = getTimeoutEndTime(endDate, v8)
	local unixTimestampMillis

	if v9 then
		local success, result = pcall(function()
			return DateTime.fromIsoDate(v9)
		end)

		unixTimestampMillis = if success and result then result.UnixTimestampMillis else nil
	else
		unixTimestampMillis = nil
	end

	local v10 = unixTimestampMillis == nil or DateTime.now().UnixTimestampMillis < unixTimestampMillis
	local state, setState = React.useState(0)

	React.useEffect(function()
		if not v10 or unixTimestampMillis == nil then
			return nil
		end

		local thread = task.delay(
			(unixTimestampMillis - DateTime.now().UnixTimestampMillis) / 1000,
			function()
				setState(function(p2)
					return p2 + 1
				end)
			end
		)

		return function()
			task.cancel(thread)
		end
	end, { unixTimestampMillis, v10, state })

	return v10
end

return useIsAvatarChangeTimeoutActive
