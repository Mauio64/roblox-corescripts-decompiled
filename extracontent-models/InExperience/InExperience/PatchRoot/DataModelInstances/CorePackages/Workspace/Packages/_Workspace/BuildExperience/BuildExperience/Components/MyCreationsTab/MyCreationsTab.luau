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
local List = Foundation.List
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local RefreshScrollingFrame = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.RefreshScrollingFrame
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local BuildEmptyState = require(script.Parent.Parent.BuildEmptyState.BuildEmptyState)
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

local function thumbForUniverseId(n1: number) -- line: 78
	return string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", n1)
end
local function privacyLabelForSummary(p1) -- line: 82
	if p1.privacyType == "Public" then
		return "Public"
	end

	return "Private"
end
local function requestHandleToPromise(p2) -- line: 89
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, reject) -- line: 90
		-- upvalues: p2 (copy)
		task.spawn(function() -- line: 91
			-- upvalues: p2 (copy), resolve (copy), reject (copy)
			while p2.state(false).status == "pending" do
				task.wait()
			end

			local v115 = p2.state(false)

			if v115.status == "succeeded" then
				resolve(v115.result)

				return
			end

			reject(v115.error)
		end)
	end)
end
local function getSessionUniverseId(p3) -- line: 106
	local v39 = p3._meta and p3._meta._roblox

	if v39 == nil then
		return nil
	end

	local universeId = v39.universeId

	if typeof(universeId) ~= "number" or universeId == 0 then
		return nil
	end

	return universeId
end
local function buildExperienceMetadataByUniverseId(t1: {[any]: any}) -- line: 118
	local t2 = {}

	for v43, v44 in t1 do
		local name = v44.name

		if typeof(name) == "string" and name ~= "" and not v44.isArchived then
			local creatorName = v44.creatorName

			t2[v43] = {
				placeId = v44.rootPlaceId,
				experienceName = name,
				creatorName = if typeof(creatorName) ~= "string" or creatorName == "" then nil else creatorName,
				visibilityLabel = v44.privacyType ~= "Public" and "Private" or "Public",
				gameIcon = string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v43)
			}
		end
	end

	return t2
end
local function buildSessionItems(t3: {[any]: any}, t4: {[any]: any}?) -- line: 139
	local t5 = {}
	local t6 = {}

	for _, v52 in t3 do
		local sessionId = v52.sessionId
		local v54 = v52._meta and v52._meta._roblox
		local v55

		if v54 == nil then
			v55 = nil
		else
			local universeId = v54.universeId

			v55 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
		end

		if typeof(sessionId) == "string" and sessionId ~= "" and v55 ~= nil and not t5[v55] then
			t5[v55] = true

			local v57 = if not t4 then nil else t4[v55]
			local v58 = if not v57 then v52.title or `Universe { v55 }` else v57.experienceName

			table.insert(t6, {
				sessionId = sessionId,
				universeId = v55,
				placeId = if not v57 then nil else v57.placeId,
				experienceName = v58,
				creatorName = if not v57 then nil else v57.creatorName,
				description = not v57 and "Private" or v57.visibilityLabel,
				gameIcon = if not v57 then string.format("rbxthumb://type=GameIcon&id=%d&w=150&h=150", v55) else v57.gameIcon
			})
		end
	end

	return t6
end
local function renderLoadingExperienceSkeleton(n2: number, n3: number, p4) -- line: 173
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-medium",
		LayoutOrder = n3,
		Size = UDim2.new(1, 0, 0, p4.Size.Size_2000),
		testId = `MyCreationsTab.LoadingSkeleton.{ n2 }`
	}, {
		ThumbnailContainer = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(p4.Size.Size_1400, p4.Size.Size_1400)
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
				Size = UDim2.new(0.72, 0, 0, p4.Size.Size_400),
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
local function MyCreationsTab(t7: {[any]: any}) -- line: 211
	-- upvalues: CreatorAgentChat (copy), UniverseConfiguration (copy), GetSearchQueryStore (copy), GetPlaytestLoadingStore (copy), GetBuildExperienceRefreshStore (copy), useTokens (copy), useSignalState (copy), React (copy), requestHandleToPromise (copy), Signals (copy), buildExperienceMetadataByUniverseId (copy), buildSessionItems (copy), chatConstants (copy), Players (copy), Promise (copy), renderLoadingExperienceSkeleton (copy), matchesSearchQuery (copy), View (copy), List (copy), InputSize (copy), IconName (copy), BuildEmptyState (copy), PlaytestStatusIndicatorForPlace (copy), RefreshScrollingFrame (copy)
	local v63 = t7.creatorAgentChatStore or CreatorAgentChat.getCreatorAgentChatStore()
	local v64 = t7.configurationStore or UniverseConfiguration.getUniverseConfigurationStore()
	local v65 = t7.searchQueryStore or GetSearchQueryStore()
	local v66 = t7.playtestLoadingStore or GetPlaytestLoadingStore()
	local v67 = GetBuildExperienceRefreshStore()
	local v68 = useTokens()
	local v69 = v65.useDebouncedQuery()
	local v70 = useSignalState(v67.getRefreshTick)
	local v71 = v63.getSessionListStore()
	local v72 = useSignalState(v71.getSessions)
	local v73 = useSignalState(v71.getNextPageToken)
	local v74 = useSignalState(v71.getStatus)
	local v75 = useSignalState(v71.getLoadMoreStatus)
	local v76 = if v74 ~= "pending" then v74 ~= "succeeded" and "Failed" or "Ready" else "NotReady"
	local v77 = React.useCallback(function() -- line: 232
		-- upvalues: requestHandleToPromise (copy), v71 (copy)
		return requestHandleToPromise(v71.refresh())
	end, { v71 })

	React.useEffect(function() -- line: 236
		-- upvalues: v71 (copy)
		v71.refresh()

		return function() -- line: 238
		end
	end, {
		v71,
		v70
	})

	local v78 = React.useMemo(function() -- line: 241
		-- upvalues: Signals (copy), v72 (copy), v64 (copy)
		return Signals.createComputed(function(p5) -- line: 242
			-- upvalues: v72 (copy), v64 (copy)
			local t8 = {}
			local t9 = {}

			for _, v120 in v72 do
				local v121 = v120._meta and v120._meta._roblox
				local v122

				if v121 == nil then
					v122 = nil
				else
					local universeId = v121.universeId

					v122 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
				end

				if v122 ~= nil and not t9[v122] then
					t9[v122] = true

					local v124 = v64.getAndFetchSummary(v122).data(p5)

					if v124 ~= nil then
						t8[v122] = v124
					end
				end
			end

			return t8
		end)
	end, {
		v64,
		v72
	})
	local v79 = useSignalState(v78)
	local v80 = React.useMemo(function() -- line: 259
		-- upvalues: buildExperienceMetadataByUniverseId (copy), v79 (copy)
		return (buildExperienceMetadataByUniverseId(v79))
	end, { v79 })
	local v81 = React.useMemo(function() -- line: 262
		-- upvalues: buildSessionItems (copy), v72 (copy), v80 (copy), v79 (copy)
		local t10 = {}

		for _, v101 in (buildSessionItems(v72, v80)) do
			local v102 = v79[v101.universeId]

			if v102 ~= nil and not v102.isArchived then
				table.insert(t10, v101)
			end
		end

		return t10
	end, {
		v72,
		v80,
		v79
	})
	local v82 = React.useMemo(function() -- line: 273
		-- upvalues: v72 (copy), v79 (copy)
		local t11 = {}

		for _, v105 in v72 do
			local v106 = v105._meta and v105._meta._roblox
			local v107

			if v106 == nil then
				v107 = nil
			else
				local universeId = v106.universeId

				v107 = if typeof(universeId) == "number" and universeId ~= 0 then universeId else nil
			end

			if v107 == nil or t11[v107] then
				continue
			end

			t11[v107] = true

			if v79[v107] == nil then
				return true
			end
		end

		return false
	end, {
		v72,
		v79
	})
	local v83 = v76 == "Ready" or #v72 > 0
	local v84 = v75 == "pending"
	local v85 = React.useCallback(function() -- line: 289
		-- upvalues: t7 (copy), chatConstants (copy), Players (copy)
		t7.onOpenChat({
			isNewGameTarget = true,
			experienceName = chatConstants.BUILD_CHAT_PAGE_TITLE,
			creatorName = if not Players.LocalPlayer then nil else Players.LocalPlayer.Name
		})
	end, { t7.onOpenChat })
	local v86 = React.useCallback(function() -- line: 297
		-- upvalues: v71 (copy), Promise (copy), requestHandleToPromise (copy)
		local v109 = v71.loadMore()

		if v109 == nil then
			return Promise.resolve()
		end

		return requestHandleToPromise(v109)
	end, {
		v84,
		v73,
		v76,
		v71
	})
	local v87 = React.useCallback(function(p6) -- line: 305
		-- upvalues: v73 (copy), v84 (copy), v76 (copy), v86 (copy)
		local AbsoluteCanvasSizeY = p6.AbsoluteCanvasSize.Y

		if v73 == nil or (v84 or v76 ~= "Ready" or p6.CanvasPosition.Y <= 0 or AbsoluteCanvasSizeY <= 0 or p6.AbsoluteWindowSize.Y <= 0) then
			return
		end

		if math.max(0, AbsoluteCanvasSizeY - p6.AbsoluteWindowSize.Y - 250) < p6.CanvasPosition.Y then
			v86()
		end
	end, {
		v84,
		v86,
		v73,
		v76
	})
	local v88 = React.useCallback(function() -- line: 324
		-- upvalues: v84 (copy), renderLoadingExperienceSkeleton (copy), v68 (copy)
		if not v84 then
			return nil
		end

		return renderLoadingExperienceSkeleton(1, 1, v68)
	end, {
		v84,
		v68
	})
	local v89 = React.useMemo(function() -- line: 332
		-- upvalues: v69 (copy), v81 (copy), matchesSearchQuery (copy)
		if v69 == "" then
			return v81
		end

		local t12 = {}

		for _, v114 in v81 do
			if matchesSearchQuery(v114.experienceName, v69) then
				table.insert(t12, v114)
			end
		end

		return t12
	end, {
		v81,
		v69
	})
	local t13

	if v83 and (not v82 and #v81 == 0) then
		t13 = {
			EmptyContent = React.createElement(View, {
				tag = "col size-full",
				padding = {
					top = UDim.new(0, v68.Padding.Medium),
					bottom = UDim.new(0, v68.Margin.Large)
				}
			}, {
				CreateList = React.createElement(List.Root, {
					LayoutOrder = 1,
					hasDivider = false,
					isContained = false,
					size = InputSize.Large
				}, {
					CreateRow = React.createElement(List.Item, {
						LayoutOrder = 1,
						title = "New game",
						description = "Build a game with AI",
						leading = IconName.PlusLarge,
						onActivated = v85
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
		local t14 = {
			CreateRow = React.createElement(List.Item, {
				LayoutOrder = 1,
				title = "New game",
				description = "Build a game with AI",
				leading = IconName.PlusLarge,
				onActivated = v85
			})
		}

		if v83 and #v81 > 0 then
			for v92, v93 in v89 do
				local experienceName = v93.experienceName
				local gameIcon = v93.gameIcon
				local placeId = v93.placeId

				t14["S" .. v93.sessionId] = React.createElement(List.Item, {
					LayoutOrder = v92 + 1,
					leading = {
						iconName = gameIcon
					},
					title = experienceName,
					description = v93.description,
					testId = `MyCreationsTab.ExperienceRow.{ v93.universeId }`,
					onActivated = function() -- line: 402
						-- upvalues: placeId (copy), v66 (copy), t7 (copy), v93 (copy), experienceName (copy), gameIcon (copy)
						if placeId ~= nil then
							v66.clearCompletedStatusForPlaceId(placeId)
						end

						t7.onOpenChat({
							universeId = v93.universeId,
							placeId = placeId,
							sessionId = v93.sessionId,
							experienceName = experienceName,
							creatorName = v93.creatorName,
							gameIcon = gameIcon
						})
					end,
					trailing = React.createElement(View, {
						tag = "row align-y-center gap-small auto-xy"
					}, {
						Status = if placeId == nil then nil else React.createElement(PlaytestStatusIndicatorForPlace, {
							LayoutOrder = 1,
							placeId = placeId,
							playtestLoadingStore = v66
						})
					})
				})
			end
		elseif v76 == "NotReady" or v82 then
			t14[`Loading{ 1 }`] = renderLoadingExperienceSkeleton(1, 2, v68)
			t14[`Loading{ 2 }`] = renderLoadingExperienceSkeleton(2, 3, v68)
		elseif v76 == "Failed" then
			t14.Error = React.createElement(List.Item, {
				LayoutOrder = 2,
				title = "Couldn't load experiences"
			})
		end

		t13 = {
			ExperienceList = React.createElement(List.Root, {
				hasDivider = false,
				isContained = {
					isContained = false,
					hasMargin = false
				},
				size = InputSize.Large
			}, t14)
		}
	end

	return React.createElement(RefreshScrollingFrame, {
		usesBuilderIcon = true,
		refresh = v77,
		onCanvasPositionChangedCallback = v87,
		onCanvasSizeChangedCallback = v87,
		createFooter = v88,
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
		}, t13)
	})
end

return MyCreationsTab
