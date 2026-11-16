local parent = script:FindFirstAncestor("AppChat").Parent

require(parent.MomentsTypes)

return {
	Moment = "moment",
	PlusReferral = "plusReferral",
	Unhandled = "unhandled",
	Invalid = "invalid"
}
