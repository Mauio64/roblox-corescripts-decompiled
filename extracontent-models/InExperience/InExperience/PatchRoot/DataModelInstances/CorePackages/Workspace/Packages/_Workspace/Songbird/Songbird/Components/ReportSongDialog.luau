local Songbird = script:FindFirstAncestor("Songbird")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local AssetFavorites = require(Songbird.Parent.AssetFavorites)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local FocusNavigationUtils = require(Songbird.Parent.FocusNavigationUtils)

local logger = require(Songbird.logger)
require(Songbird.types)

local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local DefaultTwoStepReportFlow = require(Songbird.Parent.GenericAbuseReporting.DefaultTwoStepReportFlow)
local AbuseCategory = require(Songbird.Parent.GenericAbuseReporting.AbuseCategory)
local AbuseEntrypoint = require(Songbird.Parent.GenericAbuseReporting.AbuseEntrypoint)

local useCallback = React.useCallback
local useLocalUserId = AssetFavorites.useLocalUserId

local reportCategories = {
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateAudio",
		value = "InappropriateAudio"
	},
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateThumbnail",
		value = "InappropriateThumbnail"
	}
}

local _ = { Audio = "audio", Image = "image" }

local function buildReport(data)
	local v = {
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = AbuseEntrypoint.APP }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = tostring(data.userId) }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = AbuseCategory.ABUSE_CATEGORY_INAPT_CONTENT }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = data.comment }
				}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {
					{ data = data.assetId }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = data.abuseVector }
				}
			},
			VARIANT = {
				valueList = {
					{ data = data.variant }
				}
			}
		}
	}

	local success, result = pcall(function()
		return HttpService:JSONEncode(v)
	end)
	return if success then result else nil
end

local function ReportSongDialog(props)
	local userId = useLocalUserId()

	local v = useCallback(function()
		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })

	local onSubmit = useCallback(function(p: string, comment: string): boolean
		local v2 = p == reportCategories[1].value
		local assetId

		if v2 then
			assetId = props.audio.assetId
		else
			assetId = props.audio.thumbnailAssetId
		end

		if not assetId then
			return true
		end

		local report = buildReport({
			userId = userId,
			comment = comment,
			assetId = assetId,
			abuseVector = v2 and "audio" or "image",
			variant = props.analyticsSource
		})

		local localPlayer = report and Players.LocalPlayer

		if not localPlayer then
			return true
		end

		local success, result = pcall(function()
			Players:ReportAbuseV3(localPlayer, report)
		end)

		if success then
			logger:info(`Abuse report sent for asset [{assetId}] with reason [{p}] and comment [{comment}]`)
		else
			logger:warning(`Failed to submit abuse report for asset {assetId}: {result}`)
		end

		return true
	end, { props.analyticsSource, props.audio.assetId, props.audio.thumbnailAssetId, userId })

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		selectionGroup = true
	}, {
		FocusRoot = React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{
				AbuseReportFlow = React.createElement(DefaultTwoStepReportFlow, {
					analyticsContext = props.analyticsSource,
					onCloseProps = { hasPreviousSteps = false, onAbandon = v },
					onSubmitProps = { hasNextSteps = false, onSubmit = onSubmit },
					onComplete = v,
					reportCategories = reportCategories,
					reportCategoryDefaultKey = reportCategories[1].value,
					localizationKeys = { formTitle = "Feature.SongDetails.Action.ReportAudio" }
				})
			}
		)
	})
end

return React.memo(ReportSongDialog)
