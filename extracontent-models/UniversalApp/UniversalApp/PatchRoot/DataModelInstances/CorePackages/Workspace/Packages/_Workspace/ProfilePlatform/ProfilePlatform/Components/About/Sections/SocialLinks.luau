local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local Localization = require(ProfilePlatformParent.Localization)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local InputSize = Foundation.Enums.InputSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local t1 = {
	x = "icons/brands/x",
	facebook = "icons/brands/facebook",
	youtube = "icons/brands/youtube",
	twitch = "icons/brands/twitch",
	guilded = "icons/brands/guilded"
}
local t2 = {
	"facebook",
	"x",
	"youtube",
	"twitch",
	"guilded"
}

local function SocialLinks(t3: {[any]: any}) -- line: 44
	-- upvalues: useLocalization (copy), TextKeys (copy), t2 (copy), React (copy), Button (copy), t1 (copy), InputSize (copy), ButtonVariant (copy), View (copy), FoundationText (copy)
	local v17 = useLocalization({
		socialLinks = TextKeys.SocialLinks,
		noSocialLink = TextKeys.NoSocialLink
	})
	local t4 = {}

	if t3.socialLinks then
		for i, v in ipairs(t2) do
			local v21 = t3.socialLinks[v]

			if v21 and v21.target then
				t4[v] = React.createElement(Button, {
					Selectable = false,
					tag = "auto-y size-full-0 padding-left-small padding-right-small no-hover",
					LayoutOrder = i,
					text = v21.target,
					icon = t1[v],
					size = InputSize.Small,
					variant = ButtonVariant.Utility,
					onActivated = function() -- line: 60
					end
				})
			end
		end
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-small align-x-left",
		LayoutOrder = t3.layoutOrder
	}, {
		SocialLinksTitle = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-heading-small",
			Text = v17.socialLinks
		}),
		LinksContainer = if not t3.socialLinks then React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0 text-align-x-left text-body-medium",
			Text = v17.noSocialLink
		}) else React.createElement(View, {
			LayoutOrder = 2,
			tag = "row wrap size-full-0 auto-xy gap-small align-x-left"
		}, t4)
	})
end

return SocialLinks
