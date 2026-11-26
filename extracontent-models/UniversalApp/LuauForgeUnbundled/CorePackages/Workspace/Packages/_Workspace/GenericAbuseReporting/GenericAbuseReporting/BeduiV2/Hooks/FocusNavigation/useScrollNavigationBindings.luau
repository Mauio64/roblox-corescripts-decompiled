local GuiService = game:GetService("GuiService")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactFocusNavigation")

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local scrollFrameUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/scrollFrameUtils")
local useThumbstickScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useThumbstickScroll")

local v5 = {}
local v6 = {}

local v7 = {
	[Enum.KeyCode.PageUp] = focusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.LeftBracket] = focusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.PageDown] = focusNavigationEventNameEnum.ScrollDown,
	[Enum.KeyCode.RightBracket] = focusNavigationEventNameEnum.ScrollDown
}

local function scrollFocusedContainer(p2, p3)
	if p3 == nil then
		return
	end

	local scrollTarget = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, p3)
	scrollFrameUtils.scrollByIncrement(scrollTarget, p2)
end

local function useScrollNavigationBindings(p2)
	local ref = React.useRef(nil)
	local v8 = p2 == nil or p2.includeDiscreteScroll == nil or p2.includeDiscreteScroll

	local v9 = React.useMemo(function()
		if v8 then
			return v7
		end

		return v5
	end, { v8 })

	local v10 = React.useMemo(function()
		if not v8 then
			return v6
		end

		return {
			[focusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(p3)
					local SCROLL_INCREMENT = scrollFrameUtils.SCROLL_INCREMENT
					local current = ref.current

					if current == nil then
						return
					end

					local scrollTarget = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, current)
					scrollFrameUtils.scrollByIncrement(scrollTarget, SCROLL_INCREMENT)
				end)
			},
			[focusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(p3)
					local v12 = -scrollFrameUtils.SCROLL_INCREMENT
					local current = ref.current

					if current == nil then
						return
					end

					local scrollTarget = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, current)
					scrollFrameUtils.scrollByIncrement(scrollTarget, v12)
				end)
			}
		}
	end, { v8 })

	local v11 = ReactFocusNavigation.useEventMap(v9, ref)
	local v12 = ReactFocusNavigation.useEventHandlerMap(v10, v11)

	useThumbstickScroll({ containerRef = ref, enabled = true })

	return v12
end

return useScrollNavigationBindings
