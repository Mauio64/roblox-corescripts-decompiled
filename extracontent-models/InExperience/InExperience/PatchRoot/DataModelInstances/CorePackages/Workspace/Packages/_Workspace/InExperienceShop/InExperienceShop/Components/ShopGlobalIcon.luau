local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)

local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagEnableShopIconTelemetry = require(InExperienceShop.Flags.FFlagEnableShopIconTelemetry)
local FFlagOfferNotifyOnGlobalIcon = SharedFlags.FFlagOfferNotifyOnGlobalIcon
local FFlagEnableAnyFreeTrialToolTip = require(InExperienceShop.Flags.FFlagEnableAnyFreeTrialToolTip)
local defineFastInt = game:DefineFastInt("ShopGlobalIconAnimGracePeriodMs", 3000)
local GetShopGlobalIconStore = require(InExperienceShop.Stores.GetShopGlobalIconStore)

local FFlagExperienceShopNewIconography = require(InExperienceShop.Flags.FFlagExperienceShopNewIconography)

local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local v = FFlagExperienceShopNewIconography and 0.23 or 0.2
local v2 = FFlagExperienceShopNewIconography and 0.23 or 0.2
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo3 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)

local lastTime = nil

if game:IsLoaded() then
	lastTime = tick()
else
	local loadedConnection = nil
	loadedConnection = game.Loaded:Connect(function()
		lastTime = tick()
		loadedConnection:Disconnect()
	end)
end

local function ShopGlobalIcon(props)
	if not FFlagEnableExperienceShopGlobalIcon then
		return nil
	end

	local v3 = useTokens()
	local buttonSize = props.buttonSize
	local leftGap = props.leftGap or 0
	local setIconInstance

	if FFlagOfferNotifyOnGlobalIcon or FFlagEnableAnyFreeTrialToolTip then
		setIconInstance = GetShopGlobalIconStore(false).setIconInstance
	end

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)

	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(nil)

	local ref9 = React.useRef(nil)
	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(nil)

	local ref12 = React.useRef(props.hidden)
	ref12.current = props.hidden

	React.useEffect(function()
		local numberValue = Instance.new("NumberValue")
		numberValue.Value = 0
		ref7.current = numberValue

		local numberValue2 = Instance.new("NumberValue")
		numberValue2.Value = 0
		ref8.current = numberValue2

		local valueChangedConnection = numberValue:GetPropertyChangedSignal("Value"):Connect(function()
			setState(numberValue.Value)
		end)
		local valueChangedConnection2 = numberValue2:GetPropertyChangedSignal("Value"):Connect(function()
			setState2(numberValue2.Value)
		end)

		local function stopAllAnimations()
			if ref3.current then
				ref3.current:Disconnect()
				ref3.current = nil
			end

			if ref4.current then
				ref4.current:Disconnect()
				ref4.current = nil
			end

			if ref.current then
				ref.current:Cancel()
				ref.current = nil
			end

			if ref2.current then
				ref2.current:Cancel()
				ref2.current = nil
			end

			if ref5.current then
				task.cancel(ref5.current)
				ref5.current = nil
			end

			if ref6.current then
				task.cancel(ref6.current)
				ref6.current = nil
			end
		end

		local function showImmediate() -- 1 equivalent call inferred from this helper
			numberValue.Value = buttonSize
			numberValue2.Value = 1
			setState(buttonSize)
			setState2(1)
			setState3(true)
		end

		local function showAnimated()
			stopAllAnimations()

			local v4 = defineFastInt

			if v4 > 0 then
				local v5 = lastTime and tick() - lastTime

				if v5 == nil or v5 < v4 / 1000 then
					showImmediate() -- inferred equivalent call
					return
				end
			end

			numberValue.Value = 0
			numberValue2.Value = 0
			setState3(false)

			local tween = TweenService:Create(numberValue, tweenInfo, { Value = buttonSize })
			ref.current = tween
			tween:Play()

			ref5.current = task.delay(0.2, function()
				ref5.current = nil
				setState3(true)
				local tween2 = TweenService:Create(numberValue2, tweenInfo3, { Value = 1 })
				ref2.current = tween2
				tween2:Play()
			end)
		end

		local function hideAnimated()
			stopAllAnimations()

			local tween = TweenService:Create(numberValue2, tweenInfo4, { Value = 0 })
			ref2.current = tween
			ref3.current = tween.Completed:Connect(function(p)
				if p ~= Enum.PlaybackState.Completed then
					return
				end

				ref3.current = nil
				setState3(false)
			end)
			tween:Play()

			ref5.current = task.delay(0.2, function()
				ref5.current = nil
				local tween2 = TweenService:Create(numberValue, tweenInfo2, { Value = 0 })
				ref.current = tween2
				ref4.current = tween2.Completed:Connect(function(p)
					if p ~= Enum.PlaybackState.Completed then
						return
					end

					ref4.current = nil
					ref6.current = task.delay(1.5, function()
						ref6.current = nil

						if ref9.current then
							ref9.current()
						end
					end)
				end)
				tween2:Play()
			end)
		end

		ref9.current = showAnimated
		ref10.current = hideAnimated
		ref11.current = stopAllAnimations

		if not ref12.current then
			showAnimated()
		end

		return function()
			stopAllAnimations()
			valueChangedConnection:Disconnect()
			valueChangedConnection2:Disconnect()
			numberValue:Destroy()
			numberValue2:Destroy()
			ref7.current = nil
			ref8.current = nil
		end
	end, { buttonSize })

	local ref13 = React.useRef(false)
	React.useEffect(function()
		if props.hidden == nil then
			return
		end

		if not ref13.current then
			ref13.current = true
			return
		end

		local current = ref7.current
		local current2 = ref8.current

		if not (current and current2) then
			return
		end

		if ref11.current then
			ref11.current()
		end

		if props.hidden then
			current.Value = 0
			current2.Value = 0
			setState3(false)
		else
			current.Value = buttonSize
			current2.Value = 1
			setState3(true)
		end
	end, { props.hidden, buttonSize })

	React.useEffect(function()
		return function()
			if props.onAreaChanged then
				props.onAreaChanged("experience-shop-icon", Vector2.zero, Vector2.zero)
			end
		end
	end, { props.onAreaChanged })

	local function reportArea(p)
		if not props.onAreaChanged then
			return
		end

		if props.hidden then
			props.onAreaChanged("experience-shop-icon", Vector2.zero, Vector2.zero)
		else
			props.onAreaChanged("experience-shop-icon", p.AbsolutePosition, p.AbsoluteSize)
		end
	end

	local function onActivated()
		if FFlagEnableShopIconTelemetry and not RunService:IsStudio() then
			local LoggingProtocol = require(parent.LoggingProtocol)
			local ShopIconClickEvent = require(InExperienceShop.Events.ShopIconClickEvent)
			LoggingProtocol.default:logRobloxTelemetryEvent(
				ShopIconClickEvent,
				{
					LoggingProtocol.StandardizedFields.addPlaceId,
					LoggingProtocol.StandardizedFields.addUniverseId,
					LoggingProtocol.StandardizedFields.addSessionId
				},
				{}
			)
		end

		if props.onActivated then
			props.onActivated()
		end
	end

	local v4 = buttonSize == 0 and 0 or state / buttonSize * leftGap

	local createElement = React.createElement
	local reportAreas = {
		Size = UDim2.fromOffset(v4 + state, buttonSize),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsolutePosition] = reportArea,
		[React.Change.AbsoluteSize] = reportArea
	}
	local button

	if state3 then
		local createElement2 = React.createElement
		local view = Foundation.View
		local v5 = {
			ref = setIconInstance,
			Size = UDim2.fromOffset(buttonSize, buttonSize),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -buttonSize / 2, 0.5, 0),
			cornerRadius = UDim.new(1, 0),
			backgroundStyle = v3.Color.OverMedia.OverMedia_0,
			onActivated = onActivated,
			scale = state2
		}
		local icon2

		if FFlagExperienceShopNewIconography then
			local createElement3 = React.createElement
			local icon = Foundation.Icon
			local v6 = {
				name = IconName.ShoppingBasket,
				size = buttonSize * 0.55,
				variant = 0,
				style = 0,
				Position = 0,
				AnchorPoint = 0,
				ZIndex = 1
			}
			local variant

			if props.isActive then
				variant = IconVariant.Filled
			else
				variant = IconVariant.Regular
			end

			v6.variant = variant
			v6.style = v3.Color.Content.Emphasis
			v6.Position = UDim2.fromScale(0.5, 0.5)
			v6.AnchorPoint = Vector2.new(0.5, 0.5)
			icon2 = createElement3(icon, v6)
		elseif props.icon == nil then
			local createElement3 = React.createElement
			local icon = Foundation.Icon
			local v6 = {
				name = IconName.BuildingStore,
				size = buttonSize * 0.55,
				variant = 0,
				style = 0,
				Position = 0,
				AnchorPoint = 0,
				ZIndex = 1
			}
			local variant

			if props.isActive then
				variant = IconVariant.Filled
			else
				variant = IconVariant.Regular
			end

			v6.variant = variant
			v6.style = v3.Color.Content.Emphasis
			v6.Position = UDim2.fromScale(0.5, 0.5)
			v6.AnchorPoint = Vector2.new(0.5, 0.5)
			icon2 = createElement3(icon, v6)
		else
			icon2 = React.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 1 },
				{
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					CustomIcon = props.icon
				}
			)
		end

		button = createElement2(view, v5, {
			Icon = icon2,
			StatusIndicator = props.showStatusIndicator and React.createElement("Frame", {
				Size = UDim2.fromOffset(8, 8),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(v2 + 0.5, 1 - (v + 0.5)),
				BackgroundColor3 = v3.Color.System.Emphasis.Color3,
				BackgroundTransparency = v3.Color.System.Emphasis.Transparency,
				BorderSizePixel = 0,
				ZIndex = 3
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
				UIStroke = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = v3.Color.OverMedia.OverMedia_0.Color3,
					Transparency = v3.Color.OverMedia.OverMedia_0.Transparency,
					Thickness = 2
				})
			}) or nil
		}) or nil
	end

	return createElement("Frame", reportAreas, { Button = button })
end

return ShopGlobalIcon
