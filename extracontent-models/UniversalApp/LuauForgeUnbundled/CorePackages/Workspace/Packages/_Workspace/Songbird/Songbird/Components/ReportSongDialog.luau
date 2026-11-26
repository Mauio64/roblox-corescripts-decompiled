local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local AssetFavorites = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/AssetFavorites")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/FocusNavigationUtils")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/logger")
require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")

local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local DefaultTwoStepReportFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/GenericAbuseReporting/DefaultTwoStepReportFlow")
local AbuseCategory = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/GenericAbuseReporting/AbuseCategory")
local AbuseEntrypoint = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/GenericAbuseReporting/AbuseEntrypoint")

local useCallback = React.useCallback
local useLocalUserId = AssetFavorites.useLocalUserId

local v5 = {
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateAudio",
		value = "InappropriateAudio"
	},
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateThumbnail",
		value = "InappropriateThumbnail"
	}
}

local v6 = { Audio = "audio", Image = "image" }

local function buildReport(data)
	local v7 = {
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
		return HttpService:JSONEncode(v7)
	end)

	if success then
		return result
	end

	return nil
end

local function ReportSongDialog(props)
	local v7 = useLocalUserId()

	local v8 = useCallback(function()
		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })

	local v9 = useCallback(function(p2, p3): boolean
		local v10 = p2 == v5[1].value
		local v11 = if v10 then props.audio.assetId else props.audio.thumbnailAssetId

		if not v11 then
			return true
		end

		local report = buildReport({
			userId = v7,
			comment = p3,
			assetId = v11,
			abuseVector = v10 and "audio" or "image",
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
			logger:info(`Abuse report sent for asset [{v11}] with reason [{p2}] and comment [{p3}]`)
		else
			logger:warning(`Failed to submit abuse report for asset {v11}: {result}`)
		end

		return true
	end, {
		props.analyticsSource,
		props.audio.assetId,
		props.audio.thumbnailAssetId,
		v7
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		selectionGroup = true
	}, {
		FocusRoot = React.createElement(
			focusRoot,
			{
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{
				AbuseReportFlow = React.createElement(DefaultTwoStepReportFlow, {
					analyticsContext = props.analyticsSource,
					onCloseProps = { hasPreviousSteps = false, onAbandon = v8 },
					onSubmitProps = { hasNextSteps = false, onSubmit = v9 },
					onComplete = v8,
					reportCategories = v5,
					reportCategoryDefaultKey = v5[1].value,
					localizationKeys = {
						formTitle = "Feature.SongDetails.Action.ReportAudio"
					}
				})
			}
		)
	})
end

return React.memo(ReportSongDialog)
