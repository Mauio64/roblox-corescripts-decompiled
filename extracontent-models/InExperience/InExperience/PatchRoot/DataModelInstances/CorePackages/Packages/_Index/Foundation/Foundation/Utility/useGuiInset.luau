local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Wrappers = require(Foundation.Utility.Wrappers)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local Connection = Wrappers.Connection
local instance = Wrappers.Instance
local Signal = Wrappers.Signal
local GuiService = Wrappers.Services.GuiService
local UserInputService = Wrappers.Services.UserInputService

local function getGuiInset()
	local guiInset, v = GuiService:GetGuiInset()

	return Rect.new(guiInset, v)
end

local function useGuiInset()
	local state, setState = React.useState(function()
		return getGuiInset()
	end)

	local v = React.useCallback(function()
		setState(getGuiInset())
	end, {})

	React.useEffect(function()
		local v2 = isPluginSecurity()
			and {
				Signal.Connect(GuiService.SafeZoneOffsetsChanged, v),
				Signal.Connect(instance.GetPropertyChangedSignal(UserInputService, "BottomBarSize"), v),
				Signal.Connect(instance.GetPropertyChangedSignal(UserInputService, "RightBarSize"), v)
			}
			or {}

		return function()
			for _, v3 in v2 do
				Connection.Disconnect(v3)
			end
		end
	end, {})

	return state
end

return useGuiInset
