local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local getAvatarSettingsStore = require("@luauforge/bundled/dPt").Stores.getAvatarSettingsStore

local module = require("@luauforge/deferred/hiu")
require("@luauforge/bundled/dKT")

local function useUpperAdjustmentLimitsWithSignals()
	local v5 = useSignalState(getAvatarSettingsStore(false).getAccessoryRefinementUpperBounds)
	return useSelector((React.useCallback(function(p2)
		return module(p2, v5)
	end, { v5 })))
end

return useUpperAdjustmentLimitsWithSignals
