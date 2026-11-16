local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local SetContactImporterDisplayLogic = require(parent.Actions.SetContactImporterDisplayLogic)
local updateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local SetIsPhoneVerified = require(parent.Actions.SetIsPhoneVerified)
local updateIsDiscoverabilityUnset = dependencies.SocialModalsCommon.Actions.UpdateIsDiscoverabilityUnset

local rodux = dependencies.Rodux
local llama = dependencies.llama
local Constants = require(parent.Common.Constants)

local v = {
	[Constants.SHOULD_SHOW_CONTACT_IMPORTER_FEATURE] = false,
	[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = false,
	hasOSPermissions = false,
	isPhoneVerified = false,
	isDiscoverabilityUnset = false
}

return rodux.createReducer(v, {
	[SetContactImporterDisplayLogic.name] = function(_, data)
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
	[updateContactImporterModalLogic.name] = function(p, p2)
		return (llama.Dictionary.join(p, {
			hasOSPermissions = p2.hasOSPermissions,
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = p2[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL]
		}))
	end,
	[SetIsPhoneVerified.name] = function(p, p2)
		return llama.Dictionary.join(p, { isPhoneVerified = p2.isPhoneVerified })
	end,
	[updateIsDiscoverabilityUnset.name] = function(p, p2)
		return llama.Dictionary.join(p, { isDiscoverabilityUnset = p2.isDiscoverabilityUnset })
	end
})
