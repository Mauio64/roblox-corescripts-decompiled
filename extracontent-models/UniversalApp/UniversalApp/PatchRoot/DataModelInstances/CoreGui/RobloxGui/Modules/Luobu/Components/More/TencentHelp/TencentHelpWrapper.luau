local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local RoactRodux = require(Modules.Common.RoactRodux)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Constants = require(Modules.Luobu.Constants)
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local v14 = Roact.PureComponent:extend("TencentHelpWrapper")

v14.validateProps = t.strictInterface({
	guiService = t.union(t.Instance, t.table),
	linking = t.table,
	openId = t.string,
	userId = t.string
})

function v14.render(p1) -- line: 29
	-- upvalues: UserInputService (copy), openExternalBrowser (copy)
	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android then
		p1:broadcastNotification()

		return nil
	end

	local linking = p1.props.linking
	local openId = p1.props.openId
	local userId = p1.props.userId
	local v21 = string.format("%s?sign=%s&uid=%s&c1=%s", "https://www.700chat.com/xv/web/static/chat/index.html", "37ef9b97d27505cf7010cde71be4b531abd89bc57750c3c8ec20dfdeab0d5d2d38342d82206c7c73b17486525a9637055bb161", openId, userId)

	openExternalBrowser(linking, v21)
end
function v14.broadcastNotification(p2) -- line: 46
	-- upvalues: NotificationType (copy), HttpService (copy), Constants (copy)
	local SDK_OPEN_URL = NotificationType.SDK_OPEN_URL
	local json = HttpService:JSONEncode({
		type = Constants.TENCENT_SMART_HELP_CENTER
	})

	p2.props.guiService:BroadcastNotification(json, SDK_OPEN_URL)
end

local v15 = RoactServices.connect({
	guiService = AppGuiService,
	linking = AppLinking
})(v14)

return (RoactRodux.connect(function(p3, _) -- line: 59
	return {
		userId = p3.LocalUserId,
		openId = p3.Luobu.MSDKAuth.openId
	}
end)(v15))
