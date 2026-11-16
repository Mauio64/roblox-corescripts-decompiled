local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local GetFFlagMomentsFeedStartExpanded = require(Moments.Flags.GetFFlagMomentsFeedStartExpanded)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentsPreferencesStore()
	local signal, v = createSignal(not GetFFlagMomentsFeedStartExpanded())
	local signal2, v2 = createSignal(false)
	local signal3, v3 = createSignal(false)
	local signal4, v4 = createSignal(false)

	return {
		getMinimized = signal,
		getMediaScaleType = createComputed(function(p)
			if signal(p) then
				return Enum.ScaleType.Fit
			end

			return Enum.ScaleType.Crop
		end),
		toggleFeedScaleType = function()
			if FFlagEnableArgus then
				v(not signal(false))
			end
		end,
		getFeedGlobalMute = signal2,
		toggleFeedGlobalMute = function()
			if FFlagEnableArgus then
				v2(not signal2(false))
			end
		end,
		getDebugModeEnabled = signal3,
		toggleFeedDebugMode = function()
			if FFlagEnableArgus then
				v3(not signal3(false))
			end
		end,
		getIsTeleporting = signal4,
		setTeleporting = function(flag: boolean)
			v4(flag)
		end
	}
end

return createMomentsPreferencesStore
