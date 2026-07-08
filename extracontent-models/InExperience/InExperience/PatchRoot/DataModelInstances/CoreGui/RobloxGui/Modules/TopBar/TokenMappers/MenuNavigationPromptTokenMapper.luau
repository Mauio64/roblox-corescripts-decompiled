local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Style)

return function(_, p2) -- line: 48
	return {
		Color = {
			backgroundUiColor = p2.Color.Surface.Surface_300,
			separatorColor = p2.Color.Stroke.Emphasis,
			textColor = p2.Color.Content.Emphasis,
			buttonColor = p2.Color.Content.Emphasis,
			buttonTextColor = p2.Color.Surface.Surface_300
		},
		Size = {
			displayWidth = 1920,
			promptWidth = 1080,
			imageWidth = 566,
			imageHeight = 324,
			buttonHeight = p2.Size.Size_1200,
			iconSize = p2.Size.Size_400
		},
		Space = {
			titlePadding = p2.Size.Size_300,
			bodyPadding = p2.Size.Size_600,
			iconPadding = p2.Size.Size_100
		},
		Radius = {
			cornerRadius = p2.Radius.Medium,
			buttonRadius = p2.Radius.Small
		},
		Typography = {
			label = p2.Typography.TitleLarge,
			header = p2.Typography.HeadingSmall,
			caption = p2.Typography.BodyLarge
		}
	}
end
