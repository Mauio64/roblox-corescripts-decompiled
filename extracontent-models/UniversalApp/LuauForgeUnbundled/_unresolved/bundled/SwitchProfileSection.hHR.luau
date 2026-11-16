local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local module2 = require("@luauforge/bundled/hHN")
local module3 = require("@luauforge/bundled/hHS")
local bodyText = require("@luauforge/bundled/hHO").BodyText
require("@luauforge/bundled/hHQ")

local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function onSwitchProfile()
	if ThirdPartyUserService then
		ThirdPartyUserService:ShowAccountPicker()
	end
end

local function SwitchProfileSection(props)
	local v5 = useAppPolicy(function(p2)
		return p2.getPlatformDisplayName()
	end)

	local v6 = useLocalization({
		title = props.titleKey,
		switchProfile = "Feature.Settings.Heading.SwitchProfile",
		switchProfileDescription = {
			"Feature.Settings.Description.SwitchProfile",
			platform = v5
		},
		open = "Feature.Settings.Label.Open"
	})

	return React.createElement(
		module2,
		{
			layoutOrder = props.layoutOrder,
			withDivider = props.withDivider,
			title = v6.title
		},
		{
			React.createElement(module3, {
				layoutOrder = 1,
				title = v6.switchProfile,
				status = v6.open,
				onActivated = onSwitchProfile
			}),
			React.createElement(bodyText, {
				layoutOrder = 2,
				text = v6.switchProfileDescription
			})
		}
	)
end

return SwitchProfileSection
