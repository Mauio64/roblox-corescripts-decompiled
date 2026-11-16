local parent = script:FindFirstAncestor("VoiceChat").Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local function createVoiceRestrictionController_DEPRECATED(data)
	local signal, v = Signals.createSignal("normal")

	local count = 0
	local flag = false
	local v2 = nil
	local v3 = nil
	local flag2 = false
	local thread = nil

	local function cancelExpiry() -- 5 equivalent calls inferred from this helper
		if thread then
			task.cancel(thread)
			thread = nil
		end
	end

	local function expireRestriction() -- 2 equivalent calls inferred from this helper
		if flag then
			return
		end

		cancelExpiry() -- inferred equivalent call
		count += 1
		v("hiddenUntilRejoin")
	end

	local function scheduleExpiry(p)
		cancelExpiry() -- inferred equivalent call
		local bannedUntil = p.bannedUntil

		if not bannedUntil then
			return
		end

		local v4 = bannedUntil.Seconds - DateTime.now().UnixTimestamp

		if v4 <= 0 then
			return
		end

		thread = task.delay(v4, function()
			thread = nil
			expireRestriction() -- inferred equivalent call
		end)
	end

	local function runCheck(p: string, p2, isCurrent)
		if not p2 or p2.banReason == nil then
			p2 = data.getSettings()
		end

		if not isCurrent() then
			return
		end

		if not p2 then
			data.onError("SettingsUnavailable")
		elseif p2.isBanned then
			v("restricted")
			scheduleExpiry(p2)
			local v4

			if p == "gameJoin" then
				v4 = data.getInformedOfBan()
			else
				v4 = false
			end

			if not isCurrent() then
				return
			end

			if v4 == false then
				data.showLegacyRestriction(p2, p, isCurrent)
			elseif flag2 then
				data.showLegacyRestriction(p2, "micTap", isCurrent)
			elseif v4 == nil then
				data.onError("InformedOfBanUnavailable")
			end
		else
			if p ~= "micTap" then
				data.onError("PlayerModeratedBadState")

				return
			end

			cancelExpiry() -- inferred equivalent call
			v("hiddenUntilRejoin")
		end
	end

	local function check(p: string, p2)
		if flag then
			return Promise.resolve()
		end

		if p == "expiry" then
			expireRestriction() -- inferred equivalent call
			return Promise.resolve()
		elseif p == "micTap" and v2 then
			if v3 == "gameJoin" then
				flag2 = true
			end

			return v2
		else
			if p == "gameJoin" or p == "removedFromVoice" then
				cancelExpiry() -- inferred equivalent call
			end

			flag2 = false
			count += 1
			local v4 = count
			local function isCurrent(): boolean -- 1 equivalent call inferred from this helper
				return not flag and count == v4
			end

			if p ~= "micTap" then
				v("restricted")
			end

			local v5 = Promise.defer(function(callback)
				runCheck(p, p2, isCurrent)
				callback()
			end):catch(function()
				if isCurrent() then -- inferred equivalent call
					data.onError("RestrictionRequestFailed")
				end
			end)

			v2 = v5
			v3 = p
			v5:finally(function()
				if v2 == v5 then
					v2 = nil
					v3 = nil
					flag2 = false
				end
			end)

			return v5
		end
	end

	local function dispose()
		flag = true
		count += 1

		if v2 then
			v2:cancel()
			v2 = nil
			v3 = nil
			flag2 = false
		end

		cancelExpiry() -- inferred equivalent call
		v("normal")
	end

	return { getPresentationState = signal, check = check, dispose = dispose }
end

return createVoiceRestrictionController_DEPRECATED
