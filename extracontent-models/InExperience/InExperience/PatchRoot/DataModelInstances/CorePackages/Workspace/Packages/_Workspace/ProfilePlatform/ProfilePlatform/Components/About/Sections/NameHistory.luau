local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local Text = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization

local function NameHistory(p)
	local v = useLocalization({
		previousNames = TextKeys.PreviousNames,
		noPreviousName = TextKeys.NoPreviousName
	})
	local text

	if p.nameHistory and #p.nameHistory ~= 0 then
		text = table.concat(p.nameHistory, ", ")
	else
		text = v.noPreviousName
	end

	return React.createElement(
		View,
		{ LayoutOrder = p.layoutOrder, tag = "col size-full-0 auto-y gap-small align-x-left" },
		{
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-y size-full-0 text-align-x-left text-heading-small",
				Text = v.previousNames
			}),
			Content = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "auto-y size-full-0 text-align-x-left text-body-medium text-wrap",
				Text = text,
				RichText = true
			})
		}
	)
end

return NameHistory
