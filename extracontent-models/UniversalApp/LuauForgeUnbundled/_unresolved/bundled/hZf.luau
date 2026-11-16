local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dYT")
local module2 = require("@luauforge/bundled/hZg")

local getPlatformTarget = require("@luauforge/bundled/bXw").getPlatformTarget
local module3 = require("@luauforge/bundled/dYV")
local eventTypes = module3.Analytics.Enums.EventTypes
local contexts = module3.Analytics.Enums.Contexts
local pages = module3.Analytics.Enums.Pages
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/hZh")

game:DefineFastString("ShareLinkAppOpen", "ShareLinkAppOpen")
game:DefineFastString("ShareLinkResolved", "ShareLinkResolved")
game:DefineFastString("ShareLinkErrorDialogCancelButtonClick", "ShareLinkErrorDialogCancelButtonClick")
game:DefineFastString("ShareLinkErrorDialogJoinButtonClick", "ShareLinkErrorDialogJoinButtonClick")
game:DefineFastString("ShareLinkLaunchGame", "ShareLinkLaunchGame")

return {
	get = function(p2)
		local v5 = module.get(p2)

		return {
			openAppViaShareLink = function(p3)
				v5.EventStream:setRBXEventStream(
					contexts.ShareLinks,
					eventTypes.AppOpenViaShareLink,
					Cryo.Dictionary.join({ target = getPlatformTarget() }, p3)
				)

				local v6 = p3.isViaAppsFlyer and "AppsFlyer" or ""
				v5.Diag:reportCounter(`{game:GetFastString("ShareLinkAppOpen")}{p3.linkType}{v6}`, 1)
			end,
			resolveLink = function(p3)
				v5.EventStream:setRBXEventStream(
					contexts.ShareLinks,
					eventTypes.LinkResolved,
					Cryo.Dictionary.join({ target = getPlatformTarget() }, p3)
				)
				v5.Diag:reportCounter(
					game:GetFastString("ShareLinkResolved") .. p3.linkStatus .. p3.linkType,
					1
				)
			end,
			errorDialogButtonClick = function(p3)
				v5.EventStream:setRBXEventStream(
					contexts.ShareLinks,
					eventTypes.ButtonClick,
					Cryo.Dictionary.join(
						{
							target = getPlatformTarget(),
							btn = "cancel",
							page = pages.ShareLinkErrorDialog
						},
						p3
					)
				)
				v5.Diag:reportCounter(
					game:GetFastString("ShareLinkErrorDialogCancelButtonClick") .. p3.linkType,
					1
				)
			end,
			errorJoinDialogButtonClick = function(p3)
				v5.EventStream:setRBXEventStream(
					contexts.ShareLinks,
					eventTypes.ButtonClick,
					Cryo.Dictionary.join(
						{
							target = getPlatformTarget(),
							btn = "join",
							page = pages.ShareLinkErrorDialog
						},
						p3
					)
				)
				v5.Diag:reportCounter(
					game:GetFastString("ShareLinkErrorDialogJoinButtonClick") .. p3.linkType,
					1
				)
			end,
			gameLaunch = function(data)
				module2(v5.EventStream, contexts.ShareLinks, {
					placeId = data.placeId,
					rootPlaceId = tonumber(data.placeId),
					linkId = data.linkId,
					linkType = data.linkType,
					linkStatus = data.linkStatus,
					joinAttemptId = data.joinAttemptId
				})
				v5.Diag:reportCounter(game:GetFastString("ShareLinkLaunchGame") .. data.linkType, 1)
			end
		}
	end
}
