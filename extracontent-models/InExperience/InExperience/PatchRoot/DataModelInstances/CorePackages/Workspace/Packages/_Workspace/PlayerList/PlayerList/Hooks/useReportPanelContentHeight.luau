local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local PanelContentHeightStore = require(parent.Common.PanelContentHeightStore)

local function useReportPanelContentHeight(p: number)
	local ref = React.useRef(nil)

	return React.useCallback(function(instance)
		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end

		if instance == nil then
			return
		end

		local function report() -- 1 equivalent call inferred from this helper
			local uiListLayout = instance:FindFirstChildOfClass("UIListLayout")

			if uiListLayout then
				local y = uiListLayout.AbsoluteContentSize.Y
				instance.CanvasSize = UDim2.new(0, 0, 0, y)
				PanelContentHeightStore.setBodyContentHeight(p + y)
			end
		end

		local uiListLayout = instance:FindFirstChildOfClass("UIListLayout")

		if uiListLayout then
			ref.current = uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(report)
		end

		report() -- inferred equivalent call
	end, { p })
end

return useReportPanelContentHeight
