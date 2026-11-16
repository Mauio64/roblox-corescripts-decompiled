local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")
local ListRecipientsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/ListRecipientsStatus")
local RecipientLists = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientLists")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")

local v5 = {
	getResult = Signals.createSignal({
		recipients = {},
		status = ListRecipientsStatus.Ready,
		nextPageToken = nil,
		isFetchingNextPage = false
	}),
	refresh = function() end,
	loadMore = function(p2) end
}

local function useRecipientList(p2, p3)
	local v6 = React.useMemo(function()
		if p3 then
			return (RecipientLists[p2]())
		end

		return v5
	end, { p2, p3 })
	local v7 = SignalsReact.useSignalState(v6.getResult)

	React.useEffect(function()
		v6.refresh()
	end, { v6 })

	return v7, v6
end

return useRecipientList
