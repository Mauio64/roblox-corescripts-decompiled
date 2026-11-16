local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Display = require(parent.Display)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function FullscreenFrame(options, ref)
	local v = useSelector(function(p)
		return p.GlobalGuiInset
	end)

	local v2 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	local joined = Cryo.Dictionary.join({
		Position = UDim2.new(0, -v.left - v2.left, 0, -v.top - v2.top),
		Size = UDim2.new(1, v.left + v.right + v2.left + v2.right, 1, v.top + v.bottom + v2.top + v2.bottom),
		BackgroundTransparency = 1,
		ref = ref
	}, options or {})

	return React.createElement("Frame", joined)
end

return React.forwardRef(FullscreenFrame)
