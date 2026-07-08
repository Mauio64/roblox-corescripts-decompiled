local DiscoverabilityModal = script:FindFirstAncestor("DiscoverabilityModal")
local DiscoverabilityModalParent = DiscoverabilityModal.Parent
local React = require(DiscoverabilityModalParent.React)
local Analytics = DiscoverabilityModal.Analytics
local useAnalytics = require(Analytics.useAnalytics)
local EventNames = require(Analytics.Enums.EventNames)
local Constants = require(DiscoverabilityModal.Common.Constants)
local LegallySensitiveContent = require(DiscoverabilityModalParent.LegallySensitiveContent)
local useLegallySensitiveContentAndActions = LegallySensitiveContent.useLegallySensitiveContentAndActions
local ConsentName = LegallySensitiveContent.ConsentName
local useNavigation = require(DiscoverabilityModalParent.Navigation).useNavigation
local useDispatch = require(DiscoverabilityModalParent.RoactUtils).Hooks.RoactRodux.useDispatch
local UpdateIsDiscoverabilityUnset = require(DiscoverabilityModalParent.SocialModalsCommon).Actions.UpdateIsDiscoverabilityUnset
local Foundation = require(DiscoverabilityModalParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function DiscoverabilityWithAudit(_) -- line: 24
	-- upvalues: useNavigation (copy), useDispatch (copy), useAnalytics (copy), useLegallySensitiveContentAndActions (copy), ConsentName (copy), React (copy), EventNames (copy), Constants (copy), UpdateIsDiscoverabilityUnset (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy)
	local v20 = useNavigation()
	local v21 = useDispatch()
	local v22 = useAnalytics()
	local v23, v24 = useLegallySensitiveContentAndActions(ConsentName.phoneNumberDiscoverabilityUpsell, "generic-lua-discoverability-setting-upsell")
	local wordsOfConsent = v23.wordsOfConsent
	local updateSettingWithAuditing = v24.updateSettingWithAuditing

	React.useEffect(function() -- line: 37
		-- upvalues: v22 (copy), EventNames (copy), Constants (copy)
		v22.fireAnalyticsEvent(EventNames.DiscoverabilityModalLoad, {
			version = "audit_version",
			wordingVersion = Constants.WORDING_VERSION_1
		})
	end, {})

	local v27 = React.useCallback(function() -- line: 44
		-- upvalues: v21 (copy), UpdateIsDiscoverabilityUnset (copy)
		v21(UpdateIsDiscoverabilityUnset({
			isDiscoverabilityUnset = false
		}))
	end, {})
	local v28 = v20.getParam(Constants.NAVIGATE_ON_ACTIVATED)
	local t1 = {
		{
			text = wordsOfConsent.notNow,
			variant = ButtonVariant.Standard,
			onActivated = function() -- line: 56
				-- upvalues: v22 (copy), EventNames (copy), Constants (copy), v27 (copy), v20 (copy), v28 (copy)
				v22.fireAnalyticsEvent(EventNames.DiscoverabilityModalClose, {
					selected = Constants.UNSET
				})
				v27()
				v20.pop()
				v28()
			end
		},
		{
			text = wordsOfConsent.turnOn,
			variant = ButtonVariant.Emphasis,
			onActivated = function() -- line: 68
				-- upvalues: v22 (copy), EventNames (copy), Constants (copy), updateSettingWithAuditing (copy), v27 (copy), v20 (copy), v28 (copy)
				v22.fireAnalyticsEvent(EventNames.DiscoverabilityModalContinue, {
					selected = Constants.DISCOVERABLE
				})
				updateSettingWithAuditing("phoneNumberDiscoverability", "Discoverable")
				v27()
				v20.pop()
				v28()
			end
		}
	}

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		size = DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = wordsOfConsent.title
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogView = React.createElement(Dialog.Text, {
				Text = wordsOfConsent.content
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = t1
		})
	})
end

return DiscoverabilityWithAudit
