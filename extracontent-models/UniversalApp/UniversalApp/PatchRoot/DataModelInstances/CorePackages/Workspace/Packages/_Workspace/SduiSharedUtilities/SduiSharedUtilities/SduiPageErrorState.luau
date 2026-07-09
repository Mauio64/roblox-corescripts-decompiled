local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local SystemBanner = Foundation.SystemBanner
local AlertSeverity = Foundation.Enums.AlertSeverity
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function SduiPageErrorState(t1: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), React (copy), SystemBanner (copy), AlertSeverity (copy), ButtonVariant (copy)
	local v10 = useLocalization({
		title = "CommonUI.Messages.Response.PageError",
		description = "Feature.Toast.NetworkingError.SomethingIsWrong",
		retry = "InGame.CommonUI.Button.Retry"
	})

	return React.createElement(SystemBanner, {
		severity = AlertSeverity.Error,
		title = v10.title,
		description = v10.description,
		actions = {{
			text = v10.retry,
			variant = ButtonVariant.Standard,
			onActivated = t1.refresh
		}}
	})
end

return React.memo(SduiPageErrorState)
