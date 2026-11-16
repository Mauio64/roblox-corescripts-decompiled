local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)

local parent = script.Parent.Parent
local InExperienceMenuReact = require(parent.InExperienceMenuReact)
local MoreSettingsBanner = require(script.Parent.MoreSettingsBanner)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal

local function renderMoreSettingsBanner(data)
	if not (data.isPioneerLaunch or isPioneerLaunch)() then
		return nil
	end

	local v = Create("Frame")({
		Name = "MoreSettingsBannerWrapper",
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = data.layoutOrder,
		Parent = data.parent
	})

	local v2 = nil
	SettingsShowSignal:connect(function(p)
		if p then
			v.Parent = data.parent
			v2 = ReactRoblox.createRoot(v)
			v2:render(React.createElement(InExperienceMenuReact, nil, {
				MoreSettingsBanner = React.createElement(MoreSettingsBanner)
			}))
		elseif v2 then
			v2:unmount()
			v2 = nil
			v.Parent = nil
		end
	end)

	return v
end

return renderMoreSettingsBanner
