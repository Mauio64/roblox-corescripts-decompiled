local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SharedFlags = require(ExpChatParent.SharedFlags)
local withSignalsData = require(script.Parent.withSignalsData)
local UIBlox = require(ExpChatParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Image = require(ExpChatParent.Foundation).Image
local n1 = 0.6
local vector2 = Vector2.new(-1, 0)
local v15 = game:DefineFastFlag("EnableChatMicPerfBinding", false)
local FFlagExpChatMicBubbleSingleImage = require(ExpChat.Flags.FFlagExpChatMicBubbleSingleImage)
local v17 = game:DefineFastFlag("EnableDarkerShimmerTransparency", false)
local v18 = game:DefineFastInt("ExpChatMicActivityHeartbeatIncrement", 3)

if v17 then
	n1 = 0.4
end

local GetFFlagExpChatEnableVoiceReverseNudge = require(ExpChat.Flags.GetFFlagExpChatEnableVoiceReverseNudge)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags.GetFFlagExpChatUseVoiceParticipantsStore
local Helpers = ExpChat.BubbleChat.Helpers
local getVoiceIndicatorAssetName = require(Helpers.getVoiceIndicatorAssetName)

local function createTweenShimmeringEffect(p1) -- line: 53
	-- upvalues: TweenService (copy)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, -1)
	local t1 = {
		Offset = Vector2.new(1, 0)
	}

	return (TweenService:Create(p1:getValue(), tweenInfo, t1))
end
local function ControlBubble(t2: {[any]: any}) -- line: 61
	-- upvalues: FFlagExpChatMicBubbleSingleImage (copy), React (copy), getVoiceIndicatorAssetName (copy), Image (copy), v15 (copy), ImageSetLabel (copy), RunService (copy), v18 (copy), createTweenShimmeringEffect (copy), vector2 (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), GetFFlagExpChatEnableVoiceReverseNudge (copy), Images (copy), GuiService (copy), n1 (ref)
	local v29 = nil
	local v30, u32, v33

	if FFlagExpChatMicBubbleSingleImage then
		local v31

		v30, v31 = React.useBinding(0)
		u32 = v31
		v29 = t2.iconAssetName or getVoiceIndicatorAssetName(t2.voiceState, 1, t2.iconStyle, false)
		v33 = Image
	elseif v15 then
		local v34

		v30, v34 = React.useBinding(0)
		u32 = v34
		v29 = v30:map(function(p2) -- line: 70
			-- upvalues: t2 (copy), getVoiceIndicatorAssetName (copy)
			return t2.iconAssetName or getVoiceIndicatorAssetName(t2.voiceState, p2, t2.iconStyle, false)
		end)
		v33 = Image
	else
		local v35

		v30, v35 = React.useState(0)
		u32 = v35
		v33 = ImageSetLabel
	end

	local v36 = React.useRef(0)

	React.useRef(nil)
	React.useRef(nil)

	local u37 = React.useRef(nil)
	local u38 = React.useRef(nil)

	React.useEffect(function() -- line: 88
		-- upvalues: u37 (ref), u38 (ref)
		if u37.current then
			local UIGradient = u37.current:FindFirstChildWhichIsA("UIGradient", true)

			if UIGradient then
				u38.current = UIGradient
			end
		end
	end, { u37 })
	React.useEffect(function() -- line: 97
		-- upvalues: t2 (copy), RunService (copy), v36 (copy), v18 (copy), u32 (ref), u38 (ref), createTweenShimmeringEffect (copy), vector2 (copy)
		local u44 = nil

		if t2.voiceState and t2.voiceState == "Talking" then
			local connection = RunService.PostSimulation:Connect(function() -- line: 100
				-- upvalues: v36 (copy), v18 (copy), u32 (ref)
				v36.current = ((v36.current or 0) + 1) % v18

				if v36.current == 0 then
					u32(math.random())
				end
			end)

			return function() -- line: 109
				-- upvalues: connection (ref)
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end

		if t2.voiceState and t2.voiceState == "Connecting" and u38 then
			local v46 = createTweenShimmeringEffect(u38)

			v46:Play()

			return function() -- line: 119
				-- upvalues: v46 (copy), u38 (ref), vector2 (copy)
				v46:Cancel()

				if u38 and u38.current then
					u38.current.Offset = vector2
				end
			end
		end

		return function() -- line: 128
			-- upvalues: u44 (ref)
			if u44 then
				u44:Disconnect()
				u44 = nil
			end
		end
	end, { t2.voiceState })

	local v39 = nil
	local u40 = nil

	if GetFFlagExpChatUseVoiceParticipantsStore() then
		u40 = React.useRef(t2.voiceState)
		React.useEffect(function() -- line: 141
			-- upvalues: u40 (ref), t2 (copy)
			u40.current = t2.voiceState
		end, { t2.voiceState })
		v39 = React.useCallback(function(p3) -- line: 145
			-- upvalues: t2 (copy), u40 (ref)
			if t2.onActivated then
				t2.onActivated(p3, u40.current)
			end
		end, { t2.onActivated })
	end

	if not v15 and not FFlagExpChatMicBubbleSingleImage then
		local v41 = t2.iconAssetName or getVoiceIndicatorAssetName(t2.voiceState, v30, t2.iconStyle, false)

		if GetFFlagExpChatEnableVoiceReverseNudge() then
			v41 = t2.iconAssetName or getVoiceIndicatorAssetName(t2.voiceState, v30, t2.iconStyle, t2.isUserToxic)
		end

		v29 = Images[v41]
	end

	return React.createElement("ImageButton", {
		AnchorPoint = Vector2.new(0.5, 1),
		Interactable = not GuiService:IsTenFootInterface() and nil,
		Selectable = not GuiService:IsTenFootInterface() and nil,
		Size = t2.controlBubbleSize,
		LayoutOrder = t2.LayoutOrder,
		BorderSizePixel = 0,
		Transparency = 1,
		ZIndex = 2,
		[React.Event.Activated] = if not GetFFlagExpChatUseVoiceParticipantsStore() then t2.onActivated else v39,
		BackgroundTransparency = 1,
		ref = u37
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t2.cornerRadiusOffset)
		}),
		Contents = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, t2.cornerRadiusOffset)
			}),
			Icon = React.createElement(v33, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = t2.iconSize,
				ImageTransparency = t2.iconTransparency,
				Image = v29
			}, {
				ShimmerGradient = React.createElement("UIGradient", {
					Rotation = -45,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(n1, n1, n1)),
						ColorSequenceKeypoint.new(0.5, Color3.new(0.8, 0.8, 0.8)),
						ColorSequenceKeypoint.new(1, Color3.new(n1, n1, n1))
					}),
					Enabled = t2.voiceState == "Connecting",
					Offset = vector2
				}),
				ActivityGradient = FFlagExpChatMicBubbleSingleImage and React.createElement("UIGradient", {
					Rotation = 0,
					Color = v30:map(function(p4) -- line: 213
						return ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(p4 * 0.5, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(p4 * 0.5 + 1E-06, Color3.new(0, 0, 0)),
							ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
						})
					end),
					Transparency = NumberSequence.new(0),
					Enabled = t2.voiceState ~= "Connecting"
				})
			})
		})
	})
end

if GetFFlagExpChatUseVoiceParticipantsStore() then
	return React.memo(withSignalsData(ControlBubble))
end

return React.memo(ControlBubble)
