local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SocialLuaAnalytics")
local supportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

local RealtimeEventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/RealtimeEventNames")
local FFlagMomentsParentTimeLimit = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsParentTimeLimit")

local telemetry = SocialLuaAnalytics.Telemetry

local v5 = {
	watch_tab = "watch_tab",
	deeplink = "deeplink",
	profile = "profile",
	flyout_menu = "flyout_menu"
}

local function normalizeViewSource(p2)
	return v5[p2] or "unknown"
end

local function normalizeRequestFailureReason(p2)
	if p2 == nil or p2 == "" then
		return "unknown"
	end

	if p2 == "requestFailed" or p2 == "malformedResponse" then
		return p2
	end

	if FFlagMomentsParentTimeLimit and p2 == "parentalTimeLimitReached" then
		return "parentalTimeLimitReached"
	end

	return "unknown"
end

local function normalizeMediaFailureReason(value): string
	if value == nil or value == "" then
		return "unknown"
	end

	if string.find(value, "video load errored:", 1, true) == 1 then
		return "videoLoadErrored"
	end

	if string.find(value, "video load failed:", 1, true) == 1 then
		return "videoLoadFailed"
	end

	if string.find(value, "screenshot load failed:", 1, true) == 1 then
		return "screenshotLoadFailed"
	end

	return "unknown"
end

local v6 = {
	reaction_add = "reaction_add",
	reaction_remove = "reaction_remove",
	share = "share",
	join = "join",
	report = "report",
	report_click = "report_click"
}

local function normalizeEngagementAction(p2)
	return v6[p2] or "unknown"
end

local v7 = {
	create_intent = "create_intent",
	gallery_selected = "gallery_selected",
	published = "published",
	upload = "upload",
	post_review = "post_review"
}

local function normalizeCreationStep(p2)
	return v7[p2] or "unknown"
end

local function normalizeCreationStatus(p2)
	if p2 == "success" or p2 == "failed" then
		return p2
	end

	return "unknown"
end

local v8 = {
	Moderated = "moderated",
	CaptureModerated = "moderated",
	UploadQuotaReached = "quota",
	Timeout = "timeout",
	StartUploadFailed = "startFailed",
	RegistrationFailed = "registrationFailed",
	PollError = "pollError",
	NetworkError = "network",
	ServerError = "serverError",
	InvalidRequest = "invalidRequest",
	GenericFailure = "generic"
}

local function normalizeUploadFailureReason(p2)
	return v8[p2] or "unknown"
end

local v9 = {
	malformed = "malformed",
	duplicate = "duplicate",
	moderated = "moderated",
	deleted = "deleted"
}

local function normalizeFilterReason(p2)
	return v9[p2] or "unknown"
end

local v10 = {
	music = "music",
	trim = "trim",
	text_overlay = "text_overlay",
	sticker = "sticker",
	description = "description",
	tts = "tts"
}

local function normalizePublishedEditType(p2)
	return v10[p2] or "unknown"
end

local v11 = {
	music = "music",
	trim = "trim",
	text = "text",
	sticker = "sticker",
	generateText = "generateText",
	voice = "voice"
}

local function normalizeEditTool(p2)
	return v11[p2] or "unknown"
end

local function normalizeCaptureType(p2)
	if p2 == "screenshot" or p2 == "video" then
		return p2
	end

	return "unknown"
end

local function normalizeGenerateTextStatus(p2)
	if p2 == "succeeded" or p2 == "failed" or p2 == "filtered" then
		return p2
	end

	return "unknown"
end

local function normalizeCommentsSurface(p2)
	if p2 == "watch_tab" or p2 == "profile" then
		return p2
	end

	return "unknown"
end

local v12 = { attempted = "attempted", succeeded = "succeeded", failed = "failed" }

local function normalizeCommentsListLoadStatus(p2)
	return v12[p2] or "unknown"
end

local v13 = { initial = "initial", pagination = "pagination", refresh = "refresh" }

local function normalizeCommentsLoadType(p2)
	return v13[p2] or "unknown"
end

local v14 = {
	attempted = "attempted",
	success = "success",
	rejected = "rejected",
	failed = "failed",
	unknown = "unknown",
	cancelled = "cancelled"
}

local function normalizeCommentPostStatus(p2)
	return v14[p2] or "unknown"
end

local function normalizeCommentsFailureReason(value)
	if value == nil or string.find(value, "^unknown_") ~= nil then
		return "unknown"
	end

	return value
end

local v15 = { rejected = true, failed = true, unknown = true }

local v16 = { attempted = "attempted", succeeded = "succeeded", failed = "failed" }

local function normalizeCommentRequestStatus(p2)
	return v16[p2] or "unknown"
end

local function normalizeCommentReactionAction(p2)
	if p2 == "add" or p2 == "remove" then
		return p2
	end

	return "unknown"
end

local function normalizeCommentDeleteStatus(p2)
	if p2 == "already_deleted" then
		return "already_deleted"
	end

	return v16[p2] or "unknown"
end

local function normalizeCommentReportStatus(p2): string
	if p2 == "clicked" then
		return "clicked"
	end

	return "unknown"
end

local v17 = {
	views = "views",
	lifetime_views = "lifetime_views",
	lifetime_watch_time = "lifetime_watch_time",
	lifetime_watch_time_no_replay = "lifetime_watch_time_no_replay",
	lifetime_joins = "lifetime_joins"
}

local function normalizePostInsightsQuery(p2)
	return v17[p2] or "unknown"
end

local function normalizePostInsightsRequestStatus(p2)
	if p2 == "success" or p2 == "failed" then
		return p2
	end

	return "unknown"
end

local function normalizeCommentTranslationShown(p2)
	if p2 == "translated" or p2 == "original" then
		return p2
	end

	return "unknown"
end

local function formatFeedOperationInfo(data, callback)
	local v18 = { status = data.status, feedType = data.feedType }

	if data.status == "failed" then
		v18.failureReason = callback(data.failureReason)
	end

	return v18
end

return {
	[RealtimeEventNames.MomentsFeedLoadAttempt] = telemetry.new({
		name = RealtimeEventNames.MomentsFeedLoadAttempt,
		description = "Counts Moments feed load attempts in real time, providing the denominator for feed outcome rates.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return { feedType = p2.feedType }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedState] = telemetry.new({
		name = RealtimeEventNames.MomentsFeedState,
		description = "Counts completed Moments top-of-feed outcomes in real time, dimensioned by status, feed type, and bounded failure reason.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = { status = data.status, feedType = data.feedType }

					if data.status ~= "failed" then
						return v19
					end

					local v20 = data.failureReason

					if v20 == nil or v20 == "" then
						v20 = "unknown"
					else
						v20 = v20 ~= "requestFailed"
							and v20 ~= "malformedResponse"
							and (not FFlagMomentsParentTimeLimit or v20 ~= "parentalTimeLimitReached")
							and "unknown"
							or v20
					end

					v19.failureReason = v20

					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedLoadMore] = telemetry.new({
		name = RealtimeEventNames.MomentsFeedLoadMore,
		description = "Counts attempted and failed Moments pagination requests in real time.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = { status = data.status, feedType = data.feedType }

					if data.status ~= "failed" then
						return v19
					end

					local v20 = data.failureReason

					if v20 == nil or v20 == "" then
						v20 = "unknown"
					else
						v20 = v20 ~= "requestFailed"
							and v20 ~= "malformedResponse"
							and (not FFlagMomentsParentTimeLimit or v20 ~= "parentalTimeLimitReached")
							and "unknown"
							or v20
					end

					v19.failureReason = v20

					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedMediaLoad] = telemetry.new({
		name = RealtimeEventNames.MomentsFeedMediaLoad,
		description = "Counts attempted and failed unique Moments media loads in the coordinator download window.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = normalizeMediaFailureReason
					local v20 = { status = data.status, feedType = data.feedType }

					if data.status == "failed" then
						v20.failureReason = v19(data.failureReason)
					end

					return v20
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSurfaceLoadAbort] = telemetry.new({
		name = RealtimeEventNames.MomentsSurfaceLoadAbort,
		description = "Counts Moments surface loads that end before the first frame, dimensioned by bounded abort reason.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return { reason = p2.reason }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsViewBegan] = telemetry.new({
		name = RealtimeEventNames.MomentsViewBegan,
		description = "Counts Moments views in real time, dimensioned by a bounded source.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						source = v5[p2.source] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSessionStarted] = telemetry.new({
		name = RealtimeEventNames.MomentsSessionStarted,
		description = "Counts Moments session starts in real time, dimensioned by a bounded entry source.",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						source = v5[p2.source] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSessionEnded] = telemetry.new({
		name = RealtimeEventNames.MomentsSessionEnded,
		description = "Counts Moments session ends in real time, dimensioned by a bounded entry source.",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						source = v5[p2.source] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSessionHeartbeat] = telemetry.new({
		name = RealtimeEventNames.MomentsSessionHeartbeat,
		description = "Counts periodic heartbeats emitted while a Moments session is active; multiply the per-second rate by the heartbeat interval to estimate concurrent sessions (CCU).",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						source = v5[p2.source] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsEngagement] = telemetry.new({
		name = RealtimeEventNames.MomentsEngagement,
		description = "Counts Moments engagement actions (reactions, shares, joins, report submissions, report clicks, experience-detail opens) in real time, dimensioned by a bounded action.",
		lastUpdated = { 2026, 10, 2 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						action = v6[p2.action] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCreationStep] = telemetry.new({
		name = RealtimeEventNames.MomentsCreationStep,
		description = "Counts Moments creation-flow steps in real time, dimensioned by bounded step and (for upload) status.",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = {
						step = v7[data.step] or "unknown"
					}

					if data.status ~= nil then
						local status = data.status
						v19.status = status ~= "success" and status ~= "failed" and "unknown" or status
					end

					if data.reason ~= nil then
						v19.reason = v8[data.reason] or "unknown"
					end

					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedItemsReceived] = telemetry.new({
		name = RealtimeEventNames.MomentsFeedItemsReceived,
		description = "Counts feed items received from the backend before client-side filtering; the denominator for the filtered-item rate.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return { feedType = p2.feedType }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedItemFiltered] = telemetry.new({
		name = RealtimeEventNames.MomentsFeedItemFiltered,
		description = "Counts feed items the client dropped, dimensioned by bounded reason. deleted/moderated are dropped by the feed source's availability filter; malformed/duplicate are dropped by the feed store's dedupe. Denominator is MomentsFeedItemsReceived.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						reason = v9[p2.reason] or "unknown",
						feedType = p2.feedType
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPublishedWithEdit] = telemetry.new({
		name = RealtimeEventNames.MomentsPublishedWithEdit,
		description = "Counts published moments carrying each edit type (one increment per edit type present), dimensioned by bounded editType.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						editType = v10[p2.editType] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPublishedEditCount] = telemetry.new({
		name = RealtimeEventNames.MomentsPublishedEditCount,
		description = "Counts published moments by how many edit types they carry, dimensioned by a bounded bucket (0/1/2/3plus).",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return { bucket = p2.bucket }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPublishedByCaptureType] = telemetry.new({
		name = RealtimeEventNames.MomentsPublishedByCaptureType,
		description = "Counts published moments by bounded capture type (screenshot/video).",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					local captureType = p2.captureType
					return {
						captureType = captureType ~= "screenshot" and captureType ~= "video" and "unknown" or captureType
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsEditToolOpened] = telemetry.new({
		name = RealtimeEventNames.MomentsEditToolOpened,
		description = "Counts creation edit-tool opens, dimensioned by bounded tool (music/trim/text/sticker/generateText/voice).",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						tool = v11[p2.tool] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsEditToolAbandoned] = telemetry.new({
		name = RealtimeEventNames.MomentsEditToolAbandoned,
		description = "Counts creation edit-tool cancels (Back without applying), dimensioned by bounded tool. Pairs with MomentsEditToolOpened for an open→apply conversion.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					return {
						tool = v11[p2.tool] or "unknown"
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsGenerateText] = telemetry.new({
		name = RealtimeEventNames.MomentsGenerateText,
		description = "Counts AI generate-text attempts by bounded status (succeeded/failed/filtered).",
		lastUpdated = { 2026, 8, 17 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					local status = p2.status
					return {
						status = status ~= "succeeded" and status ~= "failed" and status ~= "filtered" and "unknown" or status
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentsListLoad] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentsListLoad,
		description = "Counts Moments comment list requests in real time by bounded status, load type, surface and (failed only) failure reason. Mirrors the product list-load events.",
		lastUpdated = { 2026, 9, 29 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = v12[data.status] or "unknown"
					local v20 = {
						status = v19,
						loadType = v13[data.loadType] or "unknown",
						surface = 0
					}
					local surface = data.surface
					v20.surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface

					if v19 == "failed" then
						local failureReason = data.failureReason
						v20.failureReason = (failureReason == nil or string.find(failureReason, "^unknown_") ~= nil)
							and "unknown"
							or failureReason
					end

					return v20
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentPost] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentPost,
		description = "Counts Moments comment post requests and outcomes in real time by bounded status, surface and (rejected/failed/unknown only) failure reason. Mirrors the product post events.",
		lastUpdated = { 2026, 9, 29 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = v14[data.status] or "unknown"

					local surface = data.surface
					local v20 = {
						status = v19,
						surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface
					}

					if v15[v19] then
						local failureReason = data.failureReason
						v20.failureReason = (failureReason == nil or string.find(failureReason, "^unknown_") ~= nil)
							and "unknown"
							or failureReason
					end

					return v20
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentReaction] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentReaction,
		description = "Counts Moments comment reaction requests in real time, one attempt per network request including retries, by bounded status, action (add/remove), surface and (failed only) failure reason.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v19 = v16[data.status] or "unknown"

					local action = data.action
					local v20 = {
						status = v19,
						action = action ~= "add" and action ~= "remove" and "unknown" or action,
						surface = 0
					}

					local surface = data.surface
					v20.surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface

					if v19 == "failed" then
						local failureReason = data.failureReason
						v20.failureReason = (failureReason == nil or string.find(failureReason, "^unknown_") ~= nil)
							and "unknown"
							or failureReason
					end

					return v20
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentDelete] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentDelete,
		description = "Counts Moments comment delete requests and outcomes in real time by bounded status (already_deleted = the server reported the comment gone), surface and (failed only) failure reason.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local status = data.status
					local v19 = status ~= "already_deleted" and (v16[status] or "unknown") or status

					local surface = data.surface
					local v20 = {
						status = v19,
						surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface
					}

					if v19 == "failed" then
						local failureReason = data.failureReason
						v20.failureReason = (failureReason == nil or string.find(failureReason, "^unknown_") ~= nil)
							and "unknown"
							or failureReason
					end

					return v20
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentReport] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentReport,
		description = "Counts Moments comment report flow opens in real time by surface, including Block and Report. Counted at the same point as the product report-click event; submission happens in the host abuse-report flow.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					local status = p2.status
					local v19 = {
						status = status ~= "clicked" and "unknown" or status,
						surface = 0
					}

					local surface = p2.surface
					v19.surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface
					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentAuthorBlock] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentAuthorBlock,
		description = "Counts blocks of a comment author started from a Moments comment in real time by bounded status (attempted on confirm, then succeeded/failed) and surface.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					local v19 = {
						status = v16[p2.status] or "unknown",
						surface = 0
					}
					local surface = p2.surface
					v19.surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface
					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPostInsightsRequest] = telemetry.new({
		name = RealtimeEventNames.MomentsPostInsightsRequest,
		description = "Counts Post insights Creator Analytics (CAaaS) request outcomes in real time, once per query per page open, by bounded query (views series or one of the four lifetime totals) and status (success or failed).",
		lastUpdated = { 2026, 11, 10 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					local v19 = {
						query = v17[p2.query] or "unknown",
						status = 0
					}
					local status = p2.status
					v19.status = status ~= "success" and status ~= "failed" and "unknown" or status
					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPostInsightsRequestLatency] = telemetry.new({
		name = RealtimeEventNames.MomentsPostInsightsRequestLatency,
		description = "Post insights Creator Analytics (CAaaS) request latency in ms, as a stat (p50/p95/p99), by bounded query and status. Same requests as MomentsPostInsightsRequest: each query's first request on a cold page open, including the gateway's polling.",
		lastUpdated = { 2026, 11, 6 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryStat,
				format = function(p2)
					local v19 = {
						query = v17[p2.query] or "unknown",
						status = 0
					}
					local status = p2.status
					v19.status = status ~= "success" and status ~= "failed" and "unknown" or status
					return v19
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentTranslationToggle] = telemetry.new({
		name = RealtimeEventNames.MomentsCommentTranslationToggle,
		description = "Counts taps on a Moments comment's translation toggle in real time by the text shown after the tap (translated/original) and surface. Counted at the same point as the product translation-toggled event.",
		lastUpdated = { 2026, 11, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p2)
					local status = p2.status
					local v19 = {
						status = status ~= "translated" and status ~= "original" and "unknown" or status,
						surface = 0
					}

					local surface = p2.surface
					v19.surface = surface ~= "watch_tab" and surface ~= "profile" and "unknown" or surface
					return v19
				end
			}
		}
	})
}
