local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local React = require(FocusNavigationUtilsParent.React)
local ReactFocusNavigation = require(FocusNavigationUtilsParent.ReactFocusNavigation)
local InputHandlers = require(FocusNavigationUtilsParent.InputHandlers)
local useNavigation = require(FocusNavigationUtilsParent.Navigation).useNavigation
local useSelector = require(FocusNavigationUtilsParent.RoactUtils).Hooks.RoactRodux.useSelector
local canGoBack = require(FocusNavigationUtilsParent.Navigation).canGoBack
local FocusNavigationEventNameEnum = require(FocusNavigationUtils.FocusNavigationEventNameEnum)
local useFocusRegistryEntry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry).useFocusRegistryEntry
local FocusNavigableSurfaceIdentifierEnum = require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local useRegistryEntry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry).useRegistryEntry

local function getScrollableAncestor(p1) -- line: 21
	if p1 == nil then
		return nil
	end

	if p1:IsA("ScrollingFrame") then
		return p1
	end

	return p1:FindFirstAncestorWhichIsA("ScrollingFrame")
end
local function scrollTo(p2, n1: number) -- line: 32
	if p2 ~= nil then
		local v19 = p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y

		if n1 > 0 and p2.CanvasPosition.Y >= v19 - 350 then
			p2.CanvasPosition = Vector2.new(0, v19)

			return
		end

		if n1 < 0 and p2.CanvasPosition.Y <= 350 then
			p2.CanvasPosition = Vector2.new(0, 0)

			return
		end

		p2.CanvasPosition = p2.CanvasPosition + Vector2.new(0, n1)
	end
end

function useDefaultAppEventHandlers() -- line: 51
	-- upvalues: useNavigation (copy), useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFocusRegistryEntry (copy), useDescendantHasFocus (copy), useSelector (copy), ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), canGoBack (copy)
	local v20 = useNavigation()
	local v21 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v22 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v23 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v24 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v25 = useDescendantHasFocus(v24)
	local v26 = useSelector(function(p3) -- line: 58
		return p3.TabBarVisible
	end)
	local v27 = ReactFocusNavigation.useFocusedGuiObject()
	local v28 = if v27 ~= nil then if not v27:IsA("ScrollingFrame") then v27:FindFirstAncestorWhichIsA("ScrollingFrame") else v27 else nil
	local v29 = v28 ~= nil

	return (React.useMemo(function() -- line: 66
		-- upvalues: v25 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), canGoBack (copy), v20 (copy), v26 (copy), v23 (copy), v22 (copy), v21 (copy), v29 (copy), v28 (copy)
		local t1 = {}

		if not v25 then
			t1[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(_) -- line: 71
					-- upvalues: canGoBack (copy), v20 (copy), v26 (copy), v23 (copy)
					if canGoBack(v20) then
						v20.goBack(false)

						return
					end

					if v26 then
						v23()
					end
				end)
			}
		end

		if v22 and v21 ~= nil then
			t1[FocusNavigationEventNameEnum.Search] = {
				handler = InputHandlers.onRelease(function(_) -- line: 83
					-- upvalues: v22 (copy), v21 (copy)
					v22()

					if v21 ~= nil then
						local v34 = if not v21:IsA("TextBox") then v21:FindFirstChildWhichIsA("TextBox", true) else v21

						if v34 then
							v34:CaptureFocus()
						end
					end
				end)
			}
		end

		if v29 then
			t1[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_) -- line: 100
					-- upvalues: v28 (copy)
					local v36 = v28

					if v36 ~= nil then
						local v37 = v36.AbsoluteCanvasSize.Y - v36.AbsoluteWindowSize.Y

						if v36.CanvasPosition.Y >= v37 - 350 then
							v36.CanvasPosition = Vector2.new(0, v37)

							return
						end

						v36.CanvasPosition = v36.CanvasPosition + Vector2.new(0, 300)
					end
				end)
			}
			t1[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_) -- line: 105
					-- upvalues: v28 (copy)
					local v39 = v28

					if v39 ~= nil then
						local _ = v39.AbsoluteCanvasSize.Y - v39.AbsoluteWindowSize.Y

						if v39.CanvasPosition.Y <= 350 then
							v39.CanvasPosition = Vector2.new(0, 0)

							return
						end

						v39.CanvasPosition = v39.CanvasPosition + Vector2.new(0, -300)
					end
				end)
			}
		end

		return t1
	end, {
		v20,
		v21,
		v22,
		v23,
		v25,
		v26,
		v29
	}))
end

return useDefaultAppEventHandlers
