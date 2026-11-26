require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
require("@game/CorePackages/Workspace/Packages/Style")

local defineFastFlag = game:DefineFastFlag("StaticSMBannerTheme", false)

local function makeBannerTokens(p2, data)
	local v5 = { autoButtonColor = true, height = data.Size.Size_1000 }

	local v6 = {
		autoButtonColor = true,
		height = data.Size.Size_400,
		typography = data.Typography.BodyLarge,
		textColor = 0,
		verticalPadding = 5,
		horizontalPadding = 15,
		backgroundColor = 0
	}

	local v7 = if defineFastFlag then data.Color.Extended.White.White_100 else data.Color.Content.Emphasis
	v6.textColor = v7

	v6.backgroundColor = data.Color.Extended.Gray.Gray_700

	return {
		verticalPadding = 0,
		topMargin = 0,
		bottomMargin = 0,
		leftMargin = 0,
		rightMargin = 0,
		siteMessageBanner = v6,
		securityBanner = v5
	}
end

return makeBannerTokens
