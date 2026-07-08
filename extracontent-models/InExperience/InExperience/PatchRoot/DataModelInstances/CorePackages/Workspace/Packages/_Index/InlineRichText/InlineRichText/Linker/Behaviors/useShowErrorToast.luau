local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local NotificationModalsManager = require(InlineRichTextParent.NotificationModalsManager)
local React = require(InlineRichTextParent.React)
local useLocalization = require(InlineRichTextParent.Localization).Hooks.useLocalization

require(InlineRichText.Types)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: useLocalization (copy), React (copy), NotificationModalsManager (copy)
	local v7 = useLocalization({
		errorToastText = "CommonUI.Messages.Response.SomethingWentWrong"
	})
	local v8 = if not t1.errorToastTextOverride or t1.errorToastTextOverride == "" then v7.errorToastText else t1.errorToastTextOverride

	return React.useCallback(function() -- line: 22
		-- upvalues: NotificationModalsManager (copy), v8 (copy)
		NotificationModalsManager.SetUIBloxToast({
			toastTitle = v8,
			sequenceNumber = DateTime.now().UnixTimestamp
		})
	end, { v8 })
end
