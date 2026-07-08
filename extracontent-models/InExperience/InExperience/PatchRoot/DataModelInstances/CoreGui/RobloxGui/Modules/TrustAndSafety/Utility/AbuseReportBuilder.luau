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
local getHumanoidDescription = require(script.Parent.GetHumanoidDescription).getHumanoidDescription
local t1 = {
	annotationCircleRadius = 0,
	screenSizeWidth = 0,
	screenSizeHeight = 0,
	screenshotId = "",
	avatarIDStats = nil,
	adIDStats = nil,
	screenshotContentId = "",
	annotationOptionSeen = false,
	annotationPageSeen = false,
	identifiedAvatars = {},
	identifiedAds = {},
	annotationPoints = {},
	selectedAbusers = {},
	selectedAds = {}
}
local t2 = {
	Variant = {
		CS = "ra/cs",
		Sampling = "ra/sampling",
		E1 = "ra/e1",
		E2 = "ra/e2",
		E3 = "ra/e3",
		Unknown = "ra/unknown"
	}
}

local function v14(t3: {[any]: any}) -- line: 121
	local t4 = {}

	for _, v in ipairs(t3) do
		t4[#t4 + 1] = {
			v.X,
			v.Y
		}
	end

	return t4
end
local function v15(p1) -- line: 129
	local t5 = {}

	for _, v in pairs(p1) do
		t5[#t5 + 1] = {
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

	return t5
end
local function v16(p2) -- line: 150
	-- upvalues: v14 (copy)
	local t6 = {}

	for k, v in pairs(p2) do
		t6[#t6 + 1] = {
			userId = tostring(k),
			distance = v.distance,
			boundingBox = {
				minX = v.boundingBox.min.X,
				minY = v.boundingBox.min.Y,
				maxX = v.boundingBox.max.X,
				maxY = v.boundingBox.max.Y
			},
			hitRate = v.hitRate,
			convexHull = v14(v.convexHull)
		}

		if v.pointProcessingStats ~= nil then
			t6[#t6].pointProcessingStats = {
				not v.pointProcessingStats.wasSkipped and 0 or 1,
				v.pointProcessingStats.total,
				v.pointProcessingStats.offScreenDiscardCount,
				v.pointProcessingStats.tooCloseDiscardCount
			}
		end
	end

	return t6
end
local function v17(t7: {[any]: any}) -- line: 181
	-- upvalues: t1 (ref), GetFFlagReportAnythingEnableAdReport (copy), HttpService (copy), v16 (copy), v15 (copy), v14 (copy)
	local v32 = false

	for _, _ in pairs(t1.identifiedAvatars) do
		v32 = true

		break
	end

	local v35 = false

	if GetFFlagReportAnythingEnableAdReport() then
		for _, _ in pairs(t1.identifiedAds) do
			v35 = true

			break
		end
	end

	if v32 then
		t7.tags.IDENTIFIED_AVATARS = {
			valueList = {{
				data = HttpService:JSONEncode((v16(t1.identifiedAvatars)))
			}}
		}
	end

	if t1.avatarIDStats then
		t7.tags.AVATAR_ID_STATS = {
			valueList = {{
				data = HttpService:JSONEncode(t1.avatarIDStats)
			}}
		}
	end

	if v35 and GetFFlagReportAnythingEnableAdReport() then
		t7.tags.IDENTIFIED_ADS = {
			valueList = {{
				data = HttpService:JSONEncode((v15(t1.identifiedAds)))
			}}
		}
	end

	if t1.adIDStats and GetFFlagReportAnythingEnableAdReport() then
		t7.tags.AD_ID_STATS = {
			valueList = {{
				data = HttpService:JSONEncode(t1.adIDStats)
			}}
		}
	end

	if #t1.screenshotId > 0 then
		t7.tags.SCREENSHOT_ID = {
			valueList = {{
				data = t1.screenshotId
			}}
		}
	end

	if #t1.annotationPoints > 0 then
		t7.tags.RA_ANNOTATION_POINTS = {
			valueList = {{
				data = HttpService:JSONEncode((v14(t1.annotationPoints)))
			}}
		}
	end

	t7.tags.RA_ANNOTATION_OPTION_SEEN = {
		valueList = {{
			data = tostring(t1.annotationOptionSeen)
		}}
	}
	t7.tags.RA_ANNOTATION_PAGE_SEEN = {
		valueList = {{
			data = tostring(t1.annotationPageSeen)
		}}
	}
end
local function v18() -- line: 470
	-- upvalues: t1 (ref), GetFFlagRAEnableCircleRegion (copy), getAvatarsForRegion (copy), getAvatarsForPoint (copy), GetFFlagReportAnythingEnableAdReport (copy), getAdsForPoint (copy)
	local t8 = {}
	local t9 = {}
	local t10 = {}
	local t11 = {}

	for _, v in ipairs(t1.annotationPoints) do
		local n1 = 1e999
		local v62 = nil
		local v63 = if not GetFFlagRAEnableCircleRegion() then getAvatarsForPoint(t1.identifiedAvatars, v) else getAvatarsForRegion(t1.identifiedAvatars, v, t1.annotationCircleRadius, t1.screenSizeWidth, t1.screenSizeHeight)

		for k, _ in pairs(v63) do
			local distance = t1.identifiedAvatars[k].distance

			if distance < n1 then
				n1 = distance
				v62 = k
			end
		end

		local v67 = nil

		if GetFFlagReportAnythingEnableAdReport() then
			local v68 = getAdsForPoint(t1.identifiedAds, v)
			local n2 = 1e999

			for k, _ in pairs(v68) do
				local distance = t1.identifiedAds[k].distance

				if distance < n2 then
					n2 = distance
					v67 = k
				end
			end
		end

		if v62 ~= nil and not t8[v62] then
			t8[v62] = true
			t10[#t10 + 1] = t1.identifiedAvatars[v62].player
		elseif GetFFlagReportAnythingEnableAdReport() and v67 ~= nil and not t9[v67] then
			t9[v67] = true
			t11[#t11 + 1] = t1.identifiedAds[v67]
		end
	end

	t1.selectedAbusers = t10
	t1.selectedAds = t11
end

return {
	setAnnotationCircleRadius = function(n3: number) -- line: 537
		-- upvalues: t1 (ref)
		t1.annotationCircleRadius = n3
	end,
	getAnnotationCircleRadius = function() -- line: 540
		-- upvalues: t1 (ref)
		return t1.annotationCircleRadius
	end,
	setAspectRatioDimensions = function(n4: number, n5: number) -- line: 543
		-- upvalues: t1 (ref)
		t1.screenSizeWidth = n4
		t1.screenSizeHeight = n5
	end,
	setScreenshotId = function(s1: string) -- line: 547
		-- upvalues: t1 (ref)
		t1.screenshotId = s1
	end,
	setIdentifiedAds = function(p3) -- line: 550
		-- upvalues: t1 (ref)
		t1.identifiedAds = p3
	end,
	getIdentifiedAds = function() -- line: 553
		-- upvalues: t1 (ref)
		return t1.identifiedAds
	end,
	setIdentifiedAvatars = function(p4) -- line: 556
		-- upvalues: t1 (ref)
		t1.identifiedAvatars = p4
	end,
	getIdentifiedAvatars = function() -- line: 559
		-- upvalues: t1 (ref)
		return t1.identifiedAvatars
	end,
	setAvatarIDStats = function(p5) -- line: 562
		-- upvalues: t1 (ref)
		t1.avatarIDStats = p5
	end,
	setAdIDStats = function(p6) -- line: 565
		-- upvalues: t1 (ref)
		t1.adIDStats = p6
	end,
	setScreenshotContentId = function(s2: string) -- line: 568
		-- upvalues: t1 (ref)
		t1.screenshotContentId = s2
		t1.annotationPoints = {}
		t1.selectedAbusers = {}
	end,
	getScreenshotContentId = function() -- line: 575
		-- upvalues: t1 (ref)
		return t1.screenshotContentId
	end,
	setAnnotationPoints = function(t12: {[any]: any}) -- line: 578
		-- upvalues: t1 (ref), v18 (copy)
		t1.annotationPoints = t12
		t1.annotationOptionSeen = true
		t1.annotationPageSeen = true
		v18()
	end,
	getSelectedAbusers = function() -- line: 584
		-- upvalues: t1 (ref)
		return t1.selectedAbusers
	end,
	getSelectedAds = function() -- line: 587
		-- upvalues: t1 (ref)
		return t1.selectedAds
	end,
	clearAnnotationPoints = function() -- line: 590
		-- upvalues: t1 (ref), GetFFlagReportAnythingEnableAdReport (copy)
		t1.annotationPoints = {}
		t1.selectedAbusers = {}

		if GetFFlagReportAnythingEnableAdReport() then
			t1.selectedAds = {}
		end

		t1.annotationOptionSeen = false
		t1.annotationPageSeen = false
	end,
	getAnnotationPoints = function() -- line: 600
		-- upvalues: t1 (ref)
		return t1.annotationPoints
	end,
	setAnnotationOptionSeen = function(p7) -- line: 603
		-- upvalues: t1 (ref)
		t1.annotationOptionSeen = p7
	end,
	getAnnotationOptionSeen = function() -- line: 606
		-- upvalues: t1 (ref)
		return t1.annotationOptionSeen
	end,
	setAnnotationPageSeen = function(p8) -- line: 609
		-- upvalues: t1 (ref)
		t1.annotationPageSeen = p8
	end,
	getAnnotationPageSeen = function() -- line: 612
		-- upvalues: t1 (ref)
		return t1.annotationPageSeen
	end,
	buildExperienceReportRequest = function(t13: {[any]: any}) -- line: 270
		-- upvalues: t2 (copy), v17 (copy), t1 (ref), GetFFlagReportAnythingEnableAdReport (copy), HttpService (copy), v15 (copy)
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
				PLACE_ID = {
					valueList = {{
						data = tostring(t13.placeId)
					}}
				},
				REPORTER_COMMENT = {
					valueList = {{
						data = t13.abuseComment
					}}
				},
				REPORTED_ABUSE_VECTOR = {
					valueList = {{
						data = "place"
					}}
				},
				IN_EXP_MENU_ENTRY_POINT = {
					valueList = {{
						data = t13.menuEntryPoint
					}}
				},
				VARIANT = {
					valueList = {{
						data = t13.variant or t2.Variant.CS
					}}
				}
			}
		}

		v17(t14)

		if #t1.selectedAds > 0 and GetFFlagReportAnythingEnableAdReport() then
			t14.tags.REPORT_TARGET_ADS = {
				valueList = {{
					data = HttpService:JSONEncode((v15(t1.selectedAds)))
				}}
			}
		end

		return HttpService:JSONEncode(t14)
	end,
	buildOtherReportRequest = function(t15: {[any]: any}) -- line: 343
		-- upvalues: t2 (copy), v17 (copy), t1 (ref), GetFFlagGetHumanoidDescription (copy), getHumanoidDescription (copy), HttpService (copy)
		local t16 = {
			tags = {
				ENTRY_POINT = {
					valueList = {{
						data = "in-experience"
					}}
				},
				SUBMITTER_USER_ID = {
					valueList = {{
						data = tostring(t15.localUserId)
					}}
				},
				REPORTED_ABUSE_CATEGORY = {
					valueList = {{
						data = t15.abuseReason
					}}
				},
				REPORTER_COMMENT = {
					valueList = {{
						data = t15.abuseComment
					}}
				},
				REPORTED_ABUSE_VECTOR = {
					valueList = {{
						data = "avatar"
					}}
				},
				IN_EXP_MENU_ENTRY_POINT = {
					valueList = {{
						data = t15.menuEntryPoint
					}}
				},
				VARIANT = {
					valueList = {{
						data = t15.variant or t2.Variant.Unknown
					}}
				}
			}
		}

		v17(t16)

		if #t1.selectedAbusers > 0 then
			local str = tostring(t1.selectedAbusers[1].UserId)
			local t17 = {}

			for _, v in ipairs(t1.selectedAbusers) do
				t17[#t17 + 1] = tostring(v.UserId)
			end

			if GetFFlagGetHumanoidDescription() then
				local v46, v47 = getHumanoidDescription(t1.selectedAbusers[1].UserId)

				t16.tags.REPORT_TARGET_HUMANOID_DESCRIPTION = {
					valueList = {{
						data = HttpService:JSONEncode(v46)
					}}
				}
				t16.tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = {
					valueList = {{
						data = v47
					}}
				}

				local t18 = {}

				for _, v in ipairs(t1.selectedAbusers) do
					local v51, v52 = getHumanoidDescription(v.UserId)

					t18[#t18 + 1] = {
						humanoidDescription = v51,
						outputMessage = v52
					}
				end

				t16.tags.RA_ALL_ANNOTATED_HUMANOID_DESCRIPTIONS = {
					valueList = {{
						data = HttpService:JSONEncode(t18)
					}}
				}
			end

			t16.tags.REPORT_TARGET_USER_ID = {
				valueList = {{
					data = tostring(str)
				}}
			}
			t16.tags.RA_ALL_ANNOTATED_USER_IDS = {
				valueList = {{
					data = HttpService:JSONEncode(t17)
				}}
			}
		elseif t15.formSelectedAbuserUserId then
			if GetFFlagGetHumanoidDescription() then
				local v53, v54 = getHumanoidDescription(t15.formSelectedAbuserUserId)

				t16.tags.REPORT_TARGET_HUMANOID_DESCRIPTION = {
					valueList = {{
						data = HttpService:JSONEncode(v53)
					}}
				}
				t16.tags.REPORT_TARGET_HUMANOID_DESCRIPTION_STATUS = {
					valueList = {{
						data = v54
					}}
				}
			end

			t16.tags.REPORT_TARGET_USER_ID = {
				valueList = {{
					data = tostring(t15.formSelectedAbuserUserId)
				}}
			}
		end

		return HttpService:JSONEncode(t16)
	end,
	clear = function() -- line: 617
		-- upvalues: t1 (ref)
		t1 = {
			annotationCircleRadius = 0,
			screenSizeWidth = 0,
			screenSizeHeight = 0,
			screenshotId = "",
			avatarIDStats = nil,
			adIDStats = nil,
			screenshotContentId = "",
			annotationOptionSeen = false,
			annotationPageSeen = false,
			identifiedAvatars = {},
			identifiedAds = {},
			annotationPoints = {},
			selectedAbusers = {},
			selectedAds = {}
		}
	end,
	getAnalyticsParameters = function() -- line: 635
		-- upvalues: t1 (ref)
		return {
			finalAnnotationOptionSeen = t1.annotationOptionSeen,
			finalAnnotationPageSeen = t1.annotationPageSeen,
			finalAnnotationCount = #t1.annotationPoints,
			finalAnnotatedAvatarsCount = #t1.selectedAbusers
		}
	end,
	Constants = t2
}
