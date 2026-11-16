local parent = script:FindFirstAncestor("ProgressLoading").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local useLocalization = Localization.Hooks.useLocalization

local function PolicyContainer(p)
	local v = useLocalization({
		antiAddictionText = "Authentication.Login.WeChat.AntiAddictionText"
	})

	return React.createElement(Foundation.Text, {
		Position = p.position,
		Text = v.antiAddictionText,
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-system-contrast"
	})
end

return PolicyContainer
