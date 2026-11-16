local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(parent.BuildExperiencePlaytestLaunch.createPlaytestLoadingStore)

local Icon = Foundation.Icon
local Progress = Foundation.Progress
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize
local useTokens = Foundation.Hooks.useTokens

local function PlaytestStatusIndicator(p)
	local size_400 = useTokens().Size.Size_400

	if p.status == "Loading" then
		return React.createElement(
			View,
			{
				LayoutOrder = p.LayoutOrder,
				Size = UDim2.fromOffset(size_400, size_400),
				tag = "row align-x-center align-y-center",
				testId = "MyCreationsTab.StatusIndicator.Loading"
			},
			{
				Progress = React.createElement(Progress, {
					shape = ProgressShape.Circle,
					size = ProgressSize.Small
				})
			}
		)
	end

	if p.status == "Completed" then
		return React.createElement(Icon, {
			LayoutOrder = p.LayoutOrder,
			name = IconName.CircleCheck,
			size = size_400,
			variant = IconVariant.Filled,
			tag = "auto-xy content-system-success",
			testId = "MyCreationsTab.StatusIndicator.Completed"
		})
	end

	return nil
end

return PlaytestStatusIndicator
