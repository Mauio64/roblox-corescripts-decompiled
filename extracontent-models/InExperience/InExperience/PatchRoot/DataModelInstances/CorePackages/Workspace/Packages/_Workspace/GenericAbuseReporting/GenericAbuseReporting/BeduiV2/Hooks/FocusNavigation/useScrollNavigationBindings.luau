local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local scrollFrameUtils = require(script.Parent.scrollFrameUtils)
local useThumbstickScroll = require(script.Parent.useThumbstickScroll)

local v = {}
local v2 = {}

local v3 = {
	[Enum.KeyCode.PageUp] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.LeftBracket] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.PageDown] = FocusNavigationEventNameEnum.ScrollDown,
	[Enum.KeyCode.RightBracket] = FocusNavigationEventNameEnum.ScrollDown
}

local function scrollFocusedContainer(p: number, current) -- 2 equivalent calls inferred from this helper
	if current == nil then
		return
	end

	local scrollTarget = scrollFrameUtils.resolveScrollTarget(GuiService.SelectedCoreObject, current)
	scrollFrameUtils.scrollByIncrement(scrollTarget, p)
end

local function useScrollNavigationBindings(p)
	local ref = React.useRef(nil)
	local v4 = p == nil or p.includeDiscreteScroll == nil or p.includeDiscreteScroll

	local v5 = React.useMemo(function()
		return if v4 then v3 else v
	end, { v4 })

	local v6 = React.useMemo(function()
		if not v4 then
			return v2
		end

		return {
			[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_)
					scrollFocusedContainer(scrollFrameUtils.SCROLL_INCREMENT, ref.current) -- inferred equivalent call
				end)
			},
			[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_)
					scrollFocusedContainer(-scrollFrameUtils.SCROLL_INCREMENT, ref.current) -- inferred equivalent call
				end)
			}
		}
	end, { v4 })

	local v7 = ReactFocusNavigation.useEventMap(v5, ref)
	local v8 = ReactFocusNavigation.useEventHandlerMap(v6, v7)

	useThumbstickScroll({ containerRef = ref, enabled = true })

	return v8
end

return useScrollNavigationBindings
