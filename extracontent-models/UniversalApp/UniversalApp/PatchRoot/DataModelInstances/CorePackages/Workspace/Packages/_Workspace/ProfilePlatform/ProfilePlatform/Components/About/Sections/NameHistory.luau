local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local Localization = require(ProfilePlatformParent.Localization)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization

local function NameHistory(t1: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), View (copy), FoundationText (copy)
	local v12 = useLocalization({
		previousNames = TextKeys.PreviousNames,
		noPreviousName = TextKeys.NoPreviousName
	})
	local v13 = if not not t1.nameHistory and #t1.nameHistory ~= 0 then table.concat(t1.nameHistory, ", ") else v12.noPreviousName

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-small align-x-left",
		LayoutOrder = t1.layoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-heading-small",
			Text = v12.previousNames
		}),
		Content = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0 text-align-x-left text-body-medium text-wrap",
			RichText = true,
			Text = v13
		})
	})
end

return NameHistory
