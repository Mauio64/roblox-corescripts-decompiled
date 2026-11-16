local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/ReactFocusNavigation")

local defineFastFlag = game:DefineFastFlag("InlineSurveyFocusRoot", false)

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject

local v5 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.PageUp] = focusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.LeftBracket] = focusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.PageDown] = focusNavigationEventNameEnum.ScrollDown,
	[Enum.KeyCode.RightBracket] = focusNavigationEventNameEnum.ScrollDown
}

local function getScrollableAncestor(scrollingFrame)
	if scrollingFrame == nil then
		return nil
	end

	if scrollingFrame:IsA("ScrollingFrame") then
		return scrollingFrame
	end

	return scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
end

local function scrollTo(state, p2)
	local v6 = state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y

	if p2 > 0 then
		local y = state.CanvasPosition.Y

		if v6 - 350 <= y then
			state.CanvasPosition = Vector2.new(0, v6)
			return
		end
	end

	if p2 < 0 and state.CanvasPosition.Y <= 350 then
		state.CanvasPosition = Vector2.new(0, 0)
	else
		state.CanvasPosition += Vector2.new(0, p2)
	end
end

local function mergeRefs(callback, callback2)
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

local function useSurveyFocusRefs(p2, p3)
	local v6 = useDefaultFocusBehavior()
	local v7

	if defineFastFlag then
		local scrollingFrame = useFocusedGuiObject()

		if scrollingFrame == nil then
			scrollingFrame = nil
		elseif not scrollingFrame:IsA("ScrollingFrame") then
			scrollingFrame = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
		end

		v7 = useFocusRoot({
			surfaceIdentifier = p2,
			eventHandlers = React.useMemo(function()
				local v9 = {
					[focusNavigationEventNameEnum.NavigateBack] = {
						handler = InputHandlers.onRelease(p3)
					}
				}

				if scrollingFrame then
					v9[focusNavigationEventNameEnum.ScrollUp] = {
						handler = InputHandlers.onRelease(function()
							local v10 = scrollingFrame
							local v11 = v10.AbsoluteCanvasSize.Y - v10.AbsoluteWindowSize.Y

							if v10.CanvasPosition.Y <= 350 then
								v10.CanvasPosition = Vector2.new(0, 0)
							else
								v10.CanvasPosition += Vector2.new(0, -300)
							end
						end)
					}

					v9[focusNavigationEventNameEnum.ScrollDown] = {
						handler = InputHandlers.onRelease(function()
							local v10 = scrollingFrame
							local v11 = v10.AbsoluteCanvasSize.Y - v10.AbsoluteWindowSize.Y

							local y = v10.CanvasPosition.Y

							if v11 - 350 <= y then
								v10.CanvasPosition = Vector2.new(0, v11)
							else
								v10.CanvasPosition += Vector2.new(0, 300)
							end
						end)
					}
				end

				return v9
			end, { scrollingFrame, p3 }),
			eventMap = v5,
			isAutoFocusRoot = true
		})
	else
		v7 = useAppFocusRoot({
			surfaceIdentifier = p2,
			customEventHandlers = {
				[focusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(p3)
				}
			},
			isAutoFocusRoot = true
		})
	end

	return React.useMemo(function()
		local v8 = v7
		local v9 = v6
		return function(current)
			if type(v8) == "function" then
				v8(current)
			elseif v8 ~= nil then
				v8.current = current
			end

			if type(v9) == "function" then
				v9(current)
			elseif v9 ~= nil then
				v9.current = current
			end
		end
	end, { v7, v6 })
end

return useSurveyFocusRefs
