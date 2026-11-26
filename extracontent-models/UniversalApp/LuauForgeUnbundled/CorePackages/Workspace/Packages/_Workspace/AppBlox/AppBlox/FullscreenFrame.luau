local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Display")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SignalsReact").useSignalState

local function FullscreenFrame(options, p2)
	local v5 = useSelector(function(p3)
		return p3.GlobalGuiInset
	end)

	local v6 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	local joined = Cryo.Dictionary.join({
		Position = UDim2.new(0, -v5.left - v6.left, 0, -v5.top - v6.top),
		Size = UDim2.new(
			1,
			v5.left + v5.right + v6.left + v6.right,
			1,
			v5.top + v5.bottom + v6.top + v6.bottom
		),
		BackgroundTransparency = 1,
		ref = p2
	}, options or {})

	return React.createElement("Frame", joined)
end

return React.forwardRef(FullscreenFrame)
