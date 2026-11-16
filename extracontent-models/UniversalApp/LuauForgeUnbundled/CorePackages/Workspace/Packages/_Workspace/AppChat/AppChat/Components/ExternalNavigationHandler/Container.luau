local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactRodux")
local ExternalNavigationHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/ExternalNavigationHandler")
local mapStateToProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/mapStateToProps")
local mapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/mapDispatchToProps")

local FFlagAppChatUseSignalsForExternalNavigationRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForExternalNavigationRequest")

local useSignalState = if FFlagAppChatUseSignalsForExternalNavigationRequest then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState else nil

local v5 = if FFlagAppChatUseSignalsForExternalNavigationRequest then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetExternalNavigationRequestStore") else nil

local memo = React.memo(function(p2)
	local v6 = v5(false)
	local v7 = useSignalState(v6.getRequest)

	return React.createElement(
		ExternalNavigationHandler,
		Cryo.Dictionary.join(p2, v7, {
			completeExternalNavigation = v6.completeExternalNavigation
		})
	)
end)

if FFlagAppChatUseSignalsForExternalNavigationRequest then
	return memo
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(ExternalNavigationHandler))
