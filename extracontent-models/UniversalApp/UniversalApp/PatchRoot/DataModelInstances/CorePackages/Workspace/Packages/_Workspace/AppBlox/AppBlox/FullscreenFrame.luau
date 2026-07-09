local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Display = require(Parent.Display)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(Parent.SignalsReact).useSignalState

local function FullscreenFrame(p1, p2) -- line: 10
	-- upvalues: useSelector (copy), useSignalState (copy), Display (copy), Cryo (copy), React (copy)
	local v10 = useSelector(function(p3) -- line: 11
		return p3.GlobalGuiInset
	end)
	local v11 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)
	local v12 = Cryo.Dictionary.join({
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -v10.left - v11.left, 0, -v10.top - v11.top),
		Size = UDim2.new(1, v10.left + v10.right + v11.left + v11.right, 1, v10.top + v10.bottom + v11.top + v11.bottom),
		ref = p2
	}, p1 or {})

	return React.createElement("Frame", v12)
end

return React.forwardRef(FullscreenFrame)
