local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	NotFriends = "nonfriend",
	Friends = "friend",
	RequestSent = "requestSent",
	RequestReceived = "requestReceived",
	Ineligible = "ineligible",
	Recommendation = "recommendation"
})
