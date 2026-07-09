local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Players = game:GetService("Players")
local Foundation = require(Parent.Foundation)
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local Promise = require(Parent.Promise)
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(Parent.DataHydration.UniverseConfiguration)
local UniverseCreate = require(Parent.DataHydration.UniverseCreate)
local List = Foundation.List
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local RefreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local BuildEmptyState = require(script.Parent.Parent.BuildEmptyState.BuildEmptyState)
local getDefaultTemplatePlaceId = require(script.Parent.Parent.Parent.utils.getDefaultTemplatePlaceId)
local matchesSearchQuery = require(script.Parent.Parent.Parent.utils.matchesSearchQuery)
local PlaytestStatusIndicatorForPlace = require(script.Parent.PlaytestStatusIndicatorForPlace)
local chatConstants = require(script.Parent.Parent.Parent.Chat.chatConstants)

require(script.Parent.Parent.Parent.Chat.chatTypes)

local GetBuildExperienceRefreshStore = require(script.Parent.Parent.Parent.Stores.GetBuildExperienceRefreshStore)
local GetPlaytestLoadingStore = require(script.Parent.Parent.Parent.Stores.GetPlaytestLoadingStore)

require(script.Parent.Parent.Parent.Stores.GetPlaytestLoadingStore.createPlaytestLoadingStore)

local GetSearchQueryStore = require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore)

require(script.Parent.Parent.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)

local useSignalState = SignalsReact.useSignalState

local function thumbForUniverseId(n1: number) -- line: 83
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", n1)
end
local function privacyLabelForSummary(p1) -- line: 87
	if p1.privacyType == "Public" then
		return "Public"
	end

	return "Private"
end
local function requestHandleToPromise(p2) -- line: 94
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, reject) -- line: 95
		-- upvalues: p2 (copy)
		task.spawn(function() -- line: 96
			-- upvalues: p2 (copy), resolve (copy), reject (copy)
			while p2.state(false).status == "pending" do
				task.wait()
			end

			local v121 = p2.state(false)

			if v121.status == "succeeded" then
				resolve(v121.result)

				return
			end

			reject(v121.error)
		end)
	end)
end
local function getSessionUniverseId(p3) -- line: 111
	local v41 = p3._meta and p3._meta._roblox

	if v41 == nil then
		return nil
	end

	local universeId = v41.universeId

	if typeof(universeId) ~= "number" or universeId == 0 then
		return nil
	end

	return universeId
end
local function buildExperienceMetadataByUniverseId(t1: {[any]: any}) -- line: 123
	local t2 = {}

	for v45, v46 in t1 do
		local name = v46.name

		if typeof(name) == "string" and name ~= "" and not v46.isArchived then
			local creatorName = v46.creatorName

			t2[v45] = {
				placeId = v46.rootPlaceId,
				experienceName = name,
				creatorName = if typeof(creatorName) ~= "string" or creatorName == "" then nil else creatorName,
				visibilityLabel = v46.privacyType ~= "Public" and "Private" or "Public",
				gameIcon = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v45)
			}
		end
	end

	return t2
end
local function buildSessionItems(t3: {[any]: any}, t4: {[any]: any}?) -- line: 144
	local t5 = {}
	local t6 = {}

	for _, v54 in t3 do
		local sessionId = v54.sessionId
		local v56 = v54._meta and v54._meta._roblox
		local v57

		if v56 == nil then
			v57 = nil
		else
			local universeId = v56.universeId

			v57 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
		end

		if typeof(sessionId) == "string" and sessionId ~= "" and v57 ~= nil and not t5[v57] then
			t5[v57] = true

			local v59 = if not t4 then nil else t4[v57]
			local v60 = if not v59 then v54.title or `Universe { v57 }` else v59.experienceName

			table.insert(t6, {
				sessionId = sessionId,
				universeId = v57,
				placeId = if not v59 then nil else v59.placeId,
				experienceName = v60,
				creatorName = if not v59 then nil else v59.creatorName,
				description = not v59 and "Private" or v59.visibilityLabel,
				gameIcon = if not v59 then string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v57) else v59.gameIcon
			})
		end
	end

	return t6
end
local function renderLoadingExperienceSkeleton(n2: number, n3: number, p4) -- line: 178
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-medium",
		LayoutOrder = n3,
		Size = UDim2.new(1, 0, 0, p4.Size.Size_1900),
		testId = `MyCreationsTab.LoadingSkeleton.{ n2 }`
	}, {
		ThumbnailContainer = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(p4.Size.Size_1100, p4.Size.Size_1100)
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
				Size = UDim2.new(0.72, 0, 0, p4.Size.Size_350),
				radius = EnumsRadius.Small
			}),
			Description = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.44, 0, 0, p4.Size.Size_250),
				radius = EnumsRadius.Small
			})
		})
	})
end
local function MyCreationsTab(t7: {[any]: any}) -- line: 216
	-- upvalues: CreatorAgentChat (copy), UniverseCreate (copy), UniverseConfiguration (copy), GetSearchQueryStore (copy), GetPlaytestLoadingStore (copy), GetBuildExperienceRefreshStore (copy), useTokens (copy), useSignalState (copy), React (copy), requestHandleToPromise (copy), Signals (copy), buildExperienceMetadataByUniverseId (copy), buildSessionItems (copy), getDefaultTemplatePlaceId (copy), chatConstants (copy), Players (copy), Promise (copy), renderLoadingExperienceSkeleton (copy), matchesSearchQuery (copy), View (copy), List (copy), InputSize (copy), IconName (copy), BuildEmptyState (copy), PlaytestStatusIndicatorForPlace (copy), RefreshScrollingFrame (copy)
	local v65 = t7.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()
	local v66 = t7.createStore or UniverseCreate.getUniverseCreateStore()
	local v67 = t7.configurationStore or UniverseConfiguration.getUniverseConfigurationStore()
	local v68 = t7.searchQueryStore or GetSearchQueryStore()
	local v69 = t7.playtestLoadingStore or GetPlaytestLoadingStore()
	local v70 = GetBuildExperienceRefreshStore()
	local v71 = useTokens()
	local v72 = v68.useDebouncedQuery()
	local v73 = useSignalState(v70.getRefreshTick)
	local v74 = v65.getSessionListStore()
	local v75, v76 = React.useState(false)
	local v77 = useSignalState(v74.getSessions)
	local v78 = useSignalState(v74.getNextPageToken)
	local v79 = useSignalState(v74.getStatus)
	local v80 = useSignalState(v74.getLoadMoreStatus)
	local v81 = if v79 ~= "pending" then v79 ~= "succeeded" and "Failed" or "Ready" else "NotReady"
	local v82 = React.useCallback(function() -- line: 239
		-- upvalues: requestHandleToPromise (copy), v74 (copy)
		return requestHandleToPromise(v74.refresh())
	end, { v74 })

	React.useEffect(function() -- line: 243
		-- upvalues: v74 (copy)
		v74.refresh()

		return function() -- line: 245
		end
	end, {
		v74,
		v73
	})

	local v83 = React.useMemo(function() -- line: 248
		-- upvalues: Signals (copy), v77 (copy), v67 (copy)
		return Signals.createComputed(function(p5) -- line: 249
			-- upvalues: v77 (copy), v67 (copy)
			local t8 = {}
			local t9 = {}

			for _, v126 in v77 do
				local v127 = v126._meta and v126._meta._roblox
				local v128

				if v127 == nil then
					v128 = nil
				else
					local universeId = v127.universeId

					v128 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
				end

				if v128 ~= nil and not t9[v128] then
					t9[v128] = true

					local v130 = v67.getAndFetchSummary(v128).data(p5)

					if v130 ~= nil then
						t8[v128] = v130
					end
				end
			end

			return t8
		end)
	end, {
		v67,
		v77
	})
	local v84 = useSignalState(v83)
	local v85 = React.useMemo(function() -- line: 266
		-- upvalues: buildExperienceMetadataByUniverseId (copy), v84 (copy)
		return (buildExperienceMetadataByUniverseId(v84))
	end, { v84 })
	local v86 = React.useMemo(function() -- line: 269
		-- upvalues: buildSessionItems (copy), v77 (copy), v85 (copy), v84 (copy)
		local t10 = {}

		for _, v107 in (buildSessionItems(v77, v85)) do
			local v108 = v84[v107.universeId]

			if v108 ~= nil and not v108.isArchived then
				table.insert(t10, v107)
			end
		end

		return t10
	end, {
		v77,
		v85,
		v84
	})
	local v87 = React.useMemo(function() -- line: 280
		-- upvalues: v77 (copy), v84 (copy)
		local t11 = {}

		for _, v111 in v77 do
			local v112 = v111._meta and v111._meta._roblox
			local v113

			if v112 == nil then
				v113 = nil
			else
				local universeId = v112.universeId

				v113 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
			end

			if v113 == nil or t11[v113] then
				continue
			end

			t11[v113] = true

			if v84[v113] == nil then
				return true
			end
		end

		return false
	end, {
		v77,
		v84
	})
	local v88 = v81 == "Ready" or #v77 > 0
	local v89 = v80 == "pending"
	local v90 = React.useCallback(function() -- line: 296
		-- upvalues: v74 (copy)
		v74.refresh()
	end, { v74 })
	local v91 = React.useCallback(function() -- line: 301
		-- upvalues: v75 (copy), v76 (copy), v66 (copy), getDefaultTemplatePlaceId (copy), v67 (copy), chatConstants (copy), Players (copy), t7 (copy), v90 (copy), v65 (copy), Promise (copy)
		if v75 then
			return
		end

		v76(true)
		v66.createUniverse({
			isPublish = true,
			templatePlaceId = getDefaultTemplatePlaceId()
		}):andThen(function(p6) -- line: 311
			-- upvalues: v67 (copy), chatConstants (copy), Players (copy), t7 (copy), v90 (copy), v65 (copy), Promise (copy)
			v67.patchConfiguration(p6.universeId, {
				audiences = { 1 }
			})
			v67.setTeamCreate(p6.universeId, true)

			local rootPlaceId = p6.rootPlaceId
			local t12 = {
				isNewGameTarget = true,
				universeId = p6.universeId,
				placeId = rootPlaceId,
				experienceName = chatConstants.BUILD_CHAT_PAGE_TITLE,
				creatorName = if not Players.LocalPlayer then nil else Players.LocalPlayer.Name
			}

			if rootPlaceId == nil then
				t7.onOpenChat(t12)
				v90()

				return nil
			end

			local v134 = v65.sessionNew({
				project = {
					universeId = p6.universeId,
					placeId = rootPlaceId
				}
			})

			return Promise.new(function(resolve, reject) -- line: 95
				-- upvalues: v134 (copy)
				task.spawn(function() -- line: 96
					-- upvalues: v134 (copy), resolve (copy), reject (copy)
					while v134.state(false).status == "pending" do
						task.wait()
					end

					local v139 = v134.state(false)

					if v139.status == "succeeded" then
						resolve(v139.result)

						return
					end

					reject(v139.error)
				end)
			end):andThen(function(p7) -- line: 336
				-- upvalues: t12 (copy), t7 (copy)
				if typeof(p7) == "table" and typeof(p7.sessionId) == "string" then
					t12.sessionId = p7.sessionId
				end

				t7.onOpenChat(t12)
			end):catch(function(p8) -- line: 345
				-- upvalues: t7 (copy), t12 (copy)
				warn(`[BuildExperience] session/new failed after create: { tostring(p8) }`)
				t7.onOpenChat(t12)
			end):finally(function() -- line: 349
				-- upvalues: v90 (copy)
				v90()
			end)
		end):catch(function() -- line: 353
		end):finally(function() -- line: 354
			-- upvalues: v76 (copy)
			v76(false)
		end)
	end, {
		v66,
		v65,
		v67,
		v75,
		t7.onOpenChat,
		v90
	})
	local v92 = React.useCallback(function() -- line: 361
		-- upvalues: v74 (copy), Promise (copy), requestHandleToPromise (copy)
		local v115 = v74.loadMore()

		if v115 == nil then
			return Promise.resolve()
		end

		return requestHandleToPromise(v115)
	end, {
		v89,
		v78,
		v81,
		v74
	})
	local v93 = React.useCallback(function(p9) -- line: 369
		-- upvalues: v78 (copy), v89 (copy), v81 (copy), v92 (copy)
		local AbsoluteCanvasSizeY = p9.AbsoluteCanvasSize.Y

		if v78 == nil or (v89 or v81 ~= "Ready" or p9.CanvasPosition.Y <= 0 or AbsoluteCanvasSizeY <= 0 or p9.AbsoluteWindowSize.Y <= 0) then
			return
		end

		if math.max(0, AbsoluteCanvasSizeY - p9.AbsoluteWindowSize.Y - 250) < p9.CanvasPosition.Y then
			v92()
		end
	end, {
		v89,
		v92,
		v78,
		v81
	})
	local v94 = React.useCallback(function() -- line: 388
		-- upvalues: v89 (copy), renderLoadingExperienceSkeleton (copy), v71 (copy)
		if not v89 then
			return nil
		end

		return renderLoadingExperienceSkeleton(1, 1, v71)
	end, {
		v89,
		v71
	})
	local v95 = React.useMemo(function() -- line: 396
		-- upvalues: v72 (copy), v86 (copy), matchesSearchQuery (copy)
		if v72 == "" then
			return v86
		end

		local t13 = {}

		for _, v120 in v86 do
			if matchesSearchQuery(v120.experienceName, v72) then
				table.insert(t13, v120)
			end
		end

		return t13
	end, {
		v86,
		v72
	})
	local t14

	if v88 and (not v87 and #v86 == 0) then
		t14 = {
			EmptyContent = React.createElement(View, {
				tag = "col size-full",
				padding = {
					top = UDim.new(0, v71.Padding.Medium),
					bottom = UDim.new(0, v71.Margin.Large)
				}
			}, {
				CreateList = React.createElement(List.Root, {
					LayoutOrder = 1,
					hasDivider = false,
					isContained = false,
					size = InputSize.Medium
				}, {
					CreateRow = React.createElement(List.Item, {
						LayoutOrder = 1,
						description = "Build a game with AI",
						leading = IconName.PlusLarge,
						title = not v75 and "New game" or "Creating…",
						onActivated = if not v75 then v91 else nil
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
		local t15 = {
			CreateRow = React.createElement(List.Item, {
				LayoutOrder = 1,
				description = "Build a game with AI",
				leading = IconName.PlusLarge,
				title = not v75 and "New game" or "Creating…",
				onActivated = if not v75 then v91 else nil
			})
		}

		if v88 and #v86 > 0 then
			for v98, v99 in v95 do
				local experienceName = v99.experienceName
				local gameIcon = v99.gameIcon
				local placeId = v99.placeId

				t15["S" .. v99.sessionId] = React.createElement(List.Item, {
					LayoutOrder = v98 + 1,
					leading = {
						iconName = gameIcon
					},
					title = experienceName,
					description = v99.description,
					testId = `MyCreationsTab.ExperienceRow.{ v99.universeId }`,
					onActivated = function() -- line: 466
						-- upvalues: placeId (copy), v69 (copy), t7 (copy), v99 (copy), experienceName (copy), gameIcon (copy)
						if placeId ~= nil then
							v69.clearCompletedStatusForPlaceId(placeId)
						end

						t7.onOpenChat({
							universeId = v99.universeId,
							placeId = placeId,
							sessionId = v99.sessionId,
							experienceName = experienceName,
							creatorName = v99.creatorName,
							gameIcon = gameIcon
						})
					end,
					trailing = React.createElement(View, {
						tag = "row align-y-center gap-small auto-xy"
					}, {
						Status = if placeId == nil then nil else React.createElement(PlaytestStatusIndicatorForPlace, {
							LayoutOrder = 1,
							placeId = placeId,
							playtestLoadingStore = v69
						})
					})
				})
			end
		elseif v81 == "NotReady" or v87 then
			t15[`Loading{ 1 }`] = renderLoadingExperienceSkeleton(1, 2, v71)
			t15[`Loading{ 2 }`] = renderLoadingExperienceSkeleton(2, 3, v71)
		elseif v81 == "Failed" then
			t15.Error = React.createElement(List.Item, {
				LayoutOrder = 2,
				title = "Couldn't load experiences"
			})
		end

		t14 = {
			ExperienceList = React.createElement(List.Root, {
				hasDivider = false,
				isContained = {
					isContained = false,
					hasMargin = false
				},
				size = InputSize.Medium
			}, t15)
		}
	end

	return React.createElement(RefreshScrollingFrame, {
		usesBuilderIcon = true,
		refresh = v82,
		onCanvasPositionChangedCallback = v93,
		onCanvasSizeChangedCallback = v93,
		createFooter = v94,
		scrollingElementProps = {
			LayoutOrder = t7.LayoutOrder,
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
		}, t14)
	})
end

return MyCreationsTab
