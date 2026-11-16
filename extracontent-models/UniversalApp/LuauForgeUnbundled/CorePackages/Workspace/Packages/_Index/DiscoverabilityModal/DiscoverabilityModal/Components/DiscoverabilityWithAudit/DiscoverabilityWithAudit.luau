local React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/React")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/useAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/Enums/EventNames")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Common/Constants")

local LegallySensitiveContent = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/LegallySensitiveContent")
local useLegallySensitiveContentAndActions = LegallySensitiveContent.useLegallySensitiveContentAndActions
local consentName = LegallySensitiveContent.ConsentName

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RoactUtils").Hooks.RoactRodux.useDispatch
local updateIsDiscoverabilityUnset = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/SocialModalsCommon").Actions.UpdateIsDiscoverabilityUnset

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local function DiscoverabilityWithAudit(p2)
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = useAnalytics()

	local v8, v9 = useLegallySensitiveContentAndActions(
		consentName.phoneNumberDiscoverabilityUpsell,
		"generic-lua-discoverability-setting-upsell"
	)

	local wordsOfConsent = v8.wordsOfConsent
	local updateSettingWithAuditing = v9.updateSettingWithAuditing

	React.useEffect(function()
		v7.fireAnalyticsEvent(EventNames.DiscoverabilityModalLoad, {
			version = "audit_version",
			wordingVersion = Constants.WORDING_VERSION_1
		})
	end, {})

	local v10 = React.useCallback(function()
		v6(updateIsDiscoverabilityUnset({ isDiscoverabilityUnset = false }))
	end, {})

	local param = v5.getParam(Constants.NAVIGATE_ON_ACTIVATED)

	local v11 = {
		{
			text = wordsOfConsent.notNow,
			variant = buttonVariant.Standard,
			onActivated = function()
				v7.fireAnalyticsEvent(EventNames.DiscoverabilityModalClose, {
					selected = Constants.UNSET
				})

				v10()
				v5.pop()
				param()
			end
		},
		{
			text = wordsOfConsent.turnOn,
			variant = buttonVariant.Emphasis,
			onActivated = function()
				v7.fireAnalyticsEvent(EventNames.DiscoverabilityModalContinue, {
					selected = Constants.DISCOVERABLE
				})

				updateSettingWithAuditing("phoneNumberDiscoverability", "Discoverable")
				v10()
				v5.pop()
				param()
			end
		}
	}

	return React.createElement(dialog.Root, {
		size = dialogSize.Medium,
		hasBackdrop = true
	}, {
		DialogTitle = React.createElement(dialog.Title, { text = wordsOfConsent.title }),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			DialogView = React.createElement(dialog.Text, {
				Text = wordsOfConsent.content
			})
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = v11
		})
	})
end

return DiscoverabilityWithAudit
