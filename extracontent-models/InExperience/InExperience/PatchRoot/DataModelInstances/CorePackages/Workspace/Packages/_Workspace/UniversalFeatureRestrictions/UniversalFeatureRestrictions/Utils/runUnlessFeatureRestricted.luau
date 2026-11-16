local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local parent = UniversalFeatureRestrictions.Parent

require(UniversalFeatureRestrictions.Common.AbuseVector)
local featureRestrictionDisplayDirectSignal = require(UniversalFeatureRestrictions.Signals.featureRestrictionDisplayDirectSignal)
local GetModerationDetail = require(UniversalFeatureRestrictions.Http.GetModerationDetail)
require(parent.ModerationCommon.Types)
require(UniversalFeatureRestrictions.Utils.showFeatureRestrictionDirect)

local defineFastInt = game:DefineFastInt("UFRRunUnlessFeatureRestrictedTimeoutMs", 2000)

local function isNudge(p): boolean -- 1 equivalent call inferred from this helper
	local punishmentTypeDescription = p.punishmentTypeDescription
	return type(punishmentTypeDescription) == "string"
		and string.find(punishmentTypeDescription:lower(), "nudge", 1, true) ~= nil
end

local function expectsAcknowledgement(p): boolean -- 1 equivalent call inferred from this helper
	local interventionId = p.interventionId
	return p.acknowledgeable == true and type(interventionId) == "string" and interventionId ~= ""
end

local function runUnlessFeatureRestricted(abuseVector, data)
	local flag = false
	local flag2 = false
	local thread = nil

	local function setPhase(p: string) -- 4 equivalent calls inferred from this helper
		if data.onPhaseChanged then
			data.onPhaseChanged(p)
		end
	end

	local function settle() -- 7 equivalent calls inferred from this helper
		if flag2 then
			return
		end

		flag2 = true
		setPhase("Settled") -- inferred equivalent call
	end

	local function proceed(p: string) -- 7 equivalent calls inferred from this helper
		if flag then
			return
		end

		flag = true
		task.spawn(function()
			data.onProceed(p)
		end)
	end

	local function restrict(p: string)
		if flag then
			return
		end

		flag = true
		local onRestricted = data.onRestricted

		if onRestricted then
			task.spawn(function()
				onRestricted(p)
			end)
		end
	end

	local function failOpen()
		settle() -- inferred equivalent call
		proceed("CheckFailed") -- inferred equivalent call
	end

	local function showDialog(moderationDetail)
		local nudge = isNudge(moderationDetail) -- inferred equivalent call
		local v

		if nudge then
			v = expectsAcknowledgement(moderationDetail) -- inferred equivalent call
		else
			v = nudge
		end

		local flag3 = false
		local v2 = false
		local v3 = nil

		local function evaluate()
			if not flag3 then
				return
			end

			if v2 and v and v3 == nil then
				setPhase("Acknowledging") -- inferred equivalent call
			else
				settle() -- inferred equivalent call

				if nudge then
					if v3 == "Succeeded" then
						proceed("Nudged") -- inferred equivalent call
					elseif v3 == "Failed" then
						if flag then
							return
						end

						flag = true
						local onRestricted = data.onRestricted

						if onRestricted then
							local v4 = "NudgeAcknowledgementFailed"
							task.spawn(function()
								onRestricted(v4)
							end)
						end
					elseif v2 then
						proceed("Nudged") -- inferred equivalent call
					else
						if flag then
							return
						end

						flag = true
						local onRestricted = data.onRestricted

						if onRestricted then
							local v4 = "NudgeDismissedUnacknowledged"
							task.spawn(function()
								onRestricted(v4)
							end)
						end
					end
				else
					if flag then
						return
					end

					flag = true
					local onRestricted = data.onRestricted

					if onRestricted then
						local v4 = "ActiveRestriction"
						task.spawn(function()
							onRestricted(v4)
						end)
					end
				end
			end
		end

		local clone = table.clone(data.dialogOptions or {})
		local onAcknowledgementSuccess = clone.onAcknowledgementSuccess
		local onAcknowledgementFailure = clone.onAcknowledgementFailure
		function clone.onAcknowledgementSuccess()
			v3 = "Succeeded"
			evaluate()

			if onAcknowledgementSuccess then
				onAcknowledgementSuccess()
			end
		end
		function clone.onAcknowledgementFailure()
			v3 = "Failed"
			evaluate()

			if onAcknowledgementFailure then
				onAcknowledgementFailure()
			end
		end

		local flag4 = false

		local success, result = pcall(function()
			featureRestrictionDisplayDirectSignal:fire({
				abuseVector = abuseVector,
				moderationDetail = moderationDetail,
				options = clone,
				onHandled = function()
					flag4 = true
				end,
				onClosed = function(flag5: boolean)
					if flag3 then
						return
					end

					flag3 = true
					v2 = flag5
					evaluate()
				end
			})
		end)

		if not success then
			warn(`runUnlessFeatureRestricted: a listener failed while showing the dialog: {result}`)
		end

		if flag4 then
			setPhase("ShowingDialog") -- inferred equivalent call
			evaluate()
		else
			settle() -- inferred equivalent call

			if not flag then
				flag = true
				local v4 = "CheckFailed"
				task.spawn(function()
					data.onProceed(v4)
				end)
			end
		end
	end

	setPhase("Checking") -- inferred equivalent call
	local flag3 = false
	local moderationDetail = GetModerationDetail({ abuseVector = abuseVector })

	thread = task.delay(data.timeoutSeconds or defineFastInt / 1000, function()
		thread = nil

		if flag3 then
			return
		end

		flag3 = true
		moderationDetail:cancel()
		settle() -- inferred equivalent call
		proceed("CheckFailed") -- inferred equivalent call
	end)

	local function finishCheck(): boolean -- 2 equivalent calls inferred from this helper
		if flag3 then
			return false
		end

		flag3 = true

		if thread then
			task.cancel(thread)
			thread = nil
		end

		return true
	end

	moderationDetail:andThen(function(moderationDetail2)
		if not finishCheck() then -- inferred equivalent call
			return
		end

		if moderationDetail2 == nil or type(moderationDetail2) == "table" and next(moderationDetail2) == nil then
			settle() -- inferred equivalent call
			proceed("Clear") -- inferred equivalent call
		else
			if type(moderationDetail2) == "table" then
				showDialog(moderationDetail2)

				return
			end

			settle() -- inferred equivalent call
			proceed("CheckFailed") -- inferred equivalent call
		end
	end, function()
		if finishCheck() then -- inferred equivalent call
			settle() -- inferred equivalent call
			proceed("CheckFailed") -- inferred equivalent call
		end
	end)
end

return runUnlessFeatureRestricted
