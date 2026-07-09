local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local Cryo = require(CorePackages.Packages.Cryo)
local v4 = game:DefineFastFlag("StaticSMBannerTheme", false)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function makeBannerTokens(p1, p2) -- line: 41
	-- upvalues: v4 (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), Cryo (copy)
	local n1 = 0
	local n2 = 0
	local n3 = 0
	local n4 = 0
	local n5 = 0
	local t1 = {
		autoButtonColor = true,
		height = p2.Size.Size_1000
	}
	local t2 = {
		autoButtonColor = true,
		verticalPadding = 5,
		horizontalPadding = 15,
		height = p2.Size.Size_400,
		typography = p2.Typography.BodyLarge,
		textColor = if not v4 then p2.Color.Content.Emphasis else p2.Color.Extended.White.White_100,
		backgroundColor = p2.Color.Extended.Gray.Gray_700
	}

	if p1.uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole then
		t1 = Cryo.Dictionary.join(t1, {
			autoButtonColor = false,
			cornerRadius = UDim.new(0, p2.Radius.Medium),
			height = p2.Size.Size_1200,
			strokeColor = p2.Color.Stroke.Emphasis
		})
		t2 = Cryo.Dictionary.join(t2, {
			autoButtonColor = false,
			cornerRadius = UDim.new(0, p2.Radius.Medium),
			height = p2.Size.Size_800,
			strokeColor = p2.Color.System.Contrast,
			verticalPadding = p2.Size.Size_100,
			horizontalPadding = p2.Size.Size_200
		})
		n1 = p2.Size.Size_400
		n2 = p2.Size.Size_600
		n3 = p2.Size.Size_400
		n4 = p2.Size.Size_1600
		n5 = p2.Size.Size_1600
	end

	return {
		verticalPadding = n1,
		topMargin = n2,
		bottomMargin = n3,
		leftMargin = n4,
		rightMargin = n5,
		siteMessageBanner = t2,
		securityBanner = t1
	}
end

return makeBannerTokens
