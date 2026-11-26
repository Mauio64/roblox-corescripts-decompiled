local useLocalization = require("@luauforge/bundled/hHV").Hooks.useLocalization

require("@luauforge/bundled/hIA")
local module = require("@luauforge/bundled/hIa")

local function useRedirectErrorDialogViewModel(p2)
	local v5 = useLocalization({
		title = "Feature.Premium.Message.SomethingWentWrong",
		body = "Feature.Premium.Message.PleaseTryAgain"
	})

	local v6 = module(p2.onClose)

	return {
		title = v5.title,
		body = v5.body,
		onClose = p2.onClose,
		focusRef = v6,
		testId = "redirect-error-dialog"
	}
end

return useRedirectErrorDialogViewModel
