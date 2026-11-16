local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Motion")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local view = Foundation.View
local progress = Foundation.Progress
local progressShape = Foundation.Enums.ProgressShape
local useTokens = Foundation.Hooks.useTokens

local computeSpan = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/computeSpan")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Constants")

local v5 = {
	visible = Motion.createState({ groupTransparency = 0, barScale = 1 }),
	hidden = Motion.createState({ groupTransparency = 1, barScale = 0 }, {
		default = Motion.transition({ duration = 0.1 })
	})
}

local function ProgressLoadingAssets(p2)
	local scale = useTokens().Config.UI.Scale

	local v6, v7 = Motion.useMotion(v5.visible)

	React.useEffect(function()
		local v8 = false

		if p2.isVisible == false then
			v7(v5.hidden, {
				onAnimationComplete = function(p3)
					if not v8 and p3 == true and p2.onHideComplete then
						p2.onHideComplete()
					end
				end
			})
		else
			v7(v5.visible)
		end

		return function()
			v8 = true
		end
	end, { p2.isVisible, p2.onHideComplete })

	local v8, v9 = React.useBinding(0)
	local mapped = v8:map(function(p3)
		return computeSpan(p3, scale, Constants.PROGRESS_BAR_MARGIN, Constants.PROGRESS_BAR_MAX_WIDTH)
	end)

	local mapped2 = React.joinBindings({ width = mapped, barScale = v6.barScale }):map(function(p3)
		return UDim2.fromOffset(p3.width * p3.barScale, 0)
	end)

	local v10 = React.useCallback(function(p3)
		v9(p3.AbsoluteSize.X)
	end, {})

	return React.createElement(
		view,
		{
			tag = "size-full col align-x-center align-y-center bg-surface-0",
			GroupTransparency = v6.groupTransparency,
			onAbsoluteSizeChanged = v10
		},
		{
			ProgressBarContainer = React.createElement(view, {
				tag = "auto-y",
				Size = mapped2
			}, {
				ProgressBar = React.createElement(progress, {
					shape = progressShape.Bar,
					testId = "progress-loading-assets-bar"
				})
			})
		}
	)
end

return React.memo(ProgressLoadingAssets)
