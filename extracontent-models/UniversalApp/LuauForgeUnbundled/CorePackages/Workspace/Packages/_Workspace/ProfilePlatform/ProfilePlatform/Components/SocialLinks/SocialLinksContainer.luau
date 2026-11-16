local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local SocialLinksCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/SocialLinks/SocialLinksCarousel")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local socialMediaTypes = Enums.SocialMediaTypes

local images = UIBlox.App.ImageSet.Images

local v5 = {
	[socialMediaTypes.Twitter] = images["icons/brands/x"],
	[socialMediaTypes.Facebook] = images["icons/brands/facebook"],
	[socialMediaTypes.Discord] = images["icons/brands/discord"],
	[socialMediaTypes.YouTube] = images["icons/brands/youtube"],
	[socialMediaTypes.Twitch] = images["icons/brands/twitch"],
	[socialMediaTypes.Guilded] = images["icons/brands/guilded"],
	[socialMediaTypes.X] = images["icons/brands/x"]
}

return function(p2)
	local v6 = useProfileJsonComponent(Enums.Components.SocialLinks)
	local v7 = useLocalization({
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
			local v8 = v7[k]
			local v9 = v5[k]

			if item and v9 then
				table.insert(result, {
					key = k,
					logo = v5[k],
					url = item.url,
					name = v8
				})
			end
		end

		return result
	end

	local v8 = React.useMemo(function()
		return fn(v6)
	end, { v6, v7 })

	if #v8 > 0 then
		return React.createElement(SocialLinksCarousel, {
			layoutOrder = p2.layoutOrder,
			items = v8,
			title = p2.title
		})
	end

	return React.None
end
