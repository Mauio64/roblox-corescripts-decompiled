local parent = script:FindFirstAncestor("InExperienceShop").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBonusJwtInShop = SharedFlags.FFlagEnableBonusJwtInShop

return game:DefineFastFlag("RefetchRobuxWidgetAfterPurchase", false) and FFlagEnableBonusJwtInShop
