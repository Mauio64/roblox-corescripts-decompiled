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
local FocusNavigationDefaultEventMap = require(FocusNavigationUtils.FocusNavigationDefaultEventMap)

local function getScrollableAncestor(p1) -- line: 23
	if p1 == nil then
		return nil
	end

	if p1:IsA("ScrollingFrame") then
		return p1
	end

	return p1:FindFirstAncestorWhichIsA("ScrollingFrame")
end
local function scrollTo(p2, n1: number) -- line: 34
	if p2 ~= nil then
		local v20 = p2.AbsoluteCanvasSize.Y - p2.AbsoluteWindowSize.Y

		if n1 > 0 and p2.CanvasPosition.Y >= v20 - 350 then
			p2.CanvasPosition = Vector2.new(0, v20)

			return
		end

		if n1 < 0 and p2.CanvasPosition.Y <= 350 then
			p2.CanvasPosition = Vector2.new(0, 0)

			return
		end

		p2.CanvasPosition = p2.CanvasPosition + Vector2.new(0, n1)
	end
end

function useDefaultFocusNavigationBindings(p3) -- line: 53
	-- upvalues: useNavigation (copy), useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFocusRegistryEntry (copy), useDescendantHasFocus (copy), useSelector (copy), ReactFocusNavigation (copy), FocusNavigationDefaultEventMap (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), canGoBack (copy)
	local v22 = useNavigation()
	local v23 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v24 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v25 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v26 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v27 = useDescendantHasFocus(v26)
	local v28 = useSelector(function(p4) -- line: 60
		return p4.TabBarVisible
	end)
	local v29 = ReactFocusNavigation.useFocusedGuiObject()
	local v30 = if v29 ~= nil then if not v29:IsA("ScrollingFrame") then v29:FindFirstAncestorWhichIsA("ScrollingFrame") else v29 else nil
	local v31 = v30 ~= nil
	local v32 = ReactFocusNavigation.useEventMap(FocusNavigationDefaultEventMap, p3)
	local v33 = React.useMemo(function() -- line: 70
		-- upvalues: v27 (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), canGoBack (copy), v22 (copy), v28 (copy), v25 (copy), v24 (copy), v23 (copy), v31 (copy), v30 (copy)
		local t1 = {}

		if not v27 then
			t1[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(_) -- line: 74
					-- upvalues: canGoBack (copy), v22 (copy), v28 (copy), v25 (copy)
					if canGoBack(v22) then
						v22.goBack(false)

						return
					end

					if v28 then
						v25()
					end
				end)
			}
		end

		if v24 and v23 ~= nil then
			t1[FocusNavigationEventNameEnum.Search] = {
				handler = InputHandlers.onRelease(function(_) -- line: 86
					-- upvalues: v24 (copy), v23 (copy)
					v24()

					if v23 ~= nil then
						local v38 = if not v23:IsA("TextBox") then v23:FindFirstChildWhichIsA("TextBox", true) else v23

						if v38 then
							v38:CaptureFocus()
						end
					end
				end)
			}
		end

		if v31 then
			t1[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_) -- line: 103
					-- upvalues: v30 (copy)
					local v40 = v30

					if v40 ~= nil then
						local v41 = v40.AbsoluteCanvasSize.Y - v40.AbsoluteWindowSize.Y

						if v40.CanvasPosition.Y >= v41 - 350 then
							v40.CanvasPosition = Vector2.new(0, v41)

							return
						end

						v40.CanvasPosition = v40.CanvasPosition + Vector2.new(0, 300)
					end
				end)
			}
			t1[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_) -- line: 108
					-- upvalues: v30 (copy)
					local v43 = v30

					if v43 ~= nil then
						local _ = v43.AbsoluteCanvasSize.Y - v43.AbsoluteWindowSize.Y

						if v43.CanvasPosition.Y <= 350 then
							v43.CanvasPosition = Vector2.new(0, 0)

							return
						end

						v43.CanvasPosition = v43.CanvasPosition + Vector2.new(0, -300)
					end
				end)
			}
		end

		return t1
	end, {
		v22,
		v23,
		v24,
		v25,
		v27,
		v28,
		v31
	})

	return (ReactFocusNavigation.useEventHandlerMap(v33, v32))
end

return useDefaultFocusNavigationBindings
