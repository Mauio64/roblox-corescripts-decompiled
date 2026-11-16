local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local NotificationModalsManager = require(parent.NotificationModalsManager)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(InlineRichText.Types)

return function(p)
	local v = useLocalization({ errorToastText = "CommonUI.Messages.Response.SomethingWentWrong" })
	local toastTitle

	if p.errorToastTextOverride and p.errorToastTextOverride ~= "" then
		toastTitle = p.errorToastTextOverride
	else
		toastTitle = v.errorToastText
	end

	return React.useCallback(function()
		NotificationModalsManager.SetUIBloxToast({
			toastTitle = toastTitle,
			sequenceNumber = DateTime.now().UnixTimestamp
		})
	end, { toastTitle })
end
