local CorePackages = game:GetService("CorePackages")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")

local shareLinksRodux = require("@luauforge/bundled/hZG").ShareLinksRodux

local module = require("@luauforge/bundled/eec")

local module2 = require("@luauforge/bundled/hZI")
local module3 = require("@luauforge/bundled/hZO")
local module4 = require("@luauforge/bundled/hZP")
local module5 = require("@luauforge/bundled/hZQ")
local module6 = require("@luauforge/bundled/hZR")
local module7 = require("@luauforge/bundled/hZU")
local module8 = require("@luauforge/bundled/hZW")
local module9 = require("@luauforge/bundled/hZX")
local module10 = require("@luauforge/bundled/hZY")
local module11 = require("@luauforge/bundled/hZZ")
local linkStatus = shareLinksRodux.Enums.LinkStatus
local module12 = require("@luauforge/bundled/hMx")
require("@luauforge/bundled/hZh")
local Cryo = require(CorePackages.Packages.Cryo)
local fFlagTCShareLinkReceiverUI = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkReceiverUI
local fFlagTCShareLinkErrorModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkErrorModal

local fFlagEnableConnectionsDeepLinkSkipFilterCheck = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableConnectionsDeepLinkSkipFilterCheck

local module13 = require("@luauforge/bundled/hZV")

return function(data, data2, p2)
	local kind = string.lower(data.type or module12.Unknown)
	local code = data.code
	local shareLinksAnalytics = data2.analyticsImpls.shareLinksAnalytics
	module.Stopwatch.start(module.Events.ShareLinkOpened)
	data2.closeCentralOverlay()

	if data.v == "v2" or fFlagTCShareLinkReceiverUI and data.v == "v2-filtered" then
		if fFlagEnableConnectionsDeepLinkSkipFilterCheck then
			if fFlagTCShareLinkErrorModal then
				return (data2.resolveLinkFromLinkIdV2(code, p2):andThen(function(p3)
					shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.union(data, {
						code = Cryo.None,
						linkId = code,
						linkType = p3.responseBody.linkType,
						skipFilterCheck = Cryo.None,
						type = Cryo.None
					}))

					return module11(
						{
							linkId = code,
							linkType = kind,
							responseBody = p3.responseBody,
							isViaAppsFlyer = data.isViaAppsFlyer
						},
						data2
					)
				end):catch(function()
					module.Stopwatch.stop(module.Events.ShareLinkOpened)
					return {
						{
							{ name = appPage.Home },
							{
								name = appPage.ShareLinkInvalidModal,
								extraProps = {
									closeModal = function()
										shareLinksAnalytics.errorJoinDialogButtonClick({
											linkId = code,
											linkType = kind,
											linkStatus = linkStatus.Invalid.rawValue()
										})
									end
								}
							}
						}
					}
				end))
			end

			return (data2.resolveLinkFromLinkIdV2(code, p2):andThen(function(p3)
				shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.union(data, {
					code = Cryo.None,
					linkId = code,
					linkType = p3.responseBody.linkType,
					skipFilterCheck = Cryo.None,
					type = Cryo.None
				}))

				return module11(
					{
						linkId = code,
						linkType = kind,
						responseBody = p3.responseBody,
						isViaAppsFlyer = data.isViaAppsFlyer
					},
					data2
				)
			end))
		elseif fFlagTCShareLinkErrorModal then
			return (data2.resolveLinkFromLinkIdV2(code):andThen(function(p3)
				shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.union(data, {
					code = Cryo.None,
					linkId = code,
					linkType = p3.responseBody.linkType,
					type = Cryo.None
				}))

				return module11(
					{
						linkId = code,
						linkType = kind,
						responseBody = p3.responseBody,
						isViaAppsFlyer = data.isViaAppsFlyer
					},
					data2
				)
			end):catch(function()
				module.Stopwatch.stop(module.Events.ShareLinkOpened)
				return {
					{
						{ name = appPage.Home },
						{
							name = appPage.ShareLinkInvalidModal,
							extraProps = {
								closeModal = function()
									shareLinksAnalytics.errorJoinDialogButtonClick({
										linkId = code,
										linkType = kind,
										linkStatus = linkStatus.Invalid.rawValue()
									})
								end
							}
						}
					}
				}
			end))
		else
			return (data2.resolveLinkFromLinkIdV2(code):andThen(function(p3)
				shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.union(data, {
					code = Cryo.None,
					linkId = code,
					linkType = p3.responseBody.linkType,
					type = Cryo.None
				}))

				return module11(
					{
						linkId = code,
						linkType = kind,
						responseBody = p3.responseBody,
						isViaAppsFlyer = data.isViaAppsFlyer
					},
					data2
				)
			end))
		end
	else
		shareLinksAnalytics.openAppViaShareLink(Cryo.Dictionary.join(data, {
			code = Cryo.None,
			linkId = code,
			linkType = kind,
			type = Cryo.None
		}))

		if kind == string.lower(module12.Home) then
			module.Stopwatch.stop(module.Events.ShareLinkOpened)
			return {
				{
					{ name = appPage.Home }
				}
			}
		end

		if kind ~= string.lower(module12.Unknown) then
			return data2.resolveLinkFromLinkId(code, kind):andThen(function(p3)
				local joined = Cryo.Dictionary.join(data, {
					code = Cryo.None,
					linkType = kind,
					linkId = code,
					responseBody = p3.responseBody
				})

				if
					kind == string.lower(module12.ExperienceInviteLinkType)
					or kind == string.lower(module12.PrivateServerLinkType)
				then
					return module2(joined, data2)
				end

				if kind == string.lower(module12.ScreenshotInviteLinkType) then
					return module2(joined, data2)
				end

				if kind == string.lower(module12.OffNetworkFriendRequestLinkType) then
					return module4(joined, data2)
				end

				if kind == string.lower(module12.ExperienceDetails) then
					return module5(joined, data2)
				end

				if kind == string.lower(module12.ExperienceAffiliate) then
					return module6(joined, data2)
				end

				if
					kind == string.lower(module12.AvatarItemDetails)
					or module13 and kind == string.lower(module12.AvatarItemAffiliate)
				then
					return module7(joined, data2)
				end

				if kind == string.lower(module12.Profile) then
					return module9(joined, data2, data.source)
				end

				if kind == string.lower(module12.NotificationExperienceInviteLinkType) then
					return module8(joined, data2)
				end

				if kind == string.lower(module12.ExperienceEvent) then
					return module10(joined, data2)
				end

				module.Stopwatch.stop(module.Events.ShareLinkOpened)
				return nil
			end):catch(function()
				module.Stopwatch.stop(module.Events.ShareLinkOpened)
				return {
					{
						{ name = appPage.Games }
					},
					{
						{ name = appPage.Games },
						{
							name = appPage.ShareLinkInvalidModal,
							extraProps = {
								closeModal = function()
									shareLinksAnalytics.errorJoinDialogButtonClick({
										linkId = code,
										linkType = kind,
										linkStatus = linkStatus.Invalid.rawValue()
									})
								end
							}
						}
					}
				}
			end)
		end

		module.Stopwatch.stop(module.Events.ShareLinkOpened)
		return module3(
			{
				type = kind,
				code = data.code,
				isViaAppsFlyer = data.isViaAppsFlyer,
				stamp = data.stamp
			},
			data2
		)
	end
end
