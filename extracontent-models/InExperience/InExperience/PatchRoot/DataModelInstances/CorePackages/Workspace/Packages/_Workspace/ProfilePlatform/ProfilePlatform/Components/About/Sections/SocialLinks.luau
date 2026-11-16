local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local useLocalization = Localization.Hooks.useLocalization
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local v = {
	x = "icons/brands/x",
	facebook = "icons/brands/facebook",
	youtube = "icons/brands/youtube",
	twitch = "icons/brands/twitch",
	guilded = "icons/brands/guilded"
}

local v2 = { "facebook", "x", "youtube", "twitch", "guilded" }

local function SocialLinks(p)
	local v3 = useLocalization({
		socialLinks = TextKeys.SocialLinks,
		noSocialLink = TextKeys.NoSocialLink
	})

	local children = {}

	if p.socialLinks then
		for i, v4 in ipairs(v2) do
			local socialLink = p.socialLinks[v4]

			if socialLink and socialLink.target then
				children[v4] = React.createElement(Button, {
					LayoutOrder = i,
					Selectable = false,
					tag = "auto-y size-full-0 padding-left-small padding-right-small no-hover",
					text = socialLink.target,
					icon = v[v4],
					size = InputSize.Small,
					variant = ButtonVariant.Utility,
					onActivated = function() end
				})
			end
		end
	end

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = p.layoutOrder,
		tag = "col size-full-0 auto-y gap-small align-x-left"
	}

	local v5 = {
		SocialLinksTitle = React.createElement(Text, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-heading-small",
			Text = v3.socialLinks
		}),
		LinksContainer = 0
	}
	local linksContainer

	if p.socialLinks then
		linksContainer = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "row wrap size-full-0 auto-xy gap-small align-x-left" },
			children
		)
	else
		linksContainer = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0 text-align-x-left text-body-medium",
			Text = v3.noSocialLink
		})
	end

	v5.LinksContainer = linksContainer
	return createElement(View, v4, v5)
end

return SocialLinks
