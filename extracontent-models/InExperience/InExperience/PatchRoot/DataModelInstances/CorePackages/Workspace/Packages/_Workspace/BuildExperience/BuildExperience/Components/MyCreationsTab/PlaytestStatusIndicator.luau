local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Stores.GetPlaytestLoadingStore.createPlaytestLoadingStore)

local Icon = Foundation.Icon
local Progress = Foundation.Progress
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize
local useTokens = Foundation.Hooks.useTokens

local function PlaytestStatusIndicator(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), React (copy), View (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), Icon (copy), IconName (copy), IconVariant (copy)
	local Size_400 = useTokens().Size.Size_400

	if t1.status == "Loading" then
		return React.createElement(View, {
			tag = "row align-x-center align-y-center",
			testId = "MyCreationsTab.StatusIndicator.Loading",
			LayoutOrder = t1.LayoutOrder,
			Size = UDim2.fromOffset(Size_400, Size_400)
		}, {
			Progress = React.createElement(Progress, {
				shape = ProgressShape.Circle,
				size = ProgressSize.Small
			})
		})
	end

	if t1.status == "Completed" then
		return React.createElement(Icon, {
			tag = "auto-xy content-system-success",
			testId = "MyCreationsTab.StatusIndicator.Completed",
			LayoutOrder = t1.LayoutOrder,
			name = IconName.CircleCheck,
			size = Size_400,
			variant = IconVariant.Filled
		})
	end

	return nil
end

return PlaytestStatusIndicator
