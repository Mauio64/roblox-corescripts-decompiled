local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Wrappers = require(Foundation.Utility.Wrappers)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local Connection = Wrappers.Connection
local Instance = Wrappers.Instance
local Signal = Wrappers.Signal
local GuiService = Wrappers.Services.GuiService
local UserInputService = Wrappers.Services.UserInputService

local function getGuiInset() -- line: 14
	-- upvalues: GuiService (copy)
	local v13, v14 = GuiService:GetGuiInset()

	return Rect.new(v13, v14)
end
local function useGuiInset() -- line: 20
	-- upvalues: React (copy), getGuiInset (copy), isPluginSecurity (copy), Signal (copy), GuiService (copy), Instance (copy), UserInputService (copy), Connection (copy)
	local v15, v16 = React.useState(function() -- line: 21
		-- upvalues: getGuiInset (copy)
		return getGuiInset()
	end)
	local v17 = React.useCallback(function() -- line: 25
		-- upvalues: v16 (copy), getGuiInset (copy)
		v16(getGuiInset())
	end, {})

	React.useEffect(function() -- line: 29
		-- upvalues: isPluginSecurity (copy), Signal (copy), GuiService (copy), v17 (copy), Instance (copy), UserInputService (copy), Connection (copy)
		local t1 = {}

		if isPluginSecurity() then
			t1 = {
				Signal.Connect(GuiService.SafeZoneOffsetsChanged, v17),
				Signal.Connect(Instance.GetPropertyChangedSignal(UserInputService, "BottomBarSize"), v17),
				Signal.Connect(Instance.GetPropertyChangedSignal(UserInputService, "RightBarSize"), v17)
			}
		end

		return function() -- line: 40
			-- upvalues: t1 (ref), Connection (copy)
			for _, v20 in t1 do
				Connection.Disconnect(v20)
			end
		end
	end, {})

	return v15
end

return useGuiInset
