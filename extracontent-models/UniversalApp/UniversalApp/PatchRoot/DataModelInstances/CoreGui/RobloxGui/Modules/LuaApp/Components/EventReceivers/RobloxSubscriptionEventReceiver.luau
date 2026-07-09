local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSignalState = SignalsReact.useSignalState
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RobloxSubscriptionPurchaseApp = require(CorePackages.Workspace.Packages.RobloxSubscriptionPurchaseApp)

local function RobloxSubscriptionEventReceiver() -- line: 22
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), RobloxSubscriptionPurchaseApp (copy), useSignalState (copy), React (copy), Modules (copy)
	if not game:GetEngineFeature("ReadHasRobloxSubscriptionLua") then
		return nil
	end

	local v12 = useDispatch()
	local v13 = useRoactService(RoactNetworking)
	local v14 = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals.get()
	local v15 = useSignalState(v14.getHasRobloxSubscription)
	local v16 = React.useRef(nil)

	React.useEffect(function() -- line: 35
		-- upvalues: v16 (copy), v15 (copy), Modules (copy), v12 (copy), v13 (copy)
		local current = v16.current

		v16.current = v15

		if current == false and v15 == true then
			local FetchAllExperienceStoreProducts = require(Modules.LuaApp.Thunks.Economy.FetchAllExperienceStoreProducts)

			v12(FetchAllExperienceStoreProducts(v13))
		end
	end, {
		v15,
		v12,
		v13
	})

	return nil
end

return RobloxSubscriptionEventReceiver
