local parent = script:FindFirstAncestor("AppChat").Parent

local FFlagAppChatResolveShareLinkV2 = require(script.Parent.FFlagAppChatResolveShareLinkV2)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet

return game:DefineFastFlag("AppChatPlusReferralAssetCard", false)
	and FFlagAppChatResolveShareLinkV2
	and FFlagEnablePlusReferralLandingSheet
