local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local React = require(CorePackages.Packages.React)
local useIsFPSAtTarget = require(CorePackages.Workspace.Packages.SplashScreenManager).useIsFPSAtTarget

local function AppLoadingSplashScreen() -- line: 12
	-- upvalues: useIsFPSAtTarget (copy), React (copy), RunService (copy), Roact (copy)
	local v8 = useIsFPSAtTarget()
	local v9 = React.useRef(nil)
	local v10 = React.useRef(tick())
	local v11 = React.useRef(0)
	local v12 = React.useRef(nil)

	React.useEffect(function() -- line: 20
		-- upvalues: v8 (copy), v12 (copy), RunService (copy), v10 (copy), v11 (copy), v9 (copy)
		if not v8 then
			v12.current = RunService.RenderStepped:Connect(function(_) -- line: 22
				-- upvalues: v10 (copy), v11 (copy), v9 (copy)
				local timestamp = tick()
				local v15 = (timestamp - v10.current) * 0.5 * 360

				v11.current = v11.current + v15

				if v9.current and v9.current.Rotation ~= nil then
					v9.current.Rotation = v11.current
				end

				v10.current = timestamp
			end)

			return
		end

		if v12.current then
			v12.current:Disconnect()
		end
	end, { v8 })

	if not v8 then
		return (Roact.createElement("ScreenGui", {}, {
			Spinner = Roact.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/LoadingScreen/LoadingSpinner.png",
				BackgroundTransparency = 1,
				Size = UDim2.new(0.05, 0, 0.05, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Position = UDim2.new(0.475, 0, 0.425, 0),
				ref = v9
			})
		}))
	end

	return nil
end

return React.memo(AppLoadingSplashScreen)
