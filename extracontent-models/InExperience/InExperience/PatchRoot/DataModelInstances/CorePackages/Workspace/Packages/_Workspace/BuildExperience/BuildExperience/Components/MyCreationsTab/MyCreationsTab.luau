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
local matchesSearchQuery = require(script.Parent.Parent.Parent.utils.matchesSearchQuery)
local chatConstants = require(script.Parent.Parent.Parent.Chat.chatConstants)

require(script.Parent.Parent.Parent.Chat.chatTypes)

local GetBuildExperienceRefreshStore = require(script.Parent.Parent.Parent.Stores.GetBuildExperienceRefreshStore)
local GetSearchQueryStore = require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore)

require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)

local FFlagEnableBuildExperienceScrollPerformanceTracking = require(script.Parent.Parent.Parent.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local v34 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(script.Parent.Parent.Parent.Telemetry.useScrollPerformanceTracker)
local useSignalState = SignalsReact.useSignalState
local t1 = {
	waiting_on_client = LocalizationStrings.MY_CREATIONS_INPUT_NEEDED,
	idle = LocalizationStrings.MY_CREATIONS_READY,
	working = LocalizationStrings.MY_CREATIONS_BUILDING
}

local function thumbForUniverseId(n1: number) -- line: 97
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", n1)
end
local function privacyLabelForSummary(p1) -- line: 101
	-- upvalues: PrivacyType (copy), LocalizationStrings (copy)
	if p1.privacyType == PrivacyType.Public then
		return LocalizationStrings.MY_CREATIONS_PUBLIC
	end

	if p1.privacyType == PrivacyType.FriendsOnly then
		return LocalizationStrings.MY_CREATIONS_RESTRICTED
	end

	return LocalizationStrings.MY_CREATIONS_PRIVATE
end
local function descriptionForSessionStatus(p2) -- line: 110
	-- upvalues: t1 (copy)
	local v49 = p2._meta and p2._meta._roblox
	local v50 = if not v49 then nil else v49.sessionStatus

	if v50 == nil then
		return nil
	end

	return t1[v50]
end
local function requestHandleToPromise(p3) -- line: 119
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, reject) -- line: 120
		-- upvalues: p3 (copy)
		task.spawn(function() -- line: 121
			-- upvalues: p3 (copy), resolve (copy), reject (copy)
			while p3.state(false).status == "pending" do
				task.wait()
			end

			local v142 = p3.state(false)

			if v142.status == "succeeded" then
				resolve(v142.result)

				return
			end

			reject(v142.error)
		end)
	end)
end
local function getSessionUniverseId(p4) -- line: 136
	local v53 = p4._meta and p4._meta._roblox

	if v53 == nil then
		return nil
	end

	local universeId = v53.universeId

	if typeof(universeId) ~= "number" or universeId == 0 then
		return nil
	end

	return universeId
end
local function buildExperienceMetadataByUniverseId(t2: {[any]: any}) -- line: 148
	-- upvalues: PrivacyType (copy), LocalizationStrings (copy)
	local t3 = {}

	for v57, v58 in t2 do
		local name = v58.name

		if typeof(name) == "string" and name ~= "" and not v58.isArchived then
			local creatorName = v58.creatorName

			t3[v57] = {
				placeId = v58.rootPlaceId,
				experienceName = name,
				creatorName = if typeof(creatorName) ~= "string" or creatorName == "" then nil else creatorName,
				visibilityLabel = if v58.privacyType ~= PrivacyType.Public then if v58.privacyType ~= PrivacyType.FriendsOnly then LocalizationStrings.MY_CREATIONS_PRIVATE else LocalizationStrings.MY_CREATIONS_RESTRICTED else LocalizationStrings.MY_CREATIONS_PUBLIC,
				gameIcon = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v57)
			}
		end
	end

	return t3
end
local function buildSessionItems(t4: {[any]: any}, t5: {[any]: any}?) -- line: 169
	-- upvalues: LocalizationStrings (copy), t1 (copy)
	local t6 = {}
	local t7 = {}

	for _, v66 in t4 do
		local sessionId = v66.sessionId
		local v68 = v66._meta and v66._meta._roblox
		local v69

		if v68 == nil then
			v69 = nil
		else
			local universeId = v68.universeId

			v69 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
		end

		if typeof(sessionId) == "string" and sessionId ~= "" and v69 ~= nil and not t6[v69] then
			t6[v69] = true

			local v71 = if not t5 then nil else t5[v69]
			local v72 = if not v71 then v66.title or LocalizationStrings.formatMyCreationsUniverseName(v69) else v71.experienceName
			local t8 = {
				sessionId = sessionId,
				universeId = v69,
				placeId = if not v71 then nil else v71.placeId,
				experienceName = v72,
				creatorName = if not v71 then nil else v71.creatorName
			}
			local v74 = v66._meta and v66._meta._roblox
			local v75 = if not v74 then nil else v74.sessionStatus

			t8.description = if v75 ~= nil then t1[v75] else nil
			t8.visibilityLabel = if not v71 then LocalizationStrings.MY_CREATIONS_PRIVATE else v71.visibilityLabel
			t8.gameIcon = if not v71 then string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v69) else v71.gameIcon
			table.insert(t7, t8)
		end
	end

	return t7
end
local function renderLoadingExperienceSkeleton(n2: number, n3: number, p5) -- line: 208
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
local function MyCreationsTab(t9: {[any]: any}) -- line: 246
	-- upvalues: CreatorAgentChat (copy), UniverseConfiguration (copy), GetSearchQueryStore (copy), GetBuildExperienceRefreshStore (copy), AppLifecycleObserverService (copy), useTokens (copy), React (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v34 (copy), useSignalState (copy), requestHandleToPromise (copy), Signals (copy), v5 (copy), buildExperienceMetadataByUniverseId (copy), buildSessionItems (copy), chatConstants (copy), Players (copy), Promise (copy), renderLoadingExperienceSkeleton (copy), matchesSearchQuery (copy), View (copy), List (copy), InputSize (copy), IconName (copy), LocalizationStrings (copy), BuildEmptyState (copy), Badge (copy), BadgeShape (copy), BadgeSize (copy), BadgeVariant (copy), RefreshScrollingFrame (copy)
	local v80 = t9.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()
	local v81 = t9.configurationStore or UniverseConfiguration.getUniverseConfigurationStore()
	local v82 = t9.searchQueryStore or GetSearchQueryStore()
	local v83 = GetBuildExperienceRefreshStore()
	local v84 = t9.appLifecycleObserverService or AppLifecycleObserverService
	local v85 = t9.isFocused ~= false
	local v86 = useTokens()
	local v87 = React.useRef(nil)
	local v88 = React.useRef(false)
	local v89, v90 = React.useState(false)

	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v34("LuaApp_Build_Home_Scroll", v87)
	end

	local v91 = v82.useDebouncedQuery()
	local v92 = useSignalState(v83.getRefreshTick)
	local v93 = v80.getSessionListStore()
	local v94 = useSignalState(v93.getSessions)
	local v95 = useSignalState(v93.getNextPageToken)
	local v96 = useSignalState(v93.getStatus)
	local v97 = useSignalState(v93.getLoadMoreStatus)
	local v98 = if v96 ~= "pending" then v96 ~= "succeeded" and "Failed" or "Ready" else "NotReady"
	local v99 = React.useCallback(function() -- line: 275
		-- upvalues: requestHandleToPromise (copy), v93 (copy)
		return requestHandleToPromise(v93.refresh())
	end, { v93 })

	React.useEffect(function() -- line: 279
		-- upvalues: v84 (copy), v85 (copy), v93 (copy)
		local connection = v84.OnUnhide:Connect(function() -- line: 280
			-- upvalues: v85 (copy), v93 (copy)
			if v85 then
				v93.refresh()
			end
		end)

		return function() -- line: 286
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v84,
		v85,
		v93
	})
	React.useEffect(function() -- line: 291
		-- upvalues: v85 (copy), v90 (copy), v93 (copy), Signals (copy)
		if not v85 then
			v90(false)

			return
		end

		v90(false)

		local v123 = v93.refresh()

		return Signals.createEffect(function(p6) -- line: 299
			-- upvalues: v123 (copy), v90 (copy)
			if v123.state(p6).status == "succeeded" then
				v90(true)
			end
		end)
	end, {
		v85,
		v92,
		v93
	})

	local v100 = math.max(0, t9.pollingIntervalSeconds or v5)

	React.useEffect(function() -- line: 308
		-- upvalues: v85 (copy), v100 (copy), v93 (copy)
		if not v85 or v100 == 0 then
			return
		end

		local u124 = false

		local function scheduleNextPoll() -- line: 314
			-- upvalues: v100 (copy), u124 (ref), v93 (copy), scheduleNextPoll (copy)
			task.delay(v100, function() -- line: 315
				-- upvalues: u124 (ref), v93 (copy), scheduleNextPoll (copy)
				if u124 then
					return
				end

				v93.refresh()
				scheduleNextPoll()
			end)
		end

		task.delay(v100, function() -- line: 315
			-- upvalues: u124 (ref), v93 (copy), scheduleNextPoll (copy)
			if u124 then
				return
			end

			v93.refresh()
			scheduleNextPoll()
		end)

		return function() -- line: 325
			-- upvalues: u124 (ref)
			u124 = true
		end
	end, {
		v85,
		v100,
		v93
	})

	local v101 = React.useMemo(function() -- line: 330
		-- upvalues: Signals (copy), v94 (copy), v81 (copy)
		return Signals.createComputed(function(p7) -- line: 331
			-- upvalues: v94 (copy), v81 (copy)
			local t10 = {}
			local t11 = {}

			for _, v148 in v94 do
				local v149 = v148._meta and v148._meta._roblox
				local v150

				if v149 == nil then
					v150 = nil
				else
					local universeId = v149.universeId

					v150 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
				end

				if v150 ~= nil and not t11[v150] then
					t11[v150] = true

					local v152 = v81.getAndFetchSummary(v150).data(p7)

					if v152 ~= nil then
						t10[v150] = v152
					end
				end
			end

			return t10
		end)
	end, {
		v81,
		v94
	})
	local v102 = useSignalState(v101)
	local v103 = React.useMemo(function() -- line: 348
		-- upvalues: buildExperienceMetadataByUniverseId (copy), v102 (copy)
		return (buildExperienceMetadataByUniverseId(v102))
	end, { v102 })
	local v104 = React.useMemo(function() -- line: 351
		-- upvalues: buildSessionItems (copy), v94 (copy), v103 (copy), v102 (copy)
		local t12 = {}

		for _, v128 in (buildSessionItems(v94, v103)) do
			local v129 = v102[v128.universeId]

			if v129 ~= nil and not v129.isArchived then
				table.insert(t12, v128)
			end
		end

		return t12
	end, {
		v94,
		v103,
		v102
	})
	local v105 = React.useMemo(function() -- line: 362
		-- upvalues: v94 (copy), v102 (copy)
		local t13 = {}

		for _, v132 in v94 do
			local v133 = v132._meta and v132._meta._roblox
			local v134

			if v133 == nil then
				v134 = nil
			else
				local universeId = v133.universeId

				v134 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
			end

			if v134 == nil or t13[v134] then
				continue
			end

			t13[v134] = true

			if v102[v134] == nil then
				return true
			end
		end

		return false
	end, {
		v94,
		v102
	})
	local v106 = v98 == "Ready" or #v94 > 0
	local v107 = v97 == "pending"
	local v108 = React.useCallback(function() -- line: 378
		-- upvalues: v88 (copy), t9 (copy), chatConstants (copy), Players (copy)
		v88.current = true
		t9.onOpenChat({
			isNewGameTarget = true,
			experienceName = chatConstants.BUILD_CHAT_PAGE_TITLE,
			creatorName = if not Players.LocalPlayer then nil else Players.LocalPlayer.Name
		})
	end, { t9.onOpenChat })

	React.useEffect(function() -- line: 388
		-- upvalues: t9 (copy), v85 (copy), v89 (copy), v98 (copy), v94 (copy), v88 (copy), v108 (copy)
		if t9.autoOpenNewGame ~= false and (v85 and v89 and v98 == "Ready" and #v94 == 0 and not v88.current) then
			v108()
		end
	end, {
		v108,
		v89,
		v85,
		t9.autoOpenNewGame,
		v94,
		v98
	})

	local v109 = React.useCallback(function() -- line: 410
		-- upvalues: v93 (copy), Promise (copy), requestHandleToPromise (copy)
		local v136 = v93.loadMore()

		if v136 == nil then
			return Promise.resolve()
		end

		return requestHandleToPromise(v136)
	end, {
		v107,
		v95,
		v98,
		v93
	})
	local v110 = React.useCallback(function(p8) -- line: 418
		-- upvalues: v95 (copy), v107 (copy), v98 (copy), v109 (copy)
		local AbsoluteCanvasSizeY = p8.AbsoluteCanvasSize.Y

		if v95 == nil or (v107 or v98 ~= "Ready" or p8.CanvasPosition.Y <= 0 or AbsoluteCanvasSizeY <= 0 or p8.AbsoluteWindowSize.Y <= 0) then
			return
		end

		if math.max(0, AbsoluteCanvasSizeY - p8.AbsoluteWindowSize.Y - 250) < p8.CanvasPosition.Y then
			v109()
		end
	end, {
		v107,
		v109,
		v95,
		v98
	})
	local v111 = React.useCallback(function() -- line: 437
		-- upvalues: v107 (copy), renderLoadingExperienceSkeleton (copy), v86 (copy)
		if not v107 then
			return nil
		end

		return renderLoadingExperienceSkeleton(1, 1, v86)
	end, {
		v107,
		v86
	})
	local v112 = React.useMemo(function() -- line: 445
		-- upvalues: v91 (copy), v104 (copy), matchesSearchQuery (copy)
		if v91 == "" then
			return v104
		end

		local t14 = {}

		for _, v141 in v104 do
			if matchesSearchQuery(v141.experienceName, v91) then
				table.insert(t14, v141)
			end
		end

		return t14
	end, {
		v104,
		v91
	})
	local t15

	if v106 and not v105 and #v104 == 0 then
		t15 = {
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
						onActivated = v108
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
		local t16 = {
			CreateRow = React.createElement(List.Item, {
				LayoutOrder = 1,
				leading = IconName.PlusLarge,
				title = LocalizationStrings.MY_CREATIONS_NEW_GAME,
				description = LocalizationStrings.MY_CREATIONS_BUILD_WITH_AI,
				onActivated = v108
			})
		}

		if v106 and #v104 > 0 then
			for v115, v116 in v112 do
				local experienceName = v116.experienceName
				local gameIcon = v116.gameIcon
				local placeId = v116.placeId

				t16["S" .. v116.sessionId] = React.createElement(List.Item, {
					LayoutOrder = v115 + 1,
					leading = {
						iconName = gameIcon
					},
					title = experienceName,
					description = v116.description,
					testId = `MyCreationsTab.ExperienceRow.{ v116.universeId }`,
					onActivated = function() -- line: 514
						-- upvalues: t9 (copy), v116 (copy), placeId (copy), experienceName (copy), gameIcon (copy)
						t9.onOpenChat({
							universeId = v116.universeId,
							placeId = placeId,
							sessionId = v116.sessionId,
							experienceName = experienceName,
							creatorName = v116.creatorName,
							gameIcon = gameIcon
						})
					end,
					trailing = React.createElement(View, {
						tag = "row align-y-center auto-xy"
					}, {
						VisibilityBadge = React.createElement(Badge, {
							text = v116.visibilityLabel,
							shape = BadgeShape.Box,
							size = BadgeSize.Small,
							variant = BadgeVariant.Neutral,
							testId = `MyCreationsTab.VisibilityBadge.{ v116.universeId }`
						})
					})
				})
			end
		elseif v98 == "NotReady" or v105 then
			t16[`Loading{ 1 }`] = renderLoadingExperienceSkeleton(1, 2, v86)
			t16[`Loading{ 2 }`] = renderLoadingExperienceSkeleton(2, 3, v86)
		elseif v98 == "Failed" then
			t16.Error = React.createElement(List.Item, {
				LayoutOrder = 2,
				title = LocalizationStrings.MY_CREATIONS_LOAD_ERROR
			})
		end

		t15 = {
			ExperienceList = React.createElement(List.Root, {
				hasDivider = false,
				isContained = {
					isContained = false,
					hasMargin = false
				},
				size = InputSize.Large
			}, t16)
		}
	end

	return React.createElement(RefreshScrollingFrame, {
		usesBuilderIcon = true,
		refresh = v99,
		ref = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else v87,
		onCanvasPositionChangedCallback = v110,
		onCanvasSizeChangedCallback = v110,
		createFooter = v111,
		scrollingElementProps = {
			LayoutOrder = t9.LayoutOrder,
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
		}, t15)
	})
end

return MyCreationsTab
