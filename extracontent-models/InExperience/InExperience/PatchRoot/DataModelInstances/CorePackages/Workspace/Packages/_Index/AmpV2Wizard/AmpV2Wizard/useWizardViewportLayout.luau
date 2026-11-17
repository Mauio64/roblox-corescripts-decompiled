local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Responsive = require(parent2.Responsive)
local getWizardViewportLayout = require(parent.getWizardViewportLayout)

local function useWizardViewportLayout()
	local v = Responsive.useDeviceInsets()
	local state, setState = React.useState(nil)
	local v2 = React.useCallback(function(p)
		if p == nil then
			return
		end

		local rect = Rect.new(p.AbsolutePosition, p.AbsolutePosition + p.AbsoluteSize)
		setState(function(rect2: Rect?)
			return if rect2 == rect then rect2 else rect
		end)
	end, {})

	local fullscreenGui = Responsive.HardwareSafeAreaInsets.fullscreenGui()
	local rect = Rect.new(fullscreenGui.AbsolutePosition, fullscreenGui.AbsolutePosition + fullscreenGui.AbsoluteSize)
	local v3

	if state and state.Width > 0 and state.Height > 0 then
		v3 = getWizardViewportLayout(state, rect, v)
	end

	return v3, v2
end

return useWizardViewportLayout
