local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")

local useLocalization = Localization.Hooks.useLocalization

local function PolicyContainer(p2)
	local v5 = useLocalization({
		antiAddictionText = "Authentication.Login.WeChat.AntiAddictionText"
	})

	return React.createElement(Foundation.Text, {
		Position = p2.position,
		Text = v5.antiAddictionText,
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-system-contrast"
	})
end

return PolicyContainer
