local HttpService = game:GetService("HttpService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local GetMomentsPreferencesStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsPreferencesStore")

local createSignal = Signals.createSignal

local function createMomentsStore()
	local signal, v5 = createSignal(HttpService:GenerateGUID(false))
	local signal2, v6 = createSignal("watch_tab")
	local signal3, v7 = createSignal(os.clock())

	local signal4, v8 = createSignal(false)

	local signal5, v9 = createSignal(nil)
	return {
		getMomentsSessionId = signal,
		getSessionSource = signal2,
		setSessionSource = v6,
		getSessionStartTime = signal3,
		resetSession = function()
			v5(HttpService:GenerateGUID(false))
			v7(os.clock())
			GetMomentsPreferencesStore(false).setTeleporting(false)
		end,
		getHideDetails = signal4,
		toggleFeedDetailVisibility = function()
			if fFlagEnableArgus then
				v8(not signal4(false))
			end
		end,
		getPendingDeletion = signal5,
		requestDeletion = function(p2, p3, p4)
			if fFlagEnableArgus then
				v9({ momentId = p2, feedItemId = p3, feedSessionId = p4 })
			end
		end,
		clearPendingDeletion = function()
			v9(nil)
		end
	}
end

return createMomentsStore
