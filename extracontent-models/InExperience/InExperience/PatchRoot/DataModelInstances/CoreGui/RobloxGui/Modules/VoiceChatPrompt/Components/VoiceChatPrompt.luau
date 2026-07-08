local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local InGameMenuPolicy = require(script.Parent.Parent.Parent.InGameMenu.InGameMenuPolicy)
local VoiceChatPromptFrame = require(script.Parent.VoiceChatPromptFrame)
local v6 = Roact.PureComponent:extend("VoiceChatPrompt")

v6.validateProps = t.strictInterface({
	promptSignal = t.optional(t.RBXScriptSignal),
	errorText = t.optional(t.string),
	bannedUntil = t.optional(t.string),
	onContinueFunc = t.optional(t.callback),
	onPrimaryActivated = t.optional(t.callback),
	onSecondaryActivated = t.optional(t.callback),
	onReadyForSignal = t.optional(t.callback),
	Analytics = t.optional(t.table),
	VoiceChatServiceManager = t.optional(t.table),
	policyMapper = t.optional(t.callback),
	settingsAppAvailable = t.optional(t.boolean)
})

function v6.render(p1) -- line: 27
	-- upvalues: Roact (copy), InGameMenuPolicy (copy), VoiceChatPromptFrame (copy)
	return Roact.createElement("ScreenGui", {
		AutoLocalize = false,
		DisplayOrder = 9,
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		PolicyProvider = Roact.createElement(InGameMenuPolicy.Provider, {
			policy = { p1.props.policyMapper or InGameMenuPolicy.Mapper }
		}, {
			Content = Roact.createElement(VoiceChatPromptFrame, p1.props)
		})
	})
end

return v6
