local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local useVoiceState = require(RobloxGui.Modules.VoiceChat.Hooks.useVoiceState)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

local udim = UDim2.fromOffset(36, 36)

local function useJoinBinding(p) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		return Roact.joinBindings(p)
	end, {})
end

local function mapLevelToIcon(iconStyle) -- 1 equivalent call inferred from this helper
	return function(list)
		local item = list[1]
		local item2 = list[2]

		if item == Constants.VOICE_STATE.MUTED or item == Constants.VOICE_STATE.LOCAL_MUTED then
			return default:GetIcon("Muted", iconStyle)
		end

		if item == Constants.VOICE_STATE.CONNECTING then
			return default:GetIcon("Connecting", iconStyle)
		end

		if item == Constants.VOICE_STATE.INACTIVE then
			return default:GetIcon("Unmuted0", iconStyle)
		end

		if item ~= Constants.VOICE_STATE.TALKING then
			return default:GetIcon("Error", iconStyle)
		end

		local v = math.floor(0.5 + 5 * item2) * 20
		return default:GetIcon("Unmuted" .. tostring(v), iconStyle)
	end
end

local function GenerateGUID()
	return HttpService:GenerateGUID()
end

local function VRBarVoiceIcon(props)
	local v = useVoiceState(props.userId, props.disable or false)
	local v2, v3 = React.useBinding(0)
	local v4, v5 = React.useBinding(v)
	local v6 = useJoinBinding({ v4, v2 }) -- inferred equivalent call
	local current = React.useRef(GenerateGUID()).current or ""
	v5(v)

	local v7 = v == Constants.VOICE_STATE.TALKING

	React.useEffect(function()
		if v7 then
			RunService:BindToRenderStep(current, 1, function()
				v3(math.random())
			end)
		end

		return function()
			if v7 then
				RunService:UnbindFromRenderStep(current)
			end
		end
	end, { v7 })

	local image = React.useMemo(function()
		return v6:map(mapLevelToIcon(props.iconStyle)) -- inferred equivalent call
	end, { props.iconStyle })

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = props.BackgroundTransparency or 1,
		Image = image,
		ImageColor3 = props.ImageColor3,
		ImageTransparency = props.ImageTransparency,
		Position = props.Position,
		Size = props.Size or udim,
		[Roact.Children] = props[Roact.Children]
	})
end

return VRBarVoiceIcon
