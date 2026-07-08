local TweenService = game:GetService("TweenService")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local v7 = game:DefineFastInt("ShopGlobalIconAnimGracePeriodMs", 3000)
local FFlagExperienceShopNewIconography = require(InExperienceShop.Flags.FFlagExperienceShopNewIconography)
local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local v12 = not FFlagExperienceShopNewIconography and 0.2 or 0.23
local v13 = not FFlagExperienceShopNewIconography and 0.2 or 0.23
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo3 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local timestamp = nil

if game:IsLoaded() then
	timestamp = tick()
else
	local connection = nil

	connection = game.Loaded:Connect(function() -- line: 39
		-- upvalues: timestamp (ref), connection (ref)
		timestamp = tick()
		connection:Disconnect()
	end)
end

local function ShopGlobalIcon(t1: {[any]: any}) -- line: 56
	-- upvalues: FFlagEnableExperienceShopGlobalIcon (copy), useTokens (copy), React (copy), v7 (copy), timestamp (ref), TweenService (copy), tweenInfo (copy), tweenInfo3 (copy), tweenInfo4 (copy), tweenInfo2 (copy), Foundation (copy), FFlagExperienceShopNewIconography (copy), IconName (copy), IconVariant (copy), v13 (copy), v12 (copy)
	if not FFlagEnableExperienceShopGlobalIcon then
		return nil
	end

	local v22 = useTokens()
	local buttonSize = t1.buttonSize
	local v24 = t1.leftGap or 0
	local v25, v26 = React.useState(0)
	local v27, v28 = React.useState(0)
	local v29, v30 = React.useState(false)
	local v31 = React.useRef(nil)
	local v32 = React.useRef(nil)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36 = React.useRef(nil)
	local v37 = React.useRef(nil)
	local v38 = React.useRef(nil)
	local v39 = React.useRef(nil)
	local v40 = React.useRef(nil)

	React.useEffect(function() -- line: 82
		-- upvalues: v37 (copy), v38 (copy), v26 (copy), v28 (copy), v33 (copy), v34 (copy), v31 (copy), v32 (copy), v35 (copy), v36 (copy), buttonSize (copy), v30 (copy), v7 (copy), timestamp (ref), TweenService (copy), tweenInfo (copy), tweenInfo3 (copy), tweenInfo4 (copy), tweenInfo2 (copy), v39 (copy), v40 (copy)
		local NumberValue = Instance.new("NumberValue")

		NumberValue.Value = 0
		v37.current = NumberValue

		local NumberValue2 = Instance.new("NumberValue")

		NumberValue2.Value = 0
		v38.current = NumberValue2

		local connection = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 91
			-- upvalues: v26 (copy), NumberValue (copy)
			v26(NumberValue.Value)
		end)
		local connection2 = NumberValue2:GetPropertyChangedSignal("Value"):Connect(function() -- line: 94
			-- upvalues: v28 (copy), NumberValue2 (copy)
			v28(NumberValue2.Value)
		end)

		local function stopAllAnimations() -- line: 98
			-- upvalues: v33 (copy), v34 (copy), v31 (copy), v32 (copy), v35 (copy), v36 (copy)
			if v33.current then
				v33.current:Disconnect()
				v33.current = nil
			end

			if v34.current then
				v34.current:Disconnect()
				v34.current = nil
			end

			if v31.current then
				v31.current:Cancel()
				v31.current = nil
			end

			if v32.current then
				v32.current:Cancel()
				v32.current = nil
			end

			if v35.current then
				task.cancel(v35.current)
				v35.current = nil
			end

			if v36.current then
				task.cancel(v36.current)
				v36.current = nil
			end
		end
		local function showImmediate() -- line: 125
			-- upvalues: NumberValue (copy), buttonSize (copy), NumberValue2 (copy), v26 (copy), v28 (copy), v30 (copy)
			NumberValue.Value = buttonSize
			NumberValue2.Value = 1
			v26(buttonSize)
			v28(1)
			v30(true)
		end
		local function showAnimated() -- line: 133
			-- upvalues: stopAllAnimations (copy), v7 (copy), timestamp (ref), NumberValue (copy), buttonSize (copy), NumberValue2 (copy), v26 (copy), v28 (copy), v30 (copy), TweenService (copy), tweenInfo (copy), v31 (copy), v35 (copy), tweenInfo3 (copy), v32 (copy)
			stopAllAnimations()

			local v52 = v7

			if v52 > 0 then
				local v53 = timestamp and tick() - timestamp

				if v53 == nil or v53 < v52 / 1000 then
					NumberValue.Value = buttonSize
					NumberValue2.Value = 1
					v26(buttonSize)
					v28(1)
					v30(true)

					return
				end
			end

			NumberValue.Value = 0
			NumberValue2.Value = 0
			v30(false)

			local tween = TweenService:Create(NumberValue, tweenInfo, {
				Value = buttonSize
			})

			v31.current = tween
			tween:Play()
			v35.current = task.delay(0.2, function() -- line: 153
				-- upvalues: v35 (copy), v30 (copy), TweenService (copy), NumberValue2 (copy), tweenInfo3 (copy), v32 (copy)
				v35.current = nil
				v30(true)

				local tween2 = TweenService:Create(NumberValue2, tweenInfo3, {
					Value = 1
				})

				v32.current = tween2
				tween2:Play()
			end)
		end
		local function hideAnimated() -- line: 162
			-- upvalues: stopAllAnimations (copy), TweenService (copy), NumberValue2 (copy), tweenInfo4 (copy), v32 (copy), v33 (copy), v30 (copy), v35 (copy), NumberValue (copy), tweenInfo2 (copy), v31 (copy), v34 (copy), v36 (copy), v39 (copy)
			stopAllAnimations()

			local tween = TweenService:Create(NumberValue2, tweenInfo4, {
				Value = 0
			})

			v32.current = tween
			v33.current = tween.Completed:Connect(function(p1) -- line: 167
				-- upvalues: v33 (copy), v30 (copy)
				if p1 ~= Enum.PlaybackState.Completed then
					return
				end

				v33.current = nil
				v30(false)
			end)
			tween:Play()
			v35.current = task.delay(0.2, function() -- line: 176
				-- upvalues: v35 (copy), TweenService (copy), NumberValue (copy), tweenInfo2 (copy), v31 (copy), v34 (copy), v36 (copy), v39 (copy)
				v35.current = nil

				local tween3 = TweenService:Create(NumberValue, tweenInfo2, {
					Value = 0
				})

				v31.current = tween3
				v34.current = tween3.Completed:Connect(function(p2) -- line: 180
					-- upvalues: v34 (copy), v36 (copy), v39 (copy)
					if p2 ~= Enum.PlaybackState.Completed then
						return
					end

					v34.current = nil
					v36.current = task.delay(1.5, function() -- line: 185
						-- upvalues: v36 (copy), v39 (copy)
						v36.current = nil

						if v39.current then
							v39.current()
						end
					end)
				end)
				tween3:Play()
			end)
		end

		v39.current = showAnimated
		v40.current = hideAnimated
		showAnimated()

		return function() -- line: 201
			-- upvalues: stopAllAnimations (copy), connection (copy), connection2 (copy), NumberValue (copy), NumberValue2 (copy), v37 (copy), v38 (copy)
			stopAllAnimations()
			connection:Disconnect()
			connection2:Disconnect()
			NumberValue:Destroy()
			NumberValue2:Destroy()
			v37.current = nil
			v38.current = nil
		end
	end, { buttonSize })
	React.useEffect(function() -- line: 212
		-- upvalues: t1 (copy)
		return function() -- line: 213
			-- upvalues: t1 (copy)
			if t1.onAreaChanged then
				t1.onAreaChanged("experience-shop-icon", Vector2.zero, Vector2.zero)
			end
		end
	end, { t1.onAreaChanged })

	local function reportArea(p3) -- line: 220
		-- upvalues: t1 (copy)
		if t1.onAreaChanged then
			t1.onAreaChanged("experience-shop-icon", p3.AbsolutePosition, p3.AbsoluteSize)
		end
	end

	local v42 = if buttonSize ~= 0 then v25 / buttonSize * v24 else 0

	return React.createElement("Frame", {
		Size = UDim2.fromOffset(v42 + v25, buttonSize),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		[React.Change.AbsolutePosition] = reportArea,
		[React.Change.AbsoluteSize] = reportArea
	}, {
		Button = v29 and React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(buttonSize, buttonSize),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -buttonSize / 2, 0.5, 0),
			cornerRadius = UDim.new(1, 0),
			backgroundStyle = v22.Color.OverMedia.OverMedia_0,
			onActivated = function() -- line: 226
				-- upvalues: t1 (copy)
				if t1.onActivated then
					t1.onActivated()
				end
			end,
			scale = v27
		}, {
			Icon = if not FFlagExperienceShopNewIconography then if t1.icon == nil then React.createElement(Foundation.Icon, {
				ZIndex = 1,
				name = IconName.BuildingStore,
				size = buttonSize * 0.55,
				variant = if not t1.isActive then IconVariant.Regular else IconVariant.Filled,
				style = v22.Color.Content.Emphasis,
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
				style = v22.Color.Content.Emphasis,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}),
			StatusIndicator = t1.showStatusIndicator and React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				Size = UDim2.fromOffset(8, 8),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(v13 + 0.5, 1 - (v12 + 0.5)),
				BackgroundColor3 = v22.Color.System.Emphasis.Color3,
				BackgroundTransparency = v22.Color.System.Emphasis.Transparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				UIStroke = React.createElement("UIStroke", {
					Thickness = 2,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = v22.Color.OverMedia.OverMedia_0.Color3,
					Transparency = v22.Color.OverMedia.OverMedia_0.Transparency
				})
			}) or nil
		}) or nil
	})
end

return ShopGlobalIcon
