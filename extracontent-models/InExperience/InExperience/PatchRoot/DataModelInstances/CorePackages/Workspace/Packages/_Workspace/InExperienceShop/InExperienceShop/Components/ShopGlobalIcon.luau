local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagEnableShopIconTelemetry = require(InExperienceShop.Flags.FFlagEnableShopIconTelemetry)
local v9 = game:DefineFastInt("ShopGlobalIconAnimGracePeriodMs", 3000)
local FFlagExperienceShopNewIconography = require(InExperienceShop.Flags.FFlagExperienceShopNewIconography)
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local v14 = not FFlagExperienceShopNewIconography and 0.2 or 0.23
local v15 = not FFlagExperienceShopNewIconography and 0.2 or 0.23
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo3 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local timestamp = nil

if game:IsLoaded() then
	timestamp = tick()
else
	local connection = nil

	connection = game.Loaded:Connect(function() -- line: 41
		-- upvalues: timestamp (ref), connection (ref)
		timestamp = tick()
		connection:Disconnect()
	end)
end

local function ShopGlobalIcon(t1: {[any]: any}) -- line: 58
	-- upvalues: FFlagEnableExperienceShopGlobalIcon (copy), useTokens (copy), React (copy), v9 (copy), timestamp (ref), TweenService (copy), tweenInfo (copy), tweenInfo3 (copy), tweenInfo4 (copy), tweenInfo2 (copy), FFlagEnableShopIconTelemetry (copy), RunService (copy), InExperienceShopParent (copy), InExperienceShop (copy), Foundation (copy), FFlagExperienceShopNewIconography (copy), IconName (copy), IconVariant (copy), v15 (copy), v14 (copy)
	if not FFlagEnableExperienceShopGlobalIcon then
		return nil
	end

	local v24 = useTokens()
	local buttonSize = t1.buttonSize
	local v26 = t1.leftGap or 0
	local v27, v28 = React.useState(0)
	local v29, v30 = React.useState(0)
	local v31, v32 = React.useState(false)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36 = React.useRef(nil)
	local v37 = React.useRef(nil)
	local v38 = React.useRef(nil)
	local v39 = React.useRef(nil)
	local v40 = React.useRef(nil)
	local v41 = React.useRef(nil)
	local v42 = React.useRef(nil)

	React.useEffect(function() -- line: 84
		-- upvalues: v39 (copy), v40 (copy), v28 (copy), v30 (copy), v35 (copy), v36 (copy), v33 (copy), v34 (copy), v37 (copy), v38 (copy), buttonSize (copy), v32 (copy), v9 (copy), timestamp (ref), TweenService (copy), tweenInfo (copy), tweenInfo3 (copy), tweenInfo4 (copy), tweenInfo2 (copy), v41 (copy), v42 (copy)
		local NumberValue = Instance.new("NumberValue")

		NumberValue.Value = 0
		v39.current = NumberValue

		local NumberValue2 = Instance.new("NumberValue")

		NumberValue2.Value = 0
		v40.current = NumberValue2

		local connection = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 93
			-- upvalues: v28 (copy), NumberValue (copy)
			v28(NumberValue.Value)
		end)
		local connection2 = NumberValue2:GetPropertyChangedSignal("Value"):Connect(function() -- line: 96
			-- upvalues: v30 (copy), NumberValue2 (copy)
			v30(NumberValue2.Value)
		end)

		local function stopAllAnimations() -- line: 100
			-- upvalues: v35 (copy), v36 (copy), v33 (copy), v34 (copy), v37 (copy), v38 (copy)
			if v35.current then
				v35.current:Disconnect()
				v35.current = nil
			end

			if v36.current then
				v36.current:Disconnect()
				v36.current = nil
			end

			if v33.current then
				v33.current:Cancel()
				v33.current = nil
			end

			if v34.current then
				v34.current:Cancel()
				v34.current = nil
			end

			if v37.current then
				task.cancel(v37.current)
				v37.current = nil
			end

			if v38.current then
				task.cancel(v38.current)
				v38.current = nil
			end
		end
		local function showImmediate() -- line: 127
			-- upvalues: NumberValue (copy), buttonSize (copy), NumberValue2 (copy), v28 (copy), v30 (copy), v32 (copy)
			NumberValue.Value = buttonSize
			NumberValue2.Value = 1
			v28(buttonSize)
			v30(1)
			v32(true)
		end
		local function showAnimated() -- line: 135
			-- upvalues: stopAllAnimations (copy), v9 (copy), timestamp (ref), NumberValue (copy), buttonSize (copy), NumberValue2 (copy), v28 (copy), v30 (copy), v32 (copy), TweenService (copy), tweenInfo (copy), v33 (copy), v37 (copy), tweenInfo3 (copy), v34 (copy)
			stopAllAnimations()

			local v56 = v9

			if v56 > 0 then
				local v57 = timestamp and tick() - timestamp

				if v57 == nil or v57 < v56 / 1000 then
					NumberValue.Value = buttonSize
					NumberValue2.Value = 1
					v28(buttonSize)
					v30(1)
					v32(true)

					return
				end
			end

			NumberValue.Value = 0
			NumberValue2.Value = 0
			v32(false)

			local tween = TweenService:Create(NumberValue, tweenInfo, {
				Value = buttonSize
			})

			v33.current = tween
			tween:Play()
			v37.current = task.delay(0.2, function() -- line: 155
				-- upvalues: v37 (copy), v32 (copy), TweenService (copy), NumberValue2 (copy), tweenInfo3 (copy), v34 (copy)
				v37.current = nil
				v32(true)

				local tween2 = TweenService:Create(NumberValue2, tweenInfo3, {
					Value = 1
				})

				v34.current = tween2
				tween2:Play()
			end)
		end
		local function hideAnimated() -- line: 164
			-- upvalues: stopAllAnimations (copy), TweenService (copy), NumberValue2 (copy), tweenInfo4 (copy), v34 (copy), v35 (copy), v32 (copy), v37 (copy), NumberValue (copy), tweenInfo2 (copy), v33 (copy), v36 (copy), v38 (copy), v41 (copy)
			stopAllAnimations()

			local tween = TweenService:Create(NumberValue2, tweenInfo4, {
				Value = 0
			})

			v34.current = tween
			v35.current = tween.Completed:Connect(function(p1) -- line: 169
				-- upvalues: v35 (copy), v32 (copy)
				if p1 ~= Enum.PlaybackState.Completed then
					return
				end

				v35.current = nil
				v32(false)
			end)
			tween:Play()
			v37.current = task.delay(0.2, function() -- line: 178
				-- upvalues: v37 (copy), TweenService (copy), NumberValue (copy), tweenInfo2 (copy), v33 (copy), v36 (copy), v38 (copy), v41 (copy)
				v37.current = nil

				local tween3 = TweenService:Create(NumberValue, tweenInfo2, {
					Value = 0
				})

				v33.current = tween3
				v36.current = tween3.Completed:Connect(function(p2) -- line: 182
					-- upvalues: v36 (copy), v38 (copy), v41 (copy)
					if p2 ~= Enum.PlaybackState.Completed then
						return
					end

					v36.current = nil
					v38.current = task.delay(1.5, function() -- line: 187
						-- upvalues: v38 (copy), v41 (copy)
						v38.current = nil

						if v41.current then
							v41.current()
						end
					end)
				end)
				tween3:Play()
			end)
		end

		v41.current = showAnimated
		v42.current = hideAnimated
		showAnimated()

		return function() -- line: 203
			-- upvalues: stopAllAnimations (copy), connection (copy), connection2 (copy), NumberValue (copy), NumberValue2 (copy), v39 (copy), v40 (copy)
			stopAllAnimations()
			connection:Disconnect()
			connection2:Disconnect()
			NumberValue:Destroy()
			NumberValue2:Destroy()
			v39.current = nil
			v40.current = nil
		end
	end, { buttonSize })
	React.useEffect(function() -- line: 214
		-- upvalues: t1 (copy)
		return function() -- line: 215
			-- upvalues: t1 (copy)
			if t1.onAreaChanged then
				t1.onAreaChanged("experience-shop-icon", Vector2.zero, Vector2.zero)
			end
		end
	end, { t1.onAreaChanged })

	local function reportArea(p3) -- line: 222
		-- upvalues: t1 (copy)
		if t1.onAreaChanged then
			t1.onAreaChanged("experience-shop-icon", p3.AbsolutePosition, p3.AbsoluteSize)
		end
	end

	local v44 = if buttonSize ~= 0 then v27 / buttonSize * v26 else 0

	return React.createElement("Frame", {
		Size = UDim2.fromOffset(v44 + v27, buttonSize),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		[React.Change.AbsolutePosition] = reportArea,
		[React.Change.AbsoluteSize] = reportArea
	}, {
		Button = v31 and React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(buttonSize, buttonSize),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -buttonSize / 2, 0.5, 0),
			cornerRadius = UDim.new(1, 0),
			backgroundStyle = v24.Color.OverMedia.OverMedia_0,
			onActivated = function() -- line: 228
				-- upvalues: FFlagEnableShopIconTelemetry (copy), RunService (copy), InExperienceShopParent (copy), InExperienceShop (copy), t1 (copy)
				if FFlagEnableShopIconTelemetry and not RunService:IsStudio() then
					local LoggingProtocol = require(InExperienceShopParent.LoggingProtocol)
					local ShopIconClickEvent = require(InExperienceShop.Events.ShopIconClickEvent)

					LoggingProtocol.default:logRobloxTelemetryEvent(ShopIconClickEvent, {
						LoggingProtocol.StandardizedFields.addPlaceId,
						LoggingProtocol.StandardizedFields.addUniverseId,
						LoggingProtocol.StandardizedFields.addSessionId
					}, {})
				end

				if t1.onActivated then
					t1.onActivated()
				end
			end,
			scale = v29
		}, {
			Icon = if not FFlagExperienceShopNewIconography then if t1.icon == nil then React.createElement(Foundation.Icon, {
				ZIndex = 1,
				name = IconName.BuildingStore,
				size = buttonSize * 0.55,
				variant = if not t1.isActive then IconVariant.Regular else IconVariant.Filled,
				style = v24.Color.Content.Emphasis,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}) else React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				CustomIcon = t1.icon
			}) else React.createElement(Foundation.Icon, {
				ZIndex = 1,
				name = IconName.ShoppingBasket,
				size = buttonSize * 0.55,
				variant = if not t1.isActive then IconVariant.Regular else IconVariant.Filled,
				style = v24.Color.Content.Emphasis,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			StatusIndicator = t1.showStatusIndicator and React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				Size = UDim2.fromOffset(8, 8),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(v15 + 0.5, 1 - (v14 + 0.5)),
				BackgroundColor3 = v24.Color.System.Emphasis.Color3,
				BackgroundTransparency = v24.Color.System.Emphasis.Transparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				UIStroke = React.createElement("UIStroke", {
					Thickness = 2,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = v24.Color.OverMedia.OverMedia_0.Color3,
					Transparency = v24.Color.OverMedia.OverMedia_0.Transparency
				})
			}) or nil
		}) or nil
	})
end

return ShopGlobalIcon
