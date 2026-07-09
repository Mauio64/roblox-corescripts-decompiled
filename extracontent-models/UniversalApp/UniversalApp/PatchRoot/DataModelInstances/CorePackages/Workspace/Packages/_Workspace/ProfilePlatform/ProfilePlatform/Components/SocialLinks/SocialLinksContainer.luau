local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local SocialLinksCarousel = require(ProfilePlatform.Components.SocialLinks.SocialLinksCarousel)
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local SocialMediaTypes = Enums.SocialMediaTypes
local Images = UIBlox.App.ImageSet.Images
local t1 = {
	[SocialMediaTypes.Twitter] = Images["icons/brands/x"],
	[SocialMediaTypes.Facebook] = Images["icons/brands/facebook"],
	[SocialMediaTypes.Discord] = Images["icons/brands/discord"],
	[SocialMediaTypes.YouTube] = Images["icons/brands/youtube"],
	[SocialMediaTypes.Twitch] = Images["icons/brands/twitch"],
	[SocialMediaTypes.Guilded] = Images["icons/brands/guilded"],
	[SocialMediaTypes.X] = Images["icons/brands/x"]
}

return function(t2: {[any]: any}) -- line: 31
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), useLocalization (copy), TextKeys (copy), t1 (copy), React (copy), SocialLinksCarousel (copy)
	local v14 = useProfileJsonComponent(Enums.Components.SocialLinks)
	local v15 = useLocalization({
		facebook = TextKeys.Facebook,
		twitter = TextKeys.X,
		youtube = TextKeys.YouTube,
		twitch = TextKeys.Twitch,
		guilded = TextKeys.Guilded,
		discord = TextKeys.Discord,
		x = TextKeys.X
	})

	local function v16(p1) -- line: 43
		-- upvalues: v15 (copy), t1 (copy)
		local t3 = {}

		for k, v in pairs(p1) do
			local v22 = v15[k]
			local v23 = t1[k]

			if v and v23 then
				table.insert(t3, {
					key = k,
					logo = t1[k],
					url = v.url,
					name = v22
				})
			end
		end

		return t3
	end

	local v17 = React.useMemo(function() -- line: 60
		-- upvalues: v16 (copy), v14 (copy)
		return (v16(v14))
	end, {
		v14,
		v15
	})

	if #v17 > 0 then
		return React.createElement(SocialLinksCarousel, {
			layoutOrder = t2.layoutOrder,
			items = v17,
			title = t2.title
		})
	end

	return React.None
end
