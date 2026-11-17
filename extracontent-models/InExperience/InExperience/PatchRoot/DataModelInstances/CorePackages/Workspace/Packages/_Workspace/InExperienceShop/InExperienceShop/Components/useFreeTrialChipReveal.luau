local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)

local FFlagFreeTrialChipBuyAnimation = require(InExperienceShop.Flags.FFlagFreeTrialChipBuyAnimation)

game:DefineFastInt("FreeTrialChipRevealDurationMs", 300)

local function easeOut(value: number) -- 1 equivalent call inferred from this helper
	return TweenService:GetValue(math.clamp(value, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

local function useFreeTrialChipReveal(flag: boolean, current: string?)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local ref = React.useRef(nil)
	ref.current = state2

	local ref2 = React.useRef(true)
	local ref3 = React.useRef(nil)

	local ref4 = React.useRef(false)
	local state3, setState3 = React.useState(false)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)

	React.useEffect(function()
		if flag then
			local current2 = ref5.current
			local layerCollector

			if current2 ~= nil then
				layerCollector = current2:FindFirstAncestorWhichIsA("LayerCollector")
			end

			if layerCollector == nil or game:GetFastInt("FreeTrialChipRevealDurationMs") <= 0 then
				setState3(true)
			else
				setState(layerCollector)
			end
		else
			ref3.current = nil
			ref4.current = false
			ref2.current = true
			setState(nil)
			setState2(nil)
			setState3(false)
		end
	end, { flag, setState, setState2, setState3 })

	React.useEffect(function()
		local current2 = ref7.current

		if state3 or state == nil or current2 == nil then
			return
		end

		local function publishRevealChipSize(absoluteSize: Vector2)
			if ref.current ~= nil and (absoluteSize.X <= 0 or absoluteSize.Y <= 0) then
				return
			end

			local current3 = ref3.current

			if current3 ~= nil and absoluteSize.X == current3.X and absoluteSize.Y == current3.Y then
				return
			end

			if current3 ~= nil then
				ref3.current = nil
				ref4.current = false
				ref2.current = true
			end

			ref.current = absoluteSize
			setState2(absoluteSize)
		end

		publishRevealChipSize(current2.AbsoluteSize)
		local absoluteSizeChangedConnection = current2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			publishRevealChipSize(current2.AbsoluteSize)
		end)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { state3, state, setState2 })
	local v = state2 ~= nil
	React.useEffect(function()
		local current2 = ref7.current
		local current3 = ref6.current

		if state3 or not v or state == nil or current2 == nil or current3 == nil then
			return
		end

		local revealLayer = state
		local function getRestPosition() -- 2 equivalent calls inferred from this helper
			return current3.AbsolutePosition - revealLayer.AbsolutePosition
		end

		local fastInt = game:GetFastInt("FreeTrialChipRevealDurationMs")

		local x = revealLayer.AbsoluteSize.X
		current2.Position = UDim2.fromOffset(x, getRestPosition().Y) -- inferred equivalent call

		local total = 0
		local heartbeatConnection = nil
		heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
			total += dt * 1000
			local restPosition = getRestPosition() -- inferred equivalent call
			local v2

			if fastInt > 0 then
				v2 = easeOut(total / fastInt) -- inferred equivalent call
			else
				v2 = 1
			end

			current2.Position = UDim2.fromOffset(x + (restPosition.X - x) * v2, restPosition.Y)

			if fastInt <= total then
				if heartbeatConnection ~= nil then
					heartbeatConnection:Disconnect()
				end

				ref3.current = nil
				ref2.current = true
				setState3(true)
			end
		end)

		return function()
			if heartbeatConnection ~= nil then
				heartbeatConnection:Disconnect()
			end
		end
	end, { state3, v, state, setState3 })

	if FFlagFreeTrialChipBuyAnimation then
		local ref8 = React.useRef(nil)
		React.useLayoutEffect(function()
			if current == nil or not flag then
				ref8.current = nil
				return
			end

			local current2 = ref8.current
			ref8.current = current

			if current2 == nil or current2 == current then
				return
			end

			local current3 = ref5.current
			local layerCollector

			if current3 ~= nil then
				layerCollector = current3:FindFirstAncestorWhichIsA("LayerCollector")
			end

			if layerCollector == nil or game:GetFastInt("FreeTrialChipRevealDurationMs") <= 0 then
				return
			end

			ref3.current = ref.current
			ref4.current = true
			ref2.current = false
			setState(layerCollector)
			setState3(false)
		end, { flag, current, setState, setState3 })
	end

	return {
		isSettled = state3,
		revealLayer = state,
		revealChipSize = state2,
		revealSizeIsOwnRef = ref2,
		sampleOnSettleRef = ref4,
		slotRef = ref5,
		placeholderRef = ref6,
		revealRef = ref7
	}
end

return useFreeTrialChipReveal
