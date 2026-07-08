local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local ParentParent = script.Parent.Parent
local InExperienceMenuReact = require(ParentParent.InExperienceMenuReact)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local View = Foundation.View
local Divider = Foundation.Divider
local DividerOrientation = Foundation.Enums.DividerOrientation
local useTokens = Foundation.Hooks.useTokens

local function DividerContainer() -- line: 23
	-- upvalues: useTokens (copy), React (copy), View (copy), Divider (copy), DividerOrientation (copy)
	local v16 = useTokens()

	return React.createElement(View, {
		tag = "auto-xy",
		padding = {
			left = UDim.new(0, 10),
			top = UDim.new(0, v16.Padding.XSmall),
			bottom = UDim.new(0, v16.Padding.Large)
		}
	}, {
		Divider = React.createElement(Divider, {
			orientation = DividerOrientation.Horizontal
		})
	})
end
local function renderSettingsDivider(t1: {[any]: any}) -- line: 39
	-- upvalues: Create (copy), SettingsShowSignal (copy), ReactRoblox (copy), React (copy), InExperienceMenuReact (copy), DividerContainer (copy)
	local v18 = Create("Frame")({
		Name = "DividerWrapper",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		Parent = t1.parent
	})
	local u19 = nil

	SettingsShowSignal:connect(function(p1) -- line: 50
		-- upvalues: u19 (ref), v18 (copy), t1 (copy), ReactRoblox (copy), React (copy), InExperienceMenuReact (copy), DividerContainer (copy)
		if not p1 then
			if u19 then
				u19:unmount()
				u19 = nil
				v18.Parent = nil
			end

			return
		end

		v18.Parent = t1.parent
		u19 = ReactRoblox.createRoot(v18)
		u19:render(React.createElement(InExperienceMenuReact, nil, {
			DividerContainer = React.createElement(DividerContainer)
		}))
	end)

	return v18
end

return renderSettingsDivider
