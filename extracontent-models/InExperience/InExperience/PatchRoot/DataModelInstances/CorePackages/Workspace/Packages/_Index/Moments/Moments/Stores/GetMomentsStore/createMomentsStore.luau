local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local HttpService = game:GetService("HttpService")
local SharedFlags = require(MomentsParent.SharedFlags)
local Signals = require(MomentsParent.Signals)
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local GetFFlagMomentsPauseAudioThroughTeleport = require(Moments.Flags.GetFFlagMomentsPauseAudioThroughTeleport)
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)
local createSignal = Signals.createSignal

local function createMomentsStore() -- line: 57
	-- upvalues: createSignal (copy), HttpService (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), GetMomentsPreferencesStore (copy), FFlagEnableArgus (copy)
	local v11, v12 = createSignal(HttpService:GenerateGUID(false))
	local v13, v14 = createSignal("watch_tab")
	local v15, v16 = createSignal(os.clock())
	local v17, v18 = createSignal(false)
	local v19, v20 = createSignal(nil)

	return {
		getMomentsSessionId = v11,
		getSessionSource = v13,
		setSessionSource = v14,
		getSessionStartTime = v15,
		resetSession = function() -- line: 62
			-- upvalues: v12 (copy), HttpService (copy), v16 (copy), GetFFlagMomentsPauseAudioThroughTeleport (copy), GetMomentsPreferencesStore (copy)
			v12(HttpService:GenerateGUID(false))
			v16(os.clock())

			if GetFFlagMomentsPauseAudioThroughTeleport() then
				GetMomentsPreferencesStore(false).setTeleporting(false)
			end
		end,
		getHideDetails = v17,
		toggleFeedDetailVisibility = function() -- line: 80
			-- upvalues: FFlagEnableArgus (copy), v18 (copy), v17 (copy)
			if FFlagEnableArgus then
				v18(not v17(false))
			end
		end,
		getPendingDeletion = v19,
		requestDeletion = function(s1: string) -- line: 86
			-- upvalues: FFlagEnableArgus (copy), v20 (copy)
			if FFlagEnableArgus then
				v20(s1)
			end
		end,
		clearPendingDeletion = function() -- line: 92
			-- upvalues: v20 (copy)
			v20(nil)
		end
	}
end

return createMomentsStore
