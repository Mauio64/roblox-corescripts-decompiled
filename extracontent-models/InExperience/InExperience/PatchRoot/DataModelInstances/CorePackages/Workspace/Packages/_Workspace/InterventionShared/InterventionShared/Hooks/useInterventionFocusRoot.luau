local Parent = script:FindFirstAncestor("InterventionShared").Parent
local useMemo = require(Parent.React).useMemo
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(Parent.InputHandlers)
local useFocusedGuiObject = require(Parent.ReactFocusNavigation).useFocusedGuiObject
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.PageUp] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.LeftBracket] = FocusNavigationEventNameEnum.ScrollUp,
	[Enum.KeyCode.PageDown] = FocusNavigationEventNameEnum.ScrollDown,
	[Enum.KeyCode.RightBracket] = FocusNavigationEventNameEnum.ScrollDown
}

local function getScrollableAncestor(p1) -- line: 31
	if p1 == nil then
		return nil
	end

	if p1:IsA("ScrollingFrame") then
		return p1
	end

	return p1:FindFirstAncestorWhichIsA("ScrollingFrame")
end
local function scrollTo(p2, n1: number) -- line: 44
	if p2 ~= nil then
		local v15 = p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y

		if n1 > 0 and p2.CanvasPosition.Y >= v15 - 350 then
			p2.CanvasPosition = Vector2.new(0, v15)

			return
		end

		if n1 < 0 and p2.CanvasPosition.Y <= 350 then
			p2.CanvasPosition = Vector2.new(0, 0)

			return
		end

		p2.CanvasPosition = p2.CanvasPosition + Vector2.new(0, n1)
	end
end
local function useInterventionFocusRoot(t2: {[any]: any}) -- line: 73
	-- upvalues: useFocusedGuiObject (copy), useMemo (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useFocusRoot (copy), t1 (copy)
	local v17 = useFocusedGuiObject()
	local v18 = if v17 ~= nil then if not v17:IsA("ScrollingFrame") then v17:FindFirstAncestorWhichIsA("ScrollingFrame") else v17 else nil
	local v19 = useMemo(function() -- line: 77
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v18 (copy)
		local t3 = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onPress(function(p3) -- line: 80
					p3:cancel()
				end)
			}
		}

		if v18 then
			t3[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_) -- line: 88
					-- upvalues: v18 (copy)
					local v23 = v18

					if v23 ~= nil then
						local v24 = v23.AbsoluteCanvasSize.Y - v23.AbsoluteWindowSize.Y

						if v23.CanvasPosition.Y >= v24 - 350 then
							v23.CanvasPosition = Vector2.new(0, v24)

							return
						end

						v23.CanvasPosition = v23.CanvasPosition + Vector2.new(0, 300)
					end
				end)
			}
			t3[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_) -- line: 93
					-- upvalues: v18 (copy)
					local v26 = v18

					if v26 ~= nil then
						local _ = v26.AbsoluteCanvasSize.Y - v26.AbsoluteWindowSize.Y

						if v26.CanvasPosition.Y <= 350 then
							v26.CanvasPosition = Vector2.new(0, 0)

							return
						end

						v26.CanvasPosition = v26.CanvasPosition + Vector2.new(0, -300)
					end
				end)
			}
		end

		return t3
	end, { v18 })

	return useFocusRoot({
		surfaceIdentifier = t2.surfaceIdentifier,
		isAutoFocusRoot = t2.isAutoFocusRoot == nil or t2.isAutoFocusRoot,
		eventMap = t1,
		eventHandlers = v19
	})
end

return useInterventionFocusRoot
