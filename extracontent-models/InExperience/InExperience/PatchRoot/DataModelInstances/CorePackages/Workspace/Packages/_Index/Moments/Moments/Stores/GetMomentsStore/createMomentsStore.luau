local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local HttpService = game:GetService("HttpService")

local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local GetMomentsPreferencesStore = require(Moments.Stores.GetMomentsPreferencesStore)

local createSignal = Signals.createSignal

local function createMomentsStore()
	local signal, v = createSignal(HttpService:GenerateGUID(false))
	local signal2, setSessionSource = createSignal("watch_tab")
	local signal3, v2 = createSignal(os.clock())

	local signal4, v3 = createSignal(false)

	local signal5, v4 = createSignal(nil)
	return {
		getMomentsSessionId = signal,
		getSessionSource = signal2,
		setSessionSource = setSessionSource,
		getSessionStartTime = signal3,
		resetSession = function()
			v(HttpService:GenerateGUID(false))
			v2(os.clock())
			GetMomentsPreferencesStore(false).setTeleporting(false)
		end,
		getHideDetails = signal4,
		toggleFeedDetailVisibility = function()
			if FFlagEnableArgus then
				v3(not signal4(false))
			end
		end,
		getPendingDeletion = signal5,
		requestDeletion = function(momentId: string, feedItemId: string?, feedSessionId: string?)
			if FFlagEnableArgus then
				v4({ momentId = momentId, feedItemId = feedItemId, feedSessionId = feedSessionId })
			end
		end,
		clearPendingDeletion = function()
			v4(nil)
		end
	}
end

return createMomentsStore
