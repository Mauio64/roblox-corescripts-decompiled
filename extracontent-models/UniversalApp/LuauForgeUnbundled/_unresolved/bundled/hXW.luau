require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")

return function(p2, data)
	return {
		PageTopMargin = data.Size.Size_300,
		BackgroundGradientOffset = data.Size.Size_1600,
		SafeAreaMargin = Vector2.new(data.Size.Size_1600, data.Size.Size_600),
		ContentMargin = Vector2.new(0, 136),
		TitleHeight = data.Size.Size_1000,
		TileSize = Vector2.new(400, 400),
		ButtonSize = Vector2.new(1024, data.Size.Size_1200),
		QrSize = 200,
		LicensePanelWidthScale = 0.6,
		UserIconSize = data.Size.Size_900,
		UsernameTextFont = data.Typography.TitleLarge,
		UsernameTextStyle = {
			Color = data.Color.Content.Default.Color3,
			Transparency = data.Color.Content.Default.Transparency
		},
		NavigationItemIconStyle = {
			Color = data.Color.Content.Emphasis.Color3,
			Transparency = data.Color.Content.Emphasis.Transparency
		},
		NavigationItemTitleStyle = {
			Color = data.Color.Content.Emphasis.Color3,
			Transparency = data.Color.Content.Emphasis.Transparency
		},
		NavigationItemTitleFont = data.Typography.TitleLarge,
		DisconnectTextFont = data.Typography.TitleLarge
	}
end
