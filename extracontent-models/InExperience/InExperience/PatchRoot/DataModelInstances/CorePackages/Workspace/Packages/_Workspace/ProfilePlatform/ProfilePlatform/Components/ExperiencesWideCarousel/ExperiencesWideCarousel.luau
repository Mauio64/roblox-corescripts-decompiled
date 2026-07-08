local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local IXPService = game:GetService("IXPService")
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local CollectionCarousel = require(ProfilePlatformParent.CollectionViews).CollectionCarousel
local CollectionHeader = require(ProfilePlatformParent.CollectionViews).CollectionHeader
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local getDeepValue = require(ProfilePlatform.Utils.getDeepValue)
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)
local useSendItemImpressions = require(ProfilePlatform.Hooks.useSendItemImpressions)
local formatExperienceDetailsForImpressions = require(ProfilePlatform.Hooks.formatExperienceDetailsForImpressions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Common.Types)

local useRoactService = require(ProfilePlatformParent.RobloxAppHooks).useRoactService
local RoactAnalyticsCommonGameEvents = require(ProfilePlatformParent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local OpenGameDetails = require(ProfilePlatformParent.GameDetail).OpenGameDetails
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local SetGameVotes = require(ProfilePlatformParent.GameVotesRodux).GameVotes.SetGameVotes
local Url = require(ProfilePlatformParent.Http).Url
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)
local GameTile = require(ProfilePlatformParent.GameTile)
local GameTileView = GameTile.GameTileView
local GameTileViewConfig = GameTile.GameTileViewConfig
local GameStats = GameTile.GameStats
local formatExperienceThumbnail = GameTile.formatExperienceThumbnail
local useDesignTokens = require(ProfilePlatformParent.Style).useDesignTokens
local useTextSizeOffset = require(ProfilePlatformParent.UIBlox).Core.Style.useTextSizeOffset
local ContentType = require(ProfilePlatformParent.UnifiedLogging).ContentType
local v37 = game:DefineFastFlag("ExperiencesOnProfileIxpEnabled", false)
local v38 = game:DefineFastString("ExperiencesOnProfileIxpLayer", "")
local t1 = {}

local function chunkList(t2: {[any]: any}, n1: number) -- line: 67
	local t3 = {}
	local n2 = 1

	while n2 <= #t2 do
		local t4 = {}

		for i = n2, math.min(n2 + n1 - 1, #t2) do
			table.insert(t4, t2[i])
		end

		table.insert(t3, t4)
		n2 += n1
	end

	return t3
end
local function formatVotePercent(n3: number?, n4: number?) -- line: 81
	local v52 = math.max(0, n3 or 0)
	local v53 = v52 + math.max(0, n4 or 0)

	if v53 == 0 then
		return nil
	end

	return tostring((math.floor(v52 / v53 * 100 + 0.5))) .. "%"
end
local function getGameVotes(p1, s1: string) -- line: 95
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/games/%s/votes", Url.GAME_URL, s1), "GET")
end
local function ExperiencesWideCarousel(t5: {[any]: any}) -- line: 104
	-- upvalues: useDynamicSizeMargin (copy), useDesignTokens (copy), useTextSizeOffset (copy), useLocalization (copy), TextKeys (copy), React (copy), useDispatch (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), ProfilePlatform (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), useNavigation (copy), useSelector (copy), getDeepValue (copy), useProfileJsonComponent (copy), Enums (copy), t1 (copy), chunkList (copy), NetworkingGames (copy), myRoduxNetworkingImpl (copy), Url (copy), SetGameVotes (copy), formatExperienceDetailsForImpressions (copy), useSendItemImpressions (copy), ContentType (copy), formatExperienceThumbnail (copy), GameStats (copy), GameTileView (copy), GameTileViewConfig (copy), AppPage (copy), OpenGameDetails (copy), v37 (copy), IXPService (copy), v38 (copy), CollectionHeader (copy), CollectionCarousel (copy)
	local v57, v58 = useDynamicSizeMargin()
	local v59 = useDesignTokens()
	local v60 = useTextSizeOffset()
	local v61 = useLocalization({
		title = TextKeys.Experiences
	})
	local v62, v63 = React.useState(0)
	local v64, v65 = React.useState(0)
	local v66, v67 = React.useState(0)
	local v68 = useDispatch()
	local v69 = useProfileWrapperContext()
	local v70 = v69 and v69.profileId
	local v71 = useProfileAnalyticsContext()
	local EventNames = require(ProfilePlatform.Analytics.EventNames)
	local v73 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v74 = useNavigation()
	local v75 = useSelector(function(p2) -- line: 123
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p2, "GameVotes") or {}
	end)
	local v76 = (useProfileJsonComponent(Enums.Components.Experiences) or {}).experiences or {}
	local v77 = React.useMemo(function() -- line: 129
		-- upvalues: v76 (copy)
		local t6 = {}

		for _, v in ipairs(v76) do
			if v.universeId ~= nil then
				table.insert(t6, (tostring(v.universeId)))
			end
		end

		return t6
	end, { v76 })

	React.useEffect(function() -- line: 139
		-- upvalues: v77 (copy)
		if #v77 == 0 then
			return
		end
	end, { v77 })

	local v78 = useSelector(function(p3) -- line: 145
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p3, "ProfilePlatform.Games.byGameId") or {}
	end)
	local v79 = React.useRef({
		key = "",
		at = 0
	})

	React.useEffect(function() -- line: 154
		-- upvalues: v77 (copy), v79 (copy), t1 (copy), v78 (copy), chunkList (copy), v68 (copy), NetworkingGames (copy), v75 (copy), myRoduxNetworkingImpl (copy), Url (copy), SetGameVotes (copy)
		if #v77 == 0 then
			return
		end

		local elapsed = os.clock()
		local v93 = table.concat(v77, ",")
		local current = v79.current

		if v93 == current.key and elapsed - current.at < 2 then
			return
		end

		v79.current = {
			key = v93,
			at = elapsed
		}

		local t7 = {}

		for _, v97 in v77 do
			if not t1[v97] and v78[v97] == nil then
				table.insert(t7, v97)
			end
		end

		for _, v99 in chunkList(t7, 10) do
			v68(NetworkingGames.GetExperiencesDetails.API(v99)):catch(function() -- line: 179
				-- upvalues: v99 (copy), t1 (copy)
				for _, v127 in v99 do
					t1[v127] = true
				end
			end)
		end

		for i = 1, math.min(6, #v77) do
			local v101 = v77[i]

			if v75[v101] == nil then
				myRoduxNetworkingImpl(string.format("%sv1/games/%s/votes", Url.GAME_URL, v101), "GET"):andThen(function(p4) -- line: 192
					-- upvalues: v68 (copy), SetGameVotes (copy), v101 (copy)
					local responseBody = p4.responseBody

					if responseBody ~= nil and (responseBody.upVotes ~= nil and responseBody.downVotes ~= nil) then
						v68(SetGameVotes(v101, if not (responseBody.upVotes < 0) then responseBody.upVotes else 0, if not (responseBody.downVotes < 0) then responseBody.downVotes else 0))
					end
				end):catch(function() -- line: 204
				end)
			end
		end
	end, {
		v77,
		v78,
		v75
	})

	local v80 = React.useMemo(function() -- line: 209
		-- upvalues: v77 (copy), v78 (copy)
		local t8 = {}

		for _, v104 in v77 do
			local v105 = v78[v104]

			if v105 then
				table.insert(t8, v105)
			end
		end

		return t8
	end, {
		v77,
		v78
	})
	local v81 = React.useMemo(function() -- line: 221
		-- upvalues: formatExperienceDetailsForImpressions (copy), v80 (copy)
		return formatExperienceDetailsForImpressions(v80)
	end, { v80 })
	local v82 = useSendItemImpressions(v81, 2, ContentType.Game, 1, "ExperiencesWideCarousel")
	local v83 = React.useCallback(function(s2: string, n5: number, n6: number?, s3: string?, n7: number?, n8: number?, n9: number?) -- line: 236
		-- upvalues: v71 (copy), EventNames (copy), v70 (copy)
		v71.fireAnalyticsEvent(EventNames.ExperienceOpened, {
			row = 1,
			section = "Experiences",
			layoutType = "Wide",
			profileUserId = v70,
			experienceId = s2,
			position = n5,
			ccu = n6 or 0,
			votePercentage = s3,
			upVotes = n7 or 0,
			downVotes = n8 or 0,
			visits = n9 or 0
		})
	end, {
		v71,
		v70
	})
	local v84 = React.useCallback(function(p5, n10: number, p6) -- line: 265
		-- upvalues: formatExperienceThumbnail (copy), React (copy), GameStats (copy), v75 (copy), GameTileView (copy), GameTileViewConfig (copy), v83 (copy), v80 (copy), v73 (copy), AppPage (copy), t5 (copy), v68 (copy), OpenGameDetails (copy), v74 (copy)
		local v116 = formatExperienceThumbnail(nil, p5.rootPlaceId)
		local v117 = React.createElement(GameStats, {
			isGridTile = true,
			gameTileLayoutType = "Wide",
			stats = {
				playerCount = p5.playing or 0,
				totalUpVotes = v75[p5.experienceId] and v75[p5.experienceId].upVotes or 0,
				totalDownVotes = v75[p5.experienceId] and v75[p5.experienceId].downVotes or 0
			}
		})

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = p6,
			LayoutOrder = n10
		}, {
			Tile = React.createElement(GameTileView, {
				isHovered = false,
				hidePlayButton = true,
				isContained = false,
				Size = UDim2.fromScale(1, 1),
				image = v116,
				title = p5.name,
				imageAspectRatio = GameTileViewConfig.getImageAspectRatio("Wide"),
				footerMetadata = v117,
				onActivated = function() -- line: 295
					-- upvalues: v75 (copy), p5 (copy), v83 (copy), n10 (copy), v80 (copy), v73 (copy), AppPage (copy), t5 (copy), v68 (copy), OpenGameDetails (copy), v74 (copy)
					local v130 = v75[p5.experienceId]
					local g136 = nil
					local v135 = nil

					if v130 then
						local upVotes = v130.upVotes
						local downVotes = v130.downVotes
						local v133 = math.max(0, upVotes or 0)
						local v134 = v133 + math.max(0, downVotes or 0)

						v135 = if v134 ~= 0 then tostring((math.floor(v133 / v134 * 100 + 0.5))) .. "%" else nil

						if v135 then
							g136 = true
						end
					end

					if not g136 then
						v135 = nil
					end

					g136 = false
					v83(p5.experienceId, n10, p5.playing, v135, v130 and v130.upVotes or 0, v130 and v130.downVotes or 0, 0)

					local v137 = #v80

					v73.reportOpenGameDetailFromProfile(p5.rootPlaceId, n10, v137, p5.experienceId, AppPage.ProfilePlatform, t5.layoutOrder, 1, nil)
					v68(OpenGameDetails(p5.experienceId, v74, {
						mountAsFullView = false,
						showBackButton = true
					}))
				end
			})
		}), "EXP_Tile"
	end, {
		v83,
		v62,
		v57,
		v68,
		v74,
		v73,
		t5.layoutOrder,
		v80,
		v75
	})
	local v85 = React.useCallback(function(n11: number) -- line: 347
		-- upvalues: v66 (copy), v67 (copy), GameTileViewConfig (copy), v59 (copy), v60 (copy)
		if n11 ~= v66 then
			v67(n11)
		end

		return (GameTileViewConfig.getTileHeight(v59, n11, "Wide", false, false, false, v60, nil, nil, nil, nil, nil))
	end, {
		v59,
		v60,
		v66
	})
	local v86 = React.useCallback(function(n12: number, n13: number) -- line: 369
		return (math.max(1, (math.max(0, n12 - n13 * 2) - 12) / 2))
	end, {})

	React.useEffect(function() -- line: 374
		-- upvalues: v62 (copy), v86 (copy), v57 (copy), v80 (copy), v65 (copy)
		if v62 <= 0 then
			return
		end

		local v121 = v86(v62, v57)
		local n14 = 0

		if #v80 > 2 then
			n14 = math.clamp(60 / (v121 + 12), 0, 0.5)
		end

		v65(n14)
	end, {
		v62,
		v57,
		v80,
		v86
	})
	React.useEffect(function() -- line: 389
		-- upvalues: v80 (copy), v82 (copy)
		if #v80 > 0 then
			local t9 = {}

			for i = 1, math.min(2, #v80) do
				table.insert(t9, i)
			end

			v82(t9)
		end
	end, {
		v80,
		v82
	})
	React.useEffect(function() -- line: 401
		-- upvalues: v80 (copy), v37 (copy), IXPService (copy), v38 (copy)
		if #v80 > 0 and v37 then
			IXPService:LogFlagLinkedUserLayerExposure(v38)
		end
	end, { v80 })

	if #v80 == 0 then
		return nil
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = t5.layoutOrder,
		[React.Change.AbsoluteSize] = function(p7) -- line: 417
			-- upvalues: v58 (copy), v63 (copy)
			v58(p7)
			v63(p7.AbsoluteSize.X)
		end
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		Header = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v57),
				PaddingRight = UDim.new(0, v57)
			}),
			Content = React.createElement(CollectionHeader, {
				LayoutOrder = 1,
				hideButton = true,
				title = v61.title
			})
		}),
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 2,
			title = nil,
			numColumns = 2,
			columnGap = 12,
			items = v80,
			renderItem = v84,
			getItemHeight = v85,
			fractionalItemAmount = #v80 > 2 and v64 or 0,
			sideMargin = v57
		})
	})
end

return React.memo(ExperiencesWideCarousel)
