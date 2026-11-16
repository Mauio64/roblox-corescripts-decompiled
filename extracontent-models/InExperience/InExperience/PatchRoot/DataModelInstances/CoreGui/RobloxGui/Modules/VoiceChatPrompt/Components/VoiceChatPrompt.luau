local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local FFlagVoiceChatBanDurationUseServerTime = require(script.Parent.Parent.Parent.VoiceChat.Flags.FFlagVoiceChatBanDurationUseServerTime)
local InGameMenuPolicy = require(script.Parent.Parent.Parent.InGameMenu.InGameMenuPolicy)

local VoiceChatPromptFrame = require(script.Parent.VoiceChatPromptFrame)

local extended = Roact.PureComponent:extend("VoiceChatPrompt")

local strictInterface = t.strictInterface
local v = {
	promptSignal = t.optional(t.RBXScriptSignal),
	errorText = t.optional(t.string),
	bannedUntil = 0,
	onContinueFunc = 0,
	onPrimaryActivated = 0,
	onSecondaryActivated = 0,
	onReadyForSignal = 0,
	Analytics = 0,
	VoiceChatServiceManager = 0,
	policyMapper = 0,
	settingsAppAvailable = 0
}
local optional = t.optional
local v2

if FFlagVoiceChatBanDurationUseServerTime then
	v2 = t.interface({ minutes = t.number, absoluteSeconds = t.number })
else
	v2 = t.string
end

v.bannedUntil = optional(v2)

v.onContinueFunc = t.optional(t.callback)
v.onPrimaryActivated = t.optional(t.callback)
v.onSecondaryActivated = t.optional(t.callback)
v.onReadyForSignal = t.optional(t.callback)
v.Analytics = t.optional(t.table)
v.VoiceChatServiceManager = t.optional(t.table)
v.policyMapper = t.optional(t.callback)
v.settingsAppAvailable = t.optional(t.boolean)
extended.validateProps = strictInterface(v)

function extended.render(p)
	return Roact.createElement("ScreenGui", {
		AutoLocalize = false,
		DisplayOrder = 9,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		PolicyProvider = Roact.createElement(InGameMenuPolicy.Provider, {
			policy = { p.props.policyMapper or InGameMenuPolicy.Mapper }
		}, {
			Content = Roact.createElement(VoiceChatPromptFrame, p.props)
		})
	})
end

return extended
