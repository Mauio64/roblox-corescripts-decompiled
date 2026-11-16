local parent = script:FindFirstAncestor("IdentityVerification").Parent

local React = require(parent.React)
local Promise = require(parent.Promise)

local IDVApiProvider = require(script.Parent.Parent.Utils.IDVApiProvider)
local Enums = require(script.Parent.Parent.Common.Enums)
local IDVSessionStatusEnum = Enums.IDVSessionStatusEnum
local IDVSessionErrorEnum = Enums.IDVSessionErrorEnum

local GetFIntIDVPollDelay = require(script.Parent.Parent.Flags.GetFIntIDVPollDelay)
local GetFIntIDVMaxRetries = require(script.Parent.Parent.Flags.GetFIntIDVMaxRetries)

local GetFFlagIDVGuardStartPollingAfterUnmount = require(script.Parent.Parent.Flags.GetFFlagIDVGuardStartPollingAfterUnmount)

local fIntIDVPollDelay = GetFIntIDVPollDelay()
local fIntIDVMaxRetries = GetFIntIDVMaxRetries()
local fFlagIDVGuardStartPollingAfterUnmount = GetFFlagIDVGuardStartPollingAfterUnmount()

local function isFailure(sessionStatus: number): boolean -- 1 equivalent call inferred from this helper
	return sessionStatus == IDVSessionStatusEnum.RequiresManualReview
		or sessionStatus == IDVSessionStatusEnum.RequiresRetry
		or sessionStatus == IDVSessionStatusEnum.Expired
end

local function usePollIDVStatus(data)
	local retries = data.retries or fIntIDVMaxRetries
	local delay = data.delay or fIntIDVPollDelay

	local onStatusUpdate = data.onStatusUpdate

	local v = nil
	v = React.useCallback(function(p: string, retriesLeft: number, callback, callback2)
		if retriesLeft == 0 then
			callback2({ sessionStatus = IDVSessionStatusEnum.Expired })
		else
			IDVApiProvider.getVerifiedStatus(p):andThen(function(data2)
				local isVerified = data2.isVerified
				local sessionStatus = data2.sessionStatus
				local sessionErrorCode = data2.sessionErrorCode
				local ageEstimationNextStep = data2.ageEstimationNextStep

				if onStatusUpdate then
					onStatusUpdate({ sessionStatus = sessionStatus, retriesLeft = retriesLeft })
				end

				if isVerified and sessionStatus == IDVSessionStatusEnum.Stored then
					if sessionErrorCode == IDVSessionErrorEnum.UnknownError and ageEstimationNextStep == nil then
						return callback2({ sessionStatus = IDVSessionStatusEnum.Failure })
					end

					return callback()
				elseif isFailure(sessionStatus) then -- inferred equivalent call
					callback2({ sessionStatus = sessionStatus })
				else
					task.spawn(function()
						task.wait(delay)

						if v then
							v(p, retriesLeft - 1, callback, callback2)
						end
					end)
				end
			end):catch(function(_)
				callback2({ sessionStatus = IDVSessionStatusEnum.RequiresRetry })
			end)
		end
	end, { delay, onStatusUpdate })

	return React.useCallback(function(p)
		return Promise.new(function(callback, p2)
			if not fFlagIDVGuardStartPollingAfterUnmount then
				v(p, retries, callback, p2)
			elseif v then
				v(p, retries, callback, p2)
			else
				callback()
			end
		end)
	end, { v, retries }), (React.useCallback(function()
		v = nil
	end, {}))
end

return usePollIDVStatus
