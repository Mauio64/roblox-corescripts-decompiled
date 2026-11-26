local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local signal = Signals.createSignal(nil)

local function useRecipientSearch(p2, p3)
	local v5 = React.useMemo(function()
		if p3 == "" or p2.search == nil then
			return nil
		end

		return (p2.search(p3))
	end, { p2, p3 })
	local useSignalState = SignalsReact.useSignalState
	local v6 = if v5 then v5.getResult else signal
	local v7 = useSignalState(v6)

	React.useEffect(function()
		if v5 then
			v5.refresh()
		end
	end, { v5 })

	local v8 = {
		filterQuery = v5 and "" or p3,
		pageList = v5 or p2,
		result = nil
	}

	if not v5 then
		v7 = nil
	end

	v8.result = v7
	return v8
end

return useRecipientSearch
