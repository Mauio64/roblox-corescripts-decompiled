local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local TnSAvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local TnSAdIdentification = require(CorePackages.Workspace.Packages.TnSAdIdentification)
local HttpService = game:GetService("HttpService")
local getAvatarsForPoint = TnSAvatarIdentification.AvatarIdentification.getAvatarsForPoint
local getAvatarsForRegion = TnSAvatarIdentification.AvatarIdentification.getAvatarsForRegion
local getAdsForPoint = TnSAdIdentification.AdIdentification.getAdsForPoint
local GetFFlagReportAnythingEnableAdReport = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagReportAnythingEnableAdReport
local GetFFlagGetHumanoidDescription = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagGetHumanoidDescription
local GetFFlagRAEnableCircleRegion = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagRAEnableCircleRegion
local GetFFlagGetHumanoidDescriptionUpdatesV2E = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagGetHumanoidDescriptionUpdatesV2E
local getHumanoidDescription = require(AbuseReportMenu.ReportAnything.Utility.GetHumanoidDescription).getHumanoidDescription

require(AbuseReportMenu.Components.Types)
require(AbuseReportMenu.ReportAnything.Utility.ReportAnythingAnalytics)

local t1 = {
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

local function v15(t2: {[any]: any}) -- line: 96
	local t3 = {}

	for _, v in ipairs(t2) do
		t3[#t3 + 1] = {
			v.X,
			v.Y
		}
	end

	return t3
end
local function v16(p1) -- line: 104
	local t4 = {}

	for _, v in pairs(p1) do
		t4[#t4 + 1] = {
			assetId = v.assetId,
			distance = v.distance,
			boundingBox = {
				minX = v.boundingBox.min.X,
				minY = v.boundingBox.min.Y,
				maxX = v.boundingBox.max.X,
				maxY = v.boundingBox.max.Y
			},
			adUnitName = v.adUnitName,
			encryptedAdTrackingData = v.encryptedAdTrackingData,
			encryptionMetadata = v.encryptionMetadata
		}
	end

	return t4
end
local function v17(p2) -- line: 125
	-- upvalues: v15 (copy)
	local t5 = {}

	for k, v in pairs(p2) do
		t5[#t5 + 1] = {
			userId = tostring(k),
			distance = v.distance,
			boundingBox = {
				minX = v.boundingBox.min.X,
				minY = v.boundingBox.min.Y,
				maxX = v.boundingBox.max.X,
				maxY = v.boundingBox.max.Y
			},
			hitRate = v.hitRate,
			convexHull = v15(v.convexHull)
		}

		if v.pointProcessingStats ~= nil then
			t5[#t5].pointProcessingStats = {
				not v.pointProcessingStats.wasSkipped and 0 or 1,
				v.pointProcessingStats.total,
				v.pointProcessingStats.offScreenDiscardCount,
				v.pointProcessingStats.tooCloseDiscardCount
			}
		end
	end

	return t5
end
local function v18(p3) -- line: 177
	-- upvalues: GetFFlagRAEnableCircleRegion (copy), getAvatarsForRegion (copy), getAvatarsForPoint (copy), GetFFlagReportAnythingEnableAdReport (copy), getAdsForPoint (copy)
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local t9 = {}

	for _, v in ipairs(p3.annotationPoints) do
		local n1 = 1e999
		local v47 = nil
		local v48 = if not GetFFlagRAEnableCircleRegion() then getAvatarsForPoint(p3.identificationResults.identifiedAvatars, v) else getAvatarsForRegion(p3.identificationResults.identifiedAvatars, v, p3.annotationCircleRadius, p3.annotationAreaWidth, p3.annotationAreaHeight)

		for k, _ in pairs(v48) do
			local distance = p3.identificationResults.identifiedAvatars[k].distance

			if distance < n1 then
				n1 = distance
				v47 = k
			end
		end

		local v52 = nil

		if GetFFlagReportAnythingEnableAdReport() then
			local v53 = getAdsForPoint(p3.identificationResults.identifiedAds, v)
			local n2 = 1e999

			for k, _ in pairs(v53) do
				local distance = p3.identificationResults.identifiedAds[k].distance

				if distance < n2 then
					n2 = distance
					v52 = k
				end
			end
		end

		if v47 ~= nil and not t6[v47] then
			t6[v47] = true
			t8[#t8 + 1] = p3.identificationResults.identifiedAvatars[v47].player
		elseif GetFFlagReportAnythingEnableAdReport() and v52 ~= nil and not t7[v52] then
			t7[v52] = true
			t9[#t9 + 1] = p3.identificationResults.identifiedAds[v52]
		end
	end

	return t8, t9
end
local function v19(p4, _, t10: {[any]: any}) -- line: 242
	-- upvalues: GetFFlagReportAnythingEnableAdReport (copy), HttpService (copy), v17 (copy), v16 (copy), v15 (copy)
	local v61 = false

	for _, _ in pairs(p4.identificationResults.identifiedAvatars) do
		v61 = true

		break
	end

	local v64 = false

	if GetFFlagReportAnythingEnableAdReport() then
		for _, _ in pairs(p4.identificationResults.identifiedAds) do
			v64 = true

			break
		end
	end

	if v61 then
		t10.tags.IDENTIFIED_AVATARS = {
			valueList = {{
				data = HttpService:JSONEncode((v17(p4.identificationResults.identifiedAvatars)))
			}}
		}
	end

	if p4.identificationResults.avatarIDStats then
		t10.tags.AVATAR_ID_STATS = {
			valueList = {{
				data = HttpService:JSONEncode(p4.identificationResults.avatarIDStats)
			}}
		}
	end

	if v64 and GetFFlagReportAnythingEnableAdReport() then
		t10.tags.IDENTIFIED_ADS = {
			valueList = {{
				data = HttpService:JSONEncode((v16(p4.identificationResults.identifiedAds)))
			}}
		}
	end

	if p4.identificationResults.adIDStats and GetFFlagReportAnythingEnableAdReport() then
		t10.tags.AD_ID_STATS = {
			valueList = {{
				data = HttpService:JSONEncode(p4.identificationResults.adIDStats)
			}}
		}
	end

	if #p4.screenshotId > 0 then
		t10.tags.SCREENSHOT_ID = {
			valueList = {{
				data = p4.screenshotId
			}}
		}
	end

	if #p4.annotationPoints > 0 then
		t10.tags.RA_ANNOTATION_POINTS = {
			valueList = {{
				data = HttpService:JSONEncode((v15(p4.annotationPoints)))
			}}
		}
	end

	t10.tags.RA_ANNOTATION_OPTION_SEEN = {
		valueList = {{
			data = tostring(p4.annotationOptionSeen)
		}}
	}
	t10.tags.RA_ANNOTATION_PAGE_SEEN = {
		valueList = {{
			data = tostring(p4.annotationPageSeen)
		}}
	}
end

return {
	buildExperienceReportRequest = function(t11: {[any]: any}, p6, p7) -- line: 338
		-- upvalues: t1 (copy), v18 (copy), v19 (copy), GetFFlagReportAnythingEnableAdReport (copy), HttpService (copy), v16 (copy)
		local t12 = {
			tags = {
				ENTRY_POINT = {
					valueList = {{
						data = "in-experience"
					}}
				},
				SUBMITTER_USER_ID = {
					valueList = {{
						data = tostring(t11.localUserId)
					}}
				},
				REPORTED_ABUSE_CATEGORY = {
					valueList = {{
						data = t11.abuseReason
					}}
				},
				PLACE_ID = {
					valueList = {{
						data = tostring(t11.placeId)
					}}
				},
				REPORTER_COMMENT = {
					valueList = {{
						data = t11.abuseComment
					}}
				},
				REPORTED_ABUSE_VECTOR = {
					valueList = {{
						data = "place"
					}}
				},
				IN_EXP_MENU_ENTRY_POINT = {
					valueList = {{
						data = t11.menuEntryPoint
					}}
				},
				VARIANT = {
					valueList = {{
						data = t11.variant or t1.Variant.CS
					}}
				}
			}
		}
		local _, v72 = v18(p6)

		v19(p6, p7, t12)

		if #v72 > 0 and GetFFlagReportAnythingEnableAdReport() then
			t12.tags.REPORT_TARGET_ADS = {
				valueList = {{
					data = HttpService:JSONEncode((v16(v72)))
				}}
			}
		end

		return HttpService:JSONEncode(t12)
	end,
	buildOtherReportRequest = function(t13: {[any]: any}, p8, p9) -- line: 417
		-- upvalues: t1 (copy), v18 (copy), v19 (copy), GetFFlagGetHumanoidDescription (copy), GetFFlagGetHumanoidDescriptionUpdatesV2E (copy), getHumanoidDescription (copy), HttpService (copy)
		local t14 = {
			tags = {
				ENTRY_POINT = {
					valueList = {{
						data = "in-experience"
					}}
				},
				SUBMITTER_USER_ID = {
					valueList = {{
						data = tostring(t13.localUserId)
					}}
				},
				REPORTED_ABUSE_CATEGORY = {
					valueList = {{
						data = t13.abuseReason
					}}
				},
				REPORTER_COMMENT = {
					valueList = {{
						data = t13.abuseComment
					}}
				},
				REPORTED_ABUSE_VECTOR = {
					valueList = {{
						data = "avatar"
					}}
				},
				IN_EXP_MENU_ENTRY_POINT = {
					valueList = {{
						data = t13.menuEntryPoint
					}}
				},
				VARIANT = {
					valueList = {{
						data = t13.variant or t1.Variant.Unknown
					}}
				}
			}
		}
		local v77, _ = v18(p8)

		v19(p8, p9, t14)

		if #v77 > 0 then
			local str = tostring(v77[1].UserId)
			local t15 = {}

			for _, v in ipairs(v77) do
				t15[#t15 + 1] = tostring(v.UserId)
			end

			if GetFFlagGetHumanoidDescription() then
				local UserId = v77[1].UserId
				local humanoidDescription, humanoidDescriptionStatus

				if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
					local v84 = p8.identificationResults.identifiedAvatars[UserId]

					if v84 and v84.humanoidDescription and v84.humanoidDescriptionStatus == "OK" then
						humanoidDescription = v84.humanoidDescription
						humanoidDescriptionStatus = v84.humanoidDescriptionStatus
					else
						humanoidDescription, humanoidDescriptionStatus = getHumanoidDescription(UserId)
					end
				else
					humanoidDescription, humanoidDescriptionStatus = getHumanoidDescription(UserId)
				end

				t14.tags.REPORT_TARGET_HUMANOID_DESCRIPTION = {
					valueList = {{
						data = HttpService:JSONEncode(humanoidDescription)
					}}
				}
				t14.tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = {
					valueList = {{
						data = humanoidDescriptionStatus
					}}
				}

				local t16 = {}

				for _, v in ipairs(v77) do
					local UserId2 = v.UserId
					local humanoidDescription2, humanoidDescriptionStatus2

					if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
						local v91 = p8.identificationResults.identifiedAvatars[UserId2]

						if v91 and v91.humanoidDescription and v91.humanoidDescriptionStatus == "OK" then
							humanoidDescription2 = v91.humanoidDescription
							humanoidDescriptionStatus2 = v91.humanoidDescriptionStatus
						else
							humanoidDescription2, humanoidDescriptionStatus2 = getHumanoidDescription(UserId2)
						end
					else
						humanoidDescription2, humanoidDescriptionStatus2 = getHumanoidDescription(UserId2)
					end

					t16[#t16 + 1] = {
						humanoidDescription = humanoidDescription2,
						outputMessage = humanoidDescriptionStatus2
					}
				end

				t14.tags.RA_ALL_ANNOTATED_HUMANOID_DESCRIPTIONS = {
					valueList = {{
						data = HttpService:JSONEncode(t16)
					}}
				}
			end

			t14.tags.REPORT_TARGET_USER_ID = {
				valueList = {{
					data = tostring(str)
				}}
			}
			t14.tags.RA_ALL_ANNOTATED_USER_IDS = {
				valueList = {{
					data = HttpService:JSONEncode(t15)
				}}
			}
		elseif t13.formSelectedAbuserUserId then
			if GetFFlagGetHumanoidDescription() then
				local formSelectedAbuserUserId = t13.formSelectedAbuserUserId
				local humanoidDescription, humanoidDescriptionStatus

				if GetFFlagGetHumanoidDescriptionUpdatesV2E() then
					local v95 = p8.identificationResults.identifiedAvatars[formSelectedAbuserUserId]

					if v95 and v95.humanoidDescription and v95.humanoidDescriptionStatus == "OK" then
						humanoidDescription = v95.humanoidDescription
						humanoidDescriptionStatus = v95.humanoidDescriptionStatus
					else
						humanoidDescription, humanoidDescriptionStatus = getHumanoidDescription(formSelectedAbuserUserId)
					end
				else
					humanoidDescription, humanoidDescriptionStatus = getHumanoidDescription(formSelectedAbuserUserId)
				end

				t14.tags.REPORT_TARGET_HUMANOID_DESCRIPTION = {
					valueList = {{
						data = HttpService:JSONEncode(humanoidDescription)
					}}
				}
				t14.tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = {
					valueList = {{
						data = humanoidDescriptionStatus
					}}
				}
			end

			t14.tags.REPORT_TARGET_USER_ID = {
				valueList = {{
					data = tostring(t13.formSelectedAbuserUserId)
				}}
			}
		end

		if game:GetEngineFeature("WHAM2165") then
			return t14
		end

		return HttpService:JSONEncode(t14)
	end,
	interpretAnnotations = v18,
	Constants = t1
}
