local parent = script.Parent.Parent.Parent

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local useEventConnection = ReactUtils.useEventConnection

local function fn() -- 2 equivalent calls inferred from this helper
	local guiInset, v = GuiService:GetGuiInset()
	return { bottom = v.Y, left = guiInset.X, right = v.X, top = guiInset.Y }
end

return function()
	local state, setState = React.useState(fn()) -- inferred equivalent call

	local function fn2()
		setState(fn()) -- inferred equivalent call
	end

	useEventConnection(GuiService.SafeZoneOffsetsChanged, fn2)
	useEventConnection(UserInputService:GetPropertyChangedSignal("BottomBarSize"), fn2)
	useEventConnection(UserInputService:GetPropertyChangedSignal("RightBarSize"), fn2)

	return state
end
