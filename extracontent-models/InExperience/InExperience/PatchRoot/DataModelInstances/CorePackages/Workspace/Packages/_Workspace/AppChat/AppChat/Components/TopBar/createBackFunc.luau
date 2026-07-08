local AppChat = script:FindFirstAncestor("AppChat")
local EnumScreens = require(AppChat.EnumScreens)
local FFlagAppChatFixBackButtonOnRotation = require(AppChat.Flags.FFlagAppChatFixBackButtonOnRotation)
local canPopParentStack = require(AppChat.Utils.canPopParentStack)

local function createBackFunc(t1: {[any]: any}) -- line: 14
	-- upvalues: FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), EnumScreens (copy)
	local navigateToRootStack = t1.navigateToRootStack

	if navigateToRootStack then
		return function() -- line: 18
			-- upvalues: t1 (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), EnumScreens (copy), navigateToRootStack (copy)
			if t1.closeInputBar then
				t1.closeInputBar()
			end

			if t1.isRoot then
				if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(t1.navigation) then
					t1.navigation.pop()

					return
				end

				t1.navigation.navigate(EnumScreens.EmptyConversation)
				navigateToRootStack()

				return
			end

			t1.navigation.pop()
		end
	end

	return t1.navigation.pop
end

return createBackFunc
