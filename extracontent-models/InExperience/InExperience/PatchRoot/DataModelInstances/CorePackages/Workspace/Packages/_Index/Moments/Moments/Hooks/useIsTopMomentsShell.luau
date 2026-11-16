local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetMomentsShellStackStore = require(Moments.Stores.GetMomentsShellStackStore)

local function useIsTopMomentsShell(callback): boolean
	local momentsShellStackStore = GetMomentsShellStackStore(false)
	local state, setState = React.useState(nil)
	React.useLayoutEffect(function()
		if momentsShellStackStore.getTopShellId(false) ~= nil then
			callback("pushed")
		end

		local v, v2 = momentsShellStackStore.pushShell()
		setState(v)
		return function()
			if momentsShellStackStore.getTopShellId(false) == v then
				callback("popped")
			end

			v2()
		end
	end, { momentsShellStackStore, callback })
	local v = SignalsReact.useSignalState(momentsShellStackStore.getTopShellId)
	return state ~= nil and state == v
end

return useIsTopMomentsShell
