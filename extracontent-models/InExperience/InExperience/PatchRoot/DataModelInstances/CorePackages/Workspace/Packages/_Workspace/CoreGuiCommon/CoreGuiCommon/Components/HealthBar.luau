local StarterGui = game:GetService("StarterGui")

local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local parent = CoreGuiCommon.Parent

local Constants = require(CoreGuiCommon.Constants)

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Stores = require(CoreGuiCommon.Stores)
local GetLocalHumanoidStore = Stores.GetLocalHumanoidStore
local View = Foundation.View
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useTokens = Foundation.Hooks.useTokens
local HealthBarColors = Constants.HealthBarColors

local function getHealthBarColor(p)
	if p <= HealthBarColors.Red.Fraction then
		return HealthBarColors.Red.Color
	end

	if HealthBarColors.Green.Fraction <= p then
		return HealthBarColors.Green.Color
	end

	local total = Vector3.new(0, 0, 0)
	local total2 = 0

	for _, healthBarColor in HealthBarColors do
		local vector3 = Vector3.new(healthBarColor.Color.R, healthBarColor.Color.G, healthBarColor.Color.B)
		local v = p - healthBarColor.Fraction

		if v == 0 then
			return Color3.new(vector3.X, vector3.Y, vector3.Z)
		end

		local v2 = 1 / (v * v)
		total += v2 * vector3
		total2 += v2
	end

	local v = total / total2
	return Color3.new(v.X, v.Y, v.Z)
end

local function HealthBar(p)
	local mockStarterGui = p.mockStarterGui or StarterGui

	local v = useTokens()
	local v2 = useDeviceOrientation()
	local v3 = SignalsReact.useSignalState(GetLocalHumanoidStore)

	local state, setState = React.useState(mockStarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health))

	local v4, v5 = React.useBinding(Constants.InitialHealth)
	local v6, v7 = React.useBinding(Constants.InitialHealth)
	local v8, v9 = React.useBinding(false)

	local mapped = React.joinBindings({ v4, v6, v8 }):map(function(list)
		local item = list[1]
		local item2 = list[2]

		local v10 = 1

		if list[3] then
			return 0
		end

		if item2 > 0 then
			return (math.clamp(item / item2, 0, 1))
		end

		return v10
	end)

	local mapped2 = React.joinBindings({ v4, v6 }):map(function(list): boolean
		return list[1] < list[2]
	end)

	React.useEffect(function()
		local effect = Signals.createEffect(function(p2)
			local healthValue = v3.getHealthValue(p2)

			v5(healthValue.health or Constants.InitialHealth)
			v7(healthValue.maxHealth or Constants.InitialHealth)
			v9(healthValue.isDead or false)
		end)

		local coreGuiChangedSignalConnection = mockStarterGui.CoreGuiChangedSignal:Connect(function(p2, flag: boolean)
			if p2 == Enum.CoreGuiType.Health or p2 == Enum.CoreGuiType.All then
				setState(flag)
			end
		end)

		return function()
			effect()
			coreGuiChangedSignalConnection:Disconnect()
		end
	end, { v3 })

	if not state then
		return nil
	end

	local createElement = React.createElement
	local v10

	if v2 == RobloxAppEnums.DeviceOrientationMode.Portrait then
		v10 = v.Size.Size_2000
	else
		v10 = v.Size.Size_3000
	end

	return (createElement(View, {
		tag = "anchor-top-right position-top-right",
		Visible = mapped2,
		Size = UDim2.fromOffset(v10, v.Size.Size_400),
		LayoutOrder = p.layoutOrder,
		testId = "health-bar"
	}, {
		HealthBar = React.createElement(View, {
			tag = "bg-surface-300 radius-medium size-full",
			backgroundStyle = { Color3 = v.Color.Extended.Gray.Gray_700.Color3, Transparency = 0.2 },
			stroke = {
				Thickness = v.Stroke.Thicker,
				Transparency = 0.2,
				BorderStrokePosition = Enum.BorderStrokePosition.Outer
			},
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			Fill = React.createElement(View, {
				tag = "anchor-left-center radius-medium",
				backgroundStyle = mapped:map(function(p2)
					return { Color3 = getHealthBarColor(p2), Transparency = 0 }
				end),
				Size = mapped:map(function(p2)
					return UDim2.fromScale(p2, 1)
				end),
				testId = "health-bar-fill"
			})
		})
	}))
end

return React.memo(HealthBar)
