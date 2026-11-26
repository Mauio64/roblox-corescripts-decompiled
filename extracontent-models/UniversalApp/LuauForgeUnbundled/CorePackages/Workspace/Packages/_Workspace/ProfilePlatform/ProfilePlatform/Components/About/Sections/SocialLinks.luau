local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local useLocalization = Localization.Hooks.useLocalization
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local inputSize = Foundation.Enums.InputSize
local buttonVariant = Foundation.Enums.ButtonVariant

local v5 = {
	x = "icons/brands/x",
	facebook = "icons/brands/facebook",
	youtube = "icons/brands/youtube",
	twitch = "icons/brands/twitch",
	guilded = "icons/brands/guilded"
}

local v6 = { "facebook", "x", "youtube", "twitch", "guilded" }

local function SocialLinks(p2)
	local v7 = useLocalization({
		socialLinks = TextKeys.SocialLinks,
		noSocialLink = TextKeys.NoSocialLink
	})

	local children = {}

	if p2.socialLinks then
		for i, v8 in ipairs(v6) do
			local socialLink = p2.socialLinks[v8]

			if socialLink and socialLink.target then
				children[v8] = React.createElement(button, {
					LayoutOrder = i,
					Selectable = false,
					tag = "auto-y size-full-0 padding-left-small padding-right-small no-hover",
					text = socialLink.target,
					icon = v5[v8],
					size = inputSize.Small,
					variant = buttonVariant.Utility,
					onActivated = function() end
				})
			end
		end
	end

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = p2.layoutOrder,
		tag = "col size-full-0 auto-y gap-small align-x-left"
	}

	local v10 = {
		SocialLinksTitle = React.createElement(text, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-heading-small",
			Text = v7.socialLinks
		}),
		LinksContainer = 0
	}

	local v11 = if p2.socialLinks then React.createElement(
		view,
		{ LayoutOrder = 2, tag = "row wrap size-full-0 auto-xy gap-small align-x-left" },
		children
	) else React.createElement(text, {
		LayoutOrder = 2,
		tag = "auto-y size-full-0 text-align-x-left text-body-medium",
		Text = v7.noSocialLink
	})
	v10.LinksContainer = v11
	return createElement(view, v9, v10)
end

return SocialLinks
