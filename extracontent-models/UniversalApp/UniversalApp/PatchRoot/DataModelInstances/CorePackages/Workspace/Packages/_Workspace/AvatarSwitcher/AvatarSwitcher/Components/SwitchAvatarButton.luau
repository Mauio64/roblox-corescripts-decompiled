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
local AvatarExperienceFlags = require(AvatarSwitcherParent.AvatarExperienceFlags)
local AvatarExperienceCommon = require(AvatarSwitcherParent.AvatarExperienceCommon)
local FFlagAXAvatarTimeoutFlowIE = AvatarExperienceFlags.FFlagAXAvatarTimeoutFlowIE
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore

local function SwitchAvatarButton(t1: {[any]: any}) -- line: 31
	-- upvalues: SignalsReact (copy), getAvatarSwitcherStore (copy), FFlagAXAvatarTimeoutFlowIE (copy), getTimeoutStatusStore (copy), useLocalization (copy), React (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy), Foundation (copy), ButtonSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v22 = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v23 = SignalsReact.useSignalState(v22.getIsSwitching)
	local v24 = SignalsReact.useSignalState(v22.getSelectedOutfitId)
	local v25 = SignalsReact.useSignalState(v22.getSelectedOutfitDetails)
	local v26 = nil

	if FFlagAXAvatarTimeoutFlowIE then
		local v27 = getTimeoutStatusStore()

		v26 = SignalsReact.useSignalState(v27.getIsTimedOut)
	end

	local v28 = useLocalization({
		buttonText = "Feature.AvatarSwitcher.Action.Continue"
	})
	local v29 = v24 ~= nil and v25 == nil
	local v30 = v23 or v29
	local v31 = v30 or (v24 == nil or FFlagAXAvatarTimeoutFlowIE and v26)
	local v32 = React.useRef(nil)

	React.useEffect(function() -- line: 53
		-- upvalues: addUnifiedEventLogging (copy), v32 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy)
		task.delay(0, function() -- line: 56
			-- upvalues: addUnifiedEventLogging (copy), v32 (copy), UnifiedEventLogEnums (copy), UnifiedLoggingSurface (copy), SessionService (copy)
			addUnifiedEventLogging(v32, {
				elementName = "SWITCH_AVATAR_BUTTON",
				action = UnifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				surface = UnifiedLoggingSurface.IN_EXPERIENCE_AVATAR_SWITCHER
			}, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end, {})

	return (React.createElement(Foundation.Button, {
		text = v28.buttonText,
		size = ButtonSize.Small,
		variant = if not v31 then ButtonVariant.Emphasis else ButtonVariant.Standard,
		fillBehavior = FillBehavior.Fill,
		onActivated = t1.onActivated,
		isLoading = v30,
		isDisabled = v31,
		ref = v32
	}))
end

return SwitchAvatarButton
