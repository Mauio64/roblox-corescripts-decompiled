local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local pymkNavigationBridge = require("@luauforge/bundled/hTS").PymkNavigationBridge
local module = require("@luauforge/bundled/edM")
local module2 = require("@luauforge/bundled/ftX")

local function SduiPymkNavigationReceiver(): nil
	local v5 = useDispatch()

	React.useEffect(function()
		local v6 = pymkNavigationBridge.subscribeOpenProfile(function(p2)
			v5(module(p2.userId, {
				profilePeekViewProps = Cryo.Dictionary.join({ resetPeekView = true }, p2.extraProps or {})
			}))
		end)
		local v7 = pymkNavigationBridge.subscribeOpenAddFriends(function()
			v5(module2())
		end)

		return function()
			v6:disconnect()
			v7:disconnect()
		end
	end, { v5 })

	return nil
end

return SduiPymkNavigationReceiver
