local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local SetContactImporterDisplayLogic = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Actions/SetContactImporterDisplayLogic")
local updateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local SetIsPhoneVerified = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Actions/SetIsPhoneVerified")
local updateIsDiscoverabilityUnset = dependencies.SocialModalsCommon.Actions.UpdateIsDiscoverabilityUnset

local rodux = dependencies.Rodux
local llama = dependencies.llama
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")

local v5 = {
	[Constants.SHOULD_SHOW_CONTACT_IMPORTER_FEATURE] = false,
	[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = false,
	hasOSPermissions = false,
	isPhoneVerified = false,
	isDiscoverabilityUnset = false
}

return rodux.createReducer(v5, {
	[SetContactImporterDisplayLogic.name] = function(p2, data)
		local hasOSPermissions = data.hasOSPermissions
		local isPhoneVerified = data.isPhoneVerified
		local shouldShowContactImporterUpsellAgain = data.shouldShowContactImporterUpsellAgain
		local phoneNumberDiscoverability = data.phoneNumberDiscoverability

		local isUserOptedInLocalStorage = hasOSPermissions and data.isUserOptedInLocalStorage

		return {
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_FEATURE] = true,
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = not isUserOptedInLocalStorage and shouldShowContactImporterUpsellAgain,
			hasOSPermissions = hasOSPermissions,
			isPhoneVerified = isPhoneVerified,
			isDiscoverabilityUnset = phoneNumberDiscoverability == Constants.DISCOVERABILITY_UNSET
		}
	end,
	[updateContactImporterModalLogic.name] = function(p2, p3)
		return (llama.Dictionary.join(p2, {
			hasOSPermissions = p3.hasOSPermissions,
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = p3[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL]
		}))
	end,
	[SetIsPhoneVerified.name] = function(p2, p3)
		return llama.Dictionary.join(p2, { isPhoneVerified = p3.isPhoneVerified })
	end,
	[updateIsDiscoverabilityUnset.name] = function(p2, p3)
		return llama.Dictionary.join(p2, {
			isDiscoverabilityUnset = p3.isDiscoverabilityUnset
		})
	end
})
