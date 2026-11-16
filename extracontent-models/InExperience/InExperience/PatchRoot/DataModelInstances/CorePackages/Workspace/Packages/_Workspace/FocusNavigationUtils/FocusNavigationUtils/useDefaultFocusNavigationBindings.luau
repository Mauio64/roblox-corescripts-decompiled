local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local SharedFlags = require(parent.SharedFlags)
local FFlagFixDoubleBackNav = SharedFlags.FFlagFixDoubleBackNav
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Navigation2 = require(parent.Navigation)
local canGoBack = Navigation2.canGoBack
local FocusNavigationEventNameEnum = require(FocusNavigationUtils.FocusNavigationEventNameEnum)
local FocusNavigableSurfaceRegistry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry)
local useFocusRegistryEntry = FocusNavigableSurfaceRegistry.useFocusRegistryEntry
local FocusNavigableSurfaceIdentifierEnum = require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local FocusNavigableSurfaceRegistry2 = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry)
local useRegistryEntry = FocusNavigableSurfaceRegistry2.useRegistryEntry
local FocusNavigationDefaultEventMap = require(FocusNavigationUtils.FocusNavigationDefaultEventMap)

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

function useDefaultFocusNavigationBindings(p)
	local v = useNavigation()
	local textBox = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v2 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v3 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v4 = useDescendantHasFocus((useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)))
	local v5 = useSelector(function(p2)
		return p2.TabBarVisible
	end)

	local scrollableAncestor = getScrollableAncestor(ReactFocusNavigation.useFocusedGuiObject()) -- inferred equivalent call
	local v6 = scrollableAncestor ~= nil
	local v7 = ReactFocusNavigation.useEventMap(FocusNavigationDefaultEventMap, p)

	local v8 = React.useMemo(function()
		local v8 = {}

		if not v4 then
			v8[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					if canGoBack(v) then
						v.goBack(false)
					elseif v5 then
						v3()
					else
						return
					end

					if FFlagFixDoubleBackNav then
						p2.cancelled = true
					end
				end)
			}
		end

		if v2 and textBox ~= nil then
			v8[FocusNavigationEventNameEnum.Search] = {
				handler = InputHandlers.onRelease(function(_)
					v2()

					if textBox ~= nil then
						local v9

						if textBox:IsA("TextBox") then
							v9 = textBox
						else
							v9 = textBox:FindFirstChildWhichIsA("TextBox", true)
						end

						if v9 then
							v9:CaptureFocus()
						end
					end
				end)
			}
		end

		if v6 then
			v8[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(_)
					local v9 = scrollableAncestor

					if v9 ~= nil then
						local v10 = v9.AbsoluteCanvasSize.Y - v9.AbsoluteWindowSize.Y

						local y = v9.CanvasPosition.Y

						if v10 - 350 <= y then
							v9.CanvasPosition = Vector2.new(0, v10)
						else
							v9.CanvasPosition += Vector2.new(0, 300)
						end
					end
				end)
			}

			v8[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(_)
					local v9 = scrollableAncestor

					if v9 ~= nil then
						local _ = v9.AbsoluteCanvasSize.Y - v9.AbsoluteWindowSize.Y

						if v9.CanvasPosition.Y <= 350 then
							v9.CanvasPosition = Vector2.new(0, 0)
						else
							v9.CanvasPosition += Vector2.new(0, -300)
						end
					end
				end)
			}
		end

		return v8
	end, { v, textBox, v2, v3, v4, v5, v6 })

	return (ReactFocusNavigation.useEventHandlerMap(v8, v7))
end

return useDefaultFocusNavigationBindings
