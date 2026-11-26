local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useSelector
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FormFactor").Enums.FormFactor
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableSplitPane
local splitPaneStore = if fFlagEnableSplitPane then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SplitPane").SplitPaneStore else nil
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

return function()
	local v5 = useSelector(function(p2)
		return p2.FormFactor
	end)
	local v6

	if fFlagEnableSplitPane then
		v6 = useSignalState(splitPaneStore.getStore().getIsSplitPaneActive)
	else
		v6 = false
	end

	local v7 = useProfileWrapperContext()
	local v8 = v7.profileType == Enums.ProfileTypes.Community
	local v9 = v7.sourceInfo.source == Enums.Sources.HomepageAd

	local v11 = (if fFlagAXEnableProfileTab then v7.forceFullView == true else nil) or v8 and v9

	return (React.useMemo(function()
		if v5 == formFactor.WIDE or v6 then
			return { formFactor = Enums.ProfileFormFactor.Wide, isFullView = v11 }
		end

		return { formFactor = Enums.ProfileFormFactor.PeekView, isFullView = v11 }
	end, { v5, v11, v6 }))
end
