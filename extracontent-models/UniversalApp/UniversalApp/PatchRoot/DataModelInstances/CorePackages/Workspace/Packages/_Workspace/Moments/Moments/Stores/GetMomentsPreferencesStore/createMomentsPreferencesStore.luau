local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local SharedFlags = require(MomentsParent.SharedFlags)
local Signals = require(MomentsParent.Signals)
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local GetFFlagMomentsFeedStartExpanded = require(Moments.Flags.GetFFlagMomentsFeedStartExpanded)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMomentsPreferencesStore() -- line: 50
	-- upvalues: createSignal (copy), GetFFlagMomentsFeedStartExpanded (copy), createComputed (copy), FFlagEnableArgus (copy)
	local v10, v11 = createSignal(not GetFFlagMomentsFeedStartExpanded())
	local v12, v13 = createSignal(false)
	local v14, v15 = createSignal(false)
	local v16, v17 = createSignal(false)
	local v18 = createComputed(function(p1) -- line: 61
		-- upvalues: v10 (copy)
		if v10(p1) then
			return Enum.ScaleType.Fit
		end

		return Enum.ScaleType.Crop
	end)

	return {
		getMinimized = v10,
		getMediaScaleType = v18,
		toggleFeedScaleType = function() -- line: 69
			-- upvalues: FFlagEnableArgus (copy), v11 (copy), v10 (copy)
			if FFlagEnableArgus then
				v11(not v10(false))
			end
		end,
		getFeedGlobalMute = v12,
		toggleFeedGlobalMute = function() -- line: 75
			-- upvalues: FFlagEnableArgus (copy), v13 (copy), v12 (copy)
			if FFlagEnableArgus then
				v13(not v12(false))
			end
		end,
		getDebugModeEnabled = v14,
		toggleFeedDebugMode = function() -- line: 81
			-- upvalues: FFlagEnableArgus (copy), v15 (copy), v14 (copy)
			if FFlagEnableArgus then
				v15(not v14(false))
			end
		end,
		getIsTeleporting = v16,
		setTeleporting = function(b1: boolean) -- line: 65
			-- upvalues: v17 (copy)
			v17(b1)
		end
	}
end

return createMomentsPreferencesStore
