local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/NotificationModalsManager")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

return function(p2)
	local v5 = useLocalization({
		errorToastText = "CommonUI.Messages.Response.SomethingWentWrong"
	})
	local v6

	if p2.errorToastTextOverride and p2.errorToastTextOverride ~= "" then
		v6 = p2.errorToastTextOverride
	else
		v6 = v5.errorToastText
	end

	return React.useCallback(function()
		NotificationModalsManager.SetUIBloxToast({
			toastTitle = v6,
			sequenceNumber = DateTime.now().UnixTimestamp
		})
	end, { v6 })
end
