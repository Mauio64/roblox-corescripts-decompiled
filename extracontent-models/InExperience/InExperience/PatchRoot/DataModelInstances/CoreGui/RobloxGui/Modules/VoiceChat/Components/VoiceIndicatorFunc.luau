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
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local v16 = game:DefineFastFlag("VoiceIndicatorPerformanceOptimizationsV2", false)
local v17 = game:DefineFastInt("MicTalkingUpdateFrequency", 3)
local uDim2 = UDim2.fromOffset(28, 28)

local function useJoinBinding(p1, p2) -- line: 32
	-- upvalues: React (copy), Roact (copy)
	return React.useMemo(function() -- line: 33
		-- upvalues: Roact (copy), p1 (copy), p2 (copy)
		return Roact.joinBindings({
			p1,
			p2
		})
	end, {
		p1,
		p2
	})
end
local function mapLevelToIcon(p3, p4) -- line: 38
	-- upvalues: Constants (copy), default (copy)
	return function(p5) -- line: 40
		-- upvalues: Constants (copy), default (copy), p3 (copy), p4 (copy)
		local v52 = p5[1]
		local v53 = p5[2]

		if v52 == Constants.VOICE_STATE.MUTED or v52 == Constants.VOICE_STATE.LOCAL_MUTED then
			return default:GetIcon("Muted", p3)
		end

		if v52 == Constants.VOICE_STATE.CONNECTING or v52 == Constants.VOICE_STATE.HIDDEN then
			if p4 and p3 == "MicLight" then
				return default:GetIcon("Connecting", "MicDark")
			end

			return default:GetIcon("Connecting", p3)
		end

		if v52 == Constants.VOICE_STATE.INACTIVE then
			return default:GetIcon("Unmuted0", p3)
		end

		if v52 == Constants.VOICE_STATE.TALKING then
			local v54 = math.floor(0.5 + 5 * v53) * 20

			return default:GetIcon("Unmuted" .. tostring(v54), p3)
		end

		return default:GetIcon("Error", p3)
	end
end

local t1 = {
	[Constants.VOICE_STATE.ERROR] = true,
	[Constants.VOICE_STATE.HIDDEN] = true
}

local function GenerateGUID() -- line: 67
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID()
end
local function createTweenShimmeringEffect(p6) -- line: 83
	-- upvalues: TweenService (copy)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out, -1)
	local t2 = {
		Offset = Vector2.new(1, 0)
	}

	return (TweenService:Create(p6:getValue(), tweenInfo, t2))
end
local function VoiceIndicator(t3: {[any]: any}) -- line: 91
	-- upvalues: useVoiceState (copy), React (copy), Roact (copy), GenerateGUID (copy), Constants (copy), createTweenShimmeringEffect (copy), v16 (copy), RunService (copy), v17 (copy), t1 (copy), ReactIs (copy), default (copy), useSelectionCursor (copy), CursorKind (copy), uDim2 (copy)
	local v33 = useVoiceState(t3.userId, t3.disable or false)
	local v34, v35 = React.useBinding(0)
	local v36 = t3.selectable == nil or t3.selectable
	local v37, v38 = React.useBinding(v33)
	local v39 = React.useMemo(function() -- line: 33
		-- upvalues: Roact (copy), v37 (copy), v34 (copy)
		return Roact.joinBindings({
			v37,
			v34
		})
	end, {
		v37,
		v34
	})
	local v40 = React.useRef(GenerateGUID()).current or ""

	v38(v33)

	local v41 = v33 == Constants.VOICE_STATE.TALKING
	local v42 = v33 == Constants.VOICE_STATE.CONNECTING
	local v43 = t3.showConnectingShimmer == true
	local v44 = React.useRef(nil)

	React.useEffect(function() -- line: 105
		-- upvalues: v43 (copy), v42 (copy), v44 (copy), createTweenShimmeringEffect (copy)
		if v43 and (v42 and v44.current) then
			local v55 = createTweenShimmeringEffect(v44)

			v55:Play()

			return function() -- line: 110
				-- upvalues: v55 (copy)
				v55:Cancel()
			end
		end

		return function() -- line: 114
		end
	end, {
		v42,
		v43
	})

	if v16 then
		local v45 = React.useRef(false)

		v45.current = v33 == Constants.VOICE_STATE.TALKING
		React.useEffect(function() -- line: 121
			-- upvalues: RunService (copy), v40 (copy), v45 (copy), v17 (copy), v35 (copy)
			local n1 = 0

			RunService:BindToRenderStep(v40, 1, function() -- line: 124
				-- upvalues: v45 (copy), n1 (ref), v17 (copy), v35 (copy)
				if not v45.current then
					return
				end

				n1 += 1

				if n1 >= v17 then
					n1 = 0
					v35(math.random())
				end
			end)

			return function() -- line: 136
				-- upvalues: RunService (copy), v40 (copy)
				RunService:UnbindFromRenderStep(v40)
			end
		end, { v40 })
	else
		React.useEffect(function() -- line: 141
			-- upvalues: v41 (copy), RunService (copy), v40 (copy), v35 (copy)
			if v41 then
				RunService:BindToRenderStep(v40, 1, function() -- line: 143
					-- upvalues: v35 (copy)
					v35(math.random())
				end)
			end

			return function() -- line: 147
				-- upvalues: v41 (copy), RunService (copy), v40 (copy)
				if v41 then
					RunService:UnbindFromRenderStep(v40)
				end
			end
		end, {
			v41,
			v40
		})
	end

	local v46 = t3.hideOnError and (not v33 or t1[v33])
	local v47 = v33 ~= Constants.VOICE_STATE.LOCAL_MUTED and 0 or 0.5

	if t3.iconTransparency then
		local v48 = v47

		v47 = if not ReactIs.isBinding(t3.iconTransparency) then 1 - (1 - t3.iconTransparency) * (1 - v48) else t3.iconTransparency:map(function(p7) -- line: 161
			-- upvalues: v48 (copy)
			return 1 - (1 - p7) * (1 - v48)
		end)
	end

	local v49 = React.useMemo(function() -- line: 169
		-- upvalues: v39 (copy), t3 (copy), v43 (copy), Constants (copy), default (copy)
		local v58 = v39
		local iconStyle = t3.iconStyle
		local v60 = v43

		return v58:map(function(p8) -- line: 40
			-- upvalues: Constants (copy), default (copy), iconStyle (copy), v60 (copy)
			local v62 = p8[1]
			local v63 = p8[2]

			if v62 == Constants.VOICE_STATE.MUTED or v62 == Constants.VOICE_STATE.LOCAL_MUTED then
				return default:GetIcon("Muted", iconStyle)
			end

			if v62 == Constants.VOICE_STATE.CONNECTING or v62 == Constants.VOICE_STATE.HIDDEN then
				if v60 and iconStyle == "MicLight" then
					return default:GetIcon("Connecting", "MicDark")
				end

				return default:GetIcon("Connecting", iconStyle)
			end

			if v62 == Constants.VOICE_STATE.INACTIVE then
				return default:GetIcon("Unmuted0", iconStyle)
			end

			if v62 == Constants.VOICE_STATE.TALKING then
				local v64 = math.floor(0.5 + 5 * v63) * 20

				return default:GetIcon("Unmuted" .. tostring(v64), iconStyle)
			end

			return default:GetIcon("Error", iconStyle)
		end)
	end, {
		t3.iconStyle,
		v43
	})
	local v50 = useSelectionCursor(CursorKind.RoundedRectNoInset)

	return Roact.createElement("ImageButton", {
		Size = t3.size or uDim2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = v49,
		ImageTransparency = v47,
		Selectable = v36,
		SelectionImageObject = v50,
		Visible = not v46,
		[Roact.Event.Activated] = t3.onClicked
	}, {
		ShimmerGradient = if not v43 then nil else Roact.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.6, 0.6, 0.6)),
				ColorSequenceKeypoint.new(0.5, Color3.new(0.8, 0.8, 0.8)),
				ColorSequenceKeypoint.new(1, Color3.new(0.6, 0.6, 0.6))
			}),
			Enabled = v42,
			Rotation = -45,
			Offset = Vector2.new(-1, 0),
			[Roact.Ref] = v44
		})
	})
end

return VoiceIndicator
