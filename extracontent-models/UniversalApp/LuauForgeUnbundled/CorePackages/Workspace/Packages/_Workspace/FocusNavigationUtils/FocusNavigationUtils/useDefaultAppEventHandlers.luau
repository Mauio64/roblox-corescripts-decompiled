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

function LUAUFORGE_MODULE_GLOBALS_ajL_useDefaultAppEventHandlers()
	local v5 = useNavigation()
	local textBox = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v6 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v7 = useFocusRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v9 = useDescendantHasFocus((useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)))
	local v10 = useSelector(function(p2)
		return p2.TabBarVisible
	end)

	local scrollingFrame = ReactFocusNavigation.useFocusedGuiObject()

	if scrollingFrame == nil then
		scrollingFrame = nil
	elseif not scrollingFrame:IsA("ScrollingFrame") then
		scrollingFrame = scrollingFrame:FindFirstAncestorWhichIsA("ScrollingFrame")
	end

	local v11 = scrollingFrame ~= nil
	return (React.useMemo(function()
		local v12 = {}

		if not v9 then
			v12[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					if canGoBack(v5) then
						v5.goBack(false)
					elseif v10 then
						v7()
					else
						return
					end

					if fFlagFixDoubleBackNav then
						p2.cancelled = true
					end
				end)
			}
		end

		if v6 and textBox ~= nil then
			v12[FocusNavigationEventNameEnum.Search] = {
				handler = InputHandlers.onRelease(function(p2)
					v6()

					if textBox ~= nil then
						local v13

						if textBox:IsA("TextBox") then
							v13 = textBox
						else
							v13 = textBox:FindFirstChildWhichIsA("TextBox", true)
						end

						if v13 then
							v13:CaptureFocus()
						end
					end
				end)
			}
		end

		if v11 then
			v12[FocusNavigationEventNameEnum.ScrollDown] = {
				handler = InputHandlers.onRelease(function(p2)
					local v13 = scrollingFrame

					if v13 ~= nil then
						local v14 = v13.AbsoluteCanvasSize.Y - v13.AbsoluteWindowSize.Y

						local y = v13.CanvasPosition.Y

						if v14 - 350 <= y then
							v13.CanvasPosition = Vector2.new(0, v14)
						else
							v13.CanvasPosition += Vector2.new(0, 300)
						end
					end
				end)
			}

			v12[FocusNavigationEventNameEnum.ScrollUp] = {
				handler = InputHandlers.onRelease(function(p2)
					local v13 = scrollingFrame

					if v13 ~= nil then
						local v14 = v13.AbsoluteCanvasSize.Y - v13.AbsoluteWindowSize.Y

						if v13.CanvasPosition.Y <= 350 then
							v13.CanvasPosition = Vector2.new(0, 0)
						else
							v13.CanvasPosition += Vector2.new(0, -300)
						end
					end
				end)
			}
		end

		return v12
	end, { v5, textBox, v6, v7, v9, v10, v11 }))
end

return LUAUFORGE_MODULE_GLOBALS_ajL_useDefaultAppEventHandlers
