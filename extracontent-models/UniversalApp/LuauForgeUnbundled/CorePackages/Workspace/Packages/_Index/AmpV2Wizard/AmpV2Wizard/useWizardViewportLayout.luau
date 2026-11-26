local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Responsive")
local getWizardViewportLayout = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/getWizardViewportLayout")

local function useWizardViewportLayout()
	local v5 = Responsive.useDeviceInsets()
	local state, setState = React.useState(nil)
	local v6 = React.useCallback(function(p2)
		if p2 == nil then
			return
		end

		local rect = Rect.new(p2.AbsolutePosition, p2.AbsolutePosition + p2.AbsoluteSize)
		setState(function(p3)
			if p3 == rect then
				return p3
			end

			return rect
		end)
	end, {})

	local fullscreenGui = Responsive.HardwareSafeAreaInsets.fullscreenGui()
	local rect = Rect.new(
		fullscreenGui.AbsolutePosition,
		fullscreenGui.AbsolutePosition + fullscreenGui.AbsoluteSize
	)

	return if state and state.Width > 0 and state.Height > 0 then getWizardViewportLayout(state, rect, v5) else nil, v6
end

return useWizardViewportLayout
