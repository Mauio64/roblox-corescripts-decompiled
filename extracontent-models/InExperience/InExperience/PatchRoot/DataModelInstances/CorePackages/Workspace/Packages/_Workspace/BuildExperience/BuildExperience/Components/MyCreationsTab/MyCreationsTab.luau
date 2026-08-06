local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local Players = game:GetService("Players")
local v5 = game:DefineFastInt("MyCreationsSessionListPollingIntervalSeconds", 60)
local Foundation = require(BuildExperienceParent.Foundation)
local LuaSocialLibrariesDeps = require(BuildExperienceParent.LuaSocialLibrariesDeps)
local Promise = require(BuildExperienceParent.Promise)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local Badge = Foundation.Badge
local PrivacyType = UniverseConfiguration.PrivacyType
local List = Foundation.List
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local RefreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame
local BadgeShape = Foundation.Enums.BadgeShape
local BadgeSize = Foundation.Enums.BadgeSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local BuildEmptyState = require(script.Parent.Parent.BuildEmptyState.BuildEmptyState)
local ContentMaturityUtils = require(script.Parent.Parent.Parent.utils.ContentMaturityUtils)
local matchesSearchQuery = require(script.Parent.Parent.Parent.utils.matchesSearchQuery)
local chatConstants = require(script.Parent.Parent.Parent.Chat.chatConstants)

require(script.Parent.Parent.Parent.Chat.chatTypes)

local GetBuildExperienceRefreshStore = require(script.Parent.Parent.Parent.Stores.GetBuildExperienceRefreshStore)
local GetSearchQueryStore = require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore)

require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)

local FFlagEnableBuildExperienceScrollPerformanceTracking = require(script.Parent.Parent.Parent.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)
local v37 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(script.Parent.Parent.Parent.Telemetry.useScrollPerformanceTracker)
local useSignalState = SignalsReact.useSignalState
local t1 = {}
local t2 = {
	waiting_on_client = LocalizationStrings.MY_CREATIONS_INPUT_NEEDED,
	idle = LocalizationStrings.MY_CREATIONS_READY,
	working = LocalizationStrings.MY_CREATIONS_BUILDING
}

local function thumbForUniverseId(n1: number) -- line: 101
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", n1)
end
local function privacyLabelForSummary(p1, b1: boolean?) -- line: 105
	-- upvalues: FFlagBuildRehydrateOnPublish (copy), PrivacyType (copy), LocalizationStrings (copy)
	if FFlagBuildRehydrateOnPublish and (p1.isActive == true and p1.privacyType == PrivacyType.Public) then
		if b1 == nil then
			return nil
		end

		if b1 then
			return LocalizationStrings.MY_CREATIONS_PUBLICLY_UNAVAILABLE
		end
	end

	if p1.privacyType == PrivacyType.Public then
		return LocalizationStrings.MY_CREATIONS_PUBLIC
	end

	if p1.privacyType == PrivacyType.FriendsOnly then
		return LocalizationStrings.MY_CREATIONS_RESTRICTED
	end

	return LocalizationStrings.MY_CREATIONS_PRIVATE
end
local function descriptionForSessionStatus(p2) -- line: 124
	-- upvalues: t2 (copy)
	local v54 = p2._meta and p2._meta._roblox
	local v55 = if not v54 then nil else v54.sessionStatus

	if v55 == nil then
		return nil
	end

	return t2[v55]
end
local function requestHandleToPromise(p3) -- line: 133
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, reject) -- line: 134
		-- upvalues: p3 (copy)
		task.spawn(function() -- line: 135
			-- upvalues: p3 (copy), resolve (copy), reject (copy)
			while p3.state(false).status == "pending" do
				task.wait()
			end

			local v154 = p3.state(false)

			if v154.status == "succeeded" then
				resolve(v154.result)

				return
			end

			reject(v154.error)
		end)
	end)
end
local function getSessionUniverseId(p4) -- line: 150
	local v58 = p4._meta and p4._meta._roblox

	if v58 == nil then
		return nil
	end

	local universeId = v58.universeId

	if typeof(universeId) ~= "number" or universeId == 0 then
		return nil
	end

	return universeId
end
local function buildExperienceMetadataByUniverseId(t3: {[any]: any}, t4: {[any]: any}) -- line: 162
	-- upvalues: FFlagBuildRehydrateOnPublish (copy), PrivacyType (copy), LocalizationStrings (copy)
	local t5 = {}

	for v63, v64 in t3 do
		local name = v64.name

		if typeof(name) == "string" and name ~= "" and not v64.isArchived then
			local creatorName = v64.creatorName
			local t6 = {
				placeId = v64.rootPlaceId,
				experienceName = name,
				creatorName = if typeof(creatorName) ~= "string" or creatorName == "" then nil else creatorName
			}
			local v68 = t4[v63]

			t6.visibilityLabel = if not FFlagBuildRehydrateOnPublish or (v64.isActive ~= true or v64.privacyType ~= PrivacyType.Public) then if v64.privacyType ~= PrivacyType.Public then if v64.privacyType ~= PrivacyType.FriendsOnly then LocalizationStrings.MY_CREATIONS_PRIVATE else LocalizationStrings.MY_CREATIONS_RESTRICTED else LocalizationStrings.MY_CREATIONS_PUBLIC else if v68 ~= nil then if not v68 then if v64.privacyType ~= PrivacyType.Public then if v64.privacyType ~= PrivacyType.FriendsOnly then LocalizationStrings.MY_CREATIONS_PRIVATE else LocalizationStrings.MY_CREATIONS_RESTRICTED else LocalizationStrings.MY_CREATIONS_PUBLIC else LocalizationStrings.MY_CREATIONS_PUBLICLY_UNAVAILABLE else nil
			t6.gameIcon = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v63)
			t5[v63] = t6
		end
	end

	return t5
end
local function buildSessionItems(t7: {[any]: any}, t8: {[any]: any}?) -- line: 184
	-- upvalues: LocalizationStrings (copy), t2 (copy)
	local t9 = {}
	local t10 = {}

	for _, v74 in t7 do
		local sessionId = v74.sessionId
		local v76 = v74._meta and v74._meta._roblox
		local v77

		if v76 == nil then
			v77 = nil
		else
			local universeId = v76.universeId

			v77 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
		end

		if typeof(sessionId) == "string" and sessionId ~= "" and v77 ~= nil and not t9[v77] then
			t9[v77] = true

			local v79 = if not t8 then nil else t8[v77]
			local v80 = if not v79 then v74.title or LocalizationStrings.formatMyCreationsUniverseName(v77) else v79.experienceName
			local t11 = {
				sessionId = sessionId,
				universeId = v77,
				placeId = if not v79 then nil else v79.placeId,
				experienceName = v80,
				creatorName = if not v79 then nil else v79.creatorName
			}
			local v82 = v74._meta and v74._meta._roblox
			local v83 = if not v82 then nil else v82.sessionStatus

			t11.description = if v83 ~= nil then t2[v83] else nil
			t11.visibilityLabel = if not v79 then LocalizationStrings.MY_CREATIONS_PRIVATE else v79.visibilityLabel
			t11.gameIcon = if not v79 then string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v77) else v79.gameIcon
			table.insert(t10, t11)
		end
	end

	return t10
end
local function renderLoadingExperienceSkeleton(n2: number, n3: number, p5) -- line: 223
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-medium",
		LayoutOrder = n3,
		Size = UDim2.new(1, 0, 0, p5.Size.Size_2000),
		testId = `MyCreationsTab.LoadingSkeleton.{ n2 }`
	}, {
		ThumbnailContainer = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(p5.Size.Size_1400, p5.Size.Size_1400)
		}, {
			Thumbnail = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = EnumsRadius.Medium
			})
		}),
		Details = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col fill gap-small size-full-0 auto-y"
		}, {
			Title = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.72, 0, 0, p5.Size.Size_400),
				radius = EnumsRadius.Small
			}),
			Description = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.44, 0, 0, p5.Size.Size_250),
				radius = EnumsRadius.Small
			})
		})
	})
end
local function MyCreationsTab(t12: {[any]: any}) -- line: 261
	-- upvalues: CreatorAgentChat (copy), FFlagBuildRehydrateOnPublish (copy), UniverseActivation (copy), UniverseConfiguration (copy), GetSearchQueryStore (copy), GetBuildExperienceRefreshStore (copy), AppLifecycleObserverService (copy), useTokens (copy), React (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v37 (copy), useSignalState (copy), requestHandleToPromise (copy), Signals (copy), v5 (copy), PrivacyType (copy), ContentMaturityUtils (copy), t1 (copy), buildExperienceMetadataByUniverseId (copy), buildSessionItems (copy), chatConstants (copy), Players (copy), Promise (copy), renderLoadingExperienceSkeleton (copy), matchesSearchQuery (copy), View (copy), List (copy), InputSize (copy), IconName (copy), LocalizationStrings (copy), BuildEmptyState (copy), Badge (copy), BadgeShape (copy), BadgeSize (copy), BadgeVariant (copy), RefreshScrollingFrame (copy)
	local v88 = t12.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()
	local v89 = if not FFlagBuildRehydrateOnPublish then nil else UniverseActivation.getUniverseActivationStore()
	local v90 = t12.configurationStore or UniverseConfiguration.getUniverseConfigurationStore()
	local v91 = t12.searchQueryStore or GetSearchQueryStore()
	local v92 = GetBuildExperienceRefreshStore()
	local v93 = t12.appLifecycleObserverService or AppLifecycleObserverService
	local v94 = t12.isFocused ~= false
	local v95 = useTokens()
	local v96 = React.useRef(nil)
	local v97 = React.useRef(false)
	local v98, v99 = React.useState(false)

	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v37("LuaApp_Build_Home_Scroll", v96)
	end

	local v100 = v91.useDebouncedQuery()
	local v101 = useSignalState(v92.getRefreshTick)
	local v102 = v88.getSessionListStore()
	local v103 = useSignalState(v102.getSessions)
	local v104 = useSignalState(v102.getNextPageToken)
	local v105 = useSignalState(v102.getStatus)
	local v106 = useSignalState(v102.getLoadMoreStatus)
	local v107 = if v105 ~= "pending" then v105 ~= "succeeded" and "Failed" or "Ready" else "NotReady"
	local v108 = React.useCallback(function() -- line: 293
		-- upvalues: requestHandleToPromise (copy), v102 (copy)
		return requestHandleToPromise(v102.refresh())
	end, { v102 })

	React.useEffect(function() -- line: 297
		-- upvalues: v93 (copy), v94 (copy), v102 (copy)
		local connection = v93.OnUnhide:Connect(function() -- line: 298
			-- upvalues: v94 (copy), v102 (copy)
			if v94 then
				v102.refresh()
			end
		end)

		return function() -- line: 304
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v93,
		v94,
		v102
	})
	React.useEffect(function() -- line: 309
		-- upvalues: v94 (copy), v99 (copy), v102 (copy), Signals (copy)
		if not v94 then
			v99(false)

			return
		end

		v99(false)

		local v135 = v102.refresh()

		return Signals.createEffect(function(p6) -- line: 317
			-- upvalues: v135 (copy), v99 (copy)
			if v135.state(p6).status == "succeeded" then
				v99(true)
			end
		end)
	end, {
		v94,
		v101,
		v102
	})

	local v109 = math.max(0, t12.pollingIntervalSeconds or v5)

	React.useEffect(function() -- line: 326
		-- upvalues: v94 (copy), v109 (copy), v102 (copy)
		if not v94 or v109 == 0 then
			return
		end

		local u136 = false

		local function scheduleNextPoll() -- line: 332
			-- upvalues: v109 (copy), u136 (ref), v102 (copy), scheduleNextPoll (copy)
			task.delay(v109, function() -- line: 333
				-- upvalues: u136 (ref), v102 (copy), scheduleNextPoll (copy)
				if u136 then
					return
				end

				v102.refresh()
				scheduleNextPoll()
			end)
		end

		task.delay(v109, function() -- line: 333
			-- upvalues: u136 (ref), v102 (copy), scheduleNextPoll (copy)
			if u136 then
				return
			end

			v102.refresh()
			scheduleNextPoll()
		end)

		return function() -- line: 343
			-- upvalues: u136 (ref)
			u136 = true
		end
	end, {
		v94,
		v109,
		v102
	})

	local v110 = React.useMemo(function() -- line: 348
		-- upvalues: Signals (copy), v103 (copy), v90 (copy)
		return Signals.createComputed(function(p7) -- line: 349
			-- upvalues: v103 (copy), v90 (copy)
			local t13 = {}
			local t14 = {}

			for _, v160 in v103 do
				local v161 = v160._meta and v160._meta._roblox
				local v162

				if v161 == nil then
					v162 = nil
				else
					local universeId = v161.universeId

					v162 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
				end

				if v162 ~= nil and not t14[v162] then
					t14[v162] = true

					local v164 = v90.getAndFetchSummary(v162).data(p7)

					if v164 ~= nil then
						t13[v162] = v164
					end
				end
			end

			return t13
		end)
	end, {
		v90,
		v103
	})
	local v111 = useSignalState(v110)
	local v112 = React.useMemo(function() -- line: 368
		-- upvalues: Signals (copy), FFlagBuildRehydrateOnPublish (copy), v89 (copy), v111 (copy), PrivacyType (copy), ContentMaturityUtils (copy), t1 (copy)
		return Signals.createComputed(function(p8) -- line: 369
			-- upvalues: FFlagBuildRehydrateOnPublish (copy), v89 (copy), v111 (copy), PrivacyType (copy), ContentMaturityUtils (copy), t1 (copy)
			local t15 = {}

			if FFlagBuildRehydrateOnPublish and v89 ~= nil then
				for v167, v168 in v111 do
					if v168.isActive == true and v168.privacyType == PrivacyType.Public and v89.getAndFetchEligibility(v167).data(p8) ~= nil then
						t15[v167] = ContentMaturityUtils.isSealBroken(v167) and ContentMaturityUtils.isContentUnrated(v167)
					end
				end
			end

			if next(t15) == nil then
				return t1
			end

			return t15
		end)
	end, {
		v89,
		v111
	})
	local v113 = useSignalState(v112)
	local v114 = React.useMemo(function() -- line: 391
		-- upvalues: buildExperienceMetadataByUniverseId (copy), v111 (copy), v113 (copy)
		return (buildExperienceMetadataByUniverseId(v111, v113))
	end, {
		v113,
		v111
	})
	local v115 = React.useMemo(function() -- line: 394
		-- upvalues: buildSessionItems (copy), v103 (copy), v114 (copy), v111 (copy)
		local t16 = {}

		for _, v140 in (buildSessionItems(v103, v114)) do
			local v141 = v111[v140.universeId]

			if v141 ~= nil and not v141.isArchived then
				table.insert(t16, v140)
			end
		end

		return t16
	end, {
		v103,
		v114,
		v111
	})
	local v116 = React.useMemo(function() -- line: 405
		-- upvalues: v103 (copy), v111 (copy)
		local t17 = {}

		for _, v144 in v103 do
			local v145 = v144._meta and v144._meta._roblox
			local v146

			if v145 == nil then
				v146 = nil
			else
				local universeId = v145.universeId

				v146 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
			end

			if v146 == nil or t17[v146] then
				continue
			end

			t17[v146] = true

			if v111[v146] == nil then
				return true
			end
		end

		return false
	end, {
		v103,
		v111
	})
	local v117 = v107 == "Ready" or #v103 > 0
	local v118 = v106 == "pending"
	local v119 = React.useCallback(function() -- line: 421
		-- upvalues: v97 (copy), t12 (copy), chatConstants (copy), Players (copy)
		v97.current = true
		t12.onOpenChat({
			isNewGameTarget = true,
			experienceName = chatConstants.BUILD_CHAT_PAGE_TITLE,
			creatorName = if not Players.LocalPlayer then nil else Players.LocalPlayer.Name
		})
	end, { t12.onOpenChat })

	React.useEffect(function() -- line: 431
		-- upvalues: t12 (copy), v94 (copy), v98 (copy), v107 (copy), v103 (copy), v97 (copy), v119 (copy)
		if t12.autoOpenNewGame ~= false and (v94 and v98 and v107 == "Ready" and #v103 == 0 and not v97.current) then
			v119()
		end
	end, {
		v119,
		v98,
		v94,
		t12.autoOpenNewGame,
		v103,
		v107
	})

	local v120 = React.useCallback(function() -- line: 453
		-- upvalues: v102 (copy), Promise (copy), requestHandleToPromise (copy)
		local v148 = v102.loadMore()

		if v148 == nil then
			return Promise.resolve()
		end

		return requestHandleToPromise(v148)
	end, {
		v118,
		v104,
		v107,
		v102
	})
	local v121 = React.useCallback(function(p9) -- line: 461
		-- upvalues: v104 (copy), v118 (copy), v107 (copy), v120 (copy)
		local AbsoluteCanvasSizeY = p9.AbsoluteCanvasSize.Y

		if v104 == nil or (v118 or v107 ~= "Ready" or p9.CanvasPosition.Y <= 0 or AbsoluteCanvasSizeY <= 0 or p9.AbsoluteWindowSize.Y <= 0) then
			return
		end

		if math.max(0, AbsoluteCanvasSizeY - p9.AbsoluteWindowSize.Y - 250) < p9.CanvasPosition.Y then
			v120()
		end
	end, {
		v118,
		v120,
		v104,
		v107
	})
	local v122 = React.useCallback(function() -- line: 480
		-- upvalues: v118 (copy), renderLoadingExperienceSkeleton (copy), v95 (copy)
		if not v118 then
			return nil
		end

		return renderLoadingExperienceSkeleton(1, 1, v95)
	end, {
		v118,
		v95
	})
	local v123 = React.useMemo(function() -- line: 488
		-- upvalues: v100 (copy), v115 (copy), matchesSearchQuery (copy)
		if v100 == "" then
			return v115
		end

		local t18 = {}

		for _, v153 in v115 do
			if matchesSearchQuery(v153.experienceName, v100) then
				table.insert(t18, v153)
			end
		end

		return t18
	end, {
		v115,
		v100
	})
	local t19

	if v117 and not v116 and #v115 == 0 then
		t19 = {
			EmptyContent = React.createElement(View, {
				tag = "col size-full"
			}, {
				CreateList = React.createElement(List.Root, {
					LayoutOrder = 1,
					hasDivider = false,
					isContained = {
						isContained = false,
						hasMargin = false
					},
					size = InputSize.Large
				}, {
					CreateRow = React.createElement(List.Item, {
						LayoutOrder = 1,
						leading = IconName.PlusLarge,
						title = LocalizationStrings.MY_CREATIONS_NEW_GAME,
						description = LocalizationStrings.MY_CREATIONS_BUILD_WITH_AI,
						onActivated = v119
					})
				}),
				EmptyState = React.createElement(View, {
					LayoutOrder = 2,
					tag = "col align-x-center align-y-center fill size-full-0 padding-large",
					testId = "MyCreationsTab.Empty"
				}, {
					Content = React.createElement(BuildEmptyState)
				})
			})
		}
	else
		local t20 = {
			CreateRow = React.createElement(List.Item, {
				LayoutOrder = 1,
				leading = IconName.PlusLarge,
				title = LocalizationStrings.MY_CREATIONS_NEW_GAME,
				description = LocalizationStrings.MY_CREATIONS_BUILD_WITH_AI,
				onActivated = v119
			})
		}

		if v117 and #v115 > 0 then
			for v126, v127 in v123 do
				local experienceName = v127.experienceName
				local gameIcon = v127.gameIcon
				local placeId = v127.placeId
				local visibilityLabel = v127.visibilityLabel

				t20["S" .. v127.sessionId] = React.createElement(List.Item, {
					LayoutOrder = v126 + 1,
					leading = {
						iconName = gameIcon
					},
					title = experienceName,
					description = v127.description,
					testId = `MyCreationsTab.ExperienceRow.{ v127.universeId }`,
					onActivated = function() -- line: 558
						-- upvalues: t12 (copy), v127 (copy), placeId (copy), experienceName (copy), gameIcon (copy)
						t12.onOpenChat({
							universeId = v127.universeId,
							placeId = placeId,
							sessionId = v127.sessionId,
							experienceName = experienceName,
							creatorName = v127.creatorName,
							gameIcon = gameIcon
						})
					end,
					trailing = if visibilityLabel == nil then nil else React.createElement(View, {
						tag = "row align-y-center auto-xy"
					}, {
						VisibilityBadge = React.createElement(Badge, {
							text = visibilityLabel,
							shape = BadgeShape.Box,
							size = BadgeSize.Small,
							variant = BadgeVariant.Neutral,
							testId = `MyCreationsTab.VisibilityBadge.{ v127.universeId }`
						})
					})
				})
			end
		elseif v107 == "NotReady" or v116 then
			t20[`Loading{ 1 }`] = renderLoadingExperienceSkeleton(1, 2, v95)
			t20[`Loading{ 2 }`] = renderLoadingExperienceSkeleton(2, 3, v95)
		elseif v107 == "Failed" then
			t20.Error = React.createElement(List.Item, {
				LayoutOrder = 2,
				title = LocalizationStrings.MY_CREATIONS_LOAD_ERROR
			})
		end

		t19 = {
			ExperienceList = React.createElement(List.Root, {
				hasDivider = false,
				isContained = {
					isContained = false,
					hasMargin = false
				},
				size = InputSize.Large
			}, t20)
		}
	end

	return React.createElement(RefreshScrollingFrame, {
		usesBuilderIcon = true,
		refresh = v108,
		ref = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else v96,
		onCanvasPositionChangedCallback = v121,
		onCanvasSizeChangedCallback = v121,
		createFooter = v122,
		scrollingElementProps = {
			LayoutOrder = t12.LayoutOrder,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(1, 0, 1, 1),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			[React.Tag] = "fill"
		}
	}, {
		ContentBody = React.createElement(View, {
			tag = "composition-content-body col size-full-0 auto-y",
			testId = "MyCreationsTab.ContentBody"
		}, t19)
	})
end

return MyCreationsTab
