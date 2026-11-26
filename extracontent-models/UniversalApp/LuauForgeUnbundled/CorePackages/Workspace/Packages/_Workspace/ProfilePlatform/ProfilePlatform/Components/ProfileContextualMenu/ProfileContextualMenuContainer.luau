local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")

local ProfileContextualMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfileContextualMenu/ProfileContextualMenu")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useScreenSize
local useProfileActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileActions")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useNavigation = Navigation.useNavigation
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local fFlagProfilePlatformAddTC = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformAddTC
local fFlagProfileContextualMenuDisableFix = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileContextualMenuDisableFix
local fFlagProfileFixMenuNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileFixMenuNavigation

local function ProfileContextualMenuContainer(p2)
	local v5 = useScreenSize()
	local v6 = useNavigation()

	local param = v6.getParam(Constants.Navigation.ON_CLOSE)
	local param2 = v6.getParam(Constants.Navigation.GET_ROOT_ELEMENT_REF)
	local param3 = v6.getParam(Constants.Navigation.ON_DISMISS_REF)

	local v7 = param2()
	local v8 = if v7 then v7.AbsolutePosition else Vector2.new(0, 0)

	local v9 = useProfileJsonComponent(Enums.Components.Actions) or {}

	local v10 = useProfileActions(Enums.ButtonSurface.ContextualMenu)
	local contextual = v9.contextual

	local state, setState = React.useState(true)

	local v11 = React.useCallback(function()
		setState(false)
		v6.pop()
		param()
	end, { v6, param })
	local v12

	if fFlagProfileFixMenuNavigation then
		v12 = useAppFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
			customEventHandlers = {
				[focusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function()
						v11()
					end)
				}
			},
			isAutoFocusRoot = true,
			isFocusable = state
		})
	end

	React.useEffect(function()
		if not param3 then
			return
		end

		param3.current = v11
		return function()
			param3.current = nil
		end
	end, { v11 })

	local v13 = React.useMemo(function()
		if not contextual then
			return {}
		end

		local result = {}

		for k, v14 in contextual do
			local v15 = v10[v14]

			if not v15 then
				continue
			end

			local v16 = {
				text = v15.text,
				disabled = 0,
				isDisabled = 0,
				onActivated = 0
			}

			local v17 = if not (fFlagProfileContextualMenuDisableFix or not fFlagProfilePlatformAddTC) then v15.isDisabled else nil
			v16.disabled = v17

			local v18 = if fFlagProfileContextualMenuDisableFix then v15.isDisabled else nil
			v16.isDisabled = v18
			function v16.onActivated()
				v11()
				v15.onActivated()
			end

			table.insert(result, v16)
		end

		return result
	end, { contextual, v11, v10 })

	if fFlagProfileFixMenuNavigation then
		return React.createElement(ProfileContextualMenu, {
			buttonProps = v13,
			screenSize = v5,
			onDismiss = v11,
			rootElementPosition = v8,
			rootElementRef = { current = v7 },
			isOpen = state,
			menuRef = v12
		})
	end

	return React.createElement(focusNavigableSurfaceWrapper, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v11()
					object:cancel()
				end)
			}
		}
	}, { React.createElement(ProfileContextualMenu, {
			buttonProps = v13,
			screenSize = v5,
			onDismiss = v11,
			rootElementPosition = v8,
			rootElementRef = { current = v7 },
			isOpen = state
		}) })
end

return ProfileContextualMenuContainer
