local parent = script:FindFirstAncestor("Moments").Parent

local BuilderIcons = require(parent.BuilderIcons)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local Image = BuilderIcons.Icon.Image
local FrameVideoCamera = BuilderIcons.Icon.FrameVideoCamera

local useLocalization = Localization.Hooks.useLocalization
local useToggleState = MomentsCommon.Hooks.useToggleState
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusOnMount = FocusNavigationUtils.useFocusOnMount
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local v = {
	gallery = "Feature.Captures.Title.Gallery",
	myAvatars = "Feature.Avatar.Label.Title.MyAvatars"
}

local function useCreationMenuViewModel(data)
	local v2 = useLocalization(v)
	local v3 = useToggleState()
	local disable = v3.disable

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					disable()
					object:cancel()
				end)
			}
		}
	end, { disable })
	local v4 = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = v3.enabled,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local v5, menuRef = ReactFocusNavigation.useDefaultFocusBehavior(v4)
	local ref = useFocusOnMount(v5)

	local onToggle = React.useCallback(function()
		if data.onTriggerActivated ~= nil then
			data.onTriggerActivated()
		end

		if v3.enabled then
			v3.disable()
		else
			v3.enable()
		end
	end, { data.onTriggerActivated, v3.enabled, v3.enable, v3.disable })

	local onActivated = React.useCallback(function()
		v3.disable()
		data.onCreateFromCaptures()
	end, { v3.disable, data.onCreateFromCaptures })

	local onActivated2 = React.useCallback(function()
		v3.disable()
		data.onCreateFromAvatar()
	end, { v3.disable, data.onCreateFromAvatar })

	local items = React.useMemo(function()
		return {
			{
				id = "gallery",
				icon = Image,
				ref = ref,
				text = v2.gallery,
				onActivated = onActivated
			},
			{
				id = "myAvatars",
				icon = FrameVideoCamera,
				text = v2.myAvatars,
				onActivated = onActivated2
			}
		}
	end, { v2, onActivated, onActivated2, ref })

	return {
		isOpen = v3.enabled,
		items = items,
		menuRef = menuRef,
		onToggle = onToggle,
		onPressedOutside = disable
	}
end

return useCreationMenuViewModel
