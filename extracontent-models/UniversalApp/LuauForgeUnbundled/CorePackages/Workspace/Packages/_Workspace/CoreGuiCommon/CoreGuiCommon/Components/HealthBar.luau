local StarterGui = game:GetService("StarterGui")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Constants")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/React")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/RobloxAppHooks")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/RobloxAppEnums")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/SignalsReact")

local getLocalHumanoidStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores").GetLocalHumanoidStore
local view = Foundation.View
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useTokens = Foundation.Hooks.useTokens
local healthBarColors = Constants.HealthBarColors

local function getHealthBarColor(p2)
	if p2 <= healthBarColors.Red.Fraction then
		return healthBarColors.Red.Color
	end

	if healthBarColors.Green.Fraction <= p2 then
		return healthBarColors.Green.Color
	end

	local total = Vector3.new(0, 0, 0)
	local total2 = 0

	for k, healthBarColor in healthBarColors do
		local vector3 = Vector3.new(healthBarColor.Color.R, healthBarColor.Color.G, healthBarColor.Color.B)
		local v5 = p2 - healthBarColor.Fraction

		if v5 == 0 then
			return Color3.new(vector3.X, vector3.Y, vector3.Z)
		end

		local v6 = 1 / (v5 * v5)
		total += v6 * vector3
		total2 += v6
	end

	local v5 = total / total2
	return Color3.new(v5.X, v5.Y, v5.Z)
end

local function HealthBar(p2)
	local mockStarterGui = p2.mockStarterGui or StarterGui

	local v5 = useTokens()
	local v6 = useDeviceOrientation()
	local v7 = SignalsReact.useSignalState(getLocalHumanoidStore)

	local state, setState = React.useState(mockStarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health))

	local v8, v9 = React.useBinding(Constants.InitialHealth)
	local v10, v11 = React.useBinding(Constants.InitialHealth)
	local v12, v13 = React.useBinding(false)

	local mapped = React.joinBindings({ v8, v10, v12 }):map(function(list)
		local item = list[1]
		local item2 = list[2]

		local v14 = 1

		if list[3] then
			return 0
		end

		if item2 > 0 then
			v14 = math.clamp(item / item2, 0, 1)
		end

		return v14
	end)

	local mapped2 = React.joinBindings({ v8, v10 }):map(function(list): boolean
		return list[1] < list[2]
	end)

	React.useEffect(function()
		local effect = Signals.createEffect(function(p3)
			local healthValue = v7.getHealthValue(p3)

			v9(healthValue.health or Constants.InitialHealth)
			v11(healthValue.maxHealth or Constants.InitialHealth)
			v13(healthValue.isDead or false)
		end)

		local coreGuiChangedSignalConnection = mockStarterGui.CoreGuiChangedSignal:Connect(function(p3, p4)
			if p3 == Enum.CoreGuiType.Health or p3 == Enum.CoreGuiType.All then
				setState(p4)
			end
		end)

		return function()
			effect()
			coreGuiChangedSignalConnection:Disconnect()
		end
	end, { v7 })

	if not state then
		return nil
	end

	local createElement = React.createElement

	local fromOffset = UDim2.fromOffset
	local v16

	if v6 == RobloxAppEnums.DeviceOrientationMode.Portrait then
		v16 = v5.Size.Size_2000
	else
		v16 = v5.Size.Size_3000
	end

	return (createElement(view, {
		tag = "anchor-top-right position-top-right",
		Visible = mapped2,
		Size = fromOffset(v16, v5.Size.Size_400),
		LayoutOrder = p2.layoutOrder,
		testId = "health-bar"
	}, {
		HealthBar = React.createElement(view, {
			tag = "bg-surface-300 radius-medium size-full",
			backgroundStyle = {
				Color3 = v5.Color.Extended.Gray.Gray_700.Color3,
				Transparency = 0.2
			},
			stroke = {
				Thickness = v5.Stroke.Thicker,
				Transparency = 0.2,
				BorderStrokePosition = Enum.BorderStrokePosition.Outer
			},
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			Fill = React.createElement(view, {
				tag = "anchor-left-center radius-medium",
				backgroundStyle = mapped:map(function(p3)
					return { Color3 = getHealthBarColor(p3), Transparency = 0 }
				end),
				Size = mapped:map(function(p3)
					return UDim2.fromScale(p3, 1)
				end),
				testId = "health-bar-fill"
			})
		})
	}))
end

return React.memo(HealthBar)
