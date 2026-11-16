local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local ReactIs = require(CorePackages.Packages.ReactIs)

local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind

local useVoiceState = require(RobloxGui.Modules.VoiceChat.Hooks.useVoiceState)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local defineFastInt = game:DefineFastInt("MicTalkingUpdateFrequency", 3)

local udim = UDim2.fromOffset(28, 28)

local function useJoinBinding(p, p2) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		return Roact.joinBindings({ p, p2 })
	end, { p, p2 })
end

local function mapLevelToIcon(iconStyle, showConnectingShimmer) -- 1 equivalent call inferred from this helper
	return function(list)
		local item = list[1]
		local item2 = list[2]

		if item == Constants.VOICE_STATE.MUTED or item == Constants.VOICE_STATE.LOCAL_MUTED then
			return default:GetIcon("Muted", iconStyle)
		end

		if item == Constants.VOICE_STATE.CONNECTING or item == Constants.VOICE_STATE.HIDDEN then
			if showConnectingShimmer and iconStyle == "MicLight" then
				return default:GetIcon("Connecting", "MicDark")
			end

			return default:GetIcon("Connecting", iconStyle)
		end

		if item == Constants.VOICE_STATE.INACTIVE then
			return default:GetIcon("Unmuted0", iconStyle)
		end

		if item == Constants.VOICE_STATE.TALKING then
			return default:GetIcon("Unmuted" .. tostring(math.floor(0.5 + 5 * item2) * 20), iconStyle)
		end

		return default:GetIcon("Error", iconStyle)
	end
end

local set = { [Constants.VOICE_STATE.ERROR] = true, [Constants.VOICE_STATE.HIDDEN] = true }

local function GenerateGUID()
	return HttpService:GenerateGUID()
end

local function createTweenShimmeringEffect(ref)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, -1)
	local v = { Offset = Vector2.new(1, 0) }
	return (TweenService:Create(ref:getValue(), tweenInfo, v))
end

local function VoiceIndicator(props)
	local v = useVoiceState(props.userId, props.disable or false)
	local v2, v3 = React.useBinding(0)
	local selectable = props.selectable == nil or props.selectable
	local v4, v5 = React.useBinding(v)
	local v6 = useJoinBinding(v4, v2) -- inferred equivalent call
	local current = React.useRef(GenerateGUID()).current or ""
	v5(v)

	local enabled = v == Constants.VOICE_STATE.CONNECTING
	local showConnectingShimmer = props.showConnectingShimmer == true
	local ref = React.useRef(nil)

	React.useEffect(function()
		if showConnectingShimmer and enabled and ref.current then
			local tweenShimmeringEffect = createTweenShimmeringEffect(ref)
			tweenShimmeringEffect:Play()

			return function()
				tweenShimmeringEffect:Cancel()
			end
		end

		return function() end
	end, { enabled, showConnectingShimmer })

	local ref2 = React.useRef(false)
	ref2.current = v == Constants.VOICE_STATE.TALKING

	React.useEffect(function()
		local count = 0

		RunService:BindToRenderStep(current, 1, function()
			if not ref2.current then
				return
			end

			count += 1

			if defineFastInt <= count then
				count = 0
				v3(math.random())
			end
		end)

		return function()
			RunService:UnbindFromRenderStep(current)
		end
	end, { current })

	local visible = (not props.hideOnError or v and not set[v]) and true or false
	local v7 = v == Constants.VOICE_STATE.LOCAL_MUTED and 0.5 or 0
	local imageTransparency

	if props.iconTransparency then
		if ReactIs.isBinding(props.iconTransparency) then
			imageTransparency = props.iconTransparency:map(function(p)
				return 1 - (1 - p) * (1 - v7)
			end)
		else
			imageTransparency = 1 - (1 - props.iconTransparency) * (1 - v7)
		end
	else
		imageTransparency = v7
	end

	local image = React.useMemo(function()
		return v6:map(mapLevelToIcon(props.iconStyle, showConnectingShimmer)) -- inferred equivalent call
	end, { props.iconStyle, showConnectingShimmer })

	local selectionImageObject = useSelectionCursor(CursorKind.RoundedRectNoInset)

	local createElement = Roact.createElement
	local onClickedsByActivated = {
		Size = props.size or udim,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = image,
		ImageTransparency = imageTransparency,
		Selectable = selectable,
		SelectionImageObject = selectionImageObject,
		Visible = visible,
		[Roact.Event.Activated] = props.onClicked
	}
	local shimmerGradient

	if showConnectingShimmer then
		shimmerGradient = Roact.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.6, 0.6, 0.6)),
				ColorSequenceKeypoint.new(0.5, Color3.new(0.8, 0.8, 0.8)),
				ColorSequenceKeypoint.new(1, Color3.new(0.6, 0.6, 0.6))
			}),
			Enabled = enabled,
			Rotation = -45,
			Offset = Vector2.new(-1, 0),
			[Roact.Ref] = ref
		})
	end

	return createElement("ImageButton", onClickedsByActivated, { ShimmerGradient = shimmerGradient })
end

return VoiceIndicator
