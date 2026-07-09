local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Constants = require(Modules.LuaApp.Constants)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MorePageScrollingFrame = require(Modules.LuaApp.Components.More.MorePageScrollingFrame)
local DeviceSettingsPageContent = require(script.Parent.DeviceSettingsPageContent)
local withMorePagePaddings = require(Modules.LuaApp.Components.More.withMorePagePaddings)
local FFlagEnableDevicePreferenceLayoutUpdate = require(Modules.LuaApp.Flags.FFlagEnableDevicePreferenceLayoutUpdate)
local FFlagPreventNavBarOverlapOverDevicePreferencePage = require(Modules.LuaApp.Flags.FFlagPreventNavBarOverlapOverDevicePreferencePage)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local v17 = Roact.PureComponent:extend("DeviceSettingsPage")

v17.validateProps = t.strictInterface({
	formFactor = t.string,
	platform = t.EnumItem,
	paddings = t.optional(t.strictInterface({
		paddingHorizontal = t.number,
		paddingVertical = t.number,
		contentMaxWidth = t.number
	})),
	roactAnalytics = t.union(t.Instance, t.table)
})

local function WithHooksComponent(p1) -- line: 56
	-- upvalues: useDesignTokens (copy), Roact (copy), MorePageScrollingFrame (copy), FFlagEnableDevicePreferenceLayoutUpdate (copy), Constants (copy), DeviceSettingsPageContent (copy), TopBar (copy), FFlagPreventNavBarOverlapOverDevicePreferencePage (copy)
	local paddings = p1.paddings
	local backgroundStyle = p1.backgroundStyle

	assert(paddings, "paddings must not be nil")

	local paddingHorizontal = paddings.paddingHorizontal
	local paddingVertical = paddings.paddingVertical
	local contentMaxWidth = paddings.contentMaxWidth
	local v26 = useDesignTokens()
	local v27 = Roact.createElement(MorePageScrollingFrame, {
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		maxWidth = contentMaxWidth
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, if not FFlagEnableDevicePreferenceLayoutUpdate then Constants.MORE_PAGE_SECTION_PADDING else v26.Size.Size_600)
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, paddingHorizontal),
			PaddingRight = UDim.new(0, paddingHorizontal),
			PaddingTop = UDim.new(0, paddingVertical),
			PaddingBottom = UDim.new(0, paddingVertical)
		}),
		Content = Roact.createElement(DeviceSettingsPageContent)
	})

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = backgroundStyle.Color,
		BackgroundTransparency = backgroundStyle.Transparency
	}, {
		TopBar = Roact.createElement(TopBar.Container, {
			leftItem = TopBar.BackButton
		}),
		PageContent = Roact.createElement(TopBar.PageContent, {}, {
			UIPadding = if not FFlagPreventNavBarOverlapOverDevicePreferencePage then nil else Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v26.Size.Size_1000)
			}),
			Scroller = v27
		})
	})
end

function v17.render(p2) -- line: 109
	-- upvalues: withStyle (copy), Roact (copy), WithHooksComponent (copy)
	return withStyle(function(p3) -- line: 110
		-- upvalues: Roact (copy), WithHooksComponent (copy), p2 (copy)
		return Roact.createElement(WithHooksComponent, {
			paddings = p2.props.paddings,
			backgroundStyle = p3.Theme.BackgroundDefault
		})
	end)
end
function v17.willUnmount(_) -- line: 118
	if game:GetEngineFeature("GlobalBasicSettingsSaveStateReflection") then
		task.spawn(function() -- line: 120
			UserSettings():SaveState()
		end)
	end
end

local v19 = RoactRodux.connect(function(p5, _) -- line: 126
	return {
		formFactor = p5.FormFactor,
		platform = p5.Platform
	}
end)(v17)

return withMorePagePaddings((RoactServices.connect({
	roactAnalytics = RoactAnalytics
})(v19)))
