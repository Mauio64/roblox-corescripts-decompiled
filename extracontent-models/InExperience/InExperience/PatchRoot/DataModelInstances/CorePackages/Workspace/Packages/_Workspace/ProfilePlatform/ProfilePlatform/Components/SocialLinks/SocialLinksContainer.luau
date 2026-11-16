local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local SocialLinksCarousel = require(ProfilePlatform.Components.SocialLinks.SocialLinksCarousel)
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local SocialMediaTypes = Enums.SocialMediaTypes

local Images = UIBlox.App.ImageSet.Images

local v = {
	[SocialMediaTypes.Twitter] = Images["icons/brands/x"],
	[SocialMediaTypes.Facebook] = Images["icons/brands/facebook"],
	[SocialMediaTypes.Discord] = Images["icons/brands/discord"],
	[SocialMediaTypes.YouTube] = Images["icons/brands/youtube"],
	[SocialMediaTypes.Twitch] = Images["icons/brands/twitch"],
	[SocialMediaTypes.Guilded] = Images["icons/brands/guilded"],
	[SocialMediaTypes.X] = Images["icons/brands/x"]
}

return function(p)
	local v2 = useProfileJsonComponent(Enums.Components.SocialLinks)
	local v3 = useLocalization({
		facebook = TextKeys.Facebook,
		twitter = TextKeys.X,
		youtube = TextKeys.YouTube,
		twitch = TextKeys.Twitch,
		guilded = TextKeys.Guilded,
		discord = TextKeys.Discord,
		x = TextKeys.X
	})

	local function fn(items)
		local result = {}

		for k, item in pairs(items) do
			local name = v3[k]
			local v4 = v[k]

			if item and v4 then
				table.insert(result, { key = k, logo = v[k], url = item.url, name = name })
			end
		end

		return result
	end

	local items = React.useMemo(function()
		return fn(v2)
	end, { v2, v3 })

	if #items > 0 then
		return React.createElement(SocialLinksCarousel, {
			layoutOrder = p.layoutOrder,
			items = items,
			title = p.title
		})
	end

	return React.None
end
