local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local FetchChatSettings = require(CorePackages.Workspace.Packages.AppChat.FetchChatSettings)
local t1 = {
	isActiveChatUser = false
}

return Rodux.createReducer(t1, {
	[FetchChatSettings.Succeeded.name] = function(p1, p2) -- line: 11
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			chatEnabled = p2.responseBody.chatEnabled
		})
	end
})
