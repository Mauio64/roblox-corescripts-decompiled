local useMemo = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React").useMemo

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/FocusNavigationUtils")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InputHandlers")
local useFocusedGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/ReactFocusNavigation").useFocusedGuiObject
local useFocusRoot = FocusNavigationUtils.useFocusRoot

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
	if state ~= nil then
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
end

local function useInterventionFocusRoot(p2)
	local scrollingFrame = useFocusedGuiObject()

	if scrollingFrame == nil then
		scrollingFrame = nil
	elseif not scrollingFrame:IsA("ScrollingFrame") then
		scrollingFrame = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
	end

	local v6 = useMemo(function()
		local v7 = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onPress(function(object)
					object:cancel()
				end)
			}
		}

		if scrollingFrame then
			v7[focusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(p3)
					local v8 = scrollingFrame

					if v8 ~= nil then
						local v9 = v8.AbsoluteCanvasSize.Y - v8.AbsoluteWindowSize.Y

						local y = v8.CanvasPosition.Y

						if v9 - 350 <= y then
							v8.CanvasPosition = Vector2.new(0, v9)
						else
							v8.CanvasPosition += Vector2.new(0, 300)
						end
					end
				end)
			}

			v7[focusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(p3)
					local v8 = scrollingFrame

					if v8 ~= nil then
						local v9 = v8.AbsoluteCanvasSize.Y - v8.AbsoluteWindowSize.Y

						if v8.CanvasPosition.Y <= 350 then
							v8.CanvasPosition = Vector2.new(0, 0)
						else
							v8.CanvasPosition += Vector2.new(0, -300)
						end
					end
				end)
			}
		end

		return v7
	end, { scrollingFrame })

	return useFocusRoot({
		surfaceIdentifier = p2.surfaceIdentifier,
		isAutoFocusRoot = p2.isAutoFocusRoot == nil or p2.isAutoFocusRoot,
		eventMap = v5,
		eventHandlers = v6
	})
end

return useInterventionFocusRoot
