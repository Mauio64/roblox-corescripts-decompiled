local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	ContactImportModalPageLoad = "Contactimportmodalpageload",
	ContactImportModalContinue = "contactImportModalClickHome",
	ContactImportModalClose = "contactImportModalClose",
	ContactImportModalAddFriends = "ContactImportModalAddFriends",
	ContactsListLoaded = "contactsListLoaded",
	RequestFriendship = "requestFriendship",
	InviteContact = "inviteContact",
	ContactImportingTime = "contactImportingTime",
	CloseContactListButton = "closeContactListButton",
	CloseContactListCross = "closeContactListCross",
	PhoneVerificationWebview = "phoneVerificationWebview",
	PhoneVerificationClose = "phoneVerificationClose",
	FailedGetContactsFromDevice = "failedGetContactsFromDevice",
	FailedFormatContactsFromDevice = "failedFormatContactsFromDevice",
	FailedUploadContactsFromDevice = "failedUploadContactsFromDevice",
	FailedFindContacts = "failedFindContacts",
	FailedGetContactEntities = "failedGetContactEntities",
	FindFriendsButtonClicked = "findFriendsButtonClicked"
})
