local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Localization = require(ProfilePlatformParent.Localization)
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local FFlagProfileAboutDetailsUseSheet = require(ProfilePlatformParent.SharedFlags).FFlagProfileAboutDetailsUseSheet

local function AboutDescription(t1: {[any]: any}) -- line: 19
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), View (copy), FFlagProfileAboutDetailsUseSheet (copy), FoundationText (copy)
	local v13 = useLocalization({
		about = TextKeys.About,
		aboutHeading = {
			TextKeys.AboutDetailsHeading,
			name = t1.name
		},
		noBioYet = TextKeys.NoBioYet
	})
	local description = t1.description

	if description == nil or description == "" then
		description = v13.noBioYet
	end

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-small align-x-left",
		LayoutOrder = t1.layoutOrder
	}, {
		AboutTitle = if FFlagProfileAboutDetailsUseSheet then nil else React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left",
			Text = if not t1.name then v13.about else v13.aboutHeading
		}),
		AboutDescription = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			Text = description
		})
	})
end

return AboutDescription
