local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local IXPService = game:GetService("IXPService")
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local CollectionViews = require(parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local CollectionViews2 = require(parent.CollectionViews)
local CollectionHeader = CollectionViews2.CollectionHeader
local useDynamicSizeMargin = require(ProfilePlatform.Hooks.useDynamicSizeMargin)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
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
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local GameDetail = require(parent.GameDetail)
local OpenGameDetails = GameDetail.OpenGameDetails
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local GameVotesRodux = require(parent.GameVotesRodux)
local SetGameVotes = GameVotesRodux.GameVotes.SetGameVotes
local Http = require(parent.Http)
local Url = Http.Url

local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)

local GameTile = require(parent.GameTile)
local GameTileView = GameTile.GameTileView
local GameTileViewConfig = GameTile.GameTileViewConfig
local GameStats = GameTile.GameStats
local formatExperienceThumbnail = GameTile.formatExperienceThumbnail

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local UnifiedLogging = require(parent.UnifiedLogging)
local ContentType = UnifiedLogging.ContentType

local defineFastFlag = game:DefineFastFlag("ExperiencesOnProfileIxpEnabled", false)
local defineFastString = game:DefineFastString("ExperiencesOnProfileIxpLayer", "")

local set = {}

local function chunkList(list, p: number)
	local total = 1
	local result = {}

	while total <= #list do
		local v = {}

		for i = total, math.min(total + p - 1, #list) do
			table.insert(v, list[i])
		end

		table.insert(result, v)
		total += p
	end

	return result
end

local function formatVotePercent(upVotes: number?, downVotes: number?) -- 1 equivalent call inferred from this helper
	local v = math.max(0, upVotes or 0)
	local v2 = v + math.max(0, downVotes or 0)

	if v2 == 0 then
		return nil
	end

	return tostring((math.floor(v / v2 * 100 + 0.5))) .. "%"
end

local function getGameVotes(myRoduxNetworkingImpl2, p: string) -- 1 equivalent call inferred from this helper
	return myRoduxNetworkingImpl2(string.format("%sv1/games/%s/votes", Url.GAME_URL, p), "GET")
end

local function ExperiencesWideCarousel(p)
	local sideMargin, v = useDynamicSizeMargin()
	local v2 = useDesignTokens()
	local v3 = useTextSizeOffset()
	local v4 = useLocalization({ title = TextKeys.Experiences })

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)

	local v5 = useDispatch()

	local v6 = useProfileWrapperContext()
	local profileId = v6 and v6.profileId
	local v7 = useProfileAnalyticsContext()
	local EventNames = require(ProfilePlatform.Analytics.EventNames)
	local v8 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v9 = useNavigation()

	local v10 = useSelector(function(p2)
		return getDeepValue(p2, "GameVotes") or {}
	end)

	local experiences = (useProfileJsonComponent(Enums.Components.Experiences) or {}).experiences or {}

	local v11 = React.useMemo(function()
		local universeIds = {}

		for _, experience in ipairs(experiences) do
			if experience.universeId ~= nil then
				table.insert(universeIds, (tostring(experience.universeId)))
			end
		end

		return universeIds
	end, { experiences })

	React.useEffect(function()
		if #v11 == 0 then
		end
	end, { v11 })

	local v12 = useSelector(function(p2)
		return getDeepValue(p2, "ProfilePlatform.Games.byGameId") or {}
	end)

	local ref = React.useRef({ key = "", at = 0 })

	React.useEffect(function()
		if #v11 == 0 then
			return
		end

		local now = os.clock()
		local joined = table.concat(v11, ",")
		local current = ref.current

		if joined == current.key and now - current.at < 2 then
			return
		end

		ref.current = { key = joined, at = now }

		local v13 = {}

		for _, v14 in v11 do
			if set[v14] or v12[v14] ~= nil then
				continue
			end

			table.insert(v13, v14)
		end

		for _, v14 in chunkList(v13, 10) do
			v5(NetworkingGames.GetExperiencesDetails.API(v14)):catch(function()
				for _, v15 in v14 do
					set[v15] = true
				end
			end)
		end

		for i = 1, math.min(6, #v11) do
			local v14 = v11[i]

			if v10[v14] == nil then
				getGameVotes(myRoduxNetworkingImpl, v14):andThen(function(p2) -- inferred equivalent call
					local responseBody = p2.responseBody

					if responseBody ~= nil and responseBody.upVotes ~= nil and responseBody.downVotes ~= nil then
						v5(SetGameVotes(
							v14,
							responseBody.upVotes < 0 and 0 or responseBody.upVotes,
							responseBody.downVotes < 0 and 0 or responseBody.downVotes
						))
					end
				end):catch(function() end)
			end
		end
	end, { v11, v12, v10 })

	local items = React.useMemo(function()
		local result = {}

		for _, v13 in v11 do
			local v14 = v12[v13]

			if v14 then
				table.insert(result, v14)
			end
		end

		return result
	end, { v11, v12 })

	local v13 = useSendItemImpressions(React.useMemo(function()
		return formatExperienceDetailsForImpressions(items)
	end, { items }), 2, ContentType.Game, 1, "ExperiencesWideCarousel")

	local v14 = React.useCallback(
		function(experienceId: string, position: number, value: number?, votePercentage: string?, value2: number?, value3: number?, value4: number?)
			v7.fireAnalyticsEvent(EventNames.ExperienceOpened, {
				profileUserId = profileId,
				experienceId = experienceId,
				position = position,
				row = 1,
				ccu = value or 0,
				votePercentage = votePercentage,
				upVotes = value2 or 0,
				downVotes = value3 or 0,
				visits = value4 or 0,
				section = "Experiences",
				layoutType = "Wide"
			})
		end,
		{ v7, profileId }
	)

	local renderItem = React.useCallback(function(props, layoutOrder: number, size)
		local image = formatExperienceThumbnail(nil, props.rootPlaceId)

		local element = React.createElement(GameStats, {
			stats = {
				playerCount = props.playing or 0,
				totalUpVotes = v10[props.experienceId] and v10[props.experienceId].upVotes or 0,
				totalDownVotes = v10[props.experienceId] and v10[props.experienceId].downVotes or 0
			},
			isGridTile = true,
			gameTileLayoutType = "Wide"
		})

		return React.createElement("Frame", {
			Size = size,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		}, {
			Tile = React.createElement(GameTileView, {
				Size = UDim2.fromScale(1, 1),
				image = image,
				title = props.name,
				imageAspectRatio = GameTileViewConfig.getImageAspectRatio("Wide"),
				footerMetadata = element,
				isHovered = false,
				onActivated = function()
					local v15 = v10[props.experienceId]
					local v16

					if v15 then
						v16 = formatVotePercent(v15.upVotes, v15.downVotes) or nil -- inferred equivalent call
					end

					v14(
						props.experienceId,
						layoutOrder,
						props.playing,
						v16,
						v15 and v15.upVotes or 0,
						v15 and v15.downVotes or 0,
						0
					)

					local v17 = #items
					v8.reportOpenGameDetailFromProfile(
						props.rootPlaceId,
						layoutOrder,
						v17,
						props.experienceId,
						AppPage.ProfilePlatform,
						p.layoutOrder,
						1,
						nil
					)

					v5(OpenGameDetails(props.experienceId, v9, {
						mountAsFullView = false,
						showBackButton = true
					}))
				end,
				hidePlayButton = true,
				isContained = false
			})
		}), "EXP_Tile"
	end, {
		v14,
		state,
		sideMargin,
		v5,
		v9,
		v8,
		p.layoutOrder,
		items,
		v10
	})

	local getItemHeight = React.useCallback(function(p2: number)
		if state3 ~= p2 then
			setState3(p2)
		end

		return (GameTileViewConfig.getTileHeight(v2, p2, "Wide", false, false, false, v3, nil, nil, nil, nil, nil))
	end, { v2, v3, state3 })

	local v15 = React.useCallback(function(p2: number, p3: number)
		return (math.max(1, (math.max(0, p2 - p3 * 2) - 12) / 2))
	end, {})

	React.useEffect(function()
		if state <= 0 then
			return
		end

		local v16 = v15(state, sideMargin)

		setState2(not (#items > 2) and 0 or math.clamp(60 / (v16 + 12), 0, 0.5))
	end, { state, sideMargin, items, v15 })

	React.useEffect(function()
		if #items > 0 then
			local v16 = {}

			for i = 1, math.min(2, #items) do
				table.insert(v16, i)
			end

			v13(v16)
		end
	end, { items, v13 })

	React.useEffect(function()
		if #items > 0 and defineFastFlag then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, { items })

	if #items == 0 then
		return nil
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p.layoutOrder,
		[React.Change.AbsoluteSize] = function(p2)
			v(p2)
			setState(p2.AbsoluteSize.X)
		end
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16)
		}),
		Header = React.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, sideMargin),
					PaddingRight = UDim.new(0, sideMargin)
				}),
				Content = React.createElement(CollectionHeader, {
					LayoutOrder = 1,
					title = v4.title,
					hideButton = true
				})
			}
		),
		CollectionCarousel = React.createElement(CollectionCarousel, {
			LayoutOrder = 2,
			title = nil,
			items = items,
			renderItem = renderItem,
			getItemHeight = getItemHeight,
			numColumns = 2,
			fractionalItemAmount = #items > 2 and state2 or 0,
			columnGap = 12,
			sideMargin = sideMargin
		})
	})
end

return React.memo(ExperiencesWideCarousel)
