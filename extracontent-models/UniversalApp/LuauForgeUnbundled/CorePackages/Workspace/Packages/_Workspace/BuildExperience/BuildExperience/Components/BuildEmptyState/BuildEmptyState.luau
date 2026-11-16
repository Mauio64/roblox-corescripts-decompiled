local Players = game:GetService("Players")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function BuildEmptyState(props)
	local localPlayer = Players.LocalPlayer
	local v5 = not localPlayer and "" or localPlayer.DisplayName
	local v7 = { subline = LocalizationStrings.BUILD_SUBLINE, title = 0 }
	local v8 = if v5 == "" then LocalizationStrings.BUILD_GREETING else {
		LocalizationStrings.BUILD_GREETING_WITH_NAME,
		DISPLAY_NAME = v5
	}
	v7.title = v8
	local v9 = useLocalization(v7)

	local v10 = useTokens()
	local size_1400 = v10.Size.Size_1400

	local subline = v9.subline
	local message = props.message or v9.title

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col align-x-center gap-small auto-xy",
		testId = props.testId or "BuildEmptyState"
	}
	local v13 = {
		Nebula = React.createElement(icon, {
			LayoutOrder = 1,
			name = iconName.Nebula,
			size = size_1400,
			style = v10.Color.Content.Emphasis
		}),
		Headings = 0
	}

	local createElement2 = React.createElement

	local v16 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = message,
			tag = "auto-xy text-heading-small content-emphasis"
		}),
		Subline = 0
	}

	local v17 = if props.message == nil then React.createElement(text, {
		LayoutOrder = 2,
		Text = subline,
		tag = "auto-xy text-body-medium content-default"
	}) else nil
	v16.Subline = v17
	v13.Headings = createElement2(
		view,
		{ LayoutOrder = 2, tag = "col align-x-center gap-xxsmall auto-xy" },
		v16
	)
	return createElement(view, v12, v13)
end

return BuildEmptyState
