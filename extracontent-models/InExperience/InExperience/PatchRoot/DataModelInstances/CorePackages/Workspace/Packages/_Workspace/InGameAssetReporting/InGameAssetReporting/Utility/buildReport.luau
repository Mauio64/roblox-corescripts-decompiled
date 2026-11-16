local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")
local parent = InGameAssetReporting.Parent

require(InGameAssetReporting.Analysis.SceneAnalysis)
local GetHumanoidDescription = require(parent.GetHumanoidDescription)
local getHumanoidDescription = GetHumanoidDescription.getHumanoidDescription
local SharedFlags = require(parent.SharedFlags)
local FFlagDropUnroutableMultiReportOptions = SharedFlags.FFlagDropUnroutableMultiReportOptions

local HttpService = game:GetService("HttpService")

local v = {
	Variant = { IGARv1 = "IGARv1", IGARv3 = "IGARv3" }
}

function transformTargetPlayers(list, p: number)
	local v2 = p == 0 and 1 or p
	local result = {}

	for _, item in ipairs(list) do
		local player = item.player
		local count = item.count
		local humanoidDescription, humanoidDescriptionStatus = getHumanoidDescription(player.UserId)
		table.insert(result, {
			userId = player.UserId,
			hitCount = count,
			hitPercentage = count / v2,
			humanoidDescription = humanoidDescription,
			humanoidDescriptionStatus = humanoidDescriptionStatus
		})
	end

	return result
end

function serializeTargetPlayersIntoTagValues(list)
	local result = {}

	for _, item in ipairs(list) do
		table.insert(result, { data = HttpService:JSONEncode(item) })
	end

	return result
end

local function fn(list)
	local result = {}

	for _, item in ipairs(list) do
		result[#result + 1] = { item.X, item.Y }
	end

	return result
end

local function fn2(p): boolean -- 1 equivalent call inferred from this helper
	local extractedAssets = p.extractedAssets
	return #extractedAssets.Image > 0
		or #extractedAssets.Mesh > 0
		or #extractedAssets.Model > 0
		or #extractedAssets.Package > 0
		or #extractedAssets.Text > 0
end

function buildReport(p: number, p2: string, data, p3: string, p4: string, p5: string, p6, p7, p8: string?)
	local v2 = {
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = "in-experience" }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = tostring(p) }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = p3 }
				}
			},
			REPORTED_ABUSE_SURFACE = {
				valueList = {
					{ data = p4 }
				}
			},
			PLACE_ID = {
				valueList = {
					{ data = tostring(game.PlaceId) }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = p5 }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{
						data = (FFlagDropUnroutableMultiReportOptions or p4 ~= "username") and (p4 == "text" and game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") and "in-experience-text" or "multi") or "user_profile"
					}
				}
			},
			VARIANT = {
				valueList = {
					{ data = v.Variant.IGARv1 }
				}
			},
			IGAR_REPORT_TARGET_ASSETS = {
				valueList = {
					{
						data = HttpService:JSONEncode(data.extractedAssets)
					}
				}
			},
			IGAR_EXTRACTION_STATS = {
				valueList = {
					{
						data = HttpService:JSONEncode(data.stats)
					}
				}
			},
			IGAR_ANNOTATION_COORDINATES = {
				valueList = {
					{ data = HttpService:JSONEncode(fn(p6)) }
				}
			}
		}
	}

	if game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") and #data.extractedAssets.Text > 0 then
		v2.tags.IGAR_REPORT_TARGET_IN_EXPERIENCE_TEXT = {
			valueList = {
				{
					data = HttpService:JSONEncode(data.extractedAssets.Text)
				}
			}
		}
	end

	if game:GetEngineFeature("DeltaFactoryCloneJobId") then
		v2.tags.IGAR_REPORT_JOBID = {
			valueList = {
				{
					data = HttpService:JSONEncode(game.JobId)
				}
			}
		}
	end

	if p7 and fn2(p7) then -- inferred equivalent call
		v2.tags.IGAR_REPORT_TARGET_GUI_ASSETS = {
			valueList = {
				{
					data = HttpService:JSONEncode(p7.extractedAssets)
				}
			}
		}

		if game:GetEngineFeature("ExperienceStateCaptureExperienceChatSupport") then
			v2.tags.IGAR_REPORT_TARGET_GUI_IN_EXPERIENCE_TEXT = {
				valueList = {
					{
						data = HttpService:JSONEncode(p7.extractedAssets.Text)
					}
				}
			}
		end

		v2.tags.IGAR_GUI_EXTRACTION_STATS = {
			valueList = {
				{
					data = HttpService:JSONEncode(p7.stats)
				}
			}
		}
	end

	if #data.extractedPlayers > 0 then
		local v3 = transformTargetPlayers(data.extractedPlayers, data.stats.raycastCompletedCount)
		local valueList = serializeTargetPlayersIntoTagValues(v3)
		v2.tags.IGAR_REPORT_TARGET_PLAYERS = { valueList = valueList }

		if not FFlagDropUnroutableMultiReportOptions and p4 == "username" then
			v2.tags.REPORT_TARGET_USER_ID = {
				valueList = {
					{ data = tostring(v3[1].userId) }
				}
			}
		end
	end

	if p2 then
		v2.tags.SCREENSHOT_ID = {
			valueList = {
				{ data = p2 }
			}
		}
	end

	if p8 then
		v2.tags.VARIANT.valueList[1].data = v.Variant.IGARv3 .. "-" .. p8
	end

	if FFlagDropUnroutableMultiReportOptions or p4 ~= "username" or #data.extractedPlayers ~= 0 then
		return HttpService:JSONEncode(v2)
	end

	return nil
end

return buildReport
