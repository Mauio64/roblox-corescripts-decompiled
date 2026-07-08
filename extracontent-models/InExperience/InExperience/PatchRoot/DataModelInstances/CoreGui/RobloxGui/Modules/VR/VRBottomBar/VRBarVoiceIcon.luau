local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useVoiceState = require(RobloxGui.Modules.VoiceChat.Hooks.useVoiceState)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local uDim2 = UDim2.fromOffset(36, 36)

local function useJoinBinding(p1) -- line: 16
	-- upvalues: React (copy), Roact (copy)
	return React.useMemo(function() -- line: 17
		-- upvalues: Roact (copy), p1 (copy)
		return Roact.joinBindings(p1)
	end, {})
end
local function mapLevelToIcon(p2) -- line: 22
	-- upvalues: Constants (copy), default (copy)
	return function(p3) -- line: 24
		-- upvalues: Constants (copy), default (copy), p2 (copy)
		local v29 = p3[1]
		local v30 = p3[2]

		if v29 == Constants.VOICE_STATE.MUTED or v29 == Constants.VOICE_STATE.LOCAL_MUTED then
			return default:GetIcon("Muted", p2)
		end

		if v29 == Constants.VOICE_STATE.CONNECTING then
			return default:GetIcon("Connecting", p2)
		end

		if v29 == Constants.VOICE_STATE.INACTIVE then
			return default:GetIcon("Unmuted0", p2)
		end

		if v29 == Constants.VOICE_STATE.TALKING then
			local v31 = math.floor(0.5 + 5 * v30) * 20

			return default:GetIcon("Unmuted" .. tostring(v31), p2)
		end

		return default:GetIcon("Error", p2)
	end
end
local function GenerateGUID() -- line: 42
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID()
end
local function VRBarVoiceIcon(t1: {[any]: any}) -- line: 55
	-- upvalues: useVoiceState (copy), React (copy), Roact (copy), GenerateGUID (copy), Constants (copy), RunService (copy), default (copy), uDim2 (copy)
	local v18 = useVoiceState(t1.userId, t1.disable or false)
	local v19, v20 = React.useBinding(0)
	local v21, v22 = React.useBinding(v18)
	local t2 = {
		v21,
		v19
	}
	local v24 = React.useMemo(function() -- line: 17
		-- upvalues: Roact (copy), t2 (copy)
		return Roact.joinBindings(t2)
	end, {})
	local v25 = React.useRef(GenerateGUID()).current or ""

	v22(v18)

	local v26 = v18 == Constants.VOICE_STATE.TALKING

	React.useEffect(function() -- line: 65
		-- upvalues: v26 (copy), RunService (copy), v25 (copy), v20 (copy)
		if v26 then
			RunService:BindToRenderStep(v25, 1, function() -- line: 67
				-- upvalues: v20 (copy)
				v20(math.random())
			end)
		end

		return function() -- line: 71
			-- upvalues: v26 (copy), RunService (copy), v25 (copy)
			if v26 then
				RunService:UnbindFromRenderStep(v25)
			end
		end
	end, { v26 })

	local v27 = React.useMemo(function() -- line: 78
		-- upvalues: v24 (copy), t1 (copy), Constants (copy), default (copy)
		local v32 = v24
		local iconStyle = t1.iconStyle

		return v32:map(function(p4) -- line: 24
			-- upvalues: Constants (copy), default (copy), iconStyle (copy)
			local v35 = p4[1]
			local v36 = p4[2]

			if v35 == Constants.VOICE_STATE.MUTED or v35 == Constants.VOICE_STATE.LOCAL_MUTED then
				return default:GetIcon("Muted", iconStyle)
			end

			if v35 == Constants.VOICE_STATE.CONNECTING then
				return default:GetIcon("Connecting", iconStyle)
			end

			if v35 == Constants.VOICE_STATE.INACTIVE then
				return default:GetIcon("Unmuted0", iconStyle)
			end

			if v35 == Constants.VOICE_STATE.TALKING then
				local v37 = math.floor(0.5 + 5 * v36) * 20

				return default:GetIcon("Unmuted" .. tostring(v37), iconStyle)
			end

			return default:GetIcon("Error", iconStyle)
		end)
	end, { t1.iconStyle })

	return Roact.createElement("ImageLabel", {
		BackgroundTransparency = t1.BackgroundTransparency or 1,
		Image = v27,
		ImageColor3 = t1.ImageColor3,
		ImageTransparency = t1.ImageTransparency,
		Position = t1.Position,
		Size = t1.Size or uDim2,
		[Roact.Children] = t1[Roact.Children]
	})
end

return VRBarVoiceIcon
