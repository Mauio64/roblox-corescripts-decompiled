local module = require("@luauforge/bundled/gvb")
local module2 = require("@luauforge/bundled/gwM")
local module3 = require("@luauforge/bundled/gwN")

local function useWizardViewportLayout()
	local v5 = module2.useDeviceInsets()
	local state, setState = module.useState(nil)
	local v6 = module.useCallback(function(p2)
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

	local fullscreenGui = module2.HardwareSafeAreaInsets.fullscreenGui()
	local rect = Rect.new(
		fullscreenGui.AbsolutePosition,
		fullscreenGui.AbsolutePosition + fullscreenGui.AbsoluteSize
	)

	return if state and state.Width > 0 and state.Height > 0 then module3(state, rect, v5) else nil, v6
end

return useWizardViewportLayout
