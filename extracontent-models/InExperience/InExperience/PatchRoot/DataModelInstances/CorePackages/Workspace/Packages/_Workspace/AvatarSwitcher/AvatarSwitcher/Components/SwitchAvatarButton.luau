local SessionService = game:GetService("SessionService")

local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonSize = Foundation.Enums.ButtonSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SignalsReact = require(parent.SignalsReact)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore

local function SwitchAvatarButton(p)
	local v = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v2 = SignalsReact.useSignalState(v.getIsSwitching)
	local v3 = SignalsReact.useSignalState(v.getSelectedOutfitId)
	local v4 = SignalsReact.useSignalState(v.getSelectedOutfitDetails)

	local timeoutStatusStore = getTimeoutStatusStore()
	local v5 = SignalsReact.useSignalState(timeoutStatusStore.getIsTimedOut)

	local v6 = useLocalization({ buttonText = "Feature.AvatarSwitcher.Action.Continue" })
	local v7 = v3 ~= nil and v4 == nil
	local isLoading = v2 or v7
	local isDisabled = isLoading or v3 == nil or v5
	local ref = React.useRef(nil)

	React.useEffect(function()
		task.delay(0, function()
			addUnifiedEventLogging(
				ref,
				{
					action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
					surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER,
					elementName = "SWITCH_AVATAR_BUTTON"
				},
				{
					sessionTagName = SessionService:GetSessionTag("level2a")
				}
			)
		end)
	end, {})

	local createElement = React.createElement
	local button = Foundation.Button
	local v8 = {
		text = v6.buttonText,
		size = ButtonSize.Small,
		variant = 0,
		fillBehavior = 0,
		onActivated = 0,
		isLoading = 0,
		isDisabled = 0,
		ref = 0
	}
	local variant

	if isDisabled then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.Emphasis
	end

	v8.variant = variant
	v8.fillBehavior = FillBehavior.Fill
	v8.onActivated = p.onActivated
	v8.isLoading = isLoading
	v8.isDisabled = isDisabled
	v8.ref = ref
	return (createElement(button, v8))
end

return SwitchAvatarButton
