local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Localization = require(parent.Localization)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet

local function AboutDescription(props)
	local v = useLocalization({
		about = TextKeys.About,
		aboutHeading = {
			TextKeys.AboutDetailsHeading,
			name = props.name
		},
		noBioYet = TextKeys.NoBioYet
	})

	local text = props.description

	if text == nil or text == "" then
		text = v.noBioYet
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col size-full-0 auto-y gap-small align-x-left"
	}
	local aboutTitle

	if not FFlagProfileAboutDetailsUseSheet then
		local createElement2 = React.createElement

		local text2 = if props.name then v.aboutHeading else v.about
		aboutTitle = createElement2(Text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left",
			Text = text2
		})
	end

	return createElement(View, v2, {
		AboutTitle = aboutTitle,
		AboutDescription = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			Text = text
		})
	})
end

return AboutDescription
