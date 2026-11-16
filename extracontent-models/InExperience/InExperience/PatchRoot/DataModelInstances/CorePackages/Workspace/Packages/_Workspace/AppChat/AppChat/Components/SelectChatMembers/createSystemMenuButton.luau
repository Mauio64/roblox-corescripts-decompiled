local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local ArgCheck = require(parent.ArgCheck)
local React = require(parent.React)
local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)

local UIBlox = require(parent.UIBlox)
local TextButton = UIBlox.App.Button.TextButton

local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)

return function(props)
	local localizedStrings = props.localizedStrings
	local isDisabled = props.isDisabled
	local onActivated = props.onActivated
	ArgCheck.isNotNil(localizedStrings, "props.localizedStrings")

	local element = Roact.createElement(TextButton, {
		text = localizedStrings.systemButtonText,
		isDisabled = isDisabled,
		onActivated = function()
			if isDisabled then
				return
			end

			if onActivated then
				onActivated(localizedStrings)
			end
		end
	})

	if FFlagAppChatDomLocatorFoundationMigration and props.testId then
		return React.createElement(Foundation.View, { tag = "auto-xy", testId = props.testId }, {
			button = element
		})
	end

	return element
end
