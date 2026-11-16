local DiscoverabilityModal = script:FindFirstAncestor("DiscoverabilityModal")
local parent = DiscoverabilityModal.Parent
local React = require(parent.React)

local Analytics = DiscoverabilityModal.Analytics
local useAnalytics = require(Analytics.useAnalytics)
local EventNames = require(Analytics.Enums.EventNames)
local Constants = require(DiscoverabilityModal.Common.Constants)

local LegallySensitiveContent = require(parent.LegallySensitiveContent)
local useLegallySensitiveContentAndActions = LegallySensitiveContent.useLegallySensitiveContentAndActions
local ConsentName = LegallySensitiveContent.ConsentName

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SocialModalsCommon = require(parent.SocialModalsCommon)
local UpdateIsDiscoverabilityUnset = SocialModalsCommon.Actions.UpdateIsDiscoverabilityUnset

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function DiscoverabilityWithAudit(_)
	local v = useNavigation()
	local v2 = useDispatch()
	local v3 = useAnalytics()

	local v4, v5 = useLegallySensitiveContentAndActions(
		ConsentName.phoneNumberDiscoverabilityUpsell,
		"generic-lua-discoverability-setting-upsell"
	)

	local wordsOfConsent = v4.wordsOfConsent
	local updateSettingWithAuditing = v5.updateSettingWithAuditing

	React.useEffect(function()
		v3.fireAnalyticsEvent(EventNames.DiscoverabilityModalLoad, {
			version = "audit_version",
			wordingVersion = Constants.WORDING_VERSION_1
		})
	end, {})

	local v6 = React.useCallback(function()
		v2(UpdateIsDiscoverabilityUnset({ isDiscoverabilityUnset = false }))
	end, {})

	local param = v.getParam(Constants.NAVIGATE_ON_ACTIVATED)

	local actions = {
		{
			text = wordsOfConsent.notNow,
			variant = ButtonVariant.Standard,
			onActivated = function()
				v3.fireAnalyticsEvent(EventNames.DiscoverabilityModalClose, {
					selected = Constants.UNSET
				})

				v6()
				v.pop()
				param()
			end
		},
		{
			text = wordsOfConsent.turnOn,
			variant = ButtonVariant.Emphasis,
			onActivated = function()
				v3.fireAnalyticsEvent(EventNames.DiscoverabilityModalContinue, {
					selected = Constants.DISCOVERABLE
				})

				updateSettingWithAuditing("phoneNumberDiscoverability", "Discoverable")
				v6()
				v.pop()
				param()
			end
		}
	}

	return React.createElement(Dialog.Root, { size = DialogSize.Medium, hasBackdrop = true }, {
		DialogTitle = React.createElement(Dialog.Title, { text = wordsOfConsent.title }),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogView = React.createElement(Dialog.Text, { Text = wordsOfConsent.content })
		}),
		DialogActions = React.createElement(Dialog.Actions, { LayoutOrder = 3, actions = actions })
	})
end

return DiscoverabilityWithAudit
