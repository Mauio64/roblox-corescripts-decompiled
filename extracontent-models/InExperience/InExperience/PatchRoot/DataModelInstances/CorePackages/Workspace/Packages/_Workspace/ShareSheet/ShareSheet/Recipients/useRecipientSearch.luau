local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(ShareSheet.Types)

local signal = Signals.createSignal(nil)

local function useRecipientSearch(p, p2: string)
	local v = React.useMemo(function()
		if p2 == "" or p.search == nil then
			return nil
		end

		return (p.search(p2))
	end, { p, p2 })
	local useSignalState = SignalsReact.useSignalState
	local v2 = if v then v.getResult else signal
	local v3 = useSignalState(v2)

	React.useEffect(function()
		if v then
			v.refresh()
		end
	end, { v })

	local v4 = {
		filterQuery = v and "" or p2,
		pageList = v or p,
		result = nil
	}

	if not v then
		v3 = nil
	end

	v4.result = v3
	return v4
end

return useRecipientSearch
