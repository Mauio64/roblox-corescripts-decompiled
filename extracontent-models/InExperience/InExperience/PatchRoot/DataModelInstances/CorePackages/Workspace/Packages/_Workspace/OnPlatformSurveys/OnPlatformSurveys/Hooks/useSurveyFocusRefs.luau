local parent = script:FindFirstAncestor("OnPlatformSurveys").Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local defineFastFlag = game:DefineFastFlag("InlineSurveyFocusRoot", false)

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject

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

local function mergeRefs(callback, callback2) -- 1 equivalent call inferred from this helper
	return function(current)
		if type(callback) == "function" then
			callback(current)
		elseif callback ~= nil then
			callback.current = current
		end

		if type(callback2) == "function" then
			callback2(current)
		elseif callback2 ~= nil then
			callback2.current = current
		end
	end
end

local function useSurveyFocusRefs(surfaceIdentifier, callback)
	local v = useDefaultFocusBehavior()
	local v2

	if defineFastFlag then
		local scrollableAncestor = getScrollableAncestor(useFocusedGuiObject()) -- inferred equivalent call

		v2 = useFocusRoot({
			surfaceIdentifier = surfaceIdentifier,
			eventHandlers = React.useMemo(function()
				local v3 = {
					[FocusNavigationEventNameEnum.NavigateBack] = {
						handler = InputHandlers.onRelease(callback)
					}
				}

				if scrollableAncestor then
					v3[FocusNavigationEventNameEnum.ScrollUp] = {
						handler = InputHandlers.onRelease(function()
							local v4 = scrollableAncestor
							local _ = v4.AbsoluteCanvasSize.Y - v4.AbsoluteWindowSize.Y

							if v4.CanvasPosition.Y <= 350 then
								v4.CanvasPosition = Vector2.new(0, 0)
							else
								v4.CanvasPosition += Vector2.new(0, -300)
							end
						end)
					}

					v3[FocusNavigationEventNameEnum.ScrollDown] = {
						handler = InputHandlers.onRelease(function()
							local v4 = scrollableAncestor
							local v5 = v4.AbsoluteCanvasSize.Y - v4.AbsoluteWindowSize.Y

							local y = v4.CanvasPosition.Y

							if v5 - 350 <= y then
								v4.CanvasPosition = Vector2.new(0, v5)
							else
								v4.CanvasPosition += Vector2.new(0, 300)
							end
						end)
					}
				end

				return v3
			end, { scrollableAncestor, callback }),
			eventMap = eventMap,
			isAutoFocusRoot = true
		})
	else
		v2 = useAppFocusRoot({
			surfaceIdentifier = surfaceIdentifier,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(callback)
				}
			},
			isAutoFocusRoot = true
		})
	end

	return React.useMemo(function()
		return mergeRefs(v2, v) -- inferred equivalent call
	end, { v2, v })
end

return useSurveyFocusRefs
