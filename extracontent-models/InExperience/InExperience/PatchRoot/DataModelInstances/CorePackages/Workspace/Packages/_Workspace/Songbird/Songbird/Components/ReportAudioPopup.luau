local Songbird = script:FindFirstAncestor("Songbird")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local constants = require(Songbird.constants)
local logger = require(Songbird.logger)
local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local React = require(Songbird.Parent.React)
local DefaultTwoStepReportFlow = require(Songbird.Parent.GenericAbuseReporting.DefaultTwoStepReportFlow)
local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendChromeWindowAnalytics = require(Songbird.Analytics.sendChromeWindowAnalytics)
local ReportAudioPopupContext = require(Songbird.Components.ReportAudioPopupContext)
local getFFlagSongbirdMusicIconThumbnail = require(Songbird.Flags.getFFlagSongbirdMusicIconThumbnail)
local t1 = {
	localizationKey = "CoreScripts.TopBar.Label.InappropriateAudio",
	value = "ABUSE_CATEGORY_INAPT_CONTENT"
}
local t2 = {
	t1,
	{
		localizationKey = "Feature.SongDetails.Label.InappropriateThumbnail",
		value = "ABUSE_CATEGORY_INAPT_THUMBNAIL"
	}
}
local t3 = { t1 }
local t4 = {
	maxSize = constants.BIG_VECTOR,
	onClose = function() -- line: 39
	end,
	Players = Players
}

function buildReport(n1: number, s1: string, s2: string, n2: number, s3: string?) -- line: 55
	-- upvalues: getFFlagSongbirdMusicIconThumbnail (copy), HttpService (copy)
	local t5 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = "in-experience"
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = tostring(n1)
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = s1
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = s2
				}}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {{
					data = tostring(n2)
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = getFFlagSongbirdMusicIconThumbnail() and s3 or "audio"
				}}
			},
			VARIANT = {
				valueList = {{
					data = "ChromeMusicWhatsPlaying"
				}}
			}
		}
	}

	return HttpService:JSONEncode(t5)
end

local function ReportAudioPopup(t6: {[any]: any}) -- line: 104
	-- upvalues: Cryo (copy), t4 (copy), ReportAudioPopupContext (copy), getFFlagSongbirdMusicIconThumbnail (copy), t2 (copy), t3 (copy), MarketplaceService (copy), t1 (copy), Players (copy), logger (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy), React (copy), DefaultTwoStepReportFlow (copy), constants (copy), Foundation (copy)
	local v27 = Cryo.Dictionary.join(t4, t6)
	local v28 = ReportAudioPopupContext.use()
	local v29 = if not getFFlagSongbirdMusicIconThumbnail() or not v28.hasThumbnail then t3 else t2

	local function v30() -- line: 112
		-- upvalues: v27 (copy), v28 (copy)
		v27.onClose()
		v28.setVisibility(false)
	end

	local t7 = {
		AbuseReportFlow = React.createElement(DefaultTwoStepReportFlow, {
			analyticsContext = constants.AUDIO_ANALYTICS_CONTEXT,
			onCloseProps = {
				hasPreviousSteps = false,
				onAbandon = v30
			},
			onSubmitProps = {
				hasNextSteps = false,
				onSubmit = function(s4: string, s5: string) -- line: 118
					-- upvalues: v27 (copy), v28 (copy), MarketplaceService (copy), getFFlagSongbirdMusicIconThumbnail (copy), t1 (copy), Players (copy), logger (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy)
					local LocalPlayer = v27.Players.LocalPlayer

					if LocalPlayer and v28.assetId then
						local assetId = v28.assetId
						local ok, result = pcall(function() -- line: 123
							-- upvalues: MarketplaceService (copy), assetId (copy)
							if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
								return MarketplaceService:GetProductInfoAsync(assetId)
							end

							return MarketplaceService:GetProductInfo(assetId)
						end)

						if ok then
							if result.AssetTypeId == Enum.AssetType.Audio.Value then
								local v38 = if not getFFlagSongbirdMusicIconThumbnail() then nil else s4 ~= t1.value and "image" or "audio"
								local v39 = buildReport(LocalPlayer.UserId, s4, s5, v28.assetId, v38)

								if v39 then
									Players:ReportAbuseV3(LocalPlayer, v39)
									logger:info("Audio abuse report submitted for asset [" .. tostring(v28.assetId) .. "] with reason [" .. s4 .. "] and comment [" .. s5 .. "]")
									sendChromeWindowAnalytics({
										assetId = assetId,
										action = AnalyticActions.SubmitAudioReport
									})
								end
							else
								logger:info("Atempted to submit report for non-audio asset [" .. tostring(v28.assetId) .. "] with reason [" .. s4 .. "] and comment [" .. s5 .. "]")
								sendChromeWindowAnalytics({
									assetId = assetId,
									action = AnalyticActions.PreventNonAudioReport
								})
							end
						else
							logger:warning("Failed to fetch ProductInfo for asset [" .. tostring(v28.assetId) .. "]")
							sendChromeWindowAnalytics({
								assetId = assetId,
								action = AnalyticActions.PreventNonAudioReport
							})
						end
					end

					return true
				end
			},
			onComplete = v30,
			reportCategories = v29,
			reportCategoryDefaultKey = t1.value,
			isReportCategoryReadonly = #v29 == 1,
			localizationKeys = {
				formTitle = "CoreScripts.TopBar.Label.ReportAudio"
			}
		})
	}

	if v28.isVisible then
		if getFFlagSongbirdMusicIconThumbnail() then
			return (React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, t7))
		end

		return (React.createElement(Foundation.View, {
			tag = "size-full",
			sizeConstraint = nil
		}, t7))
	end

	return nil
end

return ReportAudioPopup
