local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
game:GetService("Players")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local Constants = require(script.Parent.Parent.Constants)
local Logger = require(script.Parent.Parent.Logger)
local logger = Logger(script.Name)

local BubbleChatBillboard = require(script.Parent.BubbleChatBillboard)

local GetFFlagBubbleVoiceIndicatorSetting = require(RobloxGui.Modules.Flags.GetFFlagBubbleVoiceIndicatorSetting)

local extended = Roact.Component:extend("ChatBillboards")

extended.validateProps = t.strictInterface({
	userMessages = t.map(t.string, t.array(t.string)),
	bubbleChatEnabled = t.boolean,
	voiceEnabled = t.boolean,
	participants = t.map(t.string, t.string)
})

function extended.getDerivedStateFromProps(p, p2)
	return {
		userMessages = Cryo.Dictionary.join(p2.userMessages or {}, p.userMessages)
	}
end

function extended:init()
	logger:debug("Initializing")
	self:setState({ userMessages = {} })

	function self.onBillboardFadeOut(p)
		self:setState({
			userMessages = Cryo.Dictionary.join(self.state.userMessages, { [p] = Cryo.None })
		})
	end
end

function extended.render(props)
	if not (props.props.voiceEnabled or props.props.bubbleChatEnabled) then
		return
	end

	local v = {}

	for k, _ in pairs(props.state.userMessages) do
		v[k] = false
	end

	for k, participant in pairs(props.props.participants) do
		if participant ~= Constants.VOICE_STATE.HIDDEN then
			v[k] = true
		end
	end

	local children = {}

	for k, v2 in pairs(v) do
		logger:trace("Rendering billboard for ...{}", (string.sub(tostring(k), -4)))
		children["BubbleChat_" .. k] = Roact.createElement(BubbleChatBillboard, {
			userId = k,
			onFadeOut = props.onBillboardFadeOut,
			voiceEnabled = props.props.voiceEnabled and v2,
			bubbleChatEnabled = props.props.bubbleChatEnabled
		})
	end

	return Roact.createElement("ScreenGui", { ResetOnSpawn = false }, children)
end

local function mapStateToProps(data)
	local voiceEnabled = data.components.voiceEnabled

	if GetFFlagBubbleVoiceIndicatorSetting() then
		voiceEnabled = data.components.voiceEnabled and data.chatSettings.Voice.ShowIndicator
	end

	return {
		userMessages = data.userMessages,
		voiceEnabled = voiceEnabled,
		bubbleChatEnabled = data.components.bubbleChatEnabled,
		participants = data.voiceState
	}
end

return RoactRodux.connect(mapStateToProps)(extended)
