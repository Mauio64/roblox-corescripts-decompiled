local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local openProfileQRCodePageBridge = require("@luauforge/bundled/hTS").OpenProfileQRCodePageBridge
local module = require("@luauforge/bundled/eeD")

local function SduiOpenProfileQRCodePageReceiver(): nil
	local v5 = useDispatch()

	React.useEffect(function()
		local v6 = openProfileQRCodePageBridge.subscribe(function(p2)
			v5(module(p2))
		end)

		return function()
			v6:disconnect()
		end
	end, { v5 })

	return nil
end

return SduiOpenProfileQRCodePageReceiver
