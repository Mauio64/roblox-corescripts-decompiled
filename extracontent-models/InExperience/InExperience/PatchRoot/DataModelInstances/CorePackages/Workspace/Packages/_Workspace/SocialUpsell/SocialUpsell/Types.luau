local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local Foundation = require(parent.Foundation)
require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
require(SocialUpsell.Enum.SocialUpsellType)

local ButtonVariant = Foundation.Enums.ButtonVariant

return {}
