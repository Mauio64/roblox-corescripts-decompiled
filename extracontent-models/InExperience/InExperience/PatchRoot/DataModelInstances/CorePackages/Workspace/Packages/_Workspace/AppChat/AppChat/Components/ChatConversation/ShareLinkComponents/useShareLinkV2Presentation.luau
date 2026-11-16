local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local GetShareLinkV2Store = require(AppChat.Stores.GetShareLinkV2Store)
require(script.Parent.ShareLinkV2Presentation)
local getShareLinkV2Presentation = require(script.Parent.getShareLinkV2Presentation)

local signal = Signals.createSignal(nil)
local signal2 = Signals.createSignal(DataHydration.DataStatus.NotReady)

local function useShareLinkV2Presentation(value: string?)
	local shareLinkV2Store = GetShareLinkV2Store(false)
	local v = React.useMemo(function()
		if value then
			return (shareLinkV2Store.getAndFetchClassification(value))
		end

		return nil
	end, { shareLinkV2Store, value or "" })
	local v2 = if v then v.data else signal
	local v3 = useSignalState(v2)
	local v4 = if v then v.status else signal2
	local v5 = useSignalState(v4)

	if v == nil then
		return nil
	end

	return getShareLinkV2Presentation(v3, v5)
end

return useShareLinkV2Presentation
