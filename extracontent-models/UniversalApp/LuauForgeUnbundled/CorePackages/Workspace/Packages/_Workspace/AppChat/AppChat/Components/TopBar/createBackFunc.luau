local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local FFlagAppChatFixBackButtonOnRotation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFixBackButtonOnRotation")
local canPopParentStack = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/canPopParentStack")

local function createBackFunc(data)
	local navigateToRootStack = data.navigateToRootStack

	if navigateToRootStack then
		return function()
			if data.closeInputBar then
				data.closeInputBar()
			end

			if not data.isRoot then
				data.navigation.pop()

				return
			end

			if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(data.navigation) then
				data.navigation.pop()
				return
			end

			data.navigation.navigate(EnumScreens.EmptyConversation)
			navigateToRootStack()
		end
	end

	return data.navigation.pop
end

return createBackFunc
