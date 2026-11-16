local parent = script.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local EventNames = require(script.Parent.Enums.EventNames)
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)

local dash = dependencies.Dash
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local BtnValues = require(script.Parent.Enums.BtnValues)
local FieldNames = require(script.Parent.FieldNames)
local getFIntContactImporterUploadContactsMax = require(parent.Flags.getFIntContactImporterUploadContactsMax)
local getFIntContactImporterUploadContactsMin = require(parent.Flags.getFIntContactImporterUploadContactsMin)

local identity = dash.identity

local AnalyticsEvents = {
	[EventNames.ContactImportModalPageLoad] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalPageLoad
	},
	[EventNames.ContactImportModalContinue] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalClick,
		additionalInfo = { btn = BtnValues.ContactImporter }
	},
	[EventNames.ContactImportModalAddFriends] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalClick,
		additionalInfo = { btn = BtnValues.AddFriends },
		formatRulesForAdditionalInfo = { isLoaded = identity, loadingTime = identity }
	},
	[EventNames.ContactImportModalClose] = {
		context = Contexts.ContactImport,
		eventType = EventTypes.ContactImportModalClick,
		additionalInfo = { btn = BtnValues.Close },
		formatRulesForAdditionalInfo = { isLoaded = identity, loadingTime = identity }
	}
}

local ContactsListLoaded = EventNames.ContactsListLoaded
AnalyticsEvents[ContactsListLoaded] = {
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
}

AnalyticsEvents[EventNames.RequestFriendship] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.RequestFriendship },
	formatRulesForAdditionalInfo = { requestedId = identity }
}

AnalyticsEvents[EventNames.InviteContact] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.InviteContact, isShortUrlEnabled = true },
	formatRulesForAdditionalInfo = { offNetworkFriendRequestLinkId = identity }
}

AnalyticsEvents[EventNames.CloseContactListButton] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.CloseContactListButton },
	formatRulesForAdditionalInfo = { isLoading = identity, loadingTime = identity }
}

AnalyticsEvents[EventNames.CloseContactListCross] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.CloseContactListCross },
	formatRulesForAdditionalInfo = { isLoading = identity, loadingTime = identity }
}

local ContactImportingTime = EventNames.ContactImportingTime
AnalyticsEvents[ContactImportingTime] = {
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
}

AnalyticsEvents[EventNames.PhoneVerificationWebview] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.NavigateToPhoneVerification
}

AnalyticsEvents[EventNames.PhoneVerificationClose] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.PhoneVerificationClose,
	formatRulesForAdditionalInfo = { isPhoneVerified = identity }
}

AnalyticsEvents[EventNames.FindFriendsButtonClicked] = {
	context = Contexts.ContactImport,
	eventType = EventTypes.ButtonClick,
	additionalInfo = { btn = BtnValues.FindFriendsButton }
}
return AnalyticsEvents
