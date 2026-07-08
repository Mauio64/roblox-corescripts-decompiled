local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

game:GetService("Players")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Constants = require(script.Parent.Parent.Constants)
local v9 = require(script.Parent.Parent.Logger)(script.Name)
local BubbleChatBillboard = require(script.Parent.BubbleChatBillboard)
local GetFFlagBubbleVoiceIndicatorSetting = require(RobloxGui.Modules.Flags.GetFFlagBubbleVoiceIndicatorSetting)
local v12 = Roact.Component:extend("ChatBillboards")

v12.validateProps = t.strictInterface({
	userMessages = t.map(t.string, t.array(t.string)),
	bubbleChatEnabled = t.boolean,
	voiceEnabled = t.boolean,
	participants = t.map(t.string, t.string)
})

function v12.getDerivedStateFromProps(p1, p2) -- line: 33
	-- upvalues: Cryo (copy)
	return {
		userMessages = Cryo.Dictionary.join(p2.userMessages or {}, p1.userMessages)
	}
end
function v12.init(p3) -- line: 42
	-- upvalues: v9 (copy), Cryo (copy)
	v9:debug("Initializing")
	p3:setState({
		userMessages = {}
	})

	function p3.onBillboardFadeOut(p4) -- line: 48
		-- upvalues: p3 (copy), Cryo (copy)
		p3:setState({
			userMessages = Cryo.Dictionary.join(p3.state.userMessages, {
				[p4] = Cryo.None
			})
		})
	end
end
function v12.render(p5) -- line: 55
	-- upvalues: Constants (copy), v9 (copy), Roact (copy), BubbleChatBillboard (copy)
	if not p5.props.voiceEnabled and not p5.props.bubbleChatEnabled then
		return
	end

	local t1 = {}

	for k, _ in pairs(p5.state.userMessages) do
		t1[k] = false
	end

	for k, v in pairs(p5.props.participants) do
		if v ~= Constants.VOICE_STATE.HIDDEN then
			t1[k] = true
		end
	end

	local t2 = {}

	for k, v in pairs(t1) do
		v9:trace("Rendering billboard for ...{}", (string.sub(tostring(k), -4)))
		t2["BubbleChat_" .. k] = Roact.createElement(BubbleChatBillboard, {
			userId = k,
			onFadeOut = p5.onBillboardFadeOut,
			voiceEnabled = p5.props.voiceEnabled and v,
			bubbleChatEnabled = p5.props.bubbleChatEnabled
		})
	end

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false
	}, t2)
end

local function mapStateToProps(p6) -- line: 93
	-- upvalues: GetFFlagBubbleVoiceIndicatorSetting (copy)
	local voiceEnabled = p6.components.voiceEnabled

	if GetFFlagBubbleVoiceIndicatorSetting() then
		voiceEnabled = p6.components.voiceEnabled and p6.chatSettings.Voice.ShowIndicator
	end

	return {
		userMessages = p6.userMessages,
		voiceEnabled = voiceEnabled,
		bubbleChatEnabled = p6.components.bubbleChatEnabled,
		participants = p6.voiceState
	}
end

return RoactRodux.connect(mapStateToProps)(v12)
