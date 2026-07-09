local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

return function(_, p2) -- line: 11
	return {
		QrSize = 200,
		LicensePanelWidthScale = 0.6,
		PageTopMargin = p2.Size.Size_300,
		BackgroundGradientOffset = p2.Size.Size_1600,
		SafeAreaMargin = Vector2.new(p2.Size.Size_1600, p2.Size.Size_600),
		ContentMargin = Vector2.new(0, 136),
		TitleHeight = p2.Size.Size_1000,
		TileSize = Vector2.new(400, 400),
		ButtonSize = Vector2.new(1024, p2.Size.Size_1200),
		UserIconSize = p2.Size.Size_900,
		UsernameTextFont = p2.Typography.TitleLarge,
		UsernameTextStyle = {
			Color = p2.Color.Content.Default.Color3,
			Transparency = p2.Color.Content.Default.Transparency
		},
		NavigationItemIconStyle = {
			Color = p2.Color.Content.Emphasis.Color3,
			Transparency = p2.Color.Content.Emphasis.Transparency
		},
		NavigationItemTitleStyle = {
			Color = p2.Color.Content.Emphasis.Color3,
			Transparency = p2.Color.Content.Emphasis.Transparency
		},
		NavigationItemTitleFont = p2.Typography.TitleLarge,
		DisconnectTextFont = p2.Typography.TitleLarge
	}
end
