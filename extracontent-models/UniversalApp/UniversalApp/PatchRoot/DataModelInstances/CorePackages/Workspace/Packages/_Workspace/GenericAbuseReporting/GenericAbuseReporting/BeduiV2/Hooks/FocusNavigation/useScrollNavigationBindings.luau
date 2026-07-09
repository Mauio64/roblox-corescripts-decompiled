local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local InputHandlers = require(Parent.InputHandlers)
local React = require(Parent.React)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local scrollFrameUtils = require(script.Parent.scrollFrameUtils)
local useThumbstickScroll = require(script.Parent.useThumbstickScroll)
local t1 = {}
local t2 = {}
local t3 = {
	[Enum.KeyCode.PageUp] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.LeftBracket] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.PageDown] = FocusNavigationEventNameEnum.ScrollDown,
	[Enum.KeyCode.RightBracket] = FocusNavigationEventNameEnum.ScrollDown
}

local function scrollFocusedContainer(n1: number, p1) -- line: 35
	-- upvalues: scrollFrameUtils (copy), GuiService (copy)
	if p1 == nil then
		return
	end

	local v17 = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, p1)

	scrollFrameUtils.scrollByIncrement(v17, n1)
end
local function useScrollNavigationBindings(t4: {[any]: any}?) -- line: 47
	-- upvalues: React (copy), t3 (copy), t1 (copy), t2 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), scrollFrameUtils (copy), GuiService (copy), ReactFocusNavigation (copy), useThumbstickScroll (copy)
	local v19 = React.useRef(nil)
	local v20 = t4 == nil or (t4.includeDiscreteScroll == nil or t4.includeDiscreteScroll)
	local v21 = React.useMemo(function() -- line: 53
		-- upvalues: v20 (copy), t3 (copy), t1 (copy)
		if v20 then
			return t3
		end

		return t1
	end, { v20 })
	local v22 = React.useMemo(function() -- line: 57
		-- upvalues: v20 (copy), t2 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), scrollFrameUtils (copy), v19 (copy), GuiService (copy)
		if not v20 then
			return t2
		end

		return {
			[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_) -- line: 64
					-- upvalues: scrollFrameUtils (copy), v19 (copy), GuiService (copy)
					local SCROLL_INCREMENT = scrollFrameUtils.SCROLL_INCREMENT
					local current = v19.current

					if current == nil then
						return
					end

					local v28 = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, current)

					scrollFrameUtils.scrollByIncrement(v28, SCROLL_INCREMENT)
				end)
			},
			[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_) -- line: 69
					-- upvalues: scrollFrameUtils (copy), v19 (copy), GuiService (copy)
					local v30 = -scrollFrameUtils.SCROLL_INCREMENT
					local current = v19.current

					if current == nil then
						return
					end

					local v32 = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, current)

					scrollFrameUtils.scrollByIncrement(v32, v30)
				end)
			}
		}
	end, { v20 })
	local v23 = ReactFocusNavigation.useEventMap(v21, v19)
	local v24 = ReactFocusNavigation.useEventHandlerMap(v22, v23)

	useThumbstickScroll({
		enabled = true,
		containerRef = v19
	})

	return v24
end

return useScrollNavigationBindings
