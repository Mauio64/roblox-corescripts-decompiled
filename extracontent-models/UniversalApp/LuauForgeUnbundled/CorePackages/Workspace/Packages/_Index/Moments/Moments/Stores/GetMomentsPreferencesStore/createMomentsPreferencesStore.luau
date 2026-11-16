local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")

local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local GetFFlagMomentsFeedStartExpanded = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagMomentsFeedStartExpanded")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentsPreferencesStore()
	local signal, v5 = createSignal(not GetFFlagMomentsFeedStartExpanded())
	local signal2, v6 = createSignal(false)
	local signal3, v7 = createSignal(false)
	local signal4, v8 = createSignal(false)

	return {
		getMinimized = signal,
		getMediaScaleType = createComputed(function(p2)
			if signal(p2) then
				return Enum.ScaleType.Fit
			end

			return Enum.ScaleType.Crop
		end),
		toggleFeedScaleType = function()
			if fFlagEnableArgus then
				v5(not signal(false))
			end
		end,
		getFeedGlobalMute = signal2,
		toggleFeedGlobalMute = function()
			if fFlagEnableArgus then
				v6(not signal2(false))
			end
		end,
		getDebugModeEnabled = signal3,
		toggleFeedDebugMode = function()
			if fFlagEnableArgus then
				v7(not signal3(false))
			end
		end,
		getIsTeleporting = signal4,
		setTeleporting = function(p2)
			v8(p2)
		end
	}
end

return createMomentsPreferencesStore
