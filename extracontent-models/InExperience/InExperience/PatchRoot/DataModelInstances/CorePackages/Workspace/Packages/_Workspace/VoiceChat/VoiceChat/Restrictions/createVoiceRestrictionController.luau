local VoiceChat = script:FindFirstAncestor("VoiceChat")
local parent = VoiceChat.Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local FIntVoiceRestrictionExpiryGraceSeconds = require(VoiceChat.Flags.FIntVoiceRestrictionExpiryGraceSeconds)

local v = { UNACKNOWLEDGED_UNEXPIRED = 8, ACKNOWLEDGED_UNEXPIRED = 9, UNACKNOWLEDGED_EXPIRED = 10 }

local function isUFRBanReason(p: number?): boolean
	return p == 8 or p == 9 or p == 10
end

local function isUnacknowledgedBanReason(p: number?): boolean
	return p == 8 or p == 10
end

local function isJoinLikeTrigger(p: string): boolean -- 1 equivalent call inferred from this helper
	return p == "gameJoin" or p == "expiry" or p == "acknowledgement"
end

local function createVoiceRestrictionController(data)
	local signal, v2 = Signals.createSignal("normal")

	local getNow = data.getNow

	local flag = false
	local v3 = nil
	local thread = nil

	local flag2 = false

	local flag3 = false
	local check

	local function hasEnded(p): boolean -- 2 equivalent calls inferred from this helper
		local bannedUntil = p.bannedUntil
		return bannedUntil ~= nil and bannedUntil.Seconds <= getNow()
	end

	local function cancelExpiry() -- 5 equivalent calls inferred from this helper
		flag3 = false

		if thread then
			task.cancel(thread)
			thread = nil
		end
	end

	local function endRestriction() -- 3 equivalent calls inferred from this helper
		cancelExpiry() -- inferred equivalent call
		flag2 = false
		v2("hiddenUntilRejoin")
	end

	local function scheduleExpiryCheck(p: number) -- 2 equivalent calls inferred from this helper
		cancelExpiry() -- inferred equivalent call
		local v4 = math.max(p - getNow(), 0)
		thread = task.delay(v4, function()
			thread = nil
			flag3 = false
			check("expiry")
		end)
	end

	local function scheduleExpiryAfterEnd(p: number?) -- 2 equivalent calls inferred from this helper
		if p then
			scheduleExpiryCheck(p + FIntVoiceRestrictionExpiryGraceSeconds) -- inferred equivalent call
		else
			cancelExpiry() -- inferred equivalent call
		end
	end

	local function createAcknowledgementHandler(p) -- 1 equivalent call inferred from this helper
		return function()
			if signal(false) ~= "restricted" or flag2 then
				return
			end

			local bannedUntil = p.bannedUntil

			if not bannedUntil or bannedUntil.Seconds <= getNow() then
				check("acknowledgement")
			end
		end
	end

	local function showUFRRestriction(p, p2: string) -- 5 equivalent calls inferred from this helper
		data.showUFRRestriction(p, p2, createAcknowledgementHandler(p)) -- inferred equivalent call
	end

	local function failCheck(p: string, p2: string) -- 2 equivalent calls inferred from this helper
		if p ~= "expiry" and p ~= "acknowledgement" then
			data.onError(p2)

			return
		end

		endRestriction() -- inferred equivalent call
	end

	local function showDialogIfUnseen(p, p2, isCurrent)
		local v4 = p.trigger
		local banReason = p2.banReason
		local v5 = banReason == v.UNACKNOWLEDGED_UNEXPIRED
			or banReason == v.ACKNOWLEDGED_UNEXPIRED
			or banReason == v.UNACKNOWLEDGED_EXPIRED
		local v6

		if v5 and v4 == "removedFromVoice" then
			v6 = true
		elseif isJoinLikeTrigger(v4) then -- inferred equivalent call
			if v5 then
				v6 = p2.banReason == 9
			else
				v6 = data.getInformedOfBan()

				if not isCurrent() then
					return
				end
			end
		else
			v6 = false
		end

		if v6 ~= false then
			if p.micTapped then
				v4 = "micTap"
			else
				if v6 ~= nil then
					return
				end

				data.onError("InformedOfBanUnavailable")
				return
			end
		end

		if v5 then
			showUFRRestriction(p2, v4) -- inferred equivalent call
		else
			data.showLegacyRestriction(p2, v4, isCurrent)
		end
	end

	local function handleEndedRestriction(p, p2)
		local trigger = p.trigger
		local banReason = p2.banReason
		local v4 = banReason == v.UNACKNOWLEDGED_UNEXPIRED
			or banReason == v.ACKNOWLEDGED_UNEXPIRED
			or banReason == v.UNACKNOWLEDGED_EXPIRED

		if trigger == "removedFromVoice" then
			scheduleExpiryCheck(getNow() + FIntVoiceRestrictionExpiryGraceSeconds) -- inferred equivalent call
			flag3 = true
		end

		if flag3 then
			if v4 and (trigger == "micTap" or p.micTapped) then
				showUFRRestriction(p2, "micTap") -- inferred equivalent call
			end
		else
			endRestriction() -- inferred equivalent call
			local banReason2 = p2.banReason

			if
				(banReason2 == v.UNACKNOWLEDGED_UNEXPIRED or banReason2 == v.UNACKNOWLEDGED_EXPIRED)
				and trigger ~= "acknowledgement"
			then
				showUFRRestriction(p2, trigger) -- inferred equivalent call
			end
		end
	end

	local function runCheck(p, p2)
		local function isCurrent(): boolean -- 1 equivalent call inferred from this helper
			return v3 == p
		end

		local trigger = p.trigger
		local v4 = p2 or data.getSettings()

		if not isCurrent() then -- inferred equivalent call
			return
		end

		if v4 then
			if v4.isBanned and not hasEnded(v4) then -- inferred equivalent call
				flag2 = false
				v2("restricted")
				local v5

				if v4.bannedUntil then
					v5 = v4.bannedUntil.Seconds
				end

				scheduleExpiryAfterEnd(v5) -- inferred equivalent call
				showDialogIfUnseen(p, v4, isCurrent)
			elseif flag2 then
				if trigger == "micTap" or p.micTapped then
					showUFRRestriction(v4, "micTap") -- inferred equivalent call
				end
			else
				if v4.isBanned or v4.banReason == 10 then
					handleEndedRestriction(p, v4)
					return
				end

				if trigger == "gameJoin" or trigger == "removedFromVoice" then
					data.onError("PlayerModeratedBadState")
					return
				end

				endRestriction() -- inferred equivalent call
			end
		else
			failCheck(trigger, "SettingsUnavailable") -- inferred equivalent call
		end
	end

	check = function(trigger: string, p)
		if flag then
			return Promise.resolve()
		end

		local v4 = v3

		if trigger == "micTap" and v4 and v4.promise then
			v4.micTapped = true
			return v4.promise
		end

		if trigger == "gameJoin" or trigger == "removedFromVoice" and not flag2 then
			cancelExpiry() -- inferred equivalent call
		end

		if trigger == "gameJoin" or trigger == "expiry" then
			flag2 = false
		end

		local v5 = { trigger = trigger, micTapped = false }
		v3 = v5

		if not p or p.banReason == nil then
			p = nil
		end

		local v6

		if trigger == "gameJoin" and p ~= nil then
			v6 = p.isBanned and hasEnded(p) -- inferred equivalent call
		else
			v6 = false
		end

		if trigger ~= "micTap" and not v6 then
			v2("restricted")
		end

		local promise = Promise.defer(function(callback)
			runCheck(v5, p)
			callback()
		end):catch(function()
			if v3 == v5 then
				failCheck(trigger, "RestrictionRequestFailed") -- inferred equivalent call
			end
		end)
		v5.promise = promise
		promise:finally(function()
			v5.promise = nil
		end)

		return promise
	end

	local function applyUFRTimeout(p: number?)
		if flag then
			return
		end

		v3 = nil
		flag2 = true
		v2("restricted")
		scheduleExpiryAfterEnd(p) -- inferred equivalent call
	end

	local function showPendingAcknowledgement(p)
		if flag or p.isBanned or p.banReason ~= 10 then
			return
		end

		if signal(false) ~= "normal" or v3 or flag2 then
			return
		end

		showUFRRestriction(p, "gameJoin") -- inferred equivalent call
	end

	local function dispose()
		flag = true

		if v3 and v3.promise then
			v3.promise:cancel()
		end

		v3 = nil
		cancelExpiry() -- inferred equivalent call
		v2("normal")
	end

	return {
		getPresentationState = signal,
		check = check,
		applyUFRTimeout = applyUFRTimeout,
		showPendingAcknowledgement = showPendingAcknowledgement,
		dispose = dispose
	}
end

return createVoiceRestrictionController
