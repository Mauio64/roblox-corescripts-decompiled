local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/hMx")

local getDeepValue = require("@luauforge/bundled/hZG").SocialLibraries.Dictionary.getDeepValue

local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
require("@luauforge/bundled/hZh")

local module4 = require("@luauforge/bundled/goM")
local module5 = require("@luauforge/bundled/hZV")

local fFlagEnableMarketplacePurchaseDeepLinkAttribution = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMarketplacePurchaseDeepLinkAttribution

return function(p2, p3)
	local shareLinksAnalytics = p3.analyticsImpls.shareLinksAnalytics
	local v5 = getDeepValue(p2, "responseBody.avatarItemDetailsData") or {}
	local itemType = v5.itemType

	if not itemType or not v5.itemId or v5.itemId == "" or v5.itemId == "0" then
		return {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog }
			}
		}
	end

	local itemId = tostring(v5.itemId)
	local v6 = nil

	for k, v8 in module.ItemType do
		if string.lower(itemType) == string.lower(v8) then
			v6 = v8
			break
		end
	end

	local v8

	if module5 and string.lower(p2.linkType) == string.lower(module2.AvatarItemAffiliate) then
		v8 = module2.AvatarItemAffiliate
	else
		v8 = module2.AvatarItemDetails
	end

	local joined = Cryo.Dictionary.join(p2, {
		responseBody = Cryo.None,
		type = Cryo.None,
		linkStatus = ExperienceInviteStatus.Valid,
		linkId = itemId,
		linkType = v8 .. v6
	})

	shareLinksAnalytics.resolveLink(joined)
	local linkId

	if fFlagEnableMarketplacePurchaseDeepLinkAttribution and v8 == module2.AvatarItemAffiliate then
		linkId = p2.linkId
	end

	local v9 = v6 .. itemId

	local v12 = { name = avatarScreen.AvatarExperienceLandingPage }
	local v13 = { name = avatarScreen.Catalog }

	local v15 = if module4 and v6 == module.ItemType.Look then avatarScreen.LookDetails else avatarScreen.ItemDetails
	return {
		{
			v12,
			v13,
			{
				name = v15,
				detail = v9,
				extraProps = {
					itemId = itemId,
					itemType = v6,
					mountAsFullView = true,
					mountAnimation = false,
					deepLinkId = linkId
				}
			}
		}
	}
end
