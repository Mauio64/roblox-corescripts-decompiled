local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local ListRecipientsStatus = require(script.Parent.ListRecipientsStatus)
local RecipientLists = require(script.Parent.RecipientLists)
require(ShareSheet.Types)
require(script.Parent.RecipientSource)

local v = {
	getResult = Signals.createSignal({
		recipients = {},
		status = ListRecipientsStatus.Ready,
		nextPageToken = nil,
		isFetchingNextPage = false
	}),
	refresh = function() end,
	loadMore = function(_: string) end
}

local function useRecipientList(p, flag: boolean)
	local v2 = React.useMemo(function()
		if flag then
			return (RecipientLists[p]())
		end

		return v
	end, { p, flag })
	local v3 = SignalsReact.useSignalState(v2.getResult)

	React.useEffect(function()
		v2.refresh()
	end, { v2 })

	return v3, v2
end

return useRecipientList
