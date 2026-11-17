local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ExpChat = script:FindFirstAncestor("ExpChat")

local parent = ExpChat.Parent
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
local SharedFlags = require(parent.SharedFlags)

local withSignalsData = require(script.Parent.withSignalsData)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Foundation = require(parent.Foundation)
local Image = Foundation.Image

local vector2 = Vector2.new(-1, 0)
local defineFastFlag = game:DefineFastFlag("EnableChatMicPerfBinding", false)
local FFlagExpChatMicBubbleSingleImage = require(ExpChat.Flags.FFlagExpChatMicBubbleSingleImage)

local defineFastFlag2 = game:DefineFastFlag("EnableDarkerShimmerTransparency", false)
local defineFastInt = game:DefineFastInt("ExpChatMicActivityHeartbeatIncrement", 3)
local v = defineFastFlag2 and 0.4 or 0.6
local GetFFlagExpChatEnableVoiceReverseNudge = require(ExpChat.Flags.GetFFlagExpChatEnableVoiceReverseNudge)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore

local Helpers = ExpChat.BubbleChat.Helpers
local getVoiceIndicatorAssetName = require(Helpers.getVoiceIndicatorAssetName)

local function createTweenShimmeringEffect(ref)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, -1)
	local v2 = { Offset = Vector2.new(1, 0) }
	return (TweenService:Create(ref:getValue(), tweenInfo, v2))
end

local function ControlBubble(props)
	local image = nil
	local state, setState, v2

	if FFlagExpChatMicBubbleSingleImage then
		state, setState = React.useBinding(0)
		image = props.iconAssetName or getVoiceIndicatorAssetName(props.voiceState, 1, props.iconStyle, false)
		v2 = Image
	elseif defineFastFlag then
		state, setState = React.useBinding(0)
		image = state:map(function(p)
			return props.iconAssetName or getVoiceIndicatorAssetName(props.voiceState, p, props.iconStyle, false)
		end)

		v2 = Image
	else
		state, setState = React.useState(0)
		v2 = ImageSetLabel
	end

	local ref = React.useRef(0)
	React.useRef(nil)
	React.useRef(nil)

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	React.useEffect(function()
		local uiGradient = ref2.current and ref2.current:FindFirstChildWhichIsA("UIGradient", true)

		if uiGradient then
			ref3.current = uiGradient
		end
	end, { ref2 })

	React.useEffect(function()
		local connection = nil

		if props.voiceState and props.voiceState == "Talking" then
			local postSimulationConnection = RunService.PostSimulation:Connect(function()
				local current = ref.current or 0
				ref.current = (current + 1) % defineFastInt

				if ref.current == 0 then
					setState(math.random())
				end
			end)

			return function()
				if postSimulationConnection then
					postSimulationConnection:Disconnect()
					postSimulationConnection = nil
				end
			end
		end

		if not props.voiceState or props.voiceState ~= "Connecting" or not ref3 then
			return function()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end

		local tweenShimmeringEffect = createTweenShimmeringEffect(ref3)
		tweenShimmeringEffect:Play()

		return function()
			tweenShimmeringEffect:Cancel()

			if ref3 and ref3.current then
				ref3.current.Offset = vector2
			end
		end
	end, { props.voiceState })

	local v3 = nil
	local ref4 = nil

	if GetFFlagExpChatUseVoiceParticipantsStore() then
		ref4 = React.useRef(props.voiceState)
		React.useEffect(function()
			ref4.current = props.voiceState
		end, { props.voiceState })

		v3 = React.useCallback(function(p)
			if props.onActivated then
				props.onActivated(p, ref4.current)
			end
		end, { props.onActivated })
	end

	if not (defineFastFlag or FFlagExpChatMicBubbleSingleImage) then
		local iconAssetName = props.iconAssetName
			or getVoiceIndicatorAssetName(props.voiceState, state, props.iconStyle, false)

		if GetFFlagExpChatEnableVoiceReverseNudge() then
			iconAssetName = props.iconAssetName
				or getVoiceIndicatorAssetName(props.voiceState, state, props.iconStyle, props.isUserToxic)
		end

		image = Images[iconAssetName]
	end

	local createElement = React.createElement
	local v4 = {}
	v4.AnchorPoint = Vector2.new(0.5, 1)
	v4.Interactable = not isTenFootInterface() and nil
	v4.Selectable = not isTenFootInterface() and nil
	v4.Size = props.controlBubbleSize
	v4.LayoutOrder = props.LayoutOrder
	v4.BorderSizePixel = 0
	v4.Transparency = 1
	v4.ZIndex = 2
	local activated = React.Event.Activated

	if not GetFFlagExpChatUseVoiceParticipantsStore() then
		v3 = props.onActivated
	end

	v4[activated] = v3
	v4.BackgroundTransparency = 1
	v4.ref = ref2
	return createElement("ImageButton", v4, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadiusOffset)
		}),
		Contents = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundTransparency = 1 },
			{
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, props.cornerRadiusOffset)
				}),
				Icon = React.createElement(v2, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = props.iconSize,
					BackgroundTransparency = 1,
					ImageTransparency = props.iconTransparency,
					BorderSizePixel = 0,
					Image = image
				}, {
					ShimmerGradient = React.createElement("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(v, v, v)),
							ColorSequenceKeypoint.new(0.5, Color3.new(0.8, 0.8, 0.8)),
							ColorSequenceKeypoint.new(1, Color3.new(v, v, v))
						}),
						Enabled = props.voiceState == "Connecting",
						Rotation = -45,
						Offset = vector2
					}),
					ActivityGradient = FFlagExpChatMicBubbleSingleImage and React.createElement("UIGradient", {
						Color = state:map(function(p)
							return ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
								ColorSequenceKeypoint.new(p * 0.5, Color3.new(1, 1, 1)),
								ColorSequenceKeypoint.new(p * 0.5 + 1e-6, Color3.new(0, 0, 0)),
								ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
							})
						end),
						Transparency = NumberSequence.new(0),
						Enabled = props.voiceState ~= "Connecting",
						Rotation = 0
					})
				})
			}
		)
	})
end

if GetFFlagExpChatUseVoiceParticipantsStore() then
	return React.memo(withSignalsData(ControlBubble))
end

return React.memo(ControlBubble)
