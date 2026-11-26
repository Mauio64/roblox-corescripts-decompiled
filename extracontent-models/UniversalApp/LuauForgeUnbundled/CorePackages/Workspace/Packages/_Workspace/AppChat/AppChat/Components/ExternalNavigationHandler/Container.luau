local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ExternalNavigationHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/ExternalNavigationHandler")
local mapStateToProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/mapStateToProps")
local mapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/mapDispatchToProps")

local module4 = require("@luauforge/deferred/hGa")
local useSignalState

if module4 then
	local SignalsReact = require(CorePackages.Packages.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local v5 = if module4 then require("@luauforge/deferred/hGb") else nil

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

if module4 then
	return memo
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(ExternalNavigationHandler))
