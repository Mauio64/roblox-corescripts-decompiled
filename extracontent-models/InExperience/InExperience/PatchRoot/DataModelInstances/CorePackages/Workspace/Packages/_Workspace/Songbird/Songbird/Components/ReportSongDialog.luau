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
local t1 = {
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateAudio",
		value = "InappropriateAudio"
	},
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateThumbnail",
		value = "InappropriateThumbnail"
	}
}
local _ = {
	Audio = "audio",
	Image = "image"
}

local function buildReport(t2: {[any]: any}) -- line: 57
	-- upvalues: AbuseEntrypoint (copy), AbuseCategory (copy), HttpService (copy)
	local t3 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = AbuseEntrypoint.APP
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = tostring(t2.userId)
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = AbuseCategory.ABUSE_CATEGORY_INAPT_CONTENT
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = t2.comment
				}}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {{
					data = t2.assetId
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = t2.abuseVector
				}}
			},
			VARIANT = {
				valueList = {{
					data = t2.variant
				}}
			}
		}
	}
	local ok, result = pcall(function() -- line: 110
		-- upvalues: HttpService (copy), t3 (copy)
		return HttpService:JSONEncode(t3)
	end)

	if ok then
		return result
	end

	return nil
end
local function ReportSongDialog(t4: {[any]: any}) -- line: 117
	-- upvalues: useLocalUserId (copy), useCallback (copy), t1 (copy), buildReport (copy), Players (copy), logger (copy), React (copy), Foundation (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), DefaultTwoStepReportFlow (copy)
	local v25 = useLocalUserId()
	local v26 = useCallback(function() -- line: 120
		-- upvalues: t4 (copy)
		if t4.onClose then
			t4.onClose()
		end
	end, { t4.onClose })
	local v27 = useCallback(function(s1: string, s2: string) -- line: 126
		-- upvalues: t1 (copy), t4 (copy), buildReport (copy), v25 (copy), Players (copy), logger (copy)
		local v30 = s1 == t1[1].value
		local v31 = if not v30 then t4.audio.thumbnailAssetId else t4.audio.assetId

		if v31 then
			local v32 = buildReport({
				userId = v25,
				comment = s2,
				assetId = v31,
				abuseVector = not v30 and "image" or "audio",
				variant = t4.analyticsSource
			})

			if v32 then
				local LocalPlayer = Players.LocalPlayer

				if LocalPlayer then
					local ok, result = pcall(function() -- line: 142
						-- upvalues: Players (copy), LocalPlayer (copy), v32 (copy)
						Players:ReportAbuseV3(LocalPlayer, v32)
					end)

					if ok then
						logger:info(`Abuse report sent for asset [{ v31 }] with reason [{ s1 }] and comment [{ s2 }]`)
					else
						logger:warning(`Failed to submit abuse report for asset { v31 }: { result }`)
					end
				end
			end
		end

		return true
	end, {
		t4.analyticsSource,
		t4.audio.assetId,
		t4.audio.thumbnailAssetId,
		v25
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		selectionGroup = true
	}, {
		FocusRoot = React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			AbuseReportFlow = React.createElement(DefaultTwoStepReportFlow, {
				analyticsContext = t4.analyticsSource,
				onCloseProps = {
					hasPreviousSteps = false,
					onAbandon = v26
				},
				onSubmitProps = {
					hasNextSteps = false,
					onSubmit = v27
				},
				onComplete = v26,
				reportCategories = t1,
				reportCategoryDefaultKey = t1[1].value,
				localizationKeys = {
					formTitle = "Feature.SongDetails.Action.ReportAudio"
				}
			})
		})
	})
end

return React.memo(ReportSongDialog)
