local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ShareLinkTypes = require(Modules.LuaApp.DeepLinks.ShareLinks.ShareLinkTypes)
local getDeepValue = require(script.Parent.dependencies).SocialLibraries.Dictionary.getDeepValue
local LinkStatus = require(script.Parent.LinkStatus)

require(script.Parent.Types)

local FFlagEnableLookDetailsDeepLink = require(Modules.LuaApp.Flags.FFlagEnableLookDetailsDeepLink)

return function(p1, p2) -- line: 19
	-- upvalues: getDeepValue (copy), AvatarScreen (copy), Constants (copy), Cryo (copy), LinkStatus (copy), ShareLinkTypes (copy), FFlagEnableLookDetailsDeepLink (copy)
	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics
	local v14 = getDeepValue(p1, "responseBody.avatarItemDetailsData") or {}
	local itemType = v14.itemType

	if not itemType or (not v14.itemId or v14.itemId == "" or v14.itemId == "0") then
		return {{
			{
				name = AvatarScreen.AvatarExperienceLandingPage
			},
			{
				name = AvatarScreen.Catalog
			}
		}}
	end

	local str = tostring(v14.itemId)
	local v17 = nil

	for _, v19 in Constants.ItemType do
		if string.lower(itemType) == string.lower(v19) then
			v17 = v19

			break
		end
	end

	local v20 = Cryo.Dictionary.join(p1, {
		responseBody = Cryo.None,
		type = Cryo.None,
		linkStatus = LinkStatus.Valid,
		linkId = str,
		linkType = ShareLinkTypes.AvatarItemDetails .. v17
	})

	shareLinksAnalytics.resolveLink(v20)

	local v21 = v17 .. str

	return {{
		{
			name = AvatarScreen.AvatarExperienceLandingPage
		},
		{
			name = AvatarScreen.Catalog
		},
		{
			name = if not FFlagEnableLookDetailsDeepLink or v17 ~= Constants.ItemType.Look then AvatarScreen.ItemDetails else AvatarScreen.LookDetails,
			detail = v21,
			extraProps = {
				mountAsFullView = true,
				mountAnimation = false,
				itemId = str,
				itemType = v17
			}
		}
	}}
end
