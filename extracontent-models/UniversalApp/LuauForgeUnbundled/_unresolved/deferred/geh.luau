local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking

local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module2 = require("@luauforge/bundled/fot")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/deferred/fAy")
local module4 = require("@luauforge/deferred/fyr")

local extended = Roact.PureComponent:extend("TencentHelpWrapper")

extended.validateProps = t.strictInterface({
	guiService = t.union(t.Instance, t.table),
	linking = t.table,
	openId = t.string,
	userId = t.string
})

function extended:render()
	local platform = UserInputService:GetPlatform()

	if platform == Enum.Platform.IOS or platform == Enum.Platform.Android then
		self:broadcastNotification()
		return nil
	end

	local linking = self.props.linking
	local openId = self.props.openId
	local userId = self.props.userId
	module4(
		linking,
		(string.format(
			"%s?sign=%s&uid=%s&c1=%s",
			"https://www.700chat.com/xv/web/static/chat/index.html",
			"37ef9b97d27505cf7010cde71be4b531abd89bc57750c3c8ec20dfdeab0d5d2d38342d82206c7c73b17486525a9637055bb161",
			openId,
			userId
		))
	)
end

function extended:broadcastNotification()
	local SDK_OPEN_URL = module2.SDK_OPEN_URL
	local jsonEncode = HttpService:JSONEncode({
		type = module3.TENCENT_SMART_HELP_CENTER
	})

	self.props.guiService:BroadcastNotification(jsonEncode, SDK_OPEN_URL)
end

local v5 = roactServices.connect({ guiService = appGuiService, linking = appLinking })(extended)

return (useSheetNavigation.connect(function(p2, p3)
	return { userId = p2.LocalUserId, openId = p2.Luobu.MSDKAuth.openId }
end)(v5))
