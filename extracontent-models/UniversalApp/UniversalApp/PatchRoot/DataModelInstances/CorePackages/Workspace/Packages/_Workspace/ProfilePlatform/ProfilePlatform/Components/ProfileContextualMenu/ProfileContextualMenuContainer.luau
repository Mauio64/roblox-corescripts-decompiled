local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Navigation = require(ProfilePlatformParent.Navigation)
local InputHandlers = require(ProfilePlatformParent.InputHandlers)
local FocusNavigationUtils = require(ProfilePlatformParent.FocusNavigationUtils)
local ProfileContextualMenu = require(script.Parent.ProfileContextualMenu)
local useScreenSize = require(ProfilePlatformParent.RobloxAppHooks).useScreenSize
local useProfileActions = require(ProfilePlatform.Hooks.useProfileActions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useNavigation = Navigation.useNavigation
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local Constants = require(ProfilePlatform.Common.Constants)
local Enums = require(ProfilePlatform.Common.Enums)
local FFlagProfilePlatformAddTC = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformAddTC
local FFlagProfileContextualMenuDisableFix = require(ProfilePlatformParent.SharedFlags).FFlagProfileContextualMenuDisableFix
local FFlagProfileFixMenuNavigation = require(ProfilePlatformParent.SharedFlags).FFlagProfileFixMenuNavigation

local function ProfileContextualMenuContainer(_) -- line: 24
	-- upvalues: useScreenSize (copy), useNavigation (copy), Constants (copy), useProfileJsonComponent (copy), Enums (copy), useProfileActions (copy), React (copy), FFlagProfileFixMenuNavigation (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FFlagProfileContextualMenuDisableFix (copy), FFlagProfilePlatformAddTC (copy), ProfileContextualMenu (copy), FocusNavigableSurfaceWrapper (copy)
	local v23 = useScreenSize()
	local v24 = useNavigation()
	local v25 = v24.getParam(Constants.Navigation.ON_CLOSE)
	local v26 = v24.getParam(Constants.Navigation.GET_ROOT_ELEMENT_REF)
	local v27 = v24.getParam(Constants.Navigation.ON_DISMISS_REF)
	local v28 = v26()
	local v29 = if not v28 then Vector2.new(0, 0) else v28.AbsolutePosition
	local v30 = useProfileJsonComponent(Enums.Components.Actions) or {}
	local v31 = useProfileActions(Enums.ButtonSurface.ContextualMenu)
	local contextual = v30.contextual
	local v33, v34 = React.useState(true)
	local v35 = React.useCallback(function() -- line: 42
		-- upvalues: v34 (copy), v24 (copy), v25 (copy)
		v34(false)
		v24.pop()
		v25()
	end, {
		v24,
		v25
	})
	local v36 = if not FFlagProfileFixMenuNavigation then nil else useAppFocusRoot({
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function() -- line: 54
					-- upvalues: v35 (copy)
					v35()
				end)
			}
		},
		isFocusable = v33
	})

	React.useEffect(function() -- line: 64
		-- upvalues: v27 (copy), v35 (copy)
		if not v27 then
			return
		end

		v27.current = v35

		return function() -- line: 69
			-- upvalues: v27 (copy)
			v27.current = nil
		end
	end, { v35 })

	local v37 = React.useMemo(function() -- line: 74
		-- upvalues: contextual (copy), v31 (copy), FFlagProfileContextualMenuDisableFix (copy), FFlagProfilePlatformAddTC (copy), v35 (copy)
		if not contextual then
			return {}
		end

		local t1 = {}

		for _, v40 in contextual do
			local v41 = v31[v40]

			if v41 then
				table.insert(t1, {
					text = v41.text,
					disabled = if not FFlagProfileContextualMenuDisableFix then if not FFlagProfilePlatformAddTC then nil else v41.isDisabled else nil,
					isDisabled = if not FFlagProfileContextualMenuDisableFix then nil else v41.isDisabled,
					onActivated = function() -- line: 90
						-- upvalues: v35 (copy), v41 (copy)
						v35()
						v41.onActivated()
					end
				})
			end
		end

		return t1
	end, {
		contextual,
		v35,
		v31
	})

	if FFlagProfileFixMenuNavigation then
		return React.createElement(ProfileContextualMenu, {
			buttonProps = v37,
			screenSize = v23,
			onDismiss = v35,
			rootElementPosition = v29,
			rootElementRef = {
				current = v28
			},
			isOpen = v33,
			menuRef = v36
		})
	end

	return (React.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2) -- line: 116
					-- upvalues: v35 (copy)
					v35()
					p2:cancel()
				end)
			}
		}
	}, { React.createElement(ProfileContextualMenu, {
		buttonProps = v37,
		screenSize = v23,
		onDismiss = v35,
		rootElementPosition = v29,
		rootElementRef = {
			current = v28
		},
		isOpen = v33
	}) }))
end

return ProfileContextualMenuContainer
