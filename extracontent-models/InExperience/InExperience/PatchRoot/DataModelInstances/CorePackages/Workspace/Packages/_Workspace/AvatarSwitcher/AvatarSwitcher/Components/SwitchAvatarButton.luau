local SessionService = game:GetService("SessionService")
local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local Foundation = require(AvatarSwitcherParent.Foundation)
local React = require(AvatarSwitcherParent.React)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonSize = Foundation.Enums.ButtonSize
local useLocalization = require(AvatarSwitcherParent.Localization).Hooks.useLocalization
local SignalsReact = require(AvatarSwitcherParent.SignalsReact)
local AvatarExperienceAnalytics = require(AvatarSwitcherParent.AvatarExperienceAnalytics)
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local UnifiedLoggingSurface = require(AvatarSwitcherParent.AvatarExperienceNavigation).Enums.UnifiedLoggingSurface
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local getTimeoutStatusStore = require(AvatarSwitcherParent.AvatarExperienceCommon).Stores.getTimeoutStatusStore

local function SwitchAvatarButton(t1: {[any]: any}) -- line: 29
	-- upvalues: SignalsReact (copy), getAvatarSwitcherStore (copy), getTimeoutStatusStore (copy), useLocalization (copy), React (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), Foundation (copy), ButtonSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v19 = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v20 = SignalsReact.useSignalState(v19.getIsSwitching)
	local v21 = SignalsReact.useSignalState(v19.getSelectedOutfitId)
	local v22 = SignalsReact.useSignalState(v19.getSelectedOutfitDetails)
	local v23 = getTimeoutStatusStore()
	local v24 = SignalsReact.useSignalState(v23.getIsTimedOut)
	local v25 = useLocalization({
		buttonText = "Feature.AvatarSwitcher.Action.Continue"
	})
	local v26 = v21 ~= nil and v22 == nil
	local v27 = v20 or v26
	local v28 = v27 or (v21 == nil or v24)
	local v29 = React.useRef(nil)

	React.useEffect(function() -- line: 47
		-- upvalues: addUnifiedEventLogging (copy), v29 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy)
		task.delay(0, function() -- line: 50
			-- upvalues: addUnifiedEventLogging (copy), v29 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy)
			addUnifiedEventLogging(v29, {
				elementName = "SWITCH_AVATAR_BUTTON",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER
			}, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end, {})

	return (React.createElement(Foundation.Button, {
		text = v25.buttonText,
		size = ButtonSize.Small,
		variant = if not v28 then ButtonVariant.Emphasis else ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = t1.onActivated,
		isLoading = v27,
		isDisabled = v28,
		ref = v29
	}))
end

return SwitchAvatarButton
