local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local ExternalNavigationHandler = require(script.Parent.ExternalNavigationHandler)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)

local FFlagAppChatUseSignalsForExternalNavigationRequest = require(AppChat.Flags.FFlagAppChatUseSignalsForExternalNavigationRequest)
local useSignalState

if FFlagAppChatUseSignalsForExternalNavigationRequest then
	local SignalsReact = require(parent.SignalsReact)
	useSignalState = SignalsReact.useSignalState
else
	useSignalState = nil
end

local GetExternalNavigationRequestStore

if FFlagAppChatUseSignalsForExternalNavigationRequest then
	GetExternalNavigationRequestStore = require(AppChat.Stores.GetExternalNavigationRequestStore)
else
	GetExternalNavigationRequestStore = nil
end

local memo = React.memo(function(p)
	local externalNavigationRequestStore = GetExternalNavigationRequestStore(false)
	local v = useSignalState(externalNavigationRequestStore.getRequest)

	return React.createElement(
		ExternalNavigationHandler,
		Cryo.Dictionary.join(p, v, {
			completeExternalNavigation = externalNavigationRequestStore.completeExternalNavigation
		})
	)
end)

if FFlagAppChatUseSignalsForExternalNavigationRequest then
	return memo
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(ExternalNavigationHandler))
