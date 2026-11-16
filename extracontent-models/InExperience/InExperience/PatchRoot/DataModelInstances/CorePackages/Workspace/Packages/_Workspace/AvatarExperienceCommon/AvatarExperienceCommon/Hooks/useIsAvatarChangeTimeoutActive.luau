local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getTimeoutStatusStore = require(AvatarExperienceCommon.Stores.TimeoutStatusStore.getTimeoutStatusStore)
local getTimeoutEndTime = require(AvatarExperienceCommon.Utils.getTimeoutEndTime)

local function getEndTimestampMillis(p: string?) -- 1 equivalent call inferred from this helper
	if not p then
		return nil
	end

	local success, result = pcall(function()
		return DateTime.fromIsoDate(p)
	end)

	if success and result then
		return result.UnixTimestampMillis
	end

	return nil
end

local function useIsAvatarChangeTimeoutActive()
	local v = useSignalState(getTimeoutStatusStore().getStatus)
	local endDate

	if v.details then
		endDate = v.details.endDate
	end

	local v2

	if v.timeoutAction then
		v2 = v.timeoutAction.endTime
	end

	local endTimestampMillis = getEndTimestampMillis(getTimeoutEndTime(endDate, v2)) -- inferred equivalent call

	local v3 = endTimestampMillis == nil or DateTime.now().UnixTimestampMillis < endTimestampMillis
	local state, setState = React.useState(0)

	React.useEffect(function()
		if not v3 or endTimestampMillis == nil then
			return nil
		end

		local thread = task.delay((endTimestampMillis - DateTime.now().UnixTimestampMillis) / 1000, function()
			setState(function(p)
				return p + 1
			end)
		end)

		return function()
			task.cancel(thread)
		end
	end, { endTimestampMillis, v3, state })

	return v3
end

return useIsAvatarChangeTimeoutActive
