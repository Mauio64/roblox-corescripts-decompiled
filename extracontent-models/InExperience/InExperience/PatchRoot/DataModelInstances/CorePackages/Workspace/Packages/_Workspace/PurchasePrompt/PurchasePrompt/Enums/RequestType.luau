local createEnum = require(script.Parent.createEnum)

return (createEnum("RequestType", {
	"None",
	"Asset",
	"Bundle",
	"GamePass",
	"Product",
	"Subscription",
	"AvatarCreationFee",
	"Experience",
	"Look",
	"DeveloperSubscription",
	"RobuxUpsell",
	"VIPServer"
}))
