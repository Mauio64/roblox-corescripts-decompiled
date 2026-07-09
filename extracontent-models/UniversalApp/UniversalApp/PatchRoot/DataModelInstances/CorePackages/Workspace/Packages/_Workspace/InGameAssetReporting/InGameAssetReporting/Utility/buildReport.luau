local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local InGameAssetReportingParent = InGameAssetReporting.Parent

require(InGameAssetReporting.Analysis.SceneAnalysis)

local getHumanoidDescription = require(InGameAssetReportingParent.GetHumanoidDescription).getHumanoidDescription
local HttpService = game:GetService("HttpService")
local t1 = {
	Variant = {
		IGARv1 = "IGARv1",
		IGARv3 = "IGARv3"
	}
}

function transformTargetPlayers(t2: {[any]: any}, n1: number) -- line: 37
	-- upvalues: getHumanoidDescription (copy)
	local t3 = {}

	if n1 == 0 then
		n1 = 1
	end

	for _, v in ipairs(t2) do
		local player = v.player
		local count = v.count
		local v14, v15 = getHumanoidDescription(player.UserId)

		table.insert(t3, {
			userId = player.UserId,
			hitCount = count,
			hitPercentage = count / n1,
			humanoidDescription = v14,
			humanoidDescriptionStatus = v15
		})
	end

	return t3
end
function serializeTargetPlayersIntoTagValues(t4: {[any]: any}) -- line: 59
	-- upvalues: HttpService (copy)
	local t5 = {}

	for _, v in ipairs(t4) do
		table.insert(t5, {
			data = HttpService:JSONEncode(v)
		})
	end

	return t5
end

local function v6(t6: {[any]: any}) -- line: 69
	local t7 = {}

	for _, v in ipairs(t6) do
		t7[#t7 + 1] = {
			v.X,
			v.Y
		}
	end

	return t7
end

function buildReport(n2: number, s1: string, p1, s2: string, s3: string, s4: string, t8: {[any]: any}, p2, s5: string?) -- line: 86
	-- upvalues: t1 (copy), HttpService (copy), v6 (copy)
	local t9 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = "in-experience"
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = tostring(n2)
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = s2
				}}
			},
			REPORTED_ABUSE_SURFACE = {
				valueList = {{
					data = s3
				}}
			},
			PLACE_ID = {
				valueList = {{
					data = tostring(game.PlaceId)
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = s4
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = if s3 ~= "username" then (s3 ~= "text" or not game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport")) and "multi" or "in-experience-text" else "user_profile"
				}}
			},
			VARIANT = {
				valueList = {{
					data = t1.Variant.IGARv1
				}}
			},
			IGAR_REPORT_TARGET_ASSETS = {
				valueList = {{
					data = HttpService:JSONEncode(p1.extractedAssets)
				}}
			},
			IGAR_EXTRACTION_STATS = {
				valueList = {{
					data = HttpService:JSONEncode(p1.stats)
				}}
			},
			IGAR_ANNOTATION_COORDINATES = {
				valueList = {{
					data = HttpService:JSONEncode((v6(t8)))
				}}
			}
		}
	}

	if game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") and #p1.extractedAssets.Text > 0 then
		t9.tags.IGAR_REPORT_TARGET_IN_EXPERIENCE_TEXT = {
			valueList = {{
				data = HttpService:JSONEncode(p1.extractedAssets.Text)
			}}
		}
	end

	if game:GetEngineFeature("DeltaFactoryCloneJobId") then
		t9.tags.IGAR_REPORT_JOBID = {
			valueList = {{
				data = HttpService:JSONEncode(game.JobId)
			}}
		}
	end

	if p2 then
		local extractedAssets = p2.extractedAssets

		if #extractedAssets.Image > 0 or (#extractedAssets.Mesh > 0 or (#extractedAssets.Model > 0 or (#extractedAssets.Package > 0 or #extractedAssets.Text > 0))) then
			t9.tags.IGAR_REPORT_TARGET_GUI_ASSETS = {
				valueList = {{
					data = HttpService:JSONEncode(p2.extractedAssets)
				}}
			}

			if game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
				t9.tags.IGAR_REPORT_TARGET_GUI_IN_EXPERIENCE_TEXT = {
					valueList = {{
						data = HttpService:JSONEncode(p2.extractedAssets.Text)
					}}
				}
			end

			t9.tags.IGAR_GUI_EXTRACTION_STATS = {
				valueList = {{
					data = HttpService:JSONEncode(p2.stats)
				}}
			}
		end
	end

	if #p1.extractedPlayers > 0 then
		local v37 = transformTargetPlayers(p1.extractedPlayers, p1.stats.raycastCompletedCount)
		local v38 = serializeTargetPlayersIntoTagValues(v37)

		t9.tags.IGAR_REPORT_TARGET_PLAYERS = {
			valueList = v38
		}

		if s3 == "username" then
			t9.tags.REPORT_TARGET_USER_ID = {
				valueList = {{
					data = tostring(v37[1].userId)
				}}
			}
		end
	end

	if s1 then
		t9.tags.SCREENSHOT_ID = {
			valueList = {{
				data = s1
			}}
		}
	end

	if s5 then
		t9.tags.VARIANT.valueList[1].data = t1.Variant.IGARv3 .. "-" .. s5
	end

	if s3 == "username" and #p1.extractedPlayers == 0 then
		return nil
	end

	return HttpService:JSONEncode(t9)
end

return buildReport
