local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/InputHandlers")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Navigation").useNavigation
local fFlagFixDoubleBackNav = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/SharedFlags").FFlagFixDoubleBackNav
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/RoactUtils").Hooks.RoactRodux.useSelector
local canGoBack = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Navigation").canGoBack
local FocusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigationEventNameEnum")
local useFocusRegistryEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceRegistry").useFocusRegistryEntry
local FocusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceIdentifierEnum")
local useDescendantHasFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDescendantHasFocus")
local useRegistryEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceRegistry").useRegistryEntry
local FocusNavigationDefaultEventMap = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigationDefaultEventMap")

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
		local v5 = state.AbsoluteCanvasSize.Y - state.AbsoluteWindowSize.Y

		if p2 > 0 then
			local y = state.CanvasPosition.Y

			if v5 - 350 <= y then
				state.CanvasPosition = Vector2.new(0, v5)
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

function LUAUFORGE_MODULE_GLOBALS_aiQ_useDefaultFocusNavigationBindings(p2)
	local v5 = useNavigation()
	local textBox = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v6 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v7 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v9 = useDescendantHasFocus((useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)))
	local v10 = useSelector(function(p3)
		return p3.TabBarVisible
	end)

	local scrollingFrame = ReactFocusNavigation.useFocusedGuiObject()

	if scrollingFrame == nil then
		scrollingFrame = nil
	elseif not scrollingFrame:IsA("ScrollingFrame") then
		scrollingFrame = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
	end

	local v11 = scrollingFrame ~= nil
	local v12 = ReactFocusNavigation.useEventMap(FocusNavigationDefaultEventMap, p2)

	local v13 = React.useMemo(function()
		local v14 = {}

		if not v9 then
			v14[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3)
					if canGoBack(v5) then
						v5.goBack(false)
					elseif v10 then
						v7()
					else
						return
					end

					if fFlagFixDoubleBackNav then
						p3.cancelled = true
					end
				end)
			}
		end

		if v6 and textBox ~= nil then
			v14[FocusNavigationEventNameEnum.Search] = {
				handler = InputHandlers.onRelease(function(p3)
					v6()

					if textBox ~= nil then
						local v15

						if textBox:IsA("TextBox") then
							v15 = textBox
						else
							v15 = textBox:FindFirstChildWhichIsA("TextBox", true)
						end

						if v15 then
							v15:CaptureFocus()
						end
					end
				end)
			}
		end

		if v11 then
			v14[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(p3)
					local v15 = scrollingFrame

					if v15 ~= nil then
						local v16 = v15.AbsoluteCanvasSize.Y - v15.AbsoluteWindowSize.Y

						local y = v15.CanvasPosition.Y

						if v16 - 350 <= y then
							v15.CanvasPosition = Vector2.new(0, v16)
						else
							v15.CanvasPosition += Vector2.new(0, 300)
						end
					end
				end)
			}

			v14[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(p3)
					local v15 = scrollingFrame

					if v15 ~= nil then
						local v16 = v15.AbsoluteCanvasSize.Y - v15.AbsoluteWindowSize.Y

						if v15.CanvasPosition.Y <= 350 then
							v15.CanvasPosition = Vector2.new(0, 0)
						else
							v15.CanvasPosition += Vector2.new(0, -300)
						end
					end
				end)
			}
		end

		return v14
	end, { v5, textBox, v6, v7, v9, v10, v11 })

	return (ReactFocusNavigation.useEventHandlerMap(v13, v12))
end

return LUAUFORGE_MODULE_GLOBALS_aiQ_useDefaultFocusNavigationBindings
