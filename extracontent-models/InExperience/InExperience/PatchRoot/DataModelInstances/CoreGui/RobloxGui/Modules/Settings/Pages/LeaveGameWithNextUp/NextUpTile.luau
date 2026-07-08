local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local LaunchGame = require(CorePackages.Workspace.Packages.GameLaunch).LaunchGame
local React = require(CorePackages.Packages.React)
local DiscoveryAnalytics = require(CorePackages.Workspace.Packages.DiscoveryAnalytics)
local Localization = require(CorePackages.Workspace.Packages.Localization)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

require(script.Parent.useNextUpSort)

local leaveGame = require(script.Parent.Parent.Parent.leaveGame)
local ImageOrSkeleton = require(script.Parent.ImageOrSkeleton)
local Telemetry = require(script.Parent.Telemetry)
local v16 = game:DefineFastFlag("AddSponsoredFooterOnNextUp", false)
local FFlagEnableNextUpImageLatencyTelemetry = require(script.Parent.Flags.FFlagEnableNextUpImageLatencyTelemetry)
local v18 = game:DefineFastFlag("EnableNextUpTileLeaveGameOnTileJoin", false)
local v19 = if not v16 then nil else require(script.Parent.SponsoredFooter)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local useLocalization = Localization.Hooks.useLocalization
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local useRoactService = RobloxAppHooks.useRoactService
local LoadableImage = UIBlox.App.Loading.LoadableImage
local View = Foundation.View
local FoundationText = Foundation.Text
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens

local function getRatingText(p1) -- line: 39
	if not p1 then
		return "--"
	end

	local v32 = p1.upVotes + p1.downVotes

	if v32 == 0 then
		return "--"
	end

	return (tostring((math.floor(p1.upVotes / v32 * 100))))
end
local function NextUpTile(t1: {[any]: any}) -- line: 60
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), useTokens (copy), useLocalization (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), React (copy), ContentProvider (copy), Telemetry (copy), HttpService (copy), gamePlayIntent (copy), v18 (copy), RunService (copy), LaunchGame (copy), leaveGame (copy), View (copy), ImageOrSkeleton (copy), LoadableImage (copy), Skeleton (copy), FoundationText (copy), v16 (copy), v19 (copy)
	local v34 = useRoactService(AppEventIngestService)
	local v35 = useTokens()
	local v36 = useLocalization
	local t2 = {}
	local t3 = { "Feature.GameDetails.RatingPercentOnly" }
	local entryData = t1.entryData
	local s1

	if not entryData then
		s1 = "--"
	else
		local v41 = entryData.upVotes + entryData.downVotes

		s1 = if v41 ~= 0 then tostring((math.floor(entryData.upVotes / v41 * 100))) else "--"
	end

	t3.percentRating = s1
	t2.RatingText = t3

	local v42 = v36(t2)

	if not FFlagEnableNextUpImageLatencyTelemetry then
		React.useEffect(function() -- line: 72
			-- upvalues: t1 (copy), ContentProvider (copy)
			if not t1.entryData or not t1.attemptPreloadImage then
				return
			end

			local image = t1.entryData.image

			if image and image ~= "" then
				ContentProvider:PreloadAsync({ image })
			end
		end, {
			t1.entryData,
			t1.attemptPreloadImage
		})
	end

	local function onJoinGame() -- line: 84
		-- upvalues: t1 (copy), FFlagEnableNextUpImageLatencyTelemetry (copy), Telemetry (copy), HttpService (copy), gamePlayIntent (copy), v34 (copy), v18 (copy), RunService (copy), LaunchGame (copy), leaveGame (copy)
		if not t1.entryData then
			return
		end

		if FFlagEnableNextUpImageLatencyTelemetry then
			Telemetry.logNextUpExitModalAction(Telemetry.NextUpSortViewActionType.JoinGame)
		end

		local v46 = HttpService:GenerateGUID(false):lower()

		gamePlayIntent(v34, "InGameExitPage", {
			placeId = t1.entryData.placeId,
			rootPlaceId = tonumber(t1.entryData.placeId),
			universeId = t1.entryData.universeId,
			sortEntryIndex = tostring(t1.positionIndex),
			gameSetTypeId = t1.topicId,
			joinAttemptId = v46
		})

		if v18 then
			if not RunService:IsStudio() then
				LaunchGame(t1.entryData.placeId, nil, {
					joinAttemptId = v46
				}, nil)
			end

			leaveGame(false)

			return
		end

		if RunService:IsStudio() then
			leaveGame(true)

			return
		end

		LaunchGame(t1.entryData.placeId, nil, {
			joinAttemptId = v46
		}, nil)
	end

	local v44 = if not FFlagEnableNextUpImageLatencyTelemetry then nil else React.useCallback(function(b1: boolean) -- line: 122
		-- upvalues: t1 (copy)
		if b1 and t1.onTileImageLoaded then
			t1.onTileImageLoaded()
		end
	end, { t1.onTileImageLoaded })

	return React.createElement(View, {
		tag = "size-0-0 auto-y col gap-small align-x-center",
		LayoutOrder = t1.positionIndex
	}, {
		thumbnail = if not FFlagEnableNextUpImageLatencyTelemetry then nil else React.createElement(ImageOrSkeleton, {
			LayoutOrder = 1,
			tag = "radius-medium",
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Size = UDim2.fromScale(1, 0.5625),
			onActivated = onJoinGame,
			Image = if not t1.entryData then nil else t1.entryData.image,
			onImageStateChanged = v44
		}),
		thumbnailContainer = if FFlagEnableNextUpImageLatencyTelemetry then nil else React.createElement(View, {
			LayoutOrder = 1,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			Size = UDim2.fromScale(1, 0.5625),
			onActivated = onJoinGame
		}, {
			image = if not t1.entryData then React.createElement(Skeleton, {
				tag = "size-full-full radius-medium"
			}) else React.createElement(LoadableImage, {
				BackgroundTransparency = 1,
				useShimmerAnimationWhileLoading = true,
				showFailedStateWhenLoadingFailed = true,
				cornerRadius = UDim.new(0, v35.Radius.Medium),
				Image = t1.entryData.image,
				Size = UDim2.fromScale(1, 1)
			})
		}),
		titleContainer = React.createElement(View, {
			tag = "size-full-0 auto-y col",
			LayoutOrder = 2
		}, {
			title = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-no-wrap text-title-medium content-emphasis text-align-x-left text-truncate-end",
				LayoutOrder = 2,
				Text = not t1.entryData and "" or t1.entryData.name
			}),
			rating = if v16 then nil else React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-no-wrap text-body-medium content-default text-align-x-left",
				LayoutOrder = 3,
				Text = not t1.entryData and "" or v42.RatingText
			}),
			footer = if not v16 then nil else if not t1.entryData or not t1.entryData.isSponsored then React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-no-wrap text-body-medium content-default text-align-x-left",
				LayoutOrder = 3,
				Text = not t1.entryData and "" or v42.RatingText
			}) else React.createElement(v19, {
				LayoutOrder = 3
			})
		})
	})
end

return React.memo(NextUpTile)
