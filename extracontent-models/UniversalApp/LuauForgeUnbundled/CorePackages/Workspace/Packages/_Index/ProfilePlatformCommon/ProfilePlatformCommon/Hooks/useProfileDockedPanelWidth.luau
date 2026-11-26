local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/RoactUtils").Hooks.RoactRodux.useSelector
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/FormFactor").Enums.FormFactor
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SignalsReact").useSignalState

local useProfileCardWidth = require("@game/CorePackages/Workspace/Packages/_Index/ProfilePlatformCommon/ProfilePlatformCommon/Hooks/useProfileCardWidth")

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SharedFlags").FFlagEnableSplitPane
local v5 = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatformCommon/SplitPane") else nil

return function(p2)
	local v6 = useSelector(function(p3)
		return p3.FormFactor
	end)
	local v7

	if fFlagEnableSplitPane then
		local v8 = useSignalState(v5.SplitPaneStore.getStore().getSupportPaneModeIfActive)
		v7 = not (v8 == nil) and v5.SplitPaneVariant.getProfileSplitPaneEligibility(v8) ~= nil
	else
		v7 = false
	end

	local v8 = useProfileCardWidth()

	if p2 and v6 == formFactor.WIDE and not v7 then
		return v8
	end

	return nil
end
