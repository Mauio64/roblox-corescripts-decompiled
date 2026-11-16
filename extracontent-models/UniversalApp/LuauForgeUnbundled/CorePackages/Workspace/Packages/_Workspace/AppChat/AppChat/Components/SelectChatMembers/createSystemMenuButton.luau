local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")

local textButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.Button.TextButton

local FFlagAppChatDomLocatorFoundationMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDomLocatorFoundationMigration")

return function(props)
	local localizedStrings = props.localizedStrings
	local isDisabled = props.isDisabled
	local onActivated = props.onActivated
	ArgCheck.isNotNil(localizedStrings, "props.localizedStrings")

	local element = Roact.createElement(textButton, {
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
		return React.createElement(Foundation.View, {
			tag = "auto-xy",
			testId = props.testId
		}, {
			button = element
		})
	end

	return element
end
