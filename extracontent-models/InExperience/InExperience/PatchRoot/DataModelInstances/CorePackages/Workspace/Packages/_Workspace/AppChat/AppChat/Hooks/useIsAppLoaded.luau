local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getDeepValue = require(AppChat.Utils.getDeepValue)
local GetAppLoadedStore = require(AppChat.Stores.GetAppLoadedStore)

local FFlagAppChatUseSignalsForAppLoaded = require(AppChat.Flags.FFlagAppChatUseSignalsForAppLoaded)

return function()
	if FFlagAppChatUseSignalsForAppLoaded then
		return useSignalState(GetAppLoadedStore(false).getAppLoaded)
	end

	return useSelector(function(p)
		return getDeepValue(p, "ChatAppReducer.AppLoaded") or false
	end)
end
