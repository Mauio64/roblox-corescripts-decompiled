local StarterGui = game:GetService("StarterGui")
local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local CoreGuiCommonParent = CoreGuiCommon.Parent
local Constants = require(CoreGuiCommon.Constants)
local Foundation = require(CoreGuiCommonParent.Foundation)
local React = require(CoreGuiCommonParent.React)
local RobloxAppHooks = require(CoreGuiCommonParent.RobloxAppHooks)
local RobloxAppEnums = require(CoreGuiCommonParent.RobloxAppEnums)
local Signals = require(CoreGuiCommonParent.Signals)
local SignalsReact = require(CoreGuiCommonParent.SignalsReact)
local GetLocalHumanoidStore = require(CoreGuiCommon.Stores).GetLocalHumanoidStore
local View = Foundation.View
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local useTokens = Foundation.Hooks.useTokens
local HealthBarColors = Constants.HealthBarColors

local function getHealthBarColor(p1) -- line: 25
	-- upvalues: HealthBarColors (copy)
	if p1 <= HealthBarColors.Red.Fraction then
		return HealthBarColors.Red.Color
	end

	if p1 >= HealthBarColors.Green.Fraction then
		return HealthBarColors.Green.Color
	end

	local vector3 = Vector3.new(0, 0, 0)
	local n1 = 0

	for _, v22 in HealthBarColors do
		local vector3_2 = Vector3.new(v22.Color.R, v22.Color.G, v22.Color.B)
		local v24 = p1 - v22.Fraction

		if v24 == 0 then
			return Color3.new(vector3_2.X, vector3_2.Y, vector3_2.Z)
		end

		local v25 = 1 / (v24 * v24)

		vector3 += v25 * vector3_2
		n1 += v25
	end

	local v26 = vector3 / n1

	return Color3.new(v26.X, v26.Y, v26.Z)
end
local function HealthBar(t1: {[any]: any}) -- line: 54
	-- upvalues: StarterGui (copy), useTokens (copy), useDeviceOrientation (copy), SignalsReact (copy), GetLocalHumanoidStore (copy), React (copy), Constants (copy), Signals (copy), View (copy), RobloxAppEnums (copy), getHealthBarColor (copy)
	local v28 = t1.mockStarterGui or StarterGui
	local v29 = useTokens()
	local v30 = useDeviceOrientation()
	local v31 = SignalsReact.useSignalState(GetLocalHumanoidStore)
	local v32, v33 = React.useState(v28:GetCoreGuiEnabled(Enum.CoreGuiType.Health))
	local v34, v35 = React.useBinding(Constants.InitialHealth)
	local v36, v37 = React.useBinding(Constants.InitialHealth)
	local v38, v39 = React.useBinding(false)
	local v40 = React.joinBindings({
		v34,
		v36,
		v38
	}):map(function(p2) -- line: 67
		local v43 = p2[1]
		local v44 = p2[2]
		local n2 = 1

		if p2[3] then
			return 0
		end

		if v44 > 0 then
			n2 = math.clamp(v43 / v44, 0, 1)
		end

		return n2
	end)
	local v41 = React.joinBindings({
		v34,
		v36
	}):map(function(t2: {[any]: any}) -- line: 82
		return t2[1] < t2[2]
	end)

	React.useEffect(function() -- line: 86
		-- upvalues: Signals (copy), v31 (copy), v35 (copy), Constants (copy), v37 (copy), v39 (copy), v28 (copy), v33 (copy)
		local v47 = Signals.createEffect(function(p3) -- line: 87
			-- upvalues: v31 (copy), v35 (copy), Constants (copy), v37 (copy), v39 (copy)
			local v52 = v31.getHealthValue(p3)

			v35(v52.health or Constants.InitialHealth)
			v37(v52.maxHealth or Constants.InitialHealth)
			v39(v52.isDead or false)
		end)
		local connection = v28.CoreGuiChangedSignal:Connect(function(p4, b1: boolean) -- line: 96
			-- upvalues: v33 (copy)
			if p4 == Enum.CoreGuiType.Health or p4 == Enum.CoreGuiType.All then
				v33(b1)
			end
		end)

		return function() -- line: 103
			-- upvalues: v47 (copy), connection (copy)
			v47()
			connection:Disconnect()
		end
	end, { v31 })

	if v32 then
		return (React.createElement(View, {
			tag = "anchor-top-right position-top-right",
			testId = "health-bar",
			Visible = v41,
			Size = UDim2.fromOffset(if v30 ~= RobloxAppEnums.DeviceOrientationMode.Portrait then v29.Size.Size_3000 else v29.Size.Size_2000, v29.Size.Size_400),
			LayoutOrder = t1.layoutOrder
		}, {
			HealthBar = React.createElement(View, {
				tag = "bg-surface-300 radius-medium size-full",
				backgroundStyle = {
					Transparency = 0.2,
					Color3 = v29.Color.Extended.Gray.Gray_700.Color3
				},
				stroke = {
					Transparency = 0.2,
					Thickness = v29.Stroke.Thicker,
					BorderStrokePosition = Enum.BorderStrokePosition.Outer
				},
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5)
			}, {
				Fill = React.createElement(View, {
					tag = "anchor-left-center radius-medium",
					testId = "health-bar-fill",
					backgroundStyle = v40:map(function(p5) -- line: 138
						-- upvalues: getHealthBarColor (copy)
						return {
							Transparency = 0,
							Color3 = getHealthBarColor(p5)
						}
					end),
					Size = v40:map(function(p6) -- line: 144
						return UDim2.fromScale(p6, 1)
					end)
				})
			})
		}))
	end

	return nil
end

return React.memo(HealthBar)
