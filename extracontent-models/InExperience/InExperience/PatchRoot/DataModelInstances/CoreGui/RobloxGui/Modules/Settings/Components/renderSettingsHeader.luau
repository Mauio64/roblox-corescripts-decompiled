local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local SettingReactView = require(CorePackages.Workspace.Packages.SettingReactView)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local ParentParent = script.Parent.Parent
local InExperienceMenuReact = require(ParentParent.InExperienceMenuReact)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local useLocalization = Localization.Hooks.useLocalization
local HeaderText = SettingReactView.HeaderText
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function HeaderTextContainer(p1) -- line: 26
	-- upvalues: useLocalization (copy), useTokens (copy), React (copy), View (copy), HeaderText (copy)
	local v19 = useLocalization({
		headerText = p1.text
	})
	local v20 = useTokens()

	return React.createElement(View, {
		tag = "auto-xy",
		padding = {
			left = UDim.new(0, 10),
			bottom = UDim.new(0, v20.Padding.Small)
		}
	}, {
		Text = React.createElement(HeaderText, {
			text = v19.headerText
		})
	})
end
local function renderSettingsHeader(t1: {[any]: any}) -- line: 44
	-- upvalues: Create (copy), SettingsShowSignal (copy), ReactRoblox (copy), React (copy), InExperienceMenuReact (copy), HeaderTextContainer (copy)
	local v22 = Create("Frame")({
		Name = "HeaderWrapper",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		Parent = t1.parent
	})
	local u23 = nil

	SettingsShowSignal:connect(function(p2) -- line: 55
		-- upvalues: u23 (ref), v22 (copy), t1 (copy), ReactRoblox (copy), React (copy), InExperienceMenuReact (copy), HeaderTextContainer (copy)
		if not p2 then
			if u23 then
				u23:unmount()
				u23 = nil
				v22.Parent = nil
			end

			return
		end

		v22.Parent = t1.parent
		u23 = ReactRoblox.createRoot(v22)
		u23:render(React.createElement(InExperienceMenuReact, nil, {
			HeaderTextContainer = React.createElement(HeaderTextContainer, {
				text = t1.headerText
			})
		}))
	end)

	return v22
end

return renderSettingsHeader
