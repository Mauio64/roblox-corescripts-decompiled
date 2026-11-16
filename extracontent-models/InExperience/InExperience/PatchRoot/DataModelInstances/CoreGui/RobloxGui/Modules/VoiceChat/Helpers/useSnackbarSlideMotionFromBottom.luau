local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Motion = require(CorePackages.Packages.Motion)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local function useSnackbarSlideMotionFromBottom(p: number?)
	local v = Foundation.Hooks.useTokens()
	local v2 = Responsive.useDeviceInsets()
	local current = React.useRef(UserGameSettings.ReducedMotion).current
	local v3 = math.max(p or v.Padding.XLarge, v2.bottom)

	local v4 = React.useMemo(function()
		return Motion.createState({
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.fromScale(0.5, 1)
		}, {
			default = {
				duration = current and 0 or 0.15,
				easingStyle = v.Ease.StandardIn
			}
		})
	end, { v, current })

	local current2 = React.useMemo(function()
		return Motion.createState({
			anchorPoint = Vector2.new(0.5, 1),
			position = UDim2.new(0.5, 0, 1, -v3)
		}, {
			default = {
				duration = current and 0 or v.Time.Time_200,
				easingStyle = v.Ease.StandardOut
			}
		})
	end, { v, current, v3 })

	local useMotion = Motion.useMotion
	local v5 = if current then current2 else v4
	local v6, current3 = useMotion(v5)

	local ref = React.useRef(current3)
	ref.current = current3
	local ref2 = React.useRef(false)

	local ref3 = React.useRef(current2)
	ref3.current = current2

	React.useEffect(function()
		if not ref2.current then
			ref.current(current2)
		end
	end, { current2 })

	local exit = React.useCallback(function(callback)
		ref2.current = true
		ref.current(v4, {
			onAnimationComplete = function(p2)
				if p2 == true then
					callback()
				end
			end
		})
	end, { v4 })

	local enter = React.useCallback(function()
		if ref2.current then
			ref2.current = false

			ref.current(ref3.current)
		end
	end, {})

	return { anchorPoint = v6.anchorPoint, position = v6.position, enter = enter, exit = exit }
end

return useSnackbarSlideMotionFromBottom
