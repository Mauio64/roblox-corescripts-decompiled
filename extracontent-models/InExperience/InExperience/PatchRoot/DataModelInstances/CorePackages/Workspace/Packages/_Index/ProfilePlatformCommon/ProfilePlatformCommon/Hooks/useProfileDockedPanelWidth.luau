local parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useProfileCardWidth = require(script.Parent.useProfileCardWidth)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local SplitPane

if FFlagEnableSplitPane then
	SplitPane = require(parent.SplitPane)
else
	SplitPane = nil
end

return function(flag: boolean?)
	local v = useSelector(function(p)
		return p.FormFactor
	end)
	local v2

	if FFlagEnableSplitPane then
		local v3 = useSignalState(SplitPane.SplitPaneStore.getStore().getSupportPaneModeIfActive)

		if v3 == nil then
			v2 = false
		else
			v2 = SplitPane.SplitPaneVariant.getProfileSplitPaneEligibility(v3) ~= nil
		end
	else
		v2 = false
	end

	local v3 = useProfileCardWidth()

	return if flag and v == formFactor.WIDE and not v2 then v3 else nil
end
