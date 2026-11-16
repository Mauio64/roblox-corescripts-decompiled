local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

require(parent.HttpClient)

require(Gifting.Constants)
require(Gifting.Enums.ItemType)
require(Gifting.Enums.GiftEligibility)
require(Gifting.Enums.RequiredAction)
require(Gifting.Enums.UserRelationship)
require(Gifting.Enums.FailureReason)
require(Gifting.Enums.AmpRecourseAction)

return {}
