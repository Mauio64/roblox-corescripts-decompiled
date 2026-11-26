local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Foundation")
local systemBanner = Foundation.SystemBanner
local alertSeverity = Foundation.Enums.AlertSeverity
local buttonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Localization").Hooks.useLocalization

local function SduiPageErrorState(p2)
	local v5 = useLocalization({
		title = "CommonUI.Messages.Response.PageError",
		description = "Feature.Toast.NetworkingError.SomethingIsWrong",
		retry = "InGame.CommonUI.Button.Retry"
	})

	return React.createElement(systemBanner, {
		severity = alertSeverity.Error,
		title = v5.title,
		description = v5.description,
		actions = {
			{
				text = v5.retry,
				variant = buttonVariant.Standard,
				onActivated = p2.refresh
			}
		}
	})
end

return React.memo(SduiPageErrorState)
