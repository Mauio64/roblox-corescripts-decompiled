local Parent = script:FindFirstAncestor("IdentityVerification").Parent
local React = require(Parent.React)
local Promise = require(Parent.Promise)
local IDVApiProvider = require(script.Parent.Parent.Utils.IDVApiProvider)
local Enums = require(script.Parent.Parent.Common.Enums)
local IDVSessionStatusEnum = Enums.IDVSessionStatusEnum
local IDVSessionErrorEnum = Enums.IDVSessionErrorEnum
local GetFIntIDVPollDelay = require(script.Parent.Parent.Flags.GetFIntIDVPollDelay)
local GetFIntIDVMaxRetries = require(script.Parent.Parent.Flags.GetFIntIDVMaxRetries)
local GetFFlagIDVGuardStartPollingAfterUnmount = require(script.Parent.Parent.Flags.GetFFlagIDVGuardStartPollingAfterUnmount)
local v11 = GetFIntIDVPollDelay()
local v12 = GetFIntIDVMaxRetries()
local v13 = GetFFlagIDVGuardStartPollingAfterUnmount()

local function isFailure(n1: number) -- line: 31
	-- upvalues: IDVSessionStatusEnum (copy)
	return n1 == IDVSessionStatusEnum.RequiresManualReview or (n1 == IDVSessionStatusEnum.RequiresRetry or n1 == IDVSessionStatusEnum.Expired)
end
local function usePollIDVStatus(t1: {[any]: any}) -- line: 37
	-- upvalues: v12 (copy), v11 (copy), React (copy), IDVSessionStatusEnum (copy), IDVApiProvider (copy), IDVSessionErrorEnum (copy), Promise (copy), v13 (copy)
	local v18 = t1.retries or v12
	local v19 = t1.delay or v11
	local onStatusUpdate = t1.onStatusUpdate
	local u21 = nil

	u21 = React.useCallback(function(s1: string, n2: number, p1, p2) -- line: 44
		-- upvalues: IDVSessionStatusEnum (copy), IDVApiProvider (copy), onStatusUpdate (copy), IDVSessionErrorEnum (copy), v19 (copy), u21 (ref)
		if n2 == 0 then
			p2({
				sessionStatus = IDVSessionStatusEnum.Expired
			})

			return
		end

		IDVApiProvider.getVerifiedStatus(s1):andThen(function(p3) -- line: 51
			-- upvalues: onStatusUpdate (copy), n2 (copy), IDVSessionStatusEnum (copy), IDVSessionErrorEnum (copy), p2 (copy), p1 (copy), v19 (copy), u21 (ref), s1 (copy)
			local isVerified = p3.isVerified
			local sessionStatus = p3.sessionStatus
			local sessionErrorCode = p3.sessionErrorCode
			local ageEstimationNextStep = p3.ageEstimationNextStep

			if onStatusUpdate then
				onStatusUpdate({
					sessionStatus = sessionStatus,
					retriesLeft = n2
				})
			end

			if isVerified and sessionStatus == IDVSessionStatusEnum.Stored then
				if sessionErrorCode == IDVSessionErrorEnum.UnknownError and ageEstimationNextStep == nil then
					return p2({
						sessionStatus = IDVSessionStatusEnum.Failure
					})
				end

				return p1()
			end

			if sessionStatus == IDVSessionStatusEnum.RequiresManualReview or (sessionStatus == IDVSessionStatusEnum.RequiresRetry or sessionStatus == IDVSessionStatusEnum.Expired) then
				p2({
					sessionStatus = sessionStatus
				})

				return
			end

			task.spawn(function() -- line: 71
				-- upvalues: v19 (copy), u21 (ref), s1 (copy), n2 (copy), p1 (copy), p2 (copy)
				task.wait(v19)

				if u21 then
					u21(s1, n2 - 1, p1, p2)
				end
			end)
		end):catch(function(_) -- line: 79
			-- upvalues: p2 (copy), IDVSessionStatusEnum (copy)
			p2({
				sessionStatus = IDVSessionStatusEnum.RequiresRetry
			})
		end)
	end, {
		v19,
		onStatusUpdate
	})

	return React.useCallback(function(p5) -- line: 84
		-- upvalues: Promise (copy), v13 (copy), u21 (ref), v18 (copy)
		return Promise.new(function(resolve, reject) -- line: 85
			-- upvalues: v13 (copy), u21 (ref), p5 (copy), v18 (copy)
			if v13 then
				if u21 then
					u21(p5, v18, resolve, reject)

					return
				end

				resolve()

				return
			end

			u21(p5, v18, resolve, reject)
		end)
	end, {
		u21,
		v18
	}), (React.useCallback(function() -- line: 98
		-- upvalues: u21 (ref)
		u21 = nil
	end, {}))
end

return usePollIDVStatus
