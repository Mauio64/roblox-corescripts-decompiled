local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local SettingReactView = require(CorePackages.Workspace.Packages.SettingReactView)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)

local parent = script.Parent.Parent
local InExperienceMenuReact = require(parent.InExperienceMenuReact)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local useLocalization = Localization.Hooks.useLocalization
local HeaderText = SettingReactView.HeaderText
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function HeaderTextContainer(p)
	local v = useLocalization({ headerText = p.text })

	local v2 = useTokens()
	return React.createElement(View, {
		tag = "auto-xy",
		padding = { left = UDim.new(0, 10), bottom = UDim.new(0, v2.Padding.Small) }
	}, {
		Text = React.createElement(HeaderText, { text = v.headerText })
	})
end

local function renderSettingsHeader(data)
	local settingsHeader = Create("Frame")({
		Name = "HeaderWrapper",
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = data.layoutOrder,
		Parent = data.parent
	})

	local v = nil
	SettingsShowSignal:connect(function(p)
		if p then
			settingsHeader.Parent = data.parent
			v = ReactRoblox.createRoot(settingsHeader)
			v:render(React.createElement(InExperienceMenuReact, nil, {
				HeaderTextContainer = React.createElement(HeaderTextContainer, {
					text = data.headerText
				})
			}))
		elseif v then
			v:unmount()
			v = nil
			settingsHeader.Parent = nil
		end
	end)

	return settingsHeader
end

return renderSettingsHeader
