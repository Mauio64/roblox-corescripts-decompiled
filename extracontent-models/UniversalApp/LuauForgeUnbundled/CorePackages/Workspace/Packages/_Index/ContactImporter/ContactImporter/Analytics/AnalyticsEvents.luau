local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/EventNames")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialLuaAnalytics")

local dash = dependencies.Dash
local enums = SocialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes
local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/BtnValues")
local FieldNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/FieldNames")
local getFIntContactImporterUploadContactsMax = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterUploadContactsMax")
local getFIntContactImporterUploadContactsMin = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterUploadContactsMin")

local identity = dash.identity

local v5 = {
	[EventNames.ContactImportModalPageLoad] = {
		context = contexts.ContactImport,
		eventType = eventTypes.ContactImportModalPageLoad
	},
	[EventNames.ContactImportModalContinue] = {
		context = contexts.ContactImport,
		eventType = eventTypes.ContactImportModalClick,
		additionalInfo = { btn = BtnValues.ContactImporter }
	},
	[EventNames.ContactImportModalAddFriends] = {
		context = contexts.ContactImport,
		eventType = eventTypes.ContactImportModalClick,
		additionalInfo = { btn = BtnValues.AddFriends },
		formatRulesForAdditionalInfo = { isLoaded = identity, loadingTime = identity }
	},
	[EventNames.ContactImportModalClose] = {
		context = contexts.ContactImport,
		eventType = eventTypes.ContactImportModalClick,
		additionalInfo = { btn = BtnValues.Close },
		formatRulesForAdditionalInfo = { isLoaded = identity, loadingTime = identity }
	}
}

local contactsListLoaded = EventNames.ContactsListLoaded
v5[contactsListLoaded] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ContactsListLoaded,
	formatRulesForAdditionalInfo = {
		[FieldNames.NumTotalContactsImported] = identity,
		[FieldNames.NumMatchedContacts] = identity,
		didBypassFetchContacts = identity,
		[FieldNames.NumTotalContactsOnDevice] = identity,
		[FieldNames.NumMaxContacts] = getFIntContactImporterUploadContactsMax,
		[FieldNames.NumMinContacts] = getFIntContactImporterUploadContactsMin
	}
}

v5[EventNames.RequestFriendship] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.RequestFriendship },
	formatRulesForAdditionalInfo = { requestedId = identity }
}

v5[EventNames.InviteContact] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.InviteContact, isShortUrlEnabled = true },
	formatRulesForAdditionalInfo = { offNetworkFriendRequestLinkId = identity }
}

v5[EventNames.CloseContactListButton] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.CloseContactListButton },
	formatRulesForAdditionalInfo = { isLoading = identity, loadingTime = identity }
}

v5[EventNames.CloseContactListCross] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.CloseContactListCross },
	formatRulesForAdditionalInfo = { isLoading = identity, loadingTime = identity }
}

local contactImportingTime = EventNames.ContactImportingTime
v5[contactImportingTime] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ContactImportingTime,
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
}

v5[EventNames.PhoneVerificationWebview] = {
	context = contexts.ContactImport,
	eventType = eventTypes.NavigateToPhoneVerification
}

v5[EventNames.PhoneVerificationClose] = {
	context = contexts.ContactImport,
	eventType = eventTypes.PhoneVerificationClose,
	formatRulesForAdditionalInfo = { isPhoneVerified = identity }
}

v5[EventNames.FindFriendsButtonClicked] = {
	context = contexts.ContactImport,
	eventType = eventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.FindFriendsButton }
}
return v5
