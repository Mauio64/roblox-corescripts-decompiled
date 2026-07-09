local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

require(CorePackages.Packages.ReactOtter)

local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function makeAppTokens(p1, p2) -- line: 13
	-- upvalues: UiMode (copy), FFlagEnableLeftNavOnConsole (copy)
	local v7 = p1.uiMode == UiMode.TenFoot
	local v8 = if not v7 or FFlagEnableLeftNavOnConsole then p2.Color.Surface.Surface_0.Transparency else 1
	local t1 = {
		dampingRatio = 1,
		frequency = 3
	}
	local v10 = if not v7 then Vector2.zero else Vector2.new(p2.Size.Size_1600, p2.Size.Size_600)

	return {
		Page = {
			BackgroundColor = p2.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v8,
			SafeAreaMargin = v10,
			ScrollAnimationConfig = t1
		}
	}
end

return makeAppTokens
