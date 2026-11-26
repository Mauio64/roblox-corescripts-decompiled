local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dFu")
local default = require("@luauforge/bundled/bZg").GameProtocol.default

local module2 = require("@luauforge/bundled/fIN")
local ExperienceInviteStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/ExperienceInviteStatus")
local module4 = require("@luauforge/bundled/fIt")
local module5 = require("@luauforge/bundled/fIO")
require("@luauforge/bundled/fIx")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagTCUpdateProfileCTAButton = SharedFlags.FFlagTCUpdateProfileCTAButton
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local fFlagEnableSchoolEntry = SharedFlags.FFlagEnableSchoolEntry
local fFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet
local fFlagEnablePlusReferralEntrypointTelemetry = SharedFlags.FFlagEnablePlusReferralEntrypointTelemetry

local defineFastString = game:DefineFastString("MomentsShareLinkExperiencePlaceId", "119524072047648")

return function(data, p2)
	local responseBody = data.responseBody or {}
	local linkType = responseBody.linkType or module5.Unknown
	local customData = responseBody.customData or {}
	local status = tostring(responseBody.status)

	local guid = HttpService:GenerateGUID(false)

	local shareLinksAnalytics = p2.analyticsImpls.shareLinksAnalytics
	local v5 = {
		linkStatus = status,
		linkId = data.linkId,
		linkType = linkType,
		isViaAppsFlyer = data.isViaAppsFlyer,
		placeId = responseBody.targetId,
		joinAttemptId = guid
	}

	shareLinksAnalytics.resolveLink(v5)

	if linkType == module5.Experience then
		if status == ExperienceInviteStatus.Valid then
			local launchGame = p2.launchGame
			local targetId = responseBody.targetId

			local targetId2 = responseBody.targetId
			launchGame(
				targetId,
				linkType,
				{ launchData = customData },
				default,
				"ExperienceValidLink",
				function(p3)
					shareLinksAnalytics.gameLaunch({
						linkId = data.linkId,
						linkType = linkType,
						linkStatus = status,
						placeId = targetId2,
						joinAttemptId = p3
					})

					module4(linkType, status)
				end
			)

			return nil
		end
	elseif linkType == module5.UserTrustedConnection or linkType == module5.StudioTrustedConnection then
		local friendRequestTokenIds = HttpService:JSONDecode(customData).FriendRequestTokenIds
		local function fn()
			shareLinksAnalytics.errorDialogButtonClick(v5)
		end

		local targetId = responseBody.targetId

		if not fFlagTCUpdateProfileCTAButton then
			p2 = nil
		end

		return module2(status, targetId, friendRequestTokenIds, fn, p2)
	elseif linkType == module5.Moments then
		local getMomentsCapabilities = require("@luauforge/bundled/fIP").Stores.GetMomentsCapabilities

		if status == ExperienceInviteStatus.Valid then
			local shareLinkTargetIdType = require("@luauforge/bundled/fIQ").Enums.ShareLinkTargetIdType
			local success, result = pcall(function()
				if type(customData) == "string" and customData ~= "" then
					return (HttpService:JSONDecode(customData))
				end

				return {}
			end)

			local v6 = not success and {} or result

			local v7 = type(v6) ~= "table" and {} or v6
			local postCreatorId = v7.postCreatorId
			local feedItemId

			if v7.targetIdType == shareLinkTargetIdType.FeedItemId then
				feedItemId = shareLinkTargetIdType.FeedItemId
			end

			local flag

			if fFlagEnableArgus then
				if not getMomentsCapabilities(false).getHasMomentsAccess(false) then
					return nil
				end

				flag = true
			else
				flag = false
			end

			if flag then
				module4(linkType, status)
				local v8 = {
					postId = responseBody.targetId,
					targetIdType = feedItemId,
					userId = postCreatorId,
					source = "deeplink"
				}

				if fFlagEnableArgusImmersiveNav and not fFlagArgoEnableMoments then
					return {
						{
							{ name = module.Home },
							{ name = module.MomentsImmersive, extraProps = v8 }
						}
					}
				end

				return {
					{
						{ name = module.Moments, extraProps = v8 }
					}
				}
			else
				local clone = table.clone(v7)
				clone.postId = responseBody.targetId
				clone.postCreatorId = postCreatorId
				clone.source = "deeplink"

				local v10 = defineFastString
				p2.launchGame(
					defineFastString,
					linkType,
					{ launchData = HttpService:JSONEncode(clone) },
					default,
					"ExperienceValidLink",
					function(p3)
						shareLinksAnalytics.gameLaunch({
							linkId = data.linkId,
							linkType = linkType,
							linkStatus = status,
							placeId = v10,
							joinAttemptId = p3
						})

						module4(linkType, status)
					end
				)

				return nil
			end
		end
	elseif linkType == module5.SchoolInvite then
		module4(linkType, status)

		if fFlagEnableSchoolEntry and status == ExperienceInviteStatus.Valid then
			return {
				{
					{ name = module.Home },
					{ name = module.AddFriendsPage },
					{
						name = module.Schools,
						extraProps = { source = "shareLink" }
					}
				}
			}
		end
	elseif fFlagEnablePlusReferralLandingSheet and linkType == module5.Referral then
		module4(linkType, status)

		if status == ExperienceInviteStatus.Valid then
			local module7 = require("@luauforge/bundled/fHh")
			local surfaceName = module7.SurfaceName
			local surfaceContext = module7.SurfaceContext

			local targetId = tonumber(responseBody.targetId)

			module7.initiateRobloxSubscriptionPurchase(
				nil,
				nil,
				nil,
				surfaceName.PlusReferralLandingSheet,
				surfaceContext.InApp,
				nil,
				fFlagEnablePlusReferralEntrypointTelemetry and {
					entrypoint = module7.Entrypoint.ShareLink
				} or nil,
				targetId
			)

			return nil
		end
	end

	return {
		{
			{ name = module.Games },
			{
				name = module.ShareLinkInvalidModal,
				extraProps = {
					closeModal = function()
						shareLinksAnalytics.errorDialogButtonClick(v5)
					end
				}
			}
		}
	}
end
