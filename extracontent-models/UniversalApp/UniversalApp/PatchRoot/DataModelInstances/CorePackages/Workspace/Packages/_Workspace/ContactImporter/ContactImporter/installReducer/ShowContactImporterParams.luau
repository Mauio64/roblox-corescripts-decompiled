local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local SetContactImporterDisplayLogic = require(ParentParent.Actions.SetContactImporterDisplayLogic)
local UpdateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local SetIsPhoneVerified = require(ParentParent.Actions.SetIsPhoneVerified)
local UpdateIsDiscoverabilityUnset = dependencies.SocialModalsCommon.Actions.UpdateIsDiscoverabilityUnset
local Rodux = dependencies.Rodux
local llama = dependencies.llama
local Constants = require(ParentParent.Common.Constants)
local t1 = {
	[Constants.SHOULD_SHOW_CONTACT_IMPORTER_FEATURE] = false,
	[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = false,
	hasOSPermissions = false,
	isPhoneVerified = false,
	isDiscoverabilityUnset = false
}

return Rodux.createReducer(t1, {
	[SetContactImporterDisplayLogic.name] = function(_: {[any]: any}, p1) -- line: 40
		-- upvalues: Constants (copy)
		local hasOSPermissions = p1.hasOSPermissions
		local isPhoneVerified = p1.isPhoneVerified
		local shouldShowContactImporterUpsellAgain = p1.shouldShowContactImporterUpsellAgain
		local phoneNumberDiscoverability = p1.phoneNumberDiscoverability
		local v17 = hasOSPermissions and p1.isUserOptedInLocalStorage

		return {
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_FEATURE] = true,
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = not v17 and shouldShowContactImporterUpsellAgain,
			hasOSPermissions = hasOSPermissions,
			isPhoneVerified = isPhoneVerified,
			isDiscoverabilityUnset = phoneNumberDiscoverability == Constants.DISCOVERABILITY_UNSET
		}
	end,
	[UpdateContactImporterModalLogic.name] = function(t3: {[any]: any}, t4: {[any]: any}) -- line: 60
		-- upvalues: llama (copy), Constants (copy)
		return (llama.Dictionary.join(t3, {
			hasOSPermissions = t4.hasOSPermissions,
			[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL] = t4[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_MODAL]
		}))
	end,
	[SetIsPhoneVerified.name] = function(t5: {[any]: any}, p2) -- line: 68
		-- upvalues: llama (copy)
		return llama.Dictionary.join(t5, {
			isPhoneVerified = p2.isPhoneVerified
		})
	end,
	[UpdateIsDiscoverabilityUnset.name] = function(t6: {[any]: any}, t7: {[any]: any}) -- line: 73
		-- upvalues: llama (copy)
		return llama.Dictionary.join(t6, {
			isDiscoverabilityUnset = t7.isDiscoverabilityUnset
		})
	end
})
