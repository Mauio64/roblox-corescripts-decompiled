local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local gamePlayIntent = require(Modules.LuaApp.Analytics.Events.Games.gamePlayIntent)
local getPlatformTarget = require(CorePackages.Workspace.Packages.Analytics).getPlatformTarget
local SocialLuaAnalytics = require(CorePackages.Workspace.Packages.SocialLuaAnalytics)
local EventTypes = SocialLuaAnalytics.Analytics.Enums.EventTypes
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local Pages = SocialLuaAnalytics.Analytics.Enums.Pages
local Cryo = require(CorePackages.Packages.Cryo)

require(Modules.LuaApp.DeepLinks.ShareLinks.Types)
game:DefineFastString("ShareLinkAppOpen", "ShareLinkAppOpen")
game:DefineFastString("ShareLinkResolved", "ShareLinkResolved")
game:DefineFastString("ShareLinkErrorDialogCancelButtonClick", "ShareLinkErrorDialogCancelButtonClick")
game:DefineFastString("ShareLinkErrorDialogJoinButtonClick", "ShareLinkErrorDialogJoinButtonClick")
game:DefineFastString("ShareLinkLaunchGame", "ShareLinkLaunchGame")

return {
	get = function(p1) -- line: 45
		-- upvalues: RoactAnalytics (copy), Contexts (copy), EventTypes (copy), Cryo (copy), getPlatformTarget (copy), Pages (copy), gamePlayIntent (copy)
		local v13 = RoactAnalytics.get(p1)

		return {
			openAppViaShareLink = function(p2) -- line: 50
				-- upvalues: v13 (copy), Contexts (copy), EventTypes (copy), Cryo (copy), getPlatformTarget (copy)
				v13.EventStream:setRBXEventStream(Contexts.ShareLinks, EventTypes.AppOpenViaShareLink, Cryo.Dictionary.join({
					target = getPlatformTarget()
				}, p2))

				local v15 = not p2.isViaAppsFlyer and "" or "AppsFlyer"

				v13.Diag:reportCounter(`{ game:GetFastString("ShareLinkAppOpen") }{ p2.linkType }{ v15 }`, 1)
			end,
			resolveLink = function(p3) -- line: 61
				-- upvalues: v13 (copy), Contexts (copy), EventTypes (copy), Cryo (copy), getPlatformTarget (copy)
				v13.EventStream:setRBXEventStream(Contexts.ShareLinks, EventTypes.LinkResolved, Cryo.Dictionary.join({
					target = getPlatformTarget()
				}, p3))
				v13.Diag:reportCounter(game:GetFastString("ShareLinkResolved") .. p3.linkStatus .. p3.linkType, 1)
			end,
			errorDialogButtonClick = function(p4) -- line: 74
				-- upvalues: v13 (copy), Contexts (copy), EventTypes (copy), Cryo (copy), getPlatformTarget (copy), Pages (copy)
				v13.EventStream:setRBXEventStream(Contexts.ShareLinks, EventTypes.ButtonClick, Cryo.Dictionary.join({
					btn = "cancel",
					target = getPlatformTarget(),
					page = Pages.ShareLinkErrorDialog
				}, p4))
				v13.Diag:reportCounter(game:GetFastString("ShareLinkErrorDialogCancelButtonClick") .. p4.linkType, 1)
			end,
			errorJoinDialogButtonClick = function(p5) -- line: 91
				-- upvalues: v13 (copy), Contexts (copy), EventTypes (copy), Cryo (copy), getPlatformTarget (copy), Pages (copy)
				v13.EventStream:setRBXEventStream(Contexts.ShareLinks, EventTypes.ButtonClick, Cryo.Dictionary.join({
					btn = "join",
					target = getPlatformTarget(),
					page = Pages.ShareLinkErrorDialog
				}, p5))
				v13.Diag:reportCounter(game:GetFastString("ShareLinkErrorDialogJoinButtonClick") .. p5.linkType, 1)
			end,
			gameLaunch = function(p6) -- line: 105
				-- upvalues: gamePlayIntent (copy), v13 (copy), Contexts (copy)
				gamePlayIntent(v13.EventStream, Contexts.ShareLinks, {
					placeId = p6.placeId,
					rootPlaceId = tonumber(p6.placeId),
					linkId = p6.linkId,
					linkType = p6.linkType,
					linkStatus = p6.linkStatus,
					joinAttemptId = p6.joinAttemptId
				})
				v13.Diag:reportCounter(game:GetFastString("ShareLinkLaunchGame") .. p6.linkType, 1)
			end
		}
	end
}
