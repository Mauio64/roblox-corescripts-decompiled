local parent = script:FindFirstAncestor("ProfilePlatformCommon").Parent

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local SplitPane

if FFlagEnableSplitPane then
	SplitPane = require(parent.SplitPane)
else
	SplitPane = nil
end

return function(): boolean
	if not FFlagEnableSplitPane then
		return false
	end

	local v = useSignalState(SplitPane.SplitPaneStore.getStore().getSupportPaneModeIfActive)

	return v ~= nil and SplitPane.SplitPaneVariant.getProfileSplitPaneEligibility(v) ~= nil
end
