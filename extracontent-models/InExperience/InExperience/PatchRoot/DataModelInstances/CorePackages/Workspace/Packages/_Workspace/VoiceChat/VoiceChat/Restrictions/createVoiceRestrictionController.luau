local parent = script:FindFirstAncestor("VoiceChat").Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local v = { UNACKNOWLEDGED = 8, ACKNOWLEDGED = 9 }

local function isUFRBanReason(p: number?): boolean
	return p == 8 or p == 9
end

local function isJoinLikeTrigger(p: string): boolean -- 1 equivalent call inferred from this helper
	return p == "gameJoin" or p == "expiry" or p == "acknowledgement"
end

local function createVoiceRestrictionController(data)
	local signal, v2 = Signals.createSignal("normal")

	local flag = false
	local v3 = nil
	local thread = nil

	local flag2 = false
	local check

	local function cancelExpiry() -- 4 equivalent calls inferred from this helper
		if thread then
			task.cancel(thread)
			thread = nil
		end
	end

	local function endRestriction() -- 2 equivalent calls inferred from this helper
		cancelExpiry() -- inferred equivalent call
		flag2 = false
		v2("hiddenUntilRejoin")
	end

	local function scheduleExpiry(p: number?)
		cancelExpiry() -- inferred equivalent call
		local v4 = not p and 0 or p - DateTime.now().UnixTimestamp

		if v4 > 0 then
			thread = task.delay(v4, function()
				thread = nil
				check("expiry")
			end)
		end
	end

	local function createAcknowledgementHandler(p) -- 1 equivalent call inferred from this helper
		return function()
			local bannedUntil = p.bannedUntil

			if not bannedUntil or bannedUntil.Seconds <= DateTime.now().UnixTimestamp then
				check("acknowledgement")
			end
		end
	end

	local function failCheck(p: string, p2: string) -- 2 equivalent calls inferred from this helper
		if p ~= "expiry" and p ~= "acknowledgement" then
			data.onError(p2)

			return
		end

		endRestriction() -- inferred equivalent call
	end

	local function showDialogIfUnseen(p, data2, isCurrent)
		local v4 = p.trigger
		local banReason = data2.banReason
		local v5 = banReason == v.UNACKNOWLEDGED or banReason == v.ACKNOWLEDGED
		local v6

		if v5 and v4 == "removedFromVoice" then
			v6 = true
		elseif isJoinLikeTrigger(v4) then -- inferred equivalent call
			if v5 then
				v6 = data2.banReason == 9
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
			data.showUFRRestriction(data2, v4, v4 == "gameJoin" and createAcknowledgementHandler(data2) or nil) -- inferred equivalent call
		else
			data.showLegacyRestriction(data2, v4, isCurrent)
		end
	end

	local function runCheck(p, data2)
		local function isCurrent(): boolean -- 1 equivalent call inferred from this helper
			return v3 == p
		end

		local trigger = p.trigger

		if not data2 or data2.banReason == nil then
			data2 = data.getSettings()
		end

		if not isCurrent() then -- inferred equivalent call
			return
		end

		if data2 then
			if data2.isBanned then
				v2("restricted")
				local v4

				if data2.bannedUntil then
					v4 = data2.bannedUntil.Seconds
				end

				scheduleExpiry(v4)
				showDialogIfUnseen(p, data2, isCurrent)
			elseif flag2 then
				if trigger == "micTap" or p.micTapped then
					data.showUFRRestriction(data2, "micTap", nil)
				end
			else
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

		if trigger ~= "micTap" then
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
		scheduleExpiry(p)
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
		dispose = dispose
	}
end

return createVoiceRestrictionController
