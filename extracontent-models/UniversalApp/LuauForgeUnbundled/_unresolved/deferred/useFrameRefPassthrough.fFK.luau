local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local module = require("@luauforge/deferred/fEI")
local module2 = require("@luauforge/deferred/fFL")
local module3 = require("@luauforge/deferred/fFM")

local v5 = {
	[Enum.KeyCode.Escape] = "NavigateBack",
	[Enum.KeyCode.ButtonB] = "NavigateBack",
	[Enum.KeyCode.ButtonY] = "Search",
	[Enum.KeyCode.Slash] = "Search",
	[Enum.KeyCode.PageUp] = "ScrollUp",
	[Enum.KeyCode.PageDown] = "ScrollDown",
	[Enum.KeyCode.LeftBracket] = "ScrollUp",
	[Enum.KeyCode.RightBracket] = "ScrollDown"
}

local function useUAHotkeySuppressionImpl(p2, p3, p4)
	local v6 = module2.useEventMap(v5, p2)
	local v7 = module.useMemo(function()
		local result = {}

		for k, v8 in v5 do
			result[v8] = {
				handler = function(p5)
					p5.cancelled = true
				end
			}
		end

		return result
	end, {})
	local v8 = module2.useEventHandlerMap(v7, v6)

	module.useEffect(function()
		if not p4 then
			return
		end

		local current = p3.current
		local current2 = p2.current

		if not (current and current2) then
			return
		end

		current2.SelectionGroup = true
		current2.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		current2.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		current2.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
		current2.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

		local selectedCoreObject = GuiService.SelectedCoreObject

		if current:IsDescendantOf(CoreGui) then
			GuiService.SelectedCoreObject = current
		end

		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
			if GuiService.SelectedCoreObject == nil and current:IsDescendantOf(CoreGui) then
				GuiService.SelectedCoreObject = current
			end
		end)

		return function()
			selectedCoreObjectChangedConnection:Disconnect()

			if GuiService.SelectedCoreObject == current then
				if selectedCoreObject and selectedCoreObject:IsDescendantOf(CoreGui) then
					GuiService.SelectedCoreObject = selectedCoreObject
				else
					GuiService.SelectedCoreObject = nil
				end
			end
		end
	end, { p4 })

	return v8
end

local function useFrameRefPassthrough(p2, p3, p4)
	return p2
end

if module3 then
	return useUAHotkeySuppressionImpl
end

return useFrameRefPassthrough
