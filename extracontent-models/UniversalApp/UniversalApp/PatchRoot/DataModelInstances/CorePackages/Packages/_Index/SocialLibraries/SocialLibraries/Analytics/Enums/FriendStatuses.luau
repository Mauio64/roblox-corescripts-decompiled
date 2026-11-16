local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	NotFriends = "nonfriend",
	Friends = "friend",
	RequestSent = "requestSent",
	RequestReceived = "requestReceived",
	Ineligible = "ineligible",
	Recommendation = "recommendation"
})
