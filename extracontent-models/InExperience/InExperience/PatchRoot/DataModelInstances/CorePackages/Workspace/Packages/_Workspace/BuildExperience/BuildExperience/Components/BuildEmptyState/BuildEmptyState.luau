local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Players = game:GetService("Players")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function BuildEmptyState(props)
	local localPlayer = Players.LocalPlayer
	local v = not localPlayer and "" or localPlayer.DisplayName
	local v2 = { subline = LocalizationStrings.BUILD_SUBLINE, title = 0 }
	local title

	if v == "" then
		title = LocalizationStrings.BUILD_GREETING
	else
		title = {
			LocalizationStrings.BUILD_GREETING_WITH_NAME,
			DISPLAY_NAME = v
		}
	end

	v2.title = title
	local v3 = useLocalization(v2)

	local v4 = useTokens()
	local size_1400 = v4.Size.Size_1400

	local subline = v3.subline
	local message = props.message or v3.title

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center gap-small auto-xy",
		testId = props.testId or "BuildEmptyState"
	}
	local v6 = {
		Nebula = React.createElement(Icon, {
			LayoutOrder = 1,
			name = IconName.Nebula,
			size = size_1400,
			style = v4.Color.Content.Emphasis
		}),
		Headings = 0
	}

	local createElement2 = React.createElement

	local v7 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = message,
			tag = "auto-xy text-heading-small content-emphasis"
		}),
		Subline = 0
	}
	local subline2

	if props.message == nil then
		subline2 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = subline,
			tag = "auto-xy text-body-medium content-default"
		})
	end

	v7.Subline = subline2
	v6.Headings = createElement2(View, {
		LayoutOrder = 2,
		tag = "col align-x-center gap-xxsmall auto-xy"
	}, v7)
	return createElement(View, v5, v6)
end

return BuildEmptyState
