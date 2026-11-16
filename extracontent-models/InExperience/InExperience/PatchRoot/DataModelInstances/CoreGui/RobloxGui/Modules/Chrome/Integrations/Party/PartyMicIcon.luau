local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)

local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected
local useIsActiveParticipant = CrossExperienceVoice.Hooks.useIsActiveParticipant
local useIsParticipantMuted = CrossExperienceVoice.Hooks.useIsParticipantMuted

local parent = script.Parent.Parent.Parent
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome.UnibarStyle

local Flags = require(parent.ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local defineFastInt = game:DefineFastInt("PartyMicVoiceIndicatorFrameBuffer", 3)

local function getLoadingIndicatorIcon(p, flag: boolean, flag2: boolean, flag3: boolean?, state: number?)
	if flag2 and p and not flag then
		if flag3 then
			return VoiceChat.Utils.GetIcon("Unmuted", "MicLight", state)
		end

		return VoiceChat.Utils.GetIcon("Unmuted0", "MicLight")
	end

	return VoiceChat.Utils.GetIcon("Muted", "MicLight")
end

function PartyMicIcon(p)
	local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or -1
	local v = useIsVoiceConnected()
	local v2 = useParticipant(userId)
	local current = useIsActiveParticipant(userId)
	local ref = React.useRef(current)
	local v3 = useIsParticipantMuted(userId) == true
	local ref2 = React.useRef(0)
	local state, setState = React.useState(0)
	local v4 = React.useMemo(function()
		return HttpService:GenerateGUID()
	end, {})

	local v5 = not FFlagTokenizeUnibarConstantsWithStyleProvider and 36 or UnibarStyle.use().ICON_SIZE

	React.useEffect(function()
		if v2 then
			p.isLocalPlayerMutedSignal:fire(v2.isMuted)
		end
	end, { v2 })

	React.useEffect(function()
		p.isVoiceConnectedSignal:fire(v)
	end, { v })

	local v6 = React.useCallback(function()
		if ref.current then
			if defineFastInt < ref2.current then
				setState(math.random())
				ref2.current = 0
			else
				ref2.current += 1
			end
		end
	end, {})

	React.useEffect(function()
		ref.current = current
	end, { current })

	React.useEffect(function()
		RunService:BindToRenderStep(v4, 1, v6)

		return function()
			RunService:UnbindFromRenderStep(v4)
		end
	end, {})

	local image = React.useMemo(function()
		return getLoadingIndicatorIcon(v2, v3, v, current, state)
	end, { v2, v3, v, current, state })

	return React.createElement(
		"Frame",
		{ Size = UDim2.new(0, v5, 0, v5), BorderSizePixel = 0, BackgroundTransparency = 1 },
		{
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Icon = React.createElement(ImageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(v5, v5),
				BackgroundTransparency = 1,
				Image = image
			}, { React.createElement("UICorner", {
					Name = "Corner",
					CornerRadius = UDim.new(1, 0)
				}) })
		}
	)
end

return PartyMicIcon
