local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local GetMomentsShellStackStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsShellStackStore")

local function useIsTopMomentsShell(callback): boolean
	local v5 = GetMomentsShellStackStore(false)
	local state, setState = React.useState(nil)
	React.useLayoutEffect(function()
		if v5.getTopShellId(false) ~= nil then
			callback("pushed")
		end

		local v6, v7 = v5.pushShell()
		setState(v6)
		return function()
			if v5.getTopShellId(false) == v6 then
				callback("popped")
			end

			v7()
		end
	end, { v5, callback })
	local v6 = SignalsReact.useSignalState(v5.getTopShellId)
	return state ~= nil and state == v6
end

return useIsTopMomentsShell
