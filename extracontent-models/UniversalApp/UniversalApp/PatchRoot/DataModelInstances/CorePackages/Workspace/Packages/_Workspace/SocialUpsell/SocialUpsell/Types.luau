local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local Foundation = require(SocialUpsellParent.Foundation)

require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
require(SocialUpsell.Enum.SocialUpsellType)

local _ = Foundation.Enums.ButtonVariant

return {}
