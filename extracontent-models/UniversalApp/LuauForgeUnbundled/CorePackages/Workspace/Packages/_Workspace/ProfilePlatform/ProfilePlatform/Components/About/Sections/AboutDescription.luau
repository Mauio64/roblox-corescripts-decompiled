local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization
local fFlagProfileAboutDetailsUseSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileAboutDetailsUseSheet

local function AboutDescription(props)
	local v5 = useLocalization({
		about = TextKeys.About,
		aboutHeading = {
			TextKeys.AboutDetailsHeading,
			name = props.name
		},
		noBioYet = TextKeys.NoBioYet
	})

	local v6 = props.description

	if v6 == nil or v6 == "" then
		v6 = v5.noBioYet
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.layoutOrder,
		tag = "col size-full-0 auto-y gap-small align-x-left"
	}
	local v10

	if not fFlagProfileAboutDetailsUseSheet then
		local createElement2 = React.createElement

		local v13 = if props.name then v5.aboutHeading else v5.about
		v10 = createElement2(text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left",
			Text = v13
		})
	end

	return createElement(view, v8, {
		AboutTitle = v10,
		AboutDescription = React.createElement(text, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			Text = v6
		})
	})
end

return AboutDescription
