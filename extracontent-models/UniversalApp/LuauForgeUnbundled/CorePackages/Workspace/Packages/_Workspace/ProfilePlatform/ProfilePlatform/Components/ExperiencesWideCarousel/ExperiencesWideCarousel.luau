local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local IXPService = game:GetService("IXPService")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local collectionCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews").CollectionCarousel
local collectionHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews").CollectionHeader
local useDynamicSizeMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local module7 = require("@luauforge/bundled/eXH")
local module8 = require("@luauforge/bundled/fdJ")
local useSendItemImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useSendItemImpressions")
local formatExperienceDetailsForImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/formatExperienceDetailsForImpressions")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useRoactService
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactServiceTags").RoactAnalyticsCommonGameEvents
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local openGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameDetail").OpenGameDetails
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local setGameVotes = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameVotesRodux").GameVotes.SetGameVotes
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http").Url

local myRoduxNetworkingImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworkingImpl")

local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameTile")
local gameTileView = GameTile.GameTileView
local gameTileViewConfig = GameTile.GameTileViewConfig
local gameStats = GameTile.GameStats
local formatExperienceThumbnail = GameTile.formatExperienceThumbnail

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Style").useDesignTokens
local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").Core.Style.useTextSizeOffset

local contentType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UnifiedLogging").ContentType

local defineFastFlag = game:DefineFastFlag("ExperiencesOnProfileIxpEnabled", false)
local defineFastString = game:DefineFastString("ExperiencesOnProfileIxpLayer", "")

local set = {}

local function chunkList(list, p2)
	local total = 1
	local result = {}

	while total <= #list do
		local v5 = {}

		for i = total, math.min(total + p2 - 1, #list) do
			table.insert(v5, list[i])
		end

		table.insert(result, v5)
		total += p2
	end

	return result
end

local function formatVotePercent(value, value2)
	local v5 = math.max(0, value or 0)
	local v6 = v5 + math.max(0, value2 or 0)

	if v6 == 0 then
		return nil
	end

	return tostring((math.floor(v5 / v6 * 100 + 0.5))) .. "%"
end

local function getGameVotes(callback, p2)
	return callback(string.format("%sv1/games/%s/votes", url.GAME_URL, p2), "GET")
end

local function ExperiencesWideCarousel(p2)
	local v5, v6 = useDynamicSizeMargin()
	local v7 = useDesignTokens()
	local v8 = useTextSizeOffset()
	local v9 = useLocalization({ title = TextKeys.Experiences })

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)

	local v10 = useDispatch()

	local v11 = useProfileWrapperContext()
	local profileId = v11 and v11.profileId
	local v12 = useProfileAnalyticsContext()
	local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
	local v13 = useRoactService(roactAnalyticsCommonGameEvents)
	local v14 = useNavigation()

	local v15 = useSelector(function(p3)
		return module7(p3, "GameVotes") or {}
	end)

	local experiences = (useProfileJsonComponent(Enums.Components.Experiences) or {}).experiences or {}

	local v16 = React.useMemo(function()
		local universeIds = {}

		for i, experience in ipairs(experiences) do
			if experience.universeId ~= nil then
				table.insert(universeIds, (tostring(experience.universeId)))
			end
		end

		return universeIds
	end, { experiences })

	React.useEffect(function()
		if #v16 == 0 then
		end
	end, { v16 })

	local v17 = useSelector(function(p3)
		return module7(p3, "ProfilePlatform.Games.byGameId") or {}
	end)

	local ref = React.useRef({ key = "", at = 0 })

	React.useEffect(function()
		if #v16 == 0 then
			return
		end

		local now = os.clock()
		local joined = table.concat(v16, ",")
		local current = ref.current

		if joined == current.key and now - current.at < 2 then
			return
		end

		ref.current = { key = joined, at = now }

		local v18 = {}

		for k, v19 in v16 do
			if set[v19] or v17[v19] ~= nil then
				continue
			end

			table.insert(v18, v19)
		end

		for k, v19 in chunkList(v18, 10) do
			v10(module8.GetExperiencesDetails.API(v19)):catch(function()
				for k2, v20 in v19 do
					set[v20] = true
				end
			end)
		end

		for i = 1, math.min(6, #v16) do
			local v19 = v16[i]

			if v15[v19] == nil then
				myRoduxNetworkingImpl(string.format("%sv1/games/%s/votes", url.GAME_URL, v19), "GET"):andThen(function(p3)
					local responseBody = p3.responseBody

					if
						responseBody ~= nil
						and responseBody.upVotes ~= nil
						and responseBody.downVotes ~= nil
					then
						v10(setGameVotes(
							v19,
							responseBody.upVotes < 0 and 0 or responseBody.upVotes,
							responseBody.downVotes < 0 and 0 or responseBody.downVotes
						))
					end
				end):catch(function() end)
			end
		end
	end, { v16, v17, v15 })

	local v18 = React.useMemo(function()
		local result = {}

		for k, v19 in v16 do
			local v20 = v17[v19]

			if v20 then
				table.insert(result, v20)
			end
		end

		return result
	end, { v16, v17 })

	local v20 = useSendItemImpressions(React.useMemo(function()
		return formatExperienceDetailsForImpressions(v18)
	end, { v18 }), 2, contentType.Game, 1, "ExperiencesWideCarousel")

	local v21 = React.useCallback(function(p3, p4, value, p5, value2, value3, value4)
		v12.fireAnalyticsEvent(EventNames.ExperienceOpened, {
			profileUserId = profileId,
			experienceId = p3,
			position = p4,
			row = 1,
			ccu = value or 0,
			votePercentage = p5,
			upVotes = value2 or 0,
			downVotes = value3 or 0,
			visits = value4 or 0,
			section = "Experiences",
			layoutType = "Wide"
		})
	end, { v12, profileId })

	local v22 = React.useCallback(function(props, p3, p4)
		local v23 = formatExperienceThumbnail(nil, props.rootPlaceId)

		local element = React.createElement(gameStats, {
			stats = {
				playerCount = props.playing or 0,
				totalUpVotes = v15[props.experienceId] and v15[props.experienceId].upVotes or 0,
				totalDownVotes = v15[props.experienceId] and v15[props.experienceId].downVotes or 0
			},
			isGridTile = true,
			gameTileLayoutType = "Wide"
		})

		return React.createElement("Frame", {
			Size = p4,
			BackgroundTransparency = 1,
			LayoutOrder = p3
		}, {
			Tile = React.createElement(gameTileView, {
				Size = UDim2.fromScale(1, 1),
				image = v23,
				title = props.name,
				imageAspectRatio = gameTileViewConfig.getImageAspectRatio("Wide"),
				footerMetadata = element,
				isHovered = false,
				onActivated = function()
					local v24 = v15[props.experienceId]
					local v25

					if v24 then
						local upVotes = v24.upVotes
						local downVotes = v24.downVotes
						local v26 = math.max(0, upVotes or 0)
						local v27 = v26 + math.max(0, downVotes or 0)

						v25 = (if v27 ~= 0 then tostring((math.floor(v26 / v27 * 100 + 0.5))) .. "%" else nil)
							or nil
					end

					v21(
						props.experienceId,
						p3,
						props.playing,
						v25,
						v24 and v24.upVotes or 0,
						v24 and v24.downVotes or 0,
						0
					)

					local v26 = #v18
					v13.reportOpenGameDetailFromProfile(
						props.rootPlaceId,
						p3,
						v26,
						props.experienceId,
						appPage.ProfilePlatform,
						p2.layoutOrder,
						1,
						nil
					)

					v10(openGameDetails(props.experienceId, v14, {
						mountAsFullView = false,
						showBackButton = true
					}))
				end,
				hidePlayButton = true,
				isContained = false
			})
		}), "EXP_Tile"
	end, {
		v21,
		state,
		v5,
		v10,
		v14,
		v13,
		p2.layoutOrder,
		v18,
		v15
	})

	local v23 = React.useCallback(function(p3)
		if state3 ~= p3 then
			setState3(p3)
		end

		return (gameTileViewConfig.getTileHeight(
			v7,
			p3,
			"Wide",
			false,
			false,
			false,
			v8,
			nil,
			nil,
			nil,
			nil,
			nil
		))
	end, { v7, v8, state3 })

	local v24 = React.useCallback(function(p3, p4)
		return (math.max(1, (math.max(0, p3 - p4 * 2) - 12) / 2))
	end, {})

	React.useEffect(function()
		if state <= 0 then
			return
		end

		local v25 = v24(state, v5)

		setState2(not (#v18 > 2) and 0 or math.clamp(60 / (v25 + 12), 0, 0.5))
	end, { state, v5, v18, v24 })

	React.useEffect(function()
		if #v18 > 0 then
			local v25 = {}

			for i = 1, math.min(2, #v18) do
				table.insert(v25, i)
			end

			v20(v25)
		end
	end, { v18, v20 })

	React.useEffect(function()
		if #v18 > 0 and defineFastFlag then
			IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
		end
	end, { v18 })

	if #v18 == 0 then
		return nil
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = p2.layoutOrder,
		[React.Change.AbsoluteSize] = function(p3)
			v6(p3)
			setState(p3.AbsoluteSize.X)
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
					PaddingLeft = UDim.new(0, v5),
					PaddingRight = UDim.new(0, v5)
				}),
				Content = React.createElement(collectionHeader, {
					LayoutOrder = 1,
					title = v9.title,
					hideButton = true
				})
			}
		),
		CollectionCarousel = React.createElement(collectionCarousel, {
			LayoutOrder = 2,
			title = nil,
			items = v18,
			renderItem = v22,
			getItemHeight = v23,
			numColumns = 2,
			fractionalItemAmount = #v18 > 2 and state2 or 0,
			columnGap = 12,
			sideMargin = v5
		})
	})
end

return React.memo(ExperiencesWideCarousel)
