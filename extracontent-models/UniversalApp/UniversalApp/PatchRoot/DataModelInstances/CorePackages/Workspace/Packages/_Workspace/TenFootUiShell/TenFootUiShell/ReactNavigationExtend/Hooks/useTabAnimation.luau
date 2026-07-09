local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local React = require(TenFootUiShellParent.React)
local ReactOtter = require(TenFootUiShellParent.ReactOtter)
local ReactNavigationExtend = TenFootUiShell.ReactNavigationExtend
local Constants = require(ReactNavigationExtend.Views.Constants)
local TenFootUiScene = require(TenFootUiShell.Hooks.TenFootUiScene)
local TabAnimationStateEnum = require(script.Parent.TabAnimationStateEnum)
local useCameraFacingGeometry = require(TenFootUiShellParent.SceneManagement).useCameraFacingGeometry

local function makeGetTabCFrame(p1, n1: number) -- line: 35
	-- upvalues: TabAnimationStateEnum (copy)
	local v15 = p1 == TabAnimationStateEnum.TabOpening or p1 == TabAnimationStateEnum.TabOpened

	local function getCenterX(p2) -- line: 39
		-- upvalues: n1 (copy), v15 (copy)
		if n1 == 0 then
			return 0
		end

		if v15 then
			if n1 < 0 then
				return -p2
			end

			return p2
		end

		if n1 < 0 then
			return p2
		end

		return -p2
	end

	return function(t1: {[any]: any}) -- line: 50
		-- upvalues: n1 (copy), v15 (copy)
		local step = t1.step
		local v32 = t1.viewportFillDimensions.X * 0.3333
		local v33 = (1 - step) * v32
		local v34 = if n1 ~= 0 then if not v15 then if not (n1 < 0) then -v33 else v33 else if not (n1 < 0) then v33 else -v33 else 0

		return CFrame.new(v34, 0, 0)
	end
end
local function useAnimationState(b1: boolean) -- line: 63
	-- upvalues: React (copy), TabAnimationStateEnum (copy)
	local v18, v19 = React.useState(TabAnimationStateEnum.TabClosed)

	React.useEffect(function() -- line: 66
		-- upvalues: v19 (copy), b1 (copy), TabAnimationStateEnum (copy)
		v19(function(p3) -- line: 67
			-- upvalues: b1 (copy), TabAnimationStateEnum (copy)
			if b1 and (p3 == TabAnimationStateEnum.TabClosed or p3 == TabAnimationStateEnum.TabClosing) then
				return TabAnimationStateEnum.TabOpening
			end

			if not b1 and (p3 == TabAnimationStateEnum.TabOpened or p3 == TabAnimationStateEnum.TabOpening) then
				return TabAnimationStateEnum.TabClosing
			end

			return p3
		end)
	end, { b1 })

	return v18, v19
end
local function useTabAnimation(t2: {[any]: any}) -- line: 86
	-- upvalues: useAnimationState (copy), useCameraFacingGeometry (copy), Constants (copy), React (copy), TabAnimationStateEnum (copy), ReactOtter (copy), TenFootUiScene (copy)
	local currentTabIndex = t2.currentTabIndex
	local v22 = currentTabIndex - t2.previousTabIndex
	local v23, v24 = useAnimationState(t2.isActiveTab)
	local v25 = useCameraFacingGeometry(Constants.DEFAULT_SCREEN_DISTANCE_TO_CAMERA)
	local v26 = React.useCallback(function() -- line: 95
		-- upvalues: v24 (copy), TabAnimationStateEnum (copy)
		v24(function(p4) -- line: 96
			-- upvalues: TabAnimationStateEnum (copy)
			if p4 == TabAnimationStateEnum.TabOpening then
				return TabAnimationStateEnum.TabOpened
			end

			if p4 == TabAnimationStateEnum.TabClosing then
				return TabAnimationStateEnum.TabClosed
			end

			return p4
		end)
	end, {})
	local v27, v28 = ReactOtter.useAnimatedBinding(0, v26)

	React.useEffect(function() -- line: 108
		-- upvalues: v23 (copy), TabAnimationStateEnum (copy), v28 (copy), ReactOtter (copy), Constants (copy)
		if v23 == TabAnimationStateEnum.TabOpening then
			v28(ReactOtter.spring(1, Constants.X_DIRECTION_ANIMATION_SPRING_CONFIG))

			return
		end

		if v23 == TabAnimationStateEnum.TabClosing then
			v28(ReactOtter.spring(0, Constants.X_DIRECTION_ANIMATION_SPRING_CONFIG))
		end
	end, { v23 })
	React.useEffect(function() -- line: 116
		-- upvalues: v23 (copy), TabAnimationStateEnum (copy), v25 (copy), currentTabIndex (copy), TenFootUiScene (copy)
		if v23 == TabAnimationStateEnum.TabOpening or v23 == TabAnimationStateEnum.TabOpened then
			local v35 = v25.viewportFillDimensions:getValue().X * 0.1634 * (currentTabIndex - 1)

			TenFootUiScene.updateXPosition(-v35)
		end
	end, {
		v23,
		v25.viewportFillDimensions,
		currentTabIndex
	})

	return React.useMemo(function() -- line: 125
		-- upvalues: v23 (copy), v22 (copy), TabAnimationStateEnum (copy), React (copy), v27 (copy), v25 (copy)
		local v36 = v23
		local v37 = v22
		local v38 = v36 == TabAnimationStateEnum.TabOpening or v36 == TabAnimationStateEnum.TabOpened

		local function getCenterX(p5) -- line: 39
			-- upvalues: v37 (copy), v38 (copy)
			if v37 == 0 then
				return 0
			end

			if v38 then
				if v37 < 0 then
					return -p5
				end

				return p5
			end

			if v37 < 0 then
				return p5
			end

			return -p5
		end

		return {
			isVisible = v23 ~= TabAnimationStateEnum.TabClosed,
			cFrame = React.joinBindings({
				step = v27,
				viewportFillDimensions = v25.viewportFillDimensions
			}):map(function(t3: {[any]: any}) -- line: 50
				-- upvalues: v37 (copy), v38 (copy)
				local step = t3.step
				local v45 = t3.viewportFillDimensions.X * 0.3333
				local v46 = (1 - step) * v45
				local v47 = if v37 ~= 0 then if not v38 then if not (v37 < 0) then -v46 else v46 else if not (v37 < 0) then v46 else -v46 else 0

				return CFrame.new(v47, 0, 0)
			end),
			transparency = v27:map(function(p6) -- line: 133
				return 1 - p6
			end)
		}
	end, {
		v27,
		v25,
		v23,
		v22
	})
end

return useTabAnimation
