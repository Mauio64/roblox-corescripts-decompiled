local parent = script:FindFirstAncestor("MomentsCommon").Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

local RealtimeEventNames = require(script.Parent.RealtimeEventNames)

local Telemetry = SocialLuaAnalytics.Telemetry

local v = {
	watch_tab = "watch_tab",
	deeplink = "deeplink",
	profile = "profile",
	flyout_menu = "flyout_menu"
}

local function normalizeViewSource(source: string) -- 4 equivalent calls inferred from this helper
	return v[source] or "unknown"
end

local function normalizeRequestFailureReason(failureReason: string?) -- 1 equivalent call inferred from this helper
	if failureReason == nil or failureReason == "" then
		return "unknown"
	end

	if failureReason == "requestFailed" or failureReason == "malformedResponse" then
		return failureReason
	end

	return "unknown"
end

local function normalizeMediaFailureReason(value: string?): string
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

local v2 = {
	reaction_add = "reaction_add",
	reaction_remove = "reaction_remove",
	share = "share",
	join = "join",
	report = "report",
	report_click = "report_click"
}

local function normalizeEngagementAction(action: string) -- 1 equivalent call inferred from this helper
	return v2[action] or "unknown"
end

local v3 = {
	create_intent = "create_intent",
	gallery_selected = "gallery_selected",
	published = "published",
	upload = "upload",
	post_review = "post_review"
}

local function normalizeCreationStep(step: string) -- 1 equivalent call inferred from this helper
	return v3[step] or "unknown"
end

local function normalizeCreationStatus(p: string) -- 1 equivalent call inferred from this helper
	return if p == "success" or p == "failed" then p else "unknown"
end

local v4 = {
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

local function normalizeUploadFailureReason(reason: string) -- 1 equivalent call inferred from this helper
	return v4[reason] or "unknown"
end

local v5 = {
	malformed = "malformed",
	duplicate = "duplicate",
	moderated = "moderated",
	deleted = "deleted"
}

local function normalizeFilterReason(reason: string) -- 1 equivalent call inferred from this helper
	return v5[reason] or "unknown"
end

local v6 = {
	music = "music",
	trim = "trim",
	text_overlay = "text_overlay",
	sticker = "sticker",
	description = "description",
	tts = "tts"
}

local function normalizePublishedEditType(editType: string) -- 1 equivalent call inferred from this helper
	return v6[editType] or "unknown"
end

local v7 = {
	music = "music",
	trim = "trim",
	text = "text",
	sticker = "sticker",
	generateText = "generateText",
	voice = "voice"
}

local function normalizeEditTool(tool: string) -- 2 equivalent calls inferred from this helper
	return v7[tool] or "unknown"
end

local function normalizeCaptureType(p: string) -- 1 equivalent call inferred from this helper
	return if p == "screenshot" or p == "video" then p else "unknown"
end

local function normalizeGenerateTextStatus(p: string) -- 1 equivalent call inferred from this helper
	if p == "succeeded" or p == "failed" or p == "filtered" then
		return p
	end

	return "unknown"
end

local function normalizeCommentsSurface(p: string) -- 6 equivalent calls inferred from this helper
	return if p == "watch_tab" or p == "profile" then p else "unknown"
end

local v8 = { attempted = "attempted", succeeded = "succeeded", failed = "failed" }

local function normalizeCommentsListLoadStatus(status: string) -- 1 equivalent call inferred from this helper
	return v8[status] or "unknown"
end

local v9 = { initial = "initial", pagination = "pagination", refresh = "refresh" }

local function normalizeCommentsLoadType(loadType: string) -- 1 equivalent call inferred from this helper
	return v9[loadType] or "unknown"
end

local v10 = {
	attempted = "attempted",
	success = "success",
	rejected = "rejected",
	failed = "failed",
	unknown = "unknown",
	cancelled = "cancelled"
}

local function normalizeCommentPostStatus(status: string) -- 1 equivalent call inferred from this helper
	return v10[status] or "unknown"
end

local function normalizeCommentsFailureReason(failureReason: string?) -- 4 equivalent calls inferred from this helper
	if failureReason == nil or string.find(failureReason, "^unknown_") ~= nil then
		return "unknown"
	end

	return failureReason
end

local v11 = { rejected = true, failed = true, unknown = true }

local v12 = { attempted = "attempted", succeeded = "succeeded", failed = "failed" }

local function normalizeCommentRequestStatus(p: string) -- 3 equivalent calls inferred from this helper
	return v12[p] or "unknown"
end

local function normalizeCommentReactionAction(p: string) -- 1 equivalent call inferred from this helper
	return if p == "add" or p == "remove" then p else "unknown"
end

local function normalizeCommentDeleteStatus(status: string) -- 1 equivalent call inferred from this helper
	if status == "already_deleted" then
		return "already_deleted"
	end

	return normalizeCommentRequestStatus(status) -- inferred equivalent call
end

local function normalizeCommentReportStatus(p: string): string -- 1 equivalent call inferred from this helper
	return if p == "clicked" then "clicked" else "unknown"
end

local function formatFeedOperationInfo(data, callback) -- 2 equivalent calls inferred from this helper
	local v13 = { status = data.status, feedType = data.feedType }

	if data.status == "failed" then
		v13.failureReason = callback(data.failureReason)
	end

	return v13
end

return {
	[RealtimeEventNames.MomentsFeedLoadAttempt] = Telemetry.new({
		name = RealtimeEventNames.MomentsFeedLoadAttempt,
		description = "Counts Moments feed load attempts in real time, providing the denominator for feed outcome rates.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { feedType = p.feedType }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedState] = Telemetry.new({
		name = RealtimeEventNames.MomentsFeedState,
		description = "Counts completed Moments top-of-feed outcomes in real time, dimensioned by status, feed type, and bounded failure reason.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v13 = { status = data.status, feedType = data.feedType }

					if data.status == "failed" then
						v13.failureReason = normalizeRequestFailureReason(data.failureReason) -- inferred equivalent call
					end

					return v13
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedLoadMore] = Telemetry.new({
		name = RealtimeEventNames.MomentsFeedLoadMore,
		description = "Counts attempted and failed Moments pagination requests in real time.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					return formatFeedOperationInfo(data, normalizeRequestFailureReason) -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedMediaLoad] = Telemetry.new({
		name = RealtimeEventNames.MomentsFeedMediaLoad,
		description = "Counts attempted and failed unique Moments media loads in the coordinator download window.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					return formatFeedOperationInfo(data, normalizeMediaFailureReason) -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSurfaceLoadAbort] = Telemetry.new({
		name = RealtimeEventNames.MomentsSurfaceLoadAbort,
		description = "Counts Moments surface loads that end before the first frame, dimensioned by bounded abort reason.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { reason = p.reason }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsViewBegan] = Telemetry.new({
		name = RealtimeEventNames.MomentsViewBegan,
		description = "Counts Moments views in real time, dimensioned by a bounded source.",
		lastUpdated = { 2026, 7, 30 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { source = normalizeViewSource(p.source) } -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSessionStarted] = Telemetry.new({
		name = RealtimeEventNames.MomentsSessionStarted,
		description = "Counts Moments session starts in real time, dimensioned by a bounded entry source.",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { source = normalizeViewSource(p.source) } -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSessionEnded] = Telemetry.new({
		name = RealtimeEventNames.MomentsSessionEnded,
		description = "Counts Moments session ends in real time, dimensioned by a bounded entry source.",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { source = normalizeViewSource(p.source) } -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsSessionHeartbeat] = Telemetry.new({
		name = RealtimeEventNames.MomentsSessionHeartbeat,
		description = "Counts periodic heartbeats emitted while a Moments session is active; multiply the per-second rate by the heartbeat interval to estimate concurrent sessions (CCU).",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { source = normalizeViewSource(p.source) } -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsEngagement] = Telemetry.new({
		name = RealtimeEventNames.MomentsEngagement,
		description = "Counts Moments engagement actions (reactions, shares, joins, report submissions, report clicks, experience-detail opens) in real time, dimensioned by a bounded action.",
		lastUpdated = { 2026, 10, 2 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						action = normalizeEngagementAction(p.action) -- inferred equivalent call
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCreationStep] = Telemetry.new({
		name = RealtimeEventNames.MomentsCreationStep,
		description = "Counts Moments creation-flow steps in real time, dimensioned by bounded step and (for upload) status.",
		lastUpdated = { 2026, 8, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local v13 = {
						step = normalizeCreationStep(data.step) -- inferred equivalent call
					}

					if data.status ~= nil then
						v13.status = normalizeCreationStatus(data.status) -- inferred equivalent call
					end

					if data.reason ~= nil then
						v13.reason = normalizeUploadFailureReason(data.reason) -- inferred equivalent call
					end

					return v13
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedItemsReceived] = Telemetry.new({
		name = RealtimeEventNames.MomentsFeedItemsReceived,
		description = "Counts feed items received from the backend before client-side filtering; the denominator for the filtered-item rate.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { feedType = p.feedType }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsFeedItemFiltered] = Telemetry.new({
		name = RealtimeEventNames.MomentsFeedItemFiltered,
		description = "Counts feed items the client dropped, dimensioned by bounded reason. deleted/moderated are dropped by the feed source's availability filter; malformed/duplicate are dropped by the feed store's dedupe. Denominator is MomentsFeedItemsReceived.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						reason = normalizeFilterReason(p.reason), -- inferred equivalent call
						feedType = p.feedType
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPublishedWithEdit] = Telemetry.new({
		name = RealtimeEventNames.MomentsPublishedWithEdit,
		description = "Counts published moments carrying each edit type (one increment per edit type present), dimensioned by bounded editType.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						editType = normalizePublishedEditType(p.editType) -- inferred equivalent call
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPublishedEditCount] = Telemetry.new({
		name = RealtimeEventNames.MomentsPublishedEditCount,
		description = "Counts published moments by how many edit types they carry, dimensioned by a bounded bucket (0/1/2/3plus).",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { bucket = p.bucket }
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsPublishedByCaptureType] = Telemetry.new({
		name = RealtimeEventNames.MomentsPublishedByCaptureType,
		description = "Counts published moments by bounded capture type (screenshot/video).",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						captureType = normalizeCaptureType(p.captureType) -- inferred equivalent call
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsEditToolOpened] = Telemetry.new({
		name = RealtimeEventNames.MomentsEditToolOpened,
		description = "Counts creation edit-tool opens, dimensioned by bounded tool (music/trim/text/sticker/generateText/voice).",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { tool = normalizeEditTool(p.tool) } -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsEditToolAbandoned] = Telemetry.new({
		name = RealtimeEventNames.MomentsEditToolAbandoned,
		description = "Counts creation edit-tool cancels (Back without applying), dimensioned by bounded tool. Pairs with MomentsEditToolOpened for an open→apply conversion.",
		lastUpdated = { 2026, 8, 5 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return { tool = normalizeEditTool(p.tool) } -- inferred equivalent call
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsGenerateText] = Telemetry.new({
		name = RealtimeEventNames.MomentsGenerateText,
		description = "Counts AI generate-text attempts by bounded status (succeeded/failed/filtered).",
		lastUpdated = { 2026, 8, 17 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						status = normalizeGenerateTextStatus(p.status) -- inferred equivalent call
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentsListLoad] = Telemetry.new({
		name = RealtimeEventNames.MomentsCommentsListLoad,
		description = "Counts Moments comment list requests in real time by bounded status, load type, surface and (failed only) failure reason. Mirrors the product list-load events.",
		lastUpdated = { 2026, 9, 29 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local commentsListLoadStatus = normalizeCommentsListLoadStatus(data.status) -- inferred equivalent call
					local v13 = {
						status = commentsListLoadStatus,
						loadType = normalizeCommentsLoadType(data.loadType), -- inferred equivalent call
						surface = normalizeCommentsSurface(data.surface) -- inferred equivalent call
					}

					if commentsListLoadStatus == "failed" then
						v13.failureReason = normalizeCommentsFailureReason(data.failureReason) -- inferred equivalent call
					end

					return v13
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentPost] = Telemetry.new({
		name = RealtimeEventNames.MomentsCommentPost,
		description = "Counts Moments comment post requests and outcomes in real time by bounded status, surface and (rejected/failed/unknown only) failure reason. Mirrors the product post events.",
		lastUpdated = { 2026, 9, 29 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local commentPostStatus = normalizeCommentPostStatus(data.status) -- inferred equivalent call
					local v13 = {
						status = commentPostStatus,
						surface = normalizeCommentsSurface(data.surface) -- inferred equivalent call
					}

					if v11[commentPostStatus] then
						v13.failureReason = normalizeCommentsFailureReason(data.failureReason) -- inferred equivalent call
					end

					return v13
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentReaction] = Telemetry.new({
		name = RealtimeEventNames.MomentsCommentReaction,
		description = "Counts Moments comment reaction requests in real time, one attempt per network request including retries, by bounded status, action (add/remove), surface and (failed only) failure reason.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local commentRequestStatus = normalizeCommentRequestStatus(data.status) -- inferred equivalent call
					local v13 = {
						status = commentRequestStatus,
						action = normalizeCommentReactionAction(data.action), -- inferred equivalent call
						surface = normalizeCommentsSurface(data.surface) -- inferred equivalent call
					}

					if commentRequestStatus == "failed" then
						v13.failureReason = normalizeCommentsFailureReason(data.failureReason) -- inferred equivalent call
					end

					return v13
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentDelete] = Telemetry.new({
		name = RealtimeEventNames.MomentsCommentDelete,
		description = "Counts Moments comment delete requests and outcomes in real time by bounded status (already_deleted = the server reported the comment gone), surface and (failed only) failure reason.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(data)
					local commentDeleteStatus = normalizeCommentDeleteStatus(data.status) -- inferred equivalent call
					local v13 = {
						status = commentDeleteStatus,
						surface = normalizeCommentsSurface(data.surface) -- inferred equivalent call
					}

					if commentDeleteStatus == "failed" then
						v13.failureReason = normalizeCommentsFailureReason(data.failureReason) -- inferred equivalent call
					end

					return v13
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentReport] = Telemetry.new({
		name = RealtimeEventNames.MomentsCommentReport,
		description = "Counts Moments comment report flow opens in real time by surface, including Block and Report. Counted at the same point as the product report-click event; submission happens in the host abuse-report flow.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						status = normalizeCommentReportStatus(p.status), -- inferred equivalent call
						surface = normalizeCommentsSurface(p.surface) -- inferred equivalent call
					}
				end
			}
		}
	}),
	[RealtimeEventNames.MomentsCommentAuthorBlock] = Telemetry.new({
		name = RealtimeEventNames.MomentsCommentAuthorBlock,
		description = "Counts blocks of a comment author started from a Moments comment in real time by bounded status (attempted on confirm, then succeeded/failed) and surface.",
		lastUpdated = { 2026, 10, 1 },
		throttlingThousandths = 10000,
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				incrementValue = 1,
				format = function(p)
					return {
						status = normalizeCommentRequestStatus(p.status), -- inferred equivalent call
						surface = normalizeCommentsSurface(p.surface) -- inferred equivalent call
					}
				end
			}
		}
	})
}
