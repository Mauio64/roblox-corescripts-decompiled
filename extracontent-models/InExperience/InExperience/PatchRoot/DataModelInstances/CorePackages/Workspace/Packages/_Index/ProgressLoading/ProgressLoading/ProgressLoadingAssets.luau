local parent = script:FindFirstAncestor("ProgressLoading").Parent

local React = require(parent.React)
local Motion = require(parent.Motion)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Progress = Foundation.Progress
local ProgressShape = Foundation.Enums.ProgressShape
local useTokens = Foundation.Hooks.useTokens

local computeSpan = require(script.Parent.computeSpan)
local Constants = require(script.Parent.Constants)

local v = {
	visible = Motion.createState({ groupTransparency = 0, barScale = 1 }),
	hidden = Motion.createState({ groupTransparency = 1, barScale = 0 }, {
		default = Motion.transition({ duration = 0.1 })
	})
}

local function ProgressLoadingAssets(p)
	local scale = useTokens().Config.UI.Scale

	local v2, v3 = Motion.useMotion(v.visible)

	React.useEffect(function()
		local v4 = false

		if p.isVisible == false then
			v3(v.hidden, {
				onAnimationComplete = function(p2)
					if not v4 and p2 == true and p.onHideComplete then
						p.onHideComplete()
					end
				end
			})
		else
			v3(v.visible)
		end

		return function()
			v4 = true
		end
	end, { p.isVisible, p.onHideComplete })

	local v4, v5 = React.useBinding(0)
	local mapped = v4:map(function(p2)
		return computeSpan(p2, scale, Constants.PROGRESS_BAR_MARGIN, Constants.PROGRESS_BAR_MAX_WIDTH)
	end)

	local mapped2 = React.joinBindings({ width = mapped, barScale = v2.barScale }):map(function(p2)
		return UDim2.fromOffset(p2.width * p2.barScale, 0)
	end)

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		v5(p2.AbsoluteSize.X)
	end, {})

	return React.createElement(
		View,
		{
			tag = "size-full col align-x-center align-y-center bg-surface-0",
			GroupTransparency = v2.groupTransparency,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged
		},
		{
			ProgressBarContainer = React.createElement(View, { tag = "auto-y", Size = mapped2 }, {
				ProgressBar = React.createElement(Progress, {
					shape = ProgressShape.Bar,
					testId = "progress-loading-assets-bar"
				})
			})
		}
	)
end

return React.memo(ProgressLoadingAssets)
