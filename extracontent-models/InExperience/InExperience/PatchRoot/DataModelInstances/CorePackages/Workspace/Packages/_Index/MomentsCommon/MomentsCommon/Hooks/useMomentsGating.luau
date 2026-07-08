local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local useAppPolicy = require(MomentsCommonParent.UniversalAppPolicy).useAppPolicy
local SharedFlags = require(MomentsCommonParent.SharedFlags)
local v6 = require(MomentsCommonParent.Loggers).Logger:new("Moments.Gating")
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local FFlagEnableArgusTab = SharedFlags.FFlagEnableArgusTab
local v10 = game:DefineFastFlag("DebugMomentsGating", false)
local ArgusExperiment = require(MomentsCommon.Flags.ArgusExperiment)

local function useMomentsGating() -- line: 47
	-- upvalues: FFlagEnableArgus (copy), useAppPolicy (copy), ArgusExperiment (copy), React (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagEnableArgusTab (copy), v10 (copy), v6 (copy)
	local v13 = FFlagEnableArgus
	local v14 = useAppPolicy(function(p1) -- line: 50
		return p1.getDisplayMomentsMoreTabTile()
	end)
	local v15 = v13 and v14
	local v16 = ArgusExperiment.useExperimentConfig({
		isExposureEnabled = false
	})
	local v17 = React.useMemo(function() -- line: 57
		-- upvalues: v16 (copy), v13 (copy), v14 (copy), v15 (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagEnableArgusTab (copy)
		local entryType = v16.entryType

		return {
			isMasterEnabled = v13,
			isAmpPolicyEnabled = v14,
			isMomentsEnabled = v15,
			isFlyoutEntryEnabled = v15 and (entryType == "flyout" or FFlagEnableArgusFlyoutEntry),
			isTabEnabled = v15 and (entryType == "tab" or FFlagEnableArgusTab),
			platformIntegrationEnabled = v15 and v16.platformIntegration,
			influencerUploadsEnabled = v15 and v16.influencerUploads,
			experimentConfig = v16
		}
	end, {
		v13,
		v14,
		v15,
		v16
	})

	React.useEffect(function() -- line: 75
		-- upvalues: v10 (copy), v6 (copy), v17 (copy), FFlagEnableArgusFlyoutEntry (copy), FFlagEnableArgusTab (copy)
		if not v10 then
			return
		end

		v6:debug("Moments.Gating master={} ampPolicy={} moments={} entryType={} platformIntegration={} influencerUploads={} flyout={} tab={} forceFlyout={} forceTab={}", tostring(v17.isMasterEnabled), tostring(v17.isAmpPolicyEnabled), tostring(v17.isMomentsEnabled), tostring(v17.experimentConfig.entryType), tostring(v17.platformIntegrationEnabled), tostring(v17.influencerUploadsEnabled), tostring(v17.isFlyoutEntryEnabled), tostring(v17.isTabEnabled), tostring(FFlagEnableArgusFlyoutEntry), (tostring(FFlagEnableArgusTab)))
	end, {
		v10,
		FFlagEnableArgusFlyoutEntry,
		FFlagEnableArgusTab,
		v17
	})

	return v17
end

return useMomentsGating
