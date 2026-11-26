local CorePackages = game:GetService("CorePackages")
require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")

require("@game/CorePackages/Workspace/Packages/Style")
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
require(CorePackages.Packages.ReactOtter)

local function makeAppTokens(p2, p3)
	local v5 = p2.uiMode == uiMode.TenFoot
	local transparency = p3.Color.Surface.Surface_0.Transparency

	local v7 = if v5 then Vector2.new(p3.Size.Size_1600, p3.Size.Size_600) else Vector2.zero
	return {
		Page = {
			BackgroundColor = p3.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = transparency,
			SafeAreaMargin = v7,
			ScrollAnimationConfig = { dampingRatio = 1, frequency = 3 }
		}
	}
end

return makeAppTokens
