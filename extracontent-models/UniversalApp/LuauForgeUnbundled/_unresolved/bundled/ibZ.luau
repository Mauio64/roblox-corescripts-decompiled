local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/ego")
local React = require(CorePackages.Packages.React)
local useIsFPSAtTarget = require("@luauforge/bundled/ibX").useIsFPSAtTarget

local function AppLoadingSplashScreen()
	local v5 = useIsFPSAtTarget()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(tick())
	local ref3 = React.useRef(0)

	local ref4 = React.useRef(nil)

	React.useEffect(function()
		if not v5 then
			ref4.current = RunService.RenderStepped:Connect(function(dt)
				local now = tick()
				local v6 = (now - ref2.current) * 0.5 * 360
				ref3.current += v6

				if ref.current and ref.current.Rotation ~= nil then
					ref.current.Rotation = ref3.current
				end

				ref2.current = now
			end)
		elseif ref4.current then
			ref4.current:Disconnect()
		end
	end, { v5 })

	if v5 then
		return nil
	end

	return (module.createElement("ScreenGui", {}, {
		Spinner = module.createElement("ImageLabel", {
			Size = UDim2.new(0.05, 0, 0.05, 0),
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			Position = UDim2.new(0.475, 0, 0.425, 0),
			Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
			BackgroundTransparency = 1,
			ref = ref
		})
	}))
end

return React.memo(AppLoadingSplashScreen)
