local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local EventNames = require(script.Parent.Enums.EventNames)
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local Dash = dependencies.Dash
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local BtnValues = require(script.Parent.Enums.BtnValues)
local FieldNames = require(script.Parent.FieldNames)
local getFIntContactImporterUploadContactsMax = require(ParentParent.Flags.getFIntContactImporterUploadContactsMax)
local getFIntContactImporterUploadContactsMin = require(ParentParent.Flags.getFIntContactImporterUploadContactsMin)
local identity = Dash.identity

return {
	[EventNames.ContactImportModalPageLoad] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalPageLoad
	},
	[EventNames.ContactImportModalContinue] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalClick,
		additionalInfo = {
			btn = BtnValues.ContactImporter
		}
	},
	[EventNames.ContactImportModalAddFriends] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalClick,
		additionalInfo = {
			btn = BtnValues.AddFriends
		},
		formatRulesForAdditionalInfo = {
			isLoaded = identity,
			loadingTime = identity
		}
	},
	[EventNames.ContactImportModalClose] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalClick,
		additionalInfo = {
			btn = BtnValues.Close
		},
		formatRulesForAdditionalInfo = {
			isLoaded = identity,
			loadingTime = identity
		}
	},
	[EventNames.ContactsListLoaded] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactsListLoaded,
		formatRulesForAdditionalInfo = {
			[FieldNames.NumTotalContactsImported] = identity,
			[FieldNames.NumMatchedContacts] = identity,
			didBypassFetchContacts = identity,
			[FieldNames.NumTotalContactsOnDevice] = identity,
			[FieldNames.NumMaxContacts] = getFIntContactImporterUploadContactsMax,
			[FieldNames.NumMinContacts] = getFIntContactImporterUploadContactsMin
		}
	},
	[EventNames.RequestFriendship] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.RequestFriendship
		},
		formatRulesForAdditionalInfo = {
			requestedId = identity
		}
	},
	[EventNames.InviteContact] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			isShortUrlEnabled = true,
			btn = BtnValues.InviteContact
		},
		formatRulesForAdditionalInfo = {
			offNetworkFriendRequestLinkId = identity
		}
	},
	[EventNames.CloseContactListButton] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.CloseContactListButton
		},
		formatRulesForAdditionalInfo = {
			isLoading = identity,
			loadingTime = identity
		}
	},
	[EventNames.CloseContactListCross] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.CloseContactListCross
		},
		formatRulesForAdditionalInfo = {
			isLoading = identity,
			loadingTime = identity
		}
	},
	[EventNames.ContactImportingTime] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportingTime,
		formatRulesForAdditionalInfo = {
			isSuccessfulUpload = identity,
			failedStep = identity,
			[FieldNames.NumTotalContactsImported] = identity,
			[FieldNames.NumMatchedContacts] = identity,
			loadingTime = identity,
			didBypassFetchContacts = identity,
			[FieldNames.NumTotalContactsOnDevice] = identity,
			[FieldNames.NumMaxContacts] = getFIntContactImporterUploadContactsMax,
			[FieldNames.NumMinContacts] = getFIntContactImporterUploadContactsMin
		}
	},
	[EventNames.PhoneVerificationWebview] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.NavigateToPhoneVerification
	},
	[EventNames.PhoneVerificationClose] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.PhoneVerificationClose,
		formatRulesForAdditionalInfo = {
			isPhoneVerified = identity
		}
	},
	[EventNames.FindFriendsButtonClicked] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FindFriendsButton
		}
	}
}
