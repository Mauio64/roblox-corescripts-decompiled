local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local SystemBanner = Foundation.SystemBanner
local AlertSeverity = Foundation.Enums.AlertSeverity
local ButtonVariant = Foundation.Enums.ButtonVariant
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function SduiPageErrorState(p)
	local v = useLocalization({
		title = "CommonUI.Messages.Response.PageError",
		description = "Feature.Toast.NetworkingError.SomethingIsWrong",
		retry = "InGame.CommonUI.Button.Retry"
	})

	return React.createElement(SystemBanner, {
		severity = AlertSeverity.Error,
		title = v.title,
		description = v.description,
		actions = {
			{ text = v.retry, variant = ButtonVariant.Standard, onActivated = p.refresh }
		}
	})
end

return React.memo(SduiPageErrorState)
