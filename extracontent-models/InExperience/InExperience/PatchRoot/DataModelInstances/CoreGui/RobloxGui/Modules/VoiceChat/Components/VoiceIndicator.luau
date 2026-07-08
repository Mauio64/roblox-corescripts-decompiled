local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local v8 = require(RobloxGui.Modules.VoiceChat.Logger)(script.Name)
local Roact = require(CorePackages.Packages.Roact)
local ReactIs = require(CorePackages.Packages.ReactIs)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local v15 = Roact.PureComponent:extend("VoiceIndicator")

v15.validateProps = t.strictInterface({
	onClicked = t.optional(t.callback),
	userId = t.string,
	hideOnError = t.optional(t.boolean),
	size = t.optional(t.UDim2),
	iconStyle = t.optional(t.union(t.literal("MicDark"), t.literal("MicLight"), t.literal("SpeakerDark"), t.literal("SpeakerLight"))),
	iconTransparency = t.optional(t.union(t.number, t.table)),
	voiceState = t.string
})
v15.defaultProps = {}

function v15.getIcon(_, p2) -- line: 47
	return "rbxasset://textures/ui/VoiceChat/" .. p2 .. ".png"
end
function v15.init(p3) -- line: 51
	-- upvalues: Roact (copy), HttpService (copy), RunService (copy), Constants (copy), default (copy)
	local v20, v21 = Roact.createBinding(0)

	p3.level = v20
	p3.updateLevel = v21

	local v22, v23 = Roact.createBinding(p3.props.voiceState)

	p3.voiceState = v22
	p3.updateVoiceState = v23
	p3.renderStepName = HttpService:GenerateGUID()
	RunService:BindToRenderStep(p3.renderStepName, 1, function() -- line: 58
		-- upvalues: p3 (copy)
		p3.updateLevel(math.random())
	end)
	p3.levelIcon = Roact.joinBindings({
		p3.voiceState,
		p3.level
	}):map(function(p4) -- line: 62
		-- upvalues: Constants (copy), default (copy), p3 (copy)
		local v37 = p4[1]
		local v38 = p4[2]

		if v37 == Constants.VOICE_STATE.MUTED or v37 == Constants.VOICE_STATE.LOCAL_MUTED then
			return default:GetIcon("Muted", p3.props.iconStyle)
		end

		if v37 == Constants.VOICE_STATE.CONNECTING then
			return default:GetIcon("Connecting", p3.props.iconStyle)
		end

		if v37 == Constants.VOICE_STATE.INACTIVE then
			return default:GetIcon("Unmuted0", p3.props.iconStyle)
		end

		if v37 == Constants.VOICE_STATE.TALKING then
			local v39 = math.floor(v38 * 5 + 0.5) * 20

			return default:GetIcon("Unmuted" .. tostring(v39), p3.props.iconStyle)
		end

		return default:GetIcon("Error", p3.props.iconStyle)
	end)
end
function v15.renderWithSelectionCursor(p5, p6) -- line: 82
	-- upvalues: Constants (copy), ReactIs (copy), Roact (copy), CursorKind (copy)
	local v26 = p5.props.voiceState == Constants.VOICE_STATE.ERROR or p5.props.voiceState == Constants.VOICE_STATE.HIDDEN

	if p5.props.hideOnError and (not p5.props.voiceState or v26) then
		return nil
	end

	local v27 = p5.props.voiceState ~= Constants.VOICE_STATE.LOCAL_MUTED and 0 or 0.5

	if p5.props.iconTransparency then
		local v28 = v27

		v27 = if not ReactIs.isBinding(p5.props.iconTransparency) then 1 - (1 - p5.props.iconTransparency) * (1 - v28) else p5.props.iconTransparency:map(function(p7) -- line: 94
			-- upvalues: v28 (copy)
			return 1 - (1 - p7) * (1 - v28)
		end)
	end

	return Roact.createElement("ImageButton", {
		Size = p5.props.size or UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = p5.levelIcon,
		ImageTransparency = v27,
		SelectionImageObject = p6(CursorKind.RoundedRectNoInset),
		[Roact.Event.Activated] = p5.props.onClicked
	})
end
function v15.render(p8) -- line: 113
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p9) -- line: 114
		-- upvalues: p8 (copy)
		return p8:renderWithSelectionCursor(p9)
	end)
end
function v15.didUpdate(p10, p11, _) -- line: 119
	-- upvalues: v8 (copy)
	v8:trace("Voice state updated to {} for ...{}", p10.props.voiceState, (string.sub(tostring(p10.props.userId), -4)))

	if p11.voiceState ~= p10.props.voiceState then
		p10.updateVoiceState(p10.props.voiceState)
	end
end
function v15.willUnmount(p13) -- line: 126
	-- upvalues: RunService (copy)
	pcall(function() -- line: 127
		-- upvalues: RunService (copy), p13 (copy)
		RunService:UnbindFromRenderStep(p13.renderStepName)
	end)
end

local function mapStateToProps(p14, p15) -- line: 132
	return {
		voiceState = p14.voiceState[p15.userId]
	}
end

return RoactRodux.connect(mapStateToProps)(v15)
