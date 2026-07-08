local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	ContactsNotSupported = "contactsNotSupported"
})
