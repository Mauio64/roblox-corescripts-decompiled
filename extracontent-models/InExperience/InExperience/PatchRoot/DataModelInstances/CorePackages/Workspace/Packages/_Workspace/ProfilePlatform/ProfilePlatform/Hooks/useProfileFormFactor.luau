local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags2.FFlagEnableSplitPane
local splitPaneStore

if FFlagEnableSplitPane then
	local SplitPane = require(parent.SplitPane)
	splitPaneStore = SplitPane.SplitPaneStore
else
	splitPaneStore = nil
end

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local Enums = require(ProfilePlatform.Common.Enums)

return function()
	local v = useSelector(function(p)
		return p.FormFactor
	end)
	local v2

	if FFlagEnableSplitPane then
		v2 = useSignalState(splitPaneStore.getStore().getIsSplitPaneActive)
	else
		v2 = false
	end

	local v3 = useProfileWrapperContext()
	local v4 = v3.profileType == Enums.ProfileTypes.Community
	local v5 = v3.sourceInfo.source == Enums.Sources.HomepageAd
	local v6

	if FFlagAXEnableProfileTab then
		v6 = v3.forceFullView == true
	end

	local isFullView = v6 or v4 and v5
	return (React.useMemo(function()
		if v == formFactor.WIDE or v2 then
			return { formFactor = Enums.ProfileFormFactor.Wide, isFullView = isFullView }
		end

		return { formFactor = Enums.ProfileFormFactor.PeekView, isFullView = isFullView }
	end, { v, isFullView, v2 }))
end
