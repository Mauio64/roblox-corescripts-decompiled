local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)

local parent = script.Parent.Parent
local InExperienceMenuReact = require(parent.InExperienceMenuReact)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local View = Foundation.View
local Divider = Foundation.Divider
local DividerOrientation = Foundation.Enums.DividerOrientation
local useTokens = Foundation.Hooks.useTokens

local function DividerContainer()
	local v = useTokens()
	return React.createElement(View, {
		tag = "auto-xy",
		padding = {
			left = UDim.new(0, 10),
			top = UDim.new(0, v.Padding.XSmall),
			bottom = UDim.new(0, v.Padding.Large)
		}
	}, {
		Divider = React.createElement(Divider, { orientation = DividerOrientation.Horizontal })
	})
end

local function renderSettingsDivider(p)
	local settingsDivider = Create("Frame")({
		Name = "DividerWrapper",
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = p.layoutOrder,
		Parent = p.parent
	})

	local v = nil
	SettingsShowSignal:connect(function(p2)
		if p2 then
			settingsDivider.Parent = p.parent
			v = ReactRoblox.createRoot(settingsDivider)
			v:render(React.createElement(InExperienceMenuReact, nil, {
				DividerContainer = React.createElement(DividerContainer)
			}))
		elseif v then
			v:unmount()
			v = nil
			settingsDivider.Parent = nil
		end
	end)

	return settingsDivider
end

return renderSettingsDivider
