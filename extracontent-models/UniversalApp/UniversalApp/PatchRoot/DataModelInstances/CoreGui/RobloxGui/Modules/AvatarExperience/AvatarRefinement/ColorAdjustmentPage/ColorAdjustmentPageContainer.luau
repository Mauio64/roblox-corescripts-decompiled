local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local useColorAdjustmentPageProps = require(script.Parent.useColorAdjustmentPageProps)
local ColorAdjustmentPage = require(script.Parent.ColorAdjustmentPage)

local function ColorAdjustmentPageContainer() -- line: 10
	-- upvalues: useColorAdjustmentPageProps (copy), React (copy), ColorAdjustmentPage (copy)
	local v9 = useColorAdjustmentPageProps()

	return React.createElement(ColorAdjustmentPage, v9)
end

local v8 = withStackVisibilityWrapper(ColorAdjustmentPageContainer)

return React.memo(v8)
