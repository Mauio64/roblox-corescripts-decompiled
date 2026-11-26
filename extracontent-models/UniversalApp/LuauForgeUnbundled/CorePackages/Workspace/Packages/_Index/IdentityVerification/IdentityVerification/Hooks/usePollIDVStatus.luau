local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/React")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/Promise")

local IDVApiProvider = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Utils/IDVApiProvider")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Common/Enums")
local idvSessionStatusEnum = Enums.IDVSessionStatusEnum
local idvSessionErrorEnum = Enums.IDVSessionErrorEnum

local GetFIntIDVPollDelay = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Flags/GetFIntIDVPollDelay")
local GetFIntIDVMaxRetries = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Flags/GetFIntIDVMaxRetries")

local GetFFlagIDVGuardStartPollingAfterUnmount = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/IdentityVerification/Flags/GetFFlagIDVGuardStartPollingAfterUnmount")

local v5 = GetFIntIDVPollDelay()
local v6 = GetFIntIDVMaxRetries()
local v7 = GetFFlagIDVGuardStartPollingAfterUnmount()

local function isFailure(p2): boolean
	return p2 == idvSessionStatusEnum.RequiresManualReview
		or p2 == idvSessionStatusEnum.RequiresRetry
		or p2 == idvSessionStatusEnum.Expired
end

local function usePollIDVStatus(data)
	local retries = data.retries or v6
	local delay2 = data.delay or v5

	local onStatusUpdate = data.onStatusUpdate

	local v8 = nil
	v8 = React.useCallback(function(p2, p3, callback, callback2)
		if p3 == 0 then
			callback2({ sessionStatus = idvSessionStatusEnum.Expired })
		else
			IDVApiProvider.getVerifiedStatus(p2):andThen(function(data2)
				local isVerified = data2.isVerified
				local sessionStatus = data2.sessionStatus
				local sessionErrorCode = data2.sessionErrorCode
				local ageEstimationNextStep = data2.ageEstimationNextStep

				if onStatusUpdate then
					onStatusUpdate({ sessionStatus = sessionStatus, retriesLeft = p3 })
				end

				if isVerified and sessionStatus == idvSessionStatusEnum.Stored then
					if
						sessionErrorCode == idvSessionErrorEnum.UnknownError
						and ageEstimationNextStep == nil
					then
						return callback2({
							sessionStatus = idvSessionStatusEnum.Failure
						})
					end

					return callback()
				elseif
					sessionStatus == idvSessionStatusEnum.RequiresManualReview
					or sessionStatus == idvSessionStatusEnum.RequiresRetry
					or sessionStatus == idvSessionStatusEnum.Expired
				then
					callback2({ sessionStatus = sessionStatus })
				else
					task.spawn(function()
						task.wait(delay2)

						if v8 then
							v8(p2, p3 - 1, callback, callback2)
						end
					end)
				end
			end):catch(function(p4)
				callback2({ sessionStatus = idvSessionStatusEnum.RequiresRetry })
			end)
		end
	end, { delay2, onStatusUpdate })

	return React.useCallback(function(p2)
		return Promise.new(function(callback, p3)
			if not v7 then
				v8(p2, retries, callback, p3)
			elseif v8 then
				v8(p2, retries, callback, p3)
			else
				callback()
			end
		end)
	end, { v8, retries }), (React.useCallback(function()
		v8 = nil
	end, {}))
end

return usePollIDVStatus
