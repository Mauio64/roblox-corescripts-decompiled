local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ArgCheck = require(AppChatParent.ArgCheck)
local React = require(AppChatParent.React)
local Roact = require(AppChatParent.Roact)
local Foundation = require(AppChatParent.Foundation)
local TextButton = require(AppChatParent.UIBlox).App.Button.TextButton
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)

return function(p1) -- line: 14
	-- upvalues: ArgCheck (copy), Roact (copy), TextButton (copy), FFlagAppChatDomLocatorFoundationMigration (copy), React (copy), Foundation (copy)
	local localizedStrings = p1.localizedStrings
	local isDisabled = p1.isDisabled
	local onActivated = p1.onActivated

	ArgCheck.isNotNil(localizedStrings, "props.localizedStrings")

	local v13 = Roact.createElement(TextButton, {
		text = localizedStrings.systemButtonText,
		isDisabled = isDisabled,
		onActivated = function() -- line: 24
			-- upvalues: isDisabled (copy), onActivated (copy), localizedStrings (copy)
			if isDisabled then
				return
			end

			if onActivated then
				onActivated(localizedStrings)
			end
		end
	})

	if FFlagAppChatDomLocatorFoundationMigration and p1.testId then
		return React.createElement(Foundation.View, {
			tag = "auto-xy",
			testId = p1.testId
		}, {
			button = v13
		})
	end

	return v13
end
