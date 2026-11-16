local parent = script:FindFirstAncestor("InterventionShared").Parent

local React = require(parent.React)
local useMemo = React.useMemo

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local eventMap = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.PageUp] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.LeftBracket] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.PageDown] = FocusNavigationEventNameEnum.ScrollDown,
	[Enum.KeyCode.RightBracket] = FocusNavigationEventNameEnum.ScrollDown
}

local function getScrollableAncestor(scrollingFrame) -- 1 equivalent call inferred from this helper
	if scrollingFrame == nil then
		return nil
	end

	if scrollingFrame:IsA("ScrollingFrame") then
		return scrollingFrame
	end

	return scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
end

local function scrollTo(state, p: number)
	if state ~= nil then
		local v = state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y

		if p > 0 then
			local y = state.CanvasPosition.Y

			if v - 350 <= y then
				state.CanvasPosition = Vector2.new(0, v)
				return
			end
		end

		if p < 0 and state.CanvasPosition.Y <= 350 then
			state.CanvasPosition = Vector2.new(0, 0)
		else
			state.CanvasPosition += Vector2.new(0, p)
		end
	end
end

local function useInterventionFocusRoot(p)
	local scrollableAncestor = getScrollableAncestor(useFocusedGuiObject()) -- inferred equivalent call

	local eventHandlers = useMemo(function()
		local v = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onPress(function(object)
					object:cancel()
				end)
			}
		}

		if scrollableAncestor then
			v[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_)
					local v2 = scrollableAncestor

					if v2 ~= nil then
						local v3 = v2.AbsoluteCanvasSize.Y - v2.AbsoluteWindowSize.Y

						local y = v2.CanvasPosition.Y

						if v3 - 350 <= y then
							v2.CanvasPosition = Vector2.new(0, v3)
						else
							v2.CanvasPosition += Vector2.new(0, 300)
						end
					end
				end)
			}

			v[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_)
					local v2 = scrollableAncestor

					if v2 ~= nil then
						local _ = v2.AbsoluteCanvasSize.Y - v2.AbsoluteWindowSize.Y

						if v2.CanvasPosition.Y <= 350 then
							v2.CanvasPosition = Vector2.new(0, 0)
						else
							v2.CanvasPosition += Vector2.new(0, -300)
						end
					end
				end)
			}
		end

		return v
	end, { scrollableAncestor })

	return useFocusRoot({
		surfaceIdentifier = p.surfaceIdentifier,
		isAutoFocusRoot = p.isAutoFocusRoot == nil or p.isAutoFocusRoot,
		eventMap = eventMap,
		eventHandlers = eventHandlers
	})
end

return useInterventionFocusRoot
