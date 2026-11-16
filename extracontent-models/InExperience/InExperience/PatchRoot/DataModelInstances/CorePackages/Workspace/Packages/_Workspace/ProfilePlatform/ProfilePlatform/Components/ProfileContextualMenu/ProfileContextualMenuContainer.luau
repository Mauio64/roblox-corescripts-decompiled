local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Navigation = require(parent.Navigation)
local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local ProfileContextualMenu = require(script.Parent.ProfileContextualMenu)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local useProfileActions = require(ProfilePlatform.Hooks.useProfileActions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useNavigation = Navigation.useNavigation
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileContextualMenuDisableFix = SharedFlags2.FFlagProfileContextualMenuDisableFix
local SharedFlags3 = require(parent.SharedFlags)
local FFlagProfileFixMenuNavigation = SharedFlags3.FFlagProfileFixMenuNavigation

local function ProfileContextualMenuContainer(_)
	local screenSize = useScreenSize()
	local v = useNavigation()

	local param = v.getParam(Constants.Navigation.ON_CLOSE)
	local param2 = v.getParam(Constants.Navigation.GET_ROOT_ELEMENT_REF)
	local param3 = v.getParam(Constants.Navigation.ON_DISMISS_REF)

	local current = param2()
	local rootElementPosition

	if current then
		rootElementPosition = current.AbsolutePosition
	else
		rootElementPosition = Vector2.new(0, 0)
	end

	local v2 = useProfileJsonComponent(Enums.Components.Actions) or {}

	local v3 = useProfileActions(Enums.ButtonSurface.ContextualMenu)
	local contextual = v2.contextual

	local state, setState = React.useState(true)

	local v4 = React.useCallback(function()
		setState(false)
		v.pop()
		param()
	end, { v, param })
	local menuRef

	if FFlagProfileFixMenuNavigation then
		menuRef = useAppFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function()
						v4()
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

		param3.current = v4
		return function()
			param3.current = nil
		end
	end, { v4 })

	local buttonProps = React.useMemo(function()
		if not contextual then
			return {}
		end

		local result = {}

		for _, v5 in contextual do
			local v6 = v3[v5]

			if not v6 then
				continue
			end

			local v7 = { text = v6.text, disabled = 0, isDisabled = 0, onActivated = 0 }
			local disabled

			if not (FFlagProfileContextualMenuDisableFix or not FFlagProfilePlatformAddTC) then
				disabled = v6.isDisabled
			end

			v7.disabled = disabled
			local isDisabled

			if FFlagProfileContextualMenuDisableFix then
				isDisabled = v6.isDisabled
			end

			v7.isDisabled = isDisabled
			function v7.onActivated()
				v4()
				v6.onActivated()
			end

			table.insert(result, v7)
		end

		return result
	end, { contextual, v4, v3 })

	if FFlagProfileFixMenuNavigation then
		return React.createElement(ProfileContextualMenu, {
			buttonProps = buttonProps,
			screenSize = screenSize,
			onDismiss = v4,
			rootElementPosition = rootElementPosition,
			rootElementRef = { current = current },
			isOpen = state,
			menuRef = menuRef
		})
	end

	return (React.createElement(FocusNavigableSurfaceWrapper, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v4()
					object:cancel()
				end)
			}
		}
	}, { React.createElement(ProfileContextualMenu, {
			buttonProps = buttonProps,
			screenSize = screenSize,
			onDismiss = v4,
			rootElementPosition = rootElementPosition,
			rootElementRef = { current = current },
			isOpen = state
		}) }))
end

return ProfileContextualMenuContainer
