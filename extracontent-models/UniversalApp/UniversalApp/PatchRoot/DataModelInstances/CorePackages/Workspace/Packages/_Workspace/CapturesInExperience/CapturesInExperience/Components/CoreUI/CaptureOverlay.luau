local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local RunService = game:GetService("RunService")
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Constants = require(ParentParent.Constants)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useBindCaptureShortcut = require(ParentParent.Hooks.useBindCaptureShortcut)
local useEffect = React.useEffect
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useShowFlashOverlay = require(ParentParent.Hooks.useShowFlashOverlay)
local useTopbarInsetHeight = require(ParentParent.Hooks.useTopbarInsetHeight)
local instant = ReactOtter.instant
local spring = ReactOtter.spring

return function(_: {[any]: any}) -- line: 26
	-- upvalues: useBindCaptureShortcut (copy), useTopbarInsetHeight (copy), useSelector (copy), Constants (copy), useShowFlashOverlay (copy), useAnimatedBinding (copy), useEffect (copy), instant (copy), RunService (copy), spring (copy), React (copy)
	useBindCaptureShortcut()

	local v17 = useTopbarInsetHeight()
	local v18 = useSelector(function(p1) -- line: 31
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].IsOverlayActive
	end)
	local v19, v20 = useShowFlashOverlay()
	local v21, v22 = useAnimatedBinding(1)

	useEffect(function() -- line: 38
		-- upvalues: v19 (copy), v20 (copy), v22 (copy), instant (copy), RunService (copy), spring (copy)
		if v19 then
			v20()
			v22((instant(0)))
			task.defer(function() -- line: 48
				-- upvalues: RunService (copy), v22 (copy), spring (copy)
				RunService.RenderStepped:Wait()
				RunService.RenderStepped:Wait()
				v22(spring(1))
			end)
		end
	end, { v19 })

	return React.createElement("Frame", {
		Active = false,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = not v19 and 1 or v21,
		Position = UDim2.fromOffset(0, -v17),
		Size = UDim2.new(1, 0, 1, v17),
		Visible = v18,
		ZIndex = Constants.ZIndex.Entrypoint
	}, {})
end
