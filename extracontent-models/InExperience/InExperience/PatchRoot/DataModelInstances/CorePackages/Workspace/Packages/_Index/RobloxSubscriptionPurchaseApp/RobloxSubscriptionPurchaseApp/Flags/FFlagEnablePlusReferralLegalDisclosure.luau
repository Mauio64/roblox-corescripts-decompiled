local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet

return game:DefineFastFlag("EnablePlusReferralLegalDisclosure", false) and FFlagEnablePlusReferralLandingSheet
