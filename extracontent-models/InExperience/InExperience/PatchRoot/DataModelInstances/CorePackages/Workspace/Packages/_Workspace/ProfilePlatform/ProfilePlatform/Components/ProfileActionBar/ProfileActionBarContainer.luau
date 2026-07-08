local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Navigation = require(ProfilePlatformParent.Navigation)
local ReactFocusNavigation = require(ProfilePlatformParent.ReactFocusNavigation)
local FocusNavigationUtils = require(ProfilePlatformParent.FocusNavigationUtils)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useMapJsonToProfileActions = require(ProfilePlatform.Components.ProfileActionBar.useMapJsonToProfileActions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local ProfileActionBar = require(ProfilePlatform.Components.ProfileActionBar.ProfileActionBar)
local ProfileActionBarWithTransferTooltip = require(ProfilePlatform.Components.ProfileActionBar.ProfileActionBarWithTransferTooltip)
local useNavigation = Navigation.useNavigation
local Enums = require(ProfilePlatform.Common.Enums)
local Constants = require(ProfilePlatform.Common.Constants)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useEffectOnMount = require(ProfilePlatformParent.RoactUtils).Hooks.useEffectOnMount
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local LoadingStagesExtension = require(ProfilePlatform.Analytics.LoadingStagesExtension)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useLastInputMode = FocusNavigationUtils.useLastInputMode
local FFlagProfilePlatformEnableTransferTooltip = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTransferTooltip)

local function ProfileActionBarContainer(p1) -- line: 36
	-- upvalues: useProfileWrapperContext (copy), useNavigation (copy), useFocusGuiObject (copy), useLastInputMode (copy), useProfileAnalyticsContext (copy), React (copy), EventNames (copy), Constants (copy), Enums (copy), useMapJsonToProfileActions (copy), FFlagProfilePlatformEnableTransferTooltip (copy), useProfileJsonComponent (copy), FFlagProfilePlatformEnableCurrencyTransfer (copy), useEffectOnMount (copy), SocialStopwatch (copy), LoadingStagesExtension (copy), ProfileActionBarWithTransferTooltip (copy), ProfileActionBar (copy)
	local profileId = useProfileWrapperContext().profileId
	local v27 = useNavigation()
	local v28 = useFocusGuiObject()
	local v29 = useLastInputMode()
	local v30 = useProfileAnalyticsContext()
	local v31, v32 = React.useState(false)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36 = React.useCallback(function() -- line: 48
		-- upvalues: v31 (copy), v35 (copy), v30 (copy), EventNames (copy), Constants (copy), v32 (copy), v33 (copy), v27 (copy), Enums (copy)
		if v31 then
			if v35 and v35.current then
				v35.current()
			end

			return
		end

		v30.fireAnalyticsEvent(EventNames.ContextualMenuButton)

		local t1 = {
			[Constants.Navigation.ON_CLOSE] = function() -- line: 59
				-- upvalues: v32 (copy)
				v32(false)
			end,
			[Constants.Navigation.GET_ROOT_ELEMENT_REF] = function() -- line: 62
				-- upvalues: v33 (copy)
				return v33.current
			end,
			[Constants.Navigation.ON_DISMISS_REF] = v35
		}

		v27.navigate(Enums.Screens.ContextualMenu, t1)
		v32(true)
	end, {
		v27,
		v31
	})

	React.useEffect(function() -- line: 73
		-- upvalues: v34 (copy), v29 (copy), v28 (copy)
		if v34.current and v29 == "Focus" then
			v28(v34.current)
		end
	end, {
		v34.current,
		v29
	})

	local v37, v38 = useMapJsonToProfileActions(profileId)
	local v39 = nil

	if FFlagProfilePlatformEnableTransferTooltip then
		local v40 = useProfileJsonComponent(Enums.Components.Actions) or {}

		v39 = FFlagProfilePlatformEnableCurrencyTransfer and (v40.contextual ~= nil and table.find(v40.contextual, Enums.ProfileActions.CurrencyTransfer) ~= nil)
	end

	useEffectOnMount(function() -- line: 88
		-- upvalues: SocialStopwatch (copy), v30 (copy), EventNames (copy), LoadingStagesExtension (copy)
		local v42 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.ProfileOpened)

		v30.fireAnalyticsEvent(EventNames.ProfileLoadingStage, {
			isProfilePlatform = true,
			statValue = if not v42 then nil else v42.timeElapsed,
			status = LoadingStagesExtension.CTALoaded
		})
	end)

	if FFlagProfilePlatformEnableTransferTooltip and v39 then
		return (React.createElement(ProfileActionBarWithTransferTooltip, {
			isContextualMenuOpen = v31,
			layoutOrder = p1.layoutOrder,
			openContextualMenu = if not v38 then nil else v36,
			profileActions = v37,
			primaryButtonRef = v34,
			moreButtonRef = v33
		}))
	end

	return (React.createElement(ProfileActionBar, {
		isContextualMenuOpen = v31,
		layoutOrder = p1.layoutOrder,
		openContextualMenu = if not v38 then nil else v36,
		profileActions = v37,
		primaryButtonRef = v34,
		moreButtonRef = v33
	}))
end

return ProfileActionBarContainer
