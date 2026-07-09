local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb
local useTokens = Foundation.Hooks.useTokens
local EnumsRadius = Foundation.Enums.Radius
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ThumbnailType = Foundation.Enums.ThumbnailType
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)
local IXPService = game:GetService("IXPService")
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local ContentProvider = game:GetService("ContentProvider")
local FStringSocialProfileCurrentlyPlayingLayer = require(ProfilePlatform.Flags.FStringSocialProfileCurrentlyPlayingLayer)
local FFlagProfileCurrentlyPlayingIXPEnabled = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingIXPEnabled)

local function CurrentlyPlaying(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), useProfileJsonComponent (copy), Enums (copy), useDispatch (copy), React (copy), NetworkingGames (copy), useSelector (copy), getDeepValue (copy), getRbxThumb (copy), ThumbnailType (copy), ThumbnailSize (copy), ContentProvider (copy), FFlagProfileCurrentlyPlayingIXPEnabled (copy), IXPService (copy), FStringSocialProfileCurrentlyPlayingLayer (copy), HorizontalPageMargin (copy), View (copy), FoundationImage (copy), Skeleton (copy), EnumsRadius (copy), FoundationText (copy)
	local v28 = useTokens()
	local v29 = useProfileJsonComponent(Enums.Components.CurrentlyPlaying)
	local v30 = useDispatch()
	local universeId = v29.universeId

	React.useEffect(function() -- line: 47
		-- upvalues: universeId (copy), v30 (copy), NetworkingGames (copy)
		if not universeId then
			return
		end

		v30(NetworkingGames.GetExperiencesDetails.API({ (tostring(universeId)) })):catch(function(p1) -- line: 51
			-- upvalues: universeId (copy)
			warn("CurrentlyPlaying: failed to fetch experience details for universeId", universeId, p1)
		end)
	end, {
		universeId,
		v30
	})

	local v32 = useSelector(function(p2) -- line: 56
		-- upvalues: getDeepValue (copy), universeId (copy)
		return getDeepValue(p2, `ProfilePlatform.Games.byGameId.{ tostring(universeId) }`)
	end)
	local v33 = v32 and v32.name or ""
	local v34 = if not universeId then nil else getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Small)
	local v35, v36 = React.useState(if not v34 then Enum.AssetFetchStatus.None else ContentProvider:GetAssetFetchStatus(v34))

	React.useEffect(function() -- line: 67
		-- upvalues: v34 (copy), ContentProvider (copy), v36 (copy)
		if not v34 then
			return
		end

		local connection = ContentProvider:GetAssetFetchStatusChangedSignal(v34):Connect(v36)

		return function() -- line: 73
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v34 })

	local v37 = getDeepValue(v29, "ageRecommendation.ageRecommendationSummary.ageRecommendation.displayNameWithHeaderShort")
	local v38 = v33 == nil or (v33 == "" or v35 == Enum.AssetFetchStatus.Loading)

	React.useEffect(function() -- line: 86
		-- upvalues: FFlagProfileCurrentlyPlayingIXPEnabled (copy), universeId (copy), IXPService (copy), FStringSocialProfileCurrentlyPlayingLayer (copy)
		if FFlagProfileCurrentlyPlayingIXPEnabled and universeId then
			IXPService:LogFlagLinkedUserLayerExposure(FStringSocialProfileCurrentlyPlayingLayer)
		end
	end, { universeId })

	if not universeId then
		return nil
	end

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		size = UDim2.new(1, 0, 0, 0),
		layoutOrder = t1.layoutOrder
	}, {
		Content = React.createElement(View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-shift-100"
		}, {
			GameThumbnail = if v38 then React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v28.Size.Size_1000, v28.Size.Size_1000),
				Radius = EnumsRadius.Small
			}) else React.createElement(FoundationImage, {
				tag = "radius-small aspect-1-1 size-1000-1000 auto-xy align-y-center",
				LayoutOrder = 1,
				Image = v34
			}),
			TextStack = React.createElement(View, {
				tag = "col align-y-center fill gap-xsmall auto-y content-default",
				LayoutOrder = 2
			}, {
				GameTitle = if v38 then React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.7, 0, 0, v28.Typography.TitleMedium.FontSize),
					Radius = EnumsRadius.Small
				}) else React.createElement(FoundationText, {
					tag = "emphasis size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end",
					LayoutOrder = 1,
					Text = v33
				}),
				AgeRecommendationText = if v38 then React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.5, 0, 0, v28.Typography.BodyMedium.FontSize),
					Radius = EnumsRadius.Small
				}) else React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
					LayoutOrder = 2,
					Text = v37
				})
			})
		})
	})
end

return CurrentlyPlaying
