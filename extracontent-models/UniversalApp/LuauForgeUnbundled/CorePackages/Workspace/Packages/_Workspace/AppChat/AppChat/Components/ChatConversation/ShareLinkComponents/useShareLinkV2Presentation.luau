local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local GetShareLinkV2Store = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetShareLinkV2Store")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/ShareLinkV2Presentation")
local getShareLinkV2Presentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/getShareLinkV2Presentation")

local signal = Signals.createSignal(nil)
local signal2 = Signals.createSignal(DataHydration.DataStatus.NotReady)

local function useShareLinkV2Presentation(value)
	local v5 = GetShareLinkV2Store(false)
	local v6 = React.useMemo(function()
		if value then
			return (v5.getAndFetchClassification(value))
		end

		return nil
	end, { v5, value or "" })
	local v8 = if v6 then v6.data else signal
	local v9 = useSignalState(v8)
	local v11 = if v6 then v6.status else signal2
	local v12 = useSignalState(v11)

	if v6 == nil then
		return nil
	end

	return getShareLinkV2Presentation(v9, v12)
end

return useShareLinkV2Presentation
