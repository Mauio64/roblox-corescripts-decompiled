local Parent = script:FindFirstAncestor("SocialUpsell").Parent
local FFlagMakeVPCFAECheckMoreGeneric = require(Parent.SharedFlags).FFlagMakeVPCFAECheckMoreGeneric

return game:DefineFastFlag("SupportVPC", false) and FFlagMakeVPCFAECheckMoreGeneric
