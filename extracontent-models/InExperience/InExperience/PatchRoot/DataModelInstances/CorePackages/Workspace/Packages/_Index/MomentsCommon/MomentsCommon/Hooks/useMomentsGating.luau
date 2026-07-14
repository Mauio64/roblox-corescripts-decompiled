local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local useAppPolicy = require(MomentsCommonParent.UniversalAppPolicy).useAppPolicy
local SharedFlags = require(MomentsCommonParent.SharedFlags)
local v6 = require(MomentsCommonParent.Loggers).Logger:new("Moments.Gating")
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local FFlagEnableArgusTab = SharedFlags.FFlagEnableArgusTab
local FFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local FFlagArgusTabImpliesFlyout = SharedFlags.FFlagArgusTabImpliesFlyout
local v12 = game:DefineFastFlag("DebugMomentsGating", false)
local ArgusExperiment = require(MomentsCommon.Flags.ArgusExperiment)

local function useMomentsGating() -- line: 49
	-- upvalues: FFlagEnableArgus (copy), useAppPolicy (copy), ArgusExperiment (copy), React (copy), FFlagArgoEnableMoments (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagArgusTabImpliesFlyout (copy), FFlagEnableArgusTab (copy), v12 (copy), v6 (copy)
	local v15 = FFlagEnableArgus
	local v16 = useAppPolicy(function(p1) -- line: 52
		return p1.getDisplayMomentsMoreTabTile()
	end)
	local v17 = v15 and v16
	local v18 = ArgusExperiment.useExperimentConfig({
		isExposureEnabled = false
	})
	local v19 = React.useMemo(function() -- line: 59
		-- upvalues: v18 (copy), FFlagArgoEnableMoments (copy), v17 (copy), v15 (copy), v16 (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagArgusTabImpliesFlyout (copy), FFlagEnableArgusTab (copy)
		local entryType = v18.entryType
		local v22 = entryType == "tab"
		local v23 = FFlagArgoEnableMoments and v17

		return {
			isMasterEnabled = v15,
			isAmpPolicyEnabled = v16,
			isMomentsEnabled = v17,
			isFlyoutEntryEnabled = v23 or v17 and (entryType == "flyout" or (FFlagEnableArgusFlyoutEntry or FFlagArgusTabImpliesFlyout and v22)),
			isTabEnabled = v23 or v17 and (v22 or FFlagEnableArgusTab),
			platformIntegrationEnabled = v23 or v17 and v18.platformIntegration,
			influencerUploadsEnabled = v17 and v18.influencerUploads,
			experimentConfig = v18
		}
	end, {
		v15,
		v16,
		v17,
		v18
	})

	React.useEffect(function() -- line: 83
		-- upvalues: v12 (copy), v6 (copy), v19 (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagEnableArgusTab (copy), FFlagArgoEnableMoments (copy)
		if not v12 then
			return
		end

		v6:debug("Moments.Gating master={} ampPolicy={} moments={} entryType={} platformIntegration={} influencerUploads={} flyout={} tab={} forceFlyout={} forceTab={} forceAll={}", tostring(v19.isMasterEnabled), tostring(v19.isAmpPolicyEnabled), tostring(v19.isMomentsEnabled), tostring(v19.experimentConfig.entryType), tostring(v19.platformIntegrationEnabled), tostring(v19.influencerUploadsEnabled), tostring(v19.isFlyoutEntryEnabled), tostring(v19.isTabEnabled), tostring(FFlagEnableArgusFlyoutEntry), tostring(FFlagEnableArgusTab), (tostring(FFlagArgoEnableMoments)))
	end, {
		v12,
		FFlagEnableArgusFlyoutEntry,
		FFlagEnableArgusTab,
		v19
	})

	return v19
end

return useMomentsGating
