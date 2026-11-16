local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")

local TnSAvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local TnSAdIdentification = require(CorePackages.Workspace.Packages.TnSAdIdentification)

local HttpService = game:GetService("HttpService")

local getAvatarsForPoint = TnSAvatarIdentification.AvatarIdentification.getAvatarsForPoint
local getAvatarsForRegion = TnSAvatarIdentification.AvatarIdentification.getAvatarsForRegion

local getAdsForPoint = TnSAdIdentification.AdIdentification.getAdsForPoint

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagReportAnythingEnableAdReport = SharedFlags.GetFFlagReportAnythingEnableAdReport

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagGetHumanoidDescription = SharedFlags2.GetFFlagGetHumanoidDescription
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagRAEnableCircleRegion = SharedFlags3.GetFFlagRAEnableCircleRegion

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagGetHumanoidDescriptionUpdatesV2E = SharedFlags4.GetFFlagGetHumanoidDescriptionUpdatesV2E

local GetHumanoidDescription = require(AbuseReportMenu.ReportAnything.Utility.GetHumanoidDescription)
local getHumanoidDescription = GetHumanoidDescription.getHumanoidDescription
require(AbuseReportMenu.Components.Types)
require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)

local constants = {
	Variant = {
		CS = "ra/cs",
		Sampling = "ra/sampling",
		E1 = "ra/e1",
		E2 = "ra/e2",
		E3 = "ra/e3",
		NM = "ra/nm",
		Unknown = "ra/unknown"
	}
}

local function fn(list)
	local result = {}

	for _, item in ipairs(list) do
		result[#result + 1] = { item.X, item.Y }
	end

	return result
end

local function fn2(items)
	local result = {}

	for _, item in pairs(items) do
		result[#result + 1] = {
			assetId = item.assetId,
			distance = item.distance,
			boundingBox = {
				minX = item.boundingBox.min.X,
				minY = item.boundingBox.min.Y,
				maxX = item.boundingBox.max.X,
				maxY = item.boundingBox.max.Y
			},
			adUnitName = item.adUnitName,
			encryptedAdTrackingData = item.encryptedAdTrackingData,
			encryptionMetadata = item.encryptionMetadata
		}
	end

	return result
end

local function fn3(identifiedAvatars)
	local result = {}

	for k, item in pairs(identifiedAvatars) do
		result[#result + 1] = {
			userId = tostring(k),
			distance = item.distance,
			boundingBox = {
				minX = item.boundingBox.min.X,
				minY = item.boundingBox.min.Y,
				maxX = item.boundingBox.max.X,
				maxY = item.boundingBox.max.Y
			},
			hitRate = item.hitRate,
			convexHull = fn(item.convexHull)
		}

		if item.pointProcessingStats ~= nil then
			result[#result].pointProcessingStats = {
				item.pointProcessingStats.wasSkipped and 1 or 0,
				item.pointProcessingStats.total,
				item.pointProcessingStats.offScreenDiscardCount,
				item.pointProcessingStats.tooCloseDiscardCount
			}
		end
	end

	return result
end

local function fn4(data)
	local set = {}

	local result = {}
	local set2 = {}

	local players = {}

	for _, annotationPoint in ipairs(data.annotationPoints) do
		local v = 1e999
		local v2 = nil
		local v3

		if GetFFlagRAEnableCircleRegion() then
			v3 = getAvatarsForRegion(
				data.identificationResults.identifiedAvatars,
				annotationPoint,
				data.annotationCircleRadius,
				data.annotationAreaWidth,
				data.annotationAreaHeight
			)
		else
			v3 = getAvatarsForPoint(data.identificationResults.identifiedAvatars, annotationPoint)
		end

		for k, _ in pairs(v3) do
			local distance = data.identificationResults.identifiedAvatars[k].distance

			if not (distance < v) then
				continue
			end

			v2 = k
			v = distance
		end

		local v4 = nil

		if GetFFlagReportAnythingEnableAdReport() then
			local adsForPoint = getAdsForPoint(data.identificationResults.identifiedAds, annotationPoint)
			local v5 = 1e999

			for k, _ in pairs(adsForPoint) do
				local distance = data.identificationResults.identifiedAds[k].distance

				if not (distance < v5) then
					continue
				end

				v4 = k
				v5 = distance
			end
		end

		if v2 == nil or set2[v2] then
			if GetFFlagReportAnythingEnableAdReport() and v4 ~= nil and not set[v4] then
				set[v4] = true
				result[#result + 1] = data.identificationResults.identifiedAds[v4]
			end
		else
			set2[v2] = true
			players[#players + 1] = data.identificationResults.identifiedAvatars[v2].player
		end
	end

	return players, result
end

local function fn5(data, _, p)
	local flag = false

	for _, _ in pairs(data.identificationResults.identifiedAvatars) do
		flag = true
		break
	end

	local v = false

	if GetFFlagReportAnythingEnableAdReport() then
		for _, _ in pairs(data.identificationResults.identifiedAds) do
			v = true
			break
		end
	end

	if flag then
		p.tags.IDENTIFIED_AVATARS = {
			valueList = {
				{
					data = HttpService:JSONEncode(fn3(data.identificationResults.identifiedAvatars))
				}
			}
		}
	end

	if data.identificationResults.avatarIDStats then
		p.tags.AVATAR_ID_STATS = {
			valueList = {
				{
					data = HttpService:JSONEncode(data.identificationResults.avatarIDStats)
				}
			}
		}
	end

	if v and GetFFlagReportAnythingEnableAdReport() then
		p.tags.IDENTIFIED_ADS = {
			valueList = {
				{
					data = HttpService:JSONEncode(fn2(data.identificationResults.identifiedAds))
				}
			}
		}
	end

	if data.identificationResults.adIDStats and GetFFlagReportAnythingEnableAdReport() then
		p.tags.AD_ID_STATS = {
			valueList = {
				{
					data = HttpService:JSONEncode(data.identificationResults.adIDStats)
				}
			}
		}
	end

	if #data.screenshotId > 0 then
		p.tags.SCREENSHOT_ID = {
			valueList = {
				{ data = data.screenshotId }
			}
		}
	end

	if #data.annotationPoints > 0 then
		p.tags.RA_ANNOTATION_POINTS = {
			valueList = {
				{
					data = HttpService:JSONEncode(fn(data.annotationPoints))
				}
			}
		}
	end

	p.tags.RA_ANNOTATION_OPTION_SEEN = {
		valueList = {
			{
				data = tostring(data.annotationOptionSeen)
			}
		}
	}

	p.tags.RA_ANNOTATION_PAGE_SEEN = {
		valueList = {
			{
				data = tostring(data.annotationPageSeen)
			}
		}
	}
end

local AbuseReportBuilder = {}

function AbuseReportBuilder.buildExperienceReportRequest(data, p, p2)
	local v = {
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = "in-experience" }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = tostring(data.localUserId) }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = data.abuseReason }
				}
			},
			PLACE_ID = {
				valueList = {
					{ data = tostring(data.placeId) }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = data.abuseComment }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = "place" }
				}
			},
			IN_EXP_MENU_ENTRY_POINT = {
				valueList = {
					{ data = data.menuEntryPoint }
				}
			},
			VARIANT = {
				valueList = {
					{
						data = data.variant or constants.Variant.CS
					}
				}
			}
		}
	}

	local _, v2 = fn4(p)
	fn5(p, p2, v)

	if #v2 > 0 and GetFFlagReportAnythingEnableAdReport() then
		v.tags.REPORT_TARGET_ADS = {
			valueList = {
				{
					data = HttpService:JSONEncode(fn2(v2))
				}
			}
		}
	end

	return HttpService:JSONEncode(v)
end

function AbuseReportBuilder.buildOtherReportRequest(data, p, p2)
	local v = {
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = "in-experience" }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = tostring(data.localUserId) }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = data.abuseReason }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = data.abuseComment }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = "avatar" }
				}
			},
			IN_EXP_MENU_ENTRY_POINT = {
				valueList = {
					{ data = data.menuEntryPoint }
				}
			},
			VARIANT = {
				valueList = {
					{
						data = data.variant or constants.Variant.Unknown
					}
				}
			}
		}
	}

	local v2, _ = fn4(p)
	fn5(p, p2, v)

	if #v2 > 0 then
		local userId = tostring(v2[1].UserId)
		local userIds = {}

		for _, v3 in ipairs(v2) do
			userIds[#userIds + 1] = tostring(v3.UserId)
		end

		if GetFFlagGetHumanoidDescription() then
			local userId2 = v2[1].UserId
			local v3, v4

			if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
				local identifiedAvatar = p.identificationResults.identifiedAvatars[userId2]

				if
					identifiedAvatar
					and identifiedAvatar.humanoidDescription
					and identifiedAvatar.humanoidDescriptionStatus == "OK"
				then
					v3 = identifiedAvatar.humanoidDescription
					v4 = identifiedAvatar.humanoidDescriptionStatus
				else
					v3, v4 = getHumanoidDescription(userId2)
				end
			else
				v3, v4 = getHumanoidDescription(userId2)
			end

			v.tags.REPORT_TARGET_HUMANOID_DESCRIPTION = {
				valueList = {
					{ data = HttpService:JSONEncode(v3) }
				}
			}

			v.tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = {
				valueList = {
					{ data = v4 }
				}
			}

			local v5 = {}

			for _, v6 in ipairs(v2) do
				local userId3 = v6.UserId
				local humanoidDescription, outputMessage

				if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
					local identifiedAvatar = p.identificationResults.identifiedAvatars[userId3]

					if
						identifiedAvatar
						and identifiedAvatar.humanoidDescription
						and identifiedAvatar.humanoidDescriptionStatus == "OK"
					then
						humanoidDescription = identifiedAvatar.humanoidDescription
						outputMessage = identifiedAvatar.humanoidDescriptionStatus
					else
						humanoidDescription, outputMessage = getHumanoidDescription(userId3)
					end
				else
					humanoidDescription, outputMessage = getHumanoidDescription(userId3)
				end

				v5[#v5 + 1] = {
					humanoidDescription = humanoidDescription,
					outputMessage = outputMessage
				}
			end

			v.tags.RA_ALL_ANNOTATED_HUMANOID_DESCRIPTIONS = {
				valueList = {
					{ data = HttpService:JSONEncode(v5) }
				}
			}
		end

		v.tags.REPORT_TARGET_USER_ID = {
			valueList = {
				{ data = tostring(userId) }
			}
		}

		v.tags.RA_ALL_ANNOTATED_USER_IDS = {
			valueList = {
				{
					data = HttpService:JSONEncode(userIds)
				}
			}
		}
	elseif data.formSelectedAbuserUserId then
		if GetFFlagGetHumanoidDescription() then
			local formSelectedAbuserUserId = data.formSelectedAbuserUserId
			local v3, v4

			if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
				local identifiedAvatar = p.identificationResults.identifiedAvatars[formSelectedAbuserUserId]

				if
					identifiedAvatar
					and identifiedAvatar.humanoidDescription
					and identifiedAvatar.humanoidDescriptionStatus == "OK"
				then
					v3 = identifiedAvatar.humanoidDescription
					v4 = identifiedAvatar.humanoidDescriptionStatus
				else
					v3, v4 = getHumanoidDescription(formSelectedAbuserUserId)
				end
			else
				v3, v4 = getHumanoidDescription(formSelectedAbuserUserId)
			end

			v.tags.REPORT_TARGET_HUMANOID_DESCRIPTION = {
				valueList = {
					{ data = HttpService:JSONEncode(v3) }
				}
			}

			v.tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = {
				valueList = {
					{ data = v4 }
				}
			}
		end

		v.tags.REPORT_TARGET_USER_ID = {
			valueList = {
				{
					data = tostring(data.formSelectedAbuserUserId)
				}
			}
		}
	end

	if game:GetEngineFeature("WHAM2165") then
		return v
	end

	return HttpService:JSONEncode(v)
end

AbuseReportBuilder.interpretAnnotations = fn4
AbuseReportBuilder.Constants = constants
return AbuseReportBuilder
