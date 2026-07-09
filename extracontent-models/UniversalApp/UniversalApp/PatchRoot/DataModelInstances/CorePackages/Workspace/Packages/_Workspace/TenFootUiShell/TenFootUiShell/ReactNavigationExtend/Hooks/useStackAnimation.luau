local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local React = require(TenFootUiShellParent.React)
local ReactOtter = require(TenFootUiShellParent.ReactOtter)
local Navigation = require(TenFootUiShellParent.Navigation)
local ViewState = Navigation.ViewState
local useEarlyIsFocused = Navigation.useEarlyIsFocused
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local Constants = require(ReactNavigationExtend.Views.Constants)
local TenFootUiScene = require(TenFootUiShell.Hooks.TenFootUiScene)
local t1 = {
	FRONT_HIDDEN = -1,
	CENTER_VISIBLE = 0,
	BACK_HIDDEN = 1
}

local function getSpringTarget(b1: boolean) -- line: 28
	if b1 then
		return 0
	end

	return 1
end
local function useStackAnimation(t2: {[any]: any}) -- line: 32
	-- upvalues: React (copy), ReactOtter (copy), ViewState (copy), t1 (copy), Constants (copy), useEarlyIsFocused (copy), TenFootUiScene (copy)
	local isTopOfStack = t2.isTopOfStack
	local totalInStack = t2.totalInStack
	local viewState = t2.viewState
	local v19, v20 = React.useState(false)
	local v21 = isTopOfStack or v19
	local v22 = React.useCallback(function() -- line: 41
		-- upvalues: t2 (copy), v20 (copy)
		t2.onAnimationComplete()
		v20(false)
	end, { t2.onAnimationComplete })
	local v23, v24 = ReactOtter.useAnimatedBinding(-1, v22)

	React.useEffect(function() -- line: 48
		-- upvalues: viewState (copy), ViewState (copy), v20 (copy), v24 (copy), ReactOtter (copy), isTopOfStack (copy), t1 (copy), Constants (copy)
		if viewState == ViewState.Opening or viewState == ViewState.Opened then
			v20(true)
			v24(ReactOtter.spring(if not isTopOfStack then t1.BACK_HIDDEN else t1.CENTER_VISIBLE, Constants.Z_DIRECTION_ANIMATION_SPRING_CONFIG))

			return
		end

		if viewState == ViewState.Closing then
			v20(true)
			v24(ReactOtter.spring(-1, Constants.Z_DIRECTION_ANIMATION_SPRING_CONFIG))
		end
	end, {
		viewState,
		isTopOfStack
	})

	local v25 = useEarlyIsFocused()

	React.useEffect(function() -- line: 60
		-- upvalues: v25 (copy), isTopOfStack (copy), Constants (copy), totalInStack (copy), TenFootUiScene (copy)
		if v25 and isTopOfStack then
			local v26 = Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA * Constants.Z_DIRECTION_ZOOM_FACTOR
			local v27 = (totalInStack - 1) * v26

			TenFootUiScene.updateZPosition(-v27)
		end
	end, {
		v25,
		isTopOfStack,
		totalInStack
	})

	return React.useMemo(function() -- line: 68
		-- upvalues: v21 (copy), v23 (copy), Constants (copy)
		return {
			isVisible = v21,
			cFrame = v23:map(function(n1: number) -- line: 71
				-- upvalues: Constants (copy)
				local v29 = Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA * Constants.Z_DIRECTION_ZOOM_FACTOR * n1

				return CFrame.new(0, 0, -v29)
			end),
			transparency = v23:map(function(n2: number) -- line: 76
				return (math.abs(n2))
			end)
		}
	end, {
		v21,
		v23
	})
end

return useStackAnimation
