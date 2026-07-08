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
local ParentParent = script.Parent.Parent.Parent
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(ParentParent.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v17 = game:DefineFastInt("PartyMicVoiceIndicatorFrameBuffer", 3)

local function getLoadingIndicatorIcon(p1, b1: boolean, b2: boolean, b3: boolean?, n1: number?) -- line: 28
	-- upvalues: VoiceChat (copy)
	if not b2 or (not p1 or b1) then
		return VoiceChat.Utils.GetIcon("Muted", "MicLight")
	end

	if b3 then
		return VoiceChat.Utils.GetIcon("Unmuted", "MicLight", n1)
	end

	return VoiceChat.Utils.GetIcon("Unmuted0", "MicLight")
end

function PartyMicIcon(p2) -- line: 44
	-- upvalues: Players (copy), useIsVoiceConnected (copy), useParticipant (copy), useIsActiveParticipant (copy), React (copy), useIsParticipantMuted (copy), HttpService (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), v17 (copy), RunService (copy), getLoadingIndicatorIcon (copy), ImageSetLabel (copy)
	local v25 = Players and (not not Players.LocalPlayer and Players.LocalPlayer.UserId) or -1
	local v26 = useIsVoiceConnected()
	local v27 = useParticipant(v25)
	local v28 = useIsActiveParticipant(v25)
	local v29 = React.useRef(v28)
	local v30 = useIsParticipantMuted(v25) == true
	local v31 = React.useRef(0)
	local v32, v33 = React.useState(0)
	local v34 = React.useMemo(function() -- line: 53
		-- upvalues: HttpService (copy)
		return HttpService:GenerateGUID()
	end, {})
	local v35 = not FFlagTokenizeUnibarConstantsWithStyleProvider and 36 or UnibarStyle.use().ICON_SIZE

	React.useEffect(function() -- line: 66
		-- upvalues: v27 (copy), p2 (copy)
		if v27 then
			p2.isLocalPlayerMutedSignal:fire(v27.isMuted)
		end
	end, { v27 })
	React.useEffect(function() -- line: 72
		-- upvalues: p2 (copy), v26 (copy)
		p2.isVoiceConnectedSignal:fire(v26)
	end, { v26 })

	local v36 = React.useCallback(function() -- line: 76
		-- upvalues: v29 (copy), v31 (copy), v17 (copy), v33 (copy)
		if v29.current then
			if v31.current > v17 then
				v33(math.random())
				v31.current = 0

				return
			end

			v31.current = v31.current + 1
		end
	end, {})

	React.useEffect(function() -- line: 87
		-- upvalues: v29 (copy), v28 (copy)
		v29.current = v28
	end, { v28 })
	React.useEffect(function() -- line: 91
		-- upvalues: RunService (copy), v34 (copy), v36 (copy)
		RunService:BindToRenderStep(v34, 1, v36)

		return function() -- line: 94
			-- upvalues: RunService (copy), v34 (copy)
			RunService:UnbindFromRenderStep(v34)
		end
	end, {})

	local v37 = React.useMemo(function() -- line: 99
		-- upvalues: getLoadingIndicatorIcon (copy), v27 (copy), v30 (copy), v26 (copy), v28 (copy), v32 (copy)
		return getLoadingIndicatorIcon(v27, v30, v26, v28, v32)
	end, {
		v27,
		v30,
		v26,
		v28,
		v32
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v35, 0, v35)
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(v35, v35),
			Image = v37
		}, { React.createElement("UICorner", {
			Name = "Corner",
			CornerRadius = UDim.new(1, 0)
		}) })
	})
end

return PartyMicIcon
