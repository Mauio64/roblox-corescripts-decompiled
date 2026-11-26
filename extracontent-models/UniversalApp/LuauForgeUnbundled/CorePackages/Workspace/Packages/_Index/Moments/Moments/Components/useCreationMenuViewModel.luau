local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/FocusNavigationUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/InputHandlers")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactFocusNavigation")

local image = BuilderIcons.Icon.Image
local frameVideoCamera = BuilderIcons.Icon.FrameVideoCamera

local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local v5 = {
	gallery = "Feature.Captures.Title.Gallery",
	myAvatars = "Feature.Avatar.Label.Title.MyAvatars"
}

local function useCreationMenuViewModel(data)
	local v6 = useLocalization(v5)
	local v7 = useToggleState()
	local disable = v7.disable

	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					disable()
					object:cancel()
				end)
			}
		}
	end, { disable })
	local v9 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = v7.enabled,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = v8
	})

	local v10, v11 = ReactFocusNavigation.useDefaultFocusBehavior(v9)
	local v12 = useFocusOnMount(v10)

	local v13 = React.useCallback(function()
		if data.onTriggerActivated ~= nil then
			data.onTriggerActivated()
		end

		if v7.enabled then
			v7.disable()
		else
			v7.enable()
		end
	end, { data.onTriggerActivated, v7.enabled, v7.enable, v7.disable })

	local v14 = React.useCallback(function()
		v7.disable()
		data.onCreateFromCaptures()
	end, { v7.disable, data.onCreateFromCaptures })

	local v15 = React.useCallback(function()
		v7.disable()
		data.onCreateFromAvatar()
	end, { v7.disable, data.onCreateFromAvatar })

	local v16 = React.useMemo(function()
		return {
			{
				id = "gallery",
				icon = image,
				ref = v12,
				text = v6.gallery,
				onActivated = v14
			},
			{
				id = "myAvatars",
				icon = frameVideoCamera,
				text = v6.myAvatars,
				onActivated = v15
			}
		}
	end, { v6, v14, v15, v12 })

	return {
		isOpen = v7.enabled,
		items = v16,
		menuRef = v11,
		onToggle = v13,
		onPressedOutside = disable
	}
end

return useCreationMenuViewModel
