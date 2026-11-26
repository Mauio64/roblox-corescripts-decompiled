local module = require("@luauforge/bundled/gjJ")
local useLocalization = require("@luauforge/bundled/gjH").Hooks.useLocalization

require("@luauforge/bundled/gya")
local module2 = require("@luauforge/bundled/gye")

local iconName = module.Enums.IconName

local function keepLanding() end

local function useCrossDeviceMagicSignInViewModel()
	local v5 = useLocalization({
		getStarted = "Authentication.Login.Heading.GetStarted",
		chooseHowToPlay = "Authentication.Login.Description.ChooseHowToPlay",
		usernameAndPassword = "Authentication.Login.Action.UsernameAndPassword",
		getCodeByEmail = "Authentication.Login.Action.GetCodeByEmail",
		createAccount = "Authentication.SignUp.Action.CreateAccountSentenceCase"
	})

	local v6 = {
		{
			key = "UsernameAndPassword",
			kind = "action",
			icon = iconName.LockClosed,
			text = v5.usernameAndPassword,
			onActivated = keepLanding
		},
		{
			key = "GetCodeByEmail",
			kind = "action",
			icon = iconName.Envelope,
			text = v5.getCodeByEmail,
			onActivated = keepLanding
		},
		{ key = "CreateAccountDivider", kind = "divider" },
		{
			key = "CreateAccount",
			kind = "action",
			icon = iconName.CirclePerson,
			text = v5.createAccount,
			onActivated = keepLanding
		}
	}

	return {
		card = {
			page = "landing",
			title = v5.getStarted,
			body = v5.chooseHowToPlay,
			rows = v6
		},
		showsQr = module2.showsQr("landing")
	}
end

return useCrossDeviceMagicSignInViewModel
