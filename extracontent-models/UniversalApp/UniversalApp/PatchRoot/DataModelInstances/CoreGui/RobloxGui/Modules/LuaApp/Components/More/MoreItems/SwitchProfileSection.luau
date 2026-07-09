local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local MoreSection = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreSection)
local MoreStatusButton = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreStatusButton)
local BodyText = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreText).BodyText

require(script.Parent.Types)

local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function onSwitchProfile() -- line: 19
	-- upvalues: ThirdPartyUserService (copy)
	if ThirdPartyUserService then
		ThirdPartyUserService:ShowAccountPicker()
	end
end
local function SwitchProfileSection(p1) -- line: 25
	-- upvalues: useAppPolicy (copy), useLocalization (copy), React (copy), MoreSection (copy), MoreStatusButton (copy), onSwitchProfile (copy), BodyText (copy)
	local v13 = useAppPolicy(function(p2) -- line: 26
		return p2.getPlatformDisplayName()
	end)
	local v14 = useLocalization({
		switchProfile = "Feature.Settings.Heading.SwitchProfile",
		open = "Feature.Settings.Label.Open",
		title = p1.titleKey,
		switchProfileDescription = {
			"Feature.Settings.Description.SwitchProfile",
			platform = v13
		}
	})

	return React.createElement(MoreSection, {
		layoutOrder = p1.layoutOrder,
		withDivider = p1.withDivider,
		title = v14.title
	}, {
		React.createElement(MoreStatusButton, {
			layoutOrder = 1,
			title = v14.switchProfile,
			status = v14.open,
			onActivated = onSwitchProfile
		}),
		React.createElement(BodyText, {
			layoutOrder = 2,
			text = v14.switchProfileDescription
		})
	})
end

return SwitchProfileSection
