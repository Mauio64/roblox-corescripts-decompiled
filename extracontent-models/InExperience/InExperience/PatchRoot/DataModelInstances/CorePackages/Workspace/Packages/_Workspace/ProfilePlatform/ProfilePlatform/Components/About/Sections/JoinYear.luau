local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local Localization = require(ProfilePlatformParent.Localization)
local BuilderIcons = require(ProfilePlatformParent.BuilderIcons)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FoundationText = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local InputSize = Foundation.Enums.InputSize
local IconVariant = Foundation.Enums.IconVariant
local CircleI = BuilderIcons.Icon.CircleI
local useLocalization = Localization.Hooks.useLocalization

local function JoinYear(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), View (copy), FoundationText (copy), Icon (copy), CircleI (copy), InputSize (copy), IconVariant (copy)
	if not t1.joinDateTime or t1.joinDateTime == "" then
		return nil
	end

	local match = string.match(t1.joinDateTime, "^(%d%d%d%d)")

	if not match then
		return nil
	end

	local v18 = useLocalization({
		statistics = TextKeys.Statistics,
		joinedInYear = {
			TextKeys.JoinedInYear,
			year = match
		}
	})

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-small align-x-left",
		LayoutOrder = t1.layoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-heading-small",
			Text = v18.statistics
		}),
		Content = React.createElement(View, {
			tag = "auto-xy size-0 row align-y-center gap-xsmall",
			LayoutOrder = t1.layoutOrder
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = CircleI,
				size = InputSize.XSmall,
				variant = IconVariant.Filled
			}),
			Text = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy size-0 text-align-x-left text-body-medium",
				Text = v18.joinedInYear
			})
		})
	})
end

return JoinYear
