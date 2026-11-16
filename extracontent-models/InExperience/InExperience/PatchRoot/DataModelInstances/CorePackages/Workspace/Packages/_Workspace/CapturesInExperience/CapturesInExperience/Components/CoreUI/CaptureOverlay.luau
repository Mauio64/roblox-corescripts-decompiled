local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local RunService = game:GetService("RunService")

local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)
local RoactUtils = require(parent2.RoactUtils)

local Constants = require(parent.Constants)

local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useBindCaptureShortcut = require(parent.Hooks.useBindCaptureShortcut)
local useEffect = React.useEffect
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useShowFlashOverlay = require(parent.Hooks.useShowFlashOverlay)
local useTopbarInsetHeight = require(parent.Hooks.useTopbarInsetHeight)

local instant = ReactOtter.instant
local spring = ReactOtter.spring

return function(_)
	useBindCaptureShortcut()

	local v = useTopbarInsetHeight()

	local visible = useSelector(function(p)
		return p[Constants.RoduxKey].IsOverlayActive
	end)

	local v2, v3 = useShowFlashOverlay()
	local v4, v5 = useAnimatedBinding(1)

	useEffect(function()
		if v2 then
			v3()

			v5((instant(0)))

			task.defer(function()
				RunService.RenderStepped:Wait()
				RunService.RenderStepped:Wait()
				v5(spring(1))
			end)
		end
	end, { v2 })

	return React.createElement("Frame", {
		Active = false,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = not v2 and 1 or v4,
		Position = UDim2.fromOffset(0, -v),
		Size = UDim2.new(1, 0, 1, v),
		Visible = visible,
		ZIndex = Constants.ZIndex.Entrypoint
	}, {})
end
