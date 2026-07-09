local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local React = require(Parent.React)
local Motion = require(Parent.Motion)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Progress = Foundation.Progress
local ProgressShape = Foundation.Enums.ProgressShape
local useTokens = Foundation.Hooks.useTokens
local computeSpan = require(script.Parent.computeSpan)
local Constants = require(script.Parent.Constants)
local t1 = {
	visible = Motion.createState({
		groupTransparency = 0,
		barScale = 1
	}),
	hidden = Motion.createState({
		groupTransparency = 1,
		barScale = 0
	}, {
		default = Motion.transition({
			duration = 0.1
		})
	})
}

local function ProgressLoadingAssets(t2: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), Motion (copy), t1 (copy), React (copy), computeSpan (copy), Constants (copy), View (copy), Progress (copy), ProgressShape (copy)
	local UIScale = useTokens().Config.UI.Scale
	local v15, v16 = Motion.useMotion(t1.visible)

	React.useEffect(function() -- line: 40
		-- upvalues: t2 (copy), v16 (copy), t1 (copy)
		local u22 = false

		if t2.isVisible == false then
			v16(t1.hidden, {
				onAnimationComplete = function(p1) -- line: 44
					-- upvalues: u22 (ref), t2 (copy)
					if not u22 and (p1 == true and t2.onHideComplete) then
						t2.onHideComplete()
					end
				end
			})
		else
			v16(t1.visible)
		end

		return function() -- line: 53
			-- upvalues: u22 (ref)
			u22 = true
		end
	end, {
		t2.isVisible,
		t2.onHideComplete
	})

	local v17, v18 = React.useBinding(0)
	local v19 = v17:map(function(p2) -- line: 59
		-- upvalues: computeSpan (copy), UIScale (copy), Constants (copy)
		return computeSpan(p2, UIScale, Constants.PROGRESS_BAR_MARGIN, Constants.PROGRESS_BAR_MAX_WIDTH)
	end)
	local v20 = React.joinBindings({
		width = v19,
		barScale = v15.barScale
	}):map(function(t3: {[any]: any}) -- line: 65
		return UDim2.fromOffset(t3.width * t3.barScale, 0)
	end)
	local v21 = React.useCallback(function(p3) -- line: 69
		-- upvalues: v18 (copy)
		v18(p3.AbsoluteSize.X)
	end, {})

	return React.createElement(View, {
		tag = "size-full col align-x-center align-y-center bg-surface-0",
		GroupTransparency = v15.groupTransparency,
		onAbsoluteSizeChanged = v21
	}, {
		ProgressBarContainer = React.createElement(View, {
			tag = "auto-y",
			Size = v20
		}, {
			ProgressBar = React.createElement(Progress, {
				testId = "progress-loading-assets-bar",
				shape = ProgressShape.Bar
			})
		})
	})
end

return React.memo(ProgressLoadingAssets)
