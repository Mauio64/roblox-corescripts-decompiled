local AppStorageService = game:GetService("AppStorageService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local Tokens = require(CorePackages.Packages.UIBlox).App.Style.Tokens
local getThemeModuleForString = require(Modules.LuaApp.Themes.getThemeModuleForString)
local ThemeContext_DEPRECATED = require(Modules.LuaApp.ThemeContext_DEPRECATED)
local v9 = Roact.Component:extend("ThemeProvider")

local function v10(p1, p2) -- line: 16
	local v13 = table.clone(p1)

	v13.ContextPrimaryButton.Color = p2.Color.ActionEmphasis.Background.Color3
	v13.ContextPrimaryButton.Transparency = p2.Color.ActionEmphasis.Background.Transparency
	v13.ContextPrimaryButton.Text.Color = p2.Color.ActionEmphasis.Foreground.Color3
	v13.ContextPrimaryButton.Text.Transparency = p2.Color.ActionEmphasis.Foreground.Transparency
	v13.SecondaryButton.Color = p2.Color.ActionSubtle.Background.Color3
	v13.SecondaryButton.Transparency = p2.Color.ActionSubtle.Background.Transparency
	v13.SecondaryButton.DisabledColor = p2.Color.ActionSubtle.Background.Color3
	v13.SecondaryButton.DisabledTransparency = 0.5
	v13.SecondaryButton.OnPressColor = p2.Color.ActionSubtle.Background.Color3
	v13.SecondaryButton.OnPressTransparency = 0.5
	v13.SecondaryButton.Text.Color = p2.Color.ActionSubtle.Foreground.Color3
	v13.SecondaryButton.Text.Transparency = p2.Color.ActionSubtle.Foreground.Transparency
	v13.SecondaryButton.Border.Color = p2.Color.ActionSubtle.Border.Color3
	v13.SecondaryButton.Border.Transparency = p2.Color.ActionSubtle.Border.Transparency
	v13.ShimmerPanel.Color = p2.Color.Common.Shimmer.Color3
	v13.ShimmerPanel.Transparency = p2.Color.Common.Shimmer.Transparency
	v13.AlertWindow.Background.Color = p2.Color.Surface.Surface_300.Color3
	v13.AlertWindow.Title.Color = p2.Color.Content.Emphasis.Color3
	v13.AlertWindow.Message.Color = p2.Color.Content.Default.Color3
	v13.AlertWindow.Divider.Color = p2.Color.Stroke.Default.Color3
	v13.GameDetails.GameInfoList.Cells.Background.Color = p2.Color.State.Press.Color3
	v13.GameDetails.GameInfoList.Cells.Background.Transparency.Pressed = p2.Color.State.Press.Transparency
	v13.GameMediaAccordion.Item.BackgroundColor = p2.Color.Surface.Surface_300.Color3
	v13.GameMediaAccordion.Item.BackgroundTransparency = 0.5
	v13.GameMediaAccordion.FakeItem.Loading.Color = p2.Color.Surface.Surface_300.Color3
	v13.GameMediaAccordion.FakeItem.Loading.BaseTransparency = 0.5
	v13.GameMediaAccordion.FakeItem.Loaded.Color = p2.Color.OverMedia.OverMedia_200.Color3
	v13.GameMediaAccordion.FakeItem.Loaded.BaseTransparency = p2.Color.OverMedia.OverMedia_200.Transparency
	v13.GameMediaAccordion.VideoIconColor = p2.Color.Content.Emphasis.Color3

	return v13
end

function v9.init(p3, p4) -- line: 59
	-- upvalues: getThemeModuleForString (copy), Tokens (copy), v10 (copy)
	local themeName = p4.themeName
	local v17 = getThemeModuleForString(themeName)
	local v18 = Tokens.getFoundationTokensDefaultScale(themeName)

	p3.state = {
		theme = v10(v17, v18)
	}
end
function v9.didMount(p5) -- line: 70
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy), getThemeModuleForString (copy), Tokens (copy), v10 (copy)
	p5.connection = AppStorageService.ItemWasSet:Connect(function(p6, p7) -- line: 71
		-- upvalues: LocalStorageKey (copy), getThemeModuleForString (copy), Tokens (copy), v10 (copy), p5 (copy)
		if p6 == LocalStorageKey.AuthenticatedTheme then
			local v24 = getThemeModuleForString(p7)
			local v25 = Tokens.getFoundationTokensDefaultScale(p7)
			local v26 = v10(v24, v25)

			p5:setState({
				theme = v26
			})
		end
	end)
end
function v9.willUnmount(p8) -- line: 84
	if p8.connection then
		p8.connection:Disconnect()
	end
end
function v9.render(p9) -- line: 90
	-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy)
	return Roact.createElement(ThemeContext_DEPRECATED.Provider, {
		value = p9.state.theme
	}, p9.props[Roact.Children])
end

return v9
