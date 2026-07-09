local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local default = require(CorePackages.Workspace.Packages.ExperienceService).GameProtocol.default
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local handleTrustedConnectionShareLink = require(script.Parent.handleTrustedConnectionShareLink)
local LinkStatus = require(script.Parent.Parent.LinkStatus)
local sendShareLinkLatencyEvent = require(script.Parent.Parent.Analytics.sendShareLinkLatencyEvent)
local ShareLinkTypesV2 = require(script.Parent.ShareLinkTypesV2)

require(script.Parent.Parent.Types)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagTCShareLinkReceiverUI = SharedFlags.FFlagTCShareLinkReceiverUI
local FFlagTCUpdateProfileCTAButton = SharedFlags.FFlagTCUpdateProfileCTAButton
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local FFlagEnableArgusTab = SharedFlags.FFlagEnableArgusTab
local v17 = game:DefineFastString("MomentsShareLinkExperiencePlaceId", "119524072047648")
local v18 = game:DefineFastFlag("MomentsFixShareDeeplink", false)

return function(t1: {[any]: any}, p1) -- line: 34
	-- upvalues: ShareLinkTypesV2 (copy), HttpService (copy), sendShareLinkLatencyEvent (copy), LinkStatus (copy), default (copy), FFlagTCShareLinkReceiverUI (copy), handleTrustedConnectionShareLink (copy), FFlagTCUpdateProfileCTAButton (copy), v18 (copy), FFlagEnableArgus (copy), FFlagEnableArgusTab (copy), FFlagEnableArgusFlyoutEntry (copy), UniversalAppPolicy (copy), CorePackages (copy), AppPage (copy), v17 (copy)
	local v21 = t1.responseBody or {}
	local v22 = v21.linkType or ShareLinkTypesV2.Unknown
	local v23 = v21.customData or {}
	local str = tostring(v21.status)
	local guid = HttpService:GenerateGUID(false)
	local shareLinksAnalytics = p1.analyticsImpls.shareLinksAnalytics
	local t2 = {
		linkStatus = str,
		linkId = t1.linkId,
		linkType = v22,
		isViaAppsFlyer = t1.isViaAppsFlyer,
		placeId = v21.targetId,
		joinAttemptId = guid
	}

	shareLinksAnalytics.resolveLink(t2)

	if v22 == ShareLinkTypesV2.Experience then
		if str == LinkStatus.Valid then
			local t3 = {
				launchData = v23
			}
			local launchGame = p1.launchGame
			local targetId = v21.targetId
			local v31 = default
			local targetId2 = v21.targetId

			launchGame(targetId, v22, t3, v31, "ExperienceValidLink", function(s1: string?) -- line: 55
				-- upvalues: shareLinksAnalytics (copy), t1 (copy), v22 (copy), str (copy), targetId2 (copy), sendShareLinkLatencyEvent (copy)
				shareLinksAnalytics.gameLaunch({
					linkId = t1.linkId,
					linkType = v22,
					linkStatus = str,
					placeId = targetId2,
					joinAttemptId = s1
				})
				sendShareLinkLatencyEvent(v22, str)
			end)

			return nil
		end
	else
		if FFlagTCShareLinkReceiverUI and (v22 == ShareLinkTypesV2.UserTrustedConnection or v22 == ShareLinkTypesV2.StudioTrustedConnection) then
			local FriendRequestTokenIds = HttpService:JSONDecode(v23).FriendRequestTokenIds

			return handleTrustedConnectionShareLink(str, v21.targetId, FriendRequestTokenIds, function() -- line: 89
				-- upvalues: shareLinksAnalytics (copy), t2 (copy)
				shareLinksAnalytics.errorDialogButtonClick(t2)
			end, if not FFlagTCUpdateProfileCTAButton then nil else p1)
		end

		if v22 == ShareLinkTypesV2.Moments and str == LinkStatus.Valid then
			local ok, result = pcall(function() -- line: 102
				-- upvalues: v23 (copy), HttpService (copy)
				if type(v23) == "string" and v23 ~= "" then
					return (HttpService:JSONDecode(v23))
				end

				return {}
			end)

			if not ok then
				result = {}
			end

			local v36 = if type(result) ~= "table" then {} else result
			local postCreatorId = v36.postCreatorId
			local v38 = true

			if v18 then
				v38 = false

				if FFlagEnableArgus and ((FFlagEnableArgusTab or FFlagEnableArgusFlyoutEntry) and UniversalAppPolicy.getAppFeaturePolicies().getDisplayMomentsMoreTabTile()) then
					v38 = true
				end
			elseif FFlagEnableArgus then
				v38 = false

				if UniversalAppPolicy.getAppFeaturePolicies().getDisplayMomentsMoreTabTile() then
					local v39 = require(CorePackages.Workspace.Packages.MomentsCommon).Flags.ArgusExperiment.getCurrentExperimentConfig()
					local v40 = v39.entryType == "tab" or FFlagEnableArgusTab
					local v41 = v39.entryType == "flyout" or FFlagEnableArgusFlyoutEntry

					v38 = v40 or v41 and v39.platformIntegration
				end
			end

			if v38 then
				sendShareLinkLatencyEvent(v22, str)

				return {{{
					name = AppPage.Moments,
					extraProps = {
						source = "deeplink",
						postId = v21.targetId,
						userId = postCreatorId
					}
				}}}
			end

			local v42 = table.clone(v36)

			v42.postId = v21.targetId
			v42.postCreatorId = postCreatorId
			v42.source = "deeplink"

			local launchGame = p1.launchGame
			local v44 = v17
			local t4 = {
				launchData = HttpService:JSONEncode(v42)
			}
			local v46 = default
			local v47 = v17

			launchGame(v44, v22, t4, v46, "ExperienceValidLink", function(s2: string?) -- line: 55
				-- upvalues: shareLinksAnalytics (copy), t1 (copy), v22 (copy), str (copy), v47 (copy), sendShareLinkLatencyEvent (copy)
				shareLinksAnalytics.gameLaunch({
					linkId = t1.linkId,
					linkType = v22,
					linkStatus = str,
					placeId = v47,
					joinAttemptId = s2
				})
				sendShareLinkLatencyEvent(v22, str)
			end)

			return nil
		end
	end

	return {{
		{
			name = AppPage.Games
		},
		{
			name = AppPage.ShareLinkInvalidModal,
			extraProps = {
				closeModal = function() -- line: 177
					-- upvalues: shareLinksAnalytics (copy), t2 (copy)
					shareLinksAnalytics.errorDialogButtonClick(t2)
				end
			}
		}
	}}
end
