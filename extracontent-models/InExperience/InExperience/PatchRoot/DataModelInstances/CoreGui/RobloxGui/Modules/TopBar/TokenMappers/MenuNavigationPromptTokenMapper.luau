local CorePackages = game:GetService("CorePackages")
require(CorePackages.Workspace.Packages.Style)

return function(_, data)
	return {
		Color = {
			backgroundUiColor = data.Color.Surface.Surface_300,
			separatorColor = data.Color.Stroke.Emphasis,
			textColor = data.Color.Content.Emphasis,
			buttonColor = data.Color.Content.Emphasis,
			buttonTextColor = data.Color.Surface.Surface_300
		},
		Size = {
			displayWidth = 1920,
			promptWidth = 1080,
			imageWidth = 566,
			imageHeight = 324,
			buttonHeight = data.Size.Size_1200,
			iconSize = data.Size.Size_400
		},
		Space = {
			titlePadding = data.Size.Size_300,
			bodyPadding = data.Size.Size_600,
			iconPadding = data.Size.Size_100
		},
		Radius = { cornerRadius = data.Radius.Medium, buttonRadius = data.Radius.Small },
		Typography = {
			label = data.Typography.TitleLarge,
			header = data.Typography.HeadingSmall,
			caption = data.Typography.BodyLarge
		}
	}
end
