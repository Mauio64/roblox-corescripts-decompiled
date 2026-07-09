local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local useLocalization = Localization.Hooks.useLocalization

local function PolicyContainer(t1: {[any]: any}) -- line: 14
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy)
	local v8 = useLocalization({
		antiAddictionText = "Authentication.Login.WeChat.AntiAddictionText"
	})

	return React.createElement(Foundation.Text, {
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-system-contrast",
		Position = t1.position,
		Text = v8.antiAddictionText
	})
end

return PolicyContainer
