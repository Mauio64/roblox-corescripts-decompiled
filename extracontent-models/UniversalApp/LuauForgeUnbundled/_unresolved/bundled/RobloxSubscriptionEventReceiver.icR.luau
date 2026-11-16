local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/eeH")
local module2 = require("@luauforge/bundled/eda")

local module3 = require("@luauforge/bundled/fzr")

local function RobloxSubscriptionEventReceiver(): nil
	if not game:GetEngineFeature("ReadHasRobloxSubscriptionLua") then
		return nil
	end

	local v5 = useDispatch()
	local v6 = module(module2)

	local v8 = useSignalState(module3.RobloxSubscriptionSignals.get().getHasRobloxSubscription)

	local ref = React.useRef(nil)

	React.useEffect(function()
		local current = ref.current
		ref.current = v8

		local v9 = current == false and v8 == true

		if v9 then
			v5(require("@luauforge/bundled/icS")(v6))
		end
	end, { v8, v5, v6 })

	return nil
end

return RobloxSubscriptionEventReceiver
