local GuiService = game:GetService("GuiService")
local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local ReactFocusNavigation = require(DiscoveryMonolithParent.ReactFocusNavigation)
local Cryo = require(DiscoveryMonolithParent.Cryo)
local useSelector = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useSelector
local FormFactor = require(DiscoveryMonolithParent.FormFactor).Enums.FormFactor
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local parseBooleanString = require(DiscoveryMonolithParent.DiscoveryUtils).parseBooleanString

require(DiscoveryMonolithParent.GameCollections)

local GameCollectionGrid = require(DiscoveryMonolithParent.GameCollections).GameCollectionGrid
local GameCollectionItemBuilder = require(DiscoveryMonolithParent.GameCollections).GameCollectionItemBuilder
local GameCollectionItemTypes = require(DiscoveryMonolithParent.GameCollections).GameCollectionItemTypes
local PlaceholderGameGrid = require(DiscoveryMonolithParent.GameCollections).PlaceholderGameGrid
local CollectionViews = require(DiscoveryMonolithParent.CollectionViews)
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes

require(DiscoveryMonolithParent.GameTile)

local getGameTileCollectionItemSize = require(DiscoveryMonolithParent.GameTile).getGameTileCollectionItemSize
local TopicContentsReducer = require(DiscoveryMonolithParent.TopicContentsRodux).TopicContentsReducer
local getSduiFeedStore = require(DiscoveryMonolithParent.ServerDrivenUi).getSduiFeedStore
local Signals = require(DiscoveryMonolithParent.Signals)
local SignalsReact = require(DiscoveryMonolithParent.SignalsReact)
local LoggingProtocol = require(DiscoveryMonolithParent.LoggingProtocol)
local default = LoggingProtocol.default
local DiscoveryEventErrorLogger = require(DiscoveryMonolithParent.DiscoveryUtils).DiscoveryEventErrorLogger
local showMoreClickEvent = require(DiscoveryMonolithParent.DiscoveryAnalytics).Events.showMoreClickEvent
local Modules = DiscoveryMonolith.Modules
local useUpdateFeedItemRenderedRows = require(Modules.Personalization.OmniFeed.DataStore.useUpdateFeedItemRenderedRows)
local useGridFlexFeedItemBounds = require(Modules.Personalization.OmniFeed.useGridFlexFeedItemBounds)
local OmniFeedProps = require(Modules.Personalization.OmniFeed.OmniFeedProps)
local Foundation = require(DiscoveryMonolithParent.Foundation)
local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant
local IconName = Foundation.Enums.IconName
local useLocalization = require(DiscoveryMonolithParent.Localization).Hooks.useLocalization
local SharedFlags = require(DiscoveryMonolithParent.SharedFlags)
local FIntGameGridFlexFeedItemTileNumPerFeed = SharedFlags.FIntGameGridFlexFeedItemTileNumPerFeed
local FIntLuaAppDelayImpressionsMaxUpdates = SharedFlags.FIntLuaAppDelayImpressionsMaxUpdates
local v40 = game:DefineFastFlag("FixPlaceholderGameGrid", false)
local FFlagLuaAppRfySignalApportioning = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppRfySignalApportioning
local FFlagLuaAppRfySignalApportioningIxp = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppRfySignalApportioningIxp
local FFlagLuaAppEnableWhyThisAdModal = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppFixHomeGridPlaceholderFlowIssues = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppFixHomeGridPlaceholderFlowIssues
local v45 = game:DefineFastFlag("LuaAppAddPlaceholderRecoveryCounter", false)
local FFlagLuaAppEnableSponsoredReportAd = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppAddRequestIdToRfySignalApportioning = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppAddRequestIdToRfySignalApportioning
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomeTouchAutoplay = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppRfyRevealRows = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppRfyRevealRows
local FFlagLuaAppEnableNxMRoduxApportioning = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local v54 = game:DefineFastFlag("LuaAppUpdateRevealMoreButtonUi", false)
local v55 = game:DefineFastInt("LuaAppGameGridRevealMoreButtonGapPx", 12)
local FFlagLuaAppRfyRevealRowsFocusFix = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppRfyRevealRowsFocusFix
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING
local t1 = {}
local u60 = not FFlagLuaAppRfySignalApportioning and nil
local u61 = not FFlagLuaAppRfySignalApportioning and nil
local u62 = nil
local u63 = nil

if FFlagLuaAppRfyRevealRows then
	function u62(p1) -- line: 98
		local v65 = if type(p1) ~= "number" then tonumber(p1) else p1

		if not v65 then
			return nil
		end

		local v66 = math.floor(v65)

		if v66 ~= v65 or v66 <= 0 then
			return nil
		end

		return v66
	end
	function u63(t2: {[any]: any}, n1: number, s1: string) -- line: 112
		-- upvalues: OmniFeedTypes (copy)
		local v70 = nil

		for v71, v72 in t2 do
			if v72.treatmentType == OmniFeedTypes.HomeGameGrid and s1 == v72.topicId then
				v70 = v71
			end
		end

		return v70 == n1
	end
end

return function(t3: {[any]: any}) -- line: 124
	-- upvalues: OmniFeedProps (copy), OmniFeedConstants (copy), parseBooleanString (copy), FFlagLuaAppRfySignalApportioningIxp (copy), FFlagLuaAppEnableWhyThisAdModal (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppRfyRevealRows (copy), u62 (ref), FFlagLuaAppSortHeaderAnchorTag (copy), FFlagLuaAppRfySignalApportioning (copy), FFlagLuaAppCompositionAlways (copy), AppPage (copy), getGameTileCollectionItemSize (copy), CollectionViews (copy), getSduiFeedStore (copy), React (copy), SignalsReact (copy), FFlagLuaAppRfyRevealRowsFocusFix (copy), ReactFocusNavigation (copy), useLocalization (copy), useSelector (copy), TopicContentsReducer (copy), u63 (ref), DiscoveryEventErrorLogger (copy), FIntGameGridFlexFeedItemTileNumPerFeed (copy), useGridFlexFeedItemBounds (copy), t1 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), Signals (copy), Cryo (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), GameCollectionItemTypes (copy), GameCollectionItemBuilder (copy), GuiService (copy), showMoreClickEvent (copy), useUpdateFeedItemRenderedRows (copy), FFlagLuaAppFixHomeGridPlaceholderFlowIssues (copy), u60 (ref), default (copy), LoggingProtocol (copy), v45 (copy), u61 (ref), GameCollectionGrid (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), FFlagLuaAppHomeTouchAutoplay (copy), v55 (copy), v54 (copy), Foundation (copy), IconName (copy), ChipSize (copy), ChipVariant (copy), PlaceholderGameGrid (copy), v40 (copy)
	local verticalScrollingFrameRef = t3[OmniFeedProps.key].verticalScrollingFrameRef
	local v75 = nil
	local v76 = nil
	local v77 = nil
	local v78 = nil
	local s2 = "Narrow"
	local v80 = nil
	local v81 = nil
	local v82 = nil
	local v83 = nil
	local v84 = nil
	local v85 = nil
	local v86 = nil
	local v87 = nil
	local v88 = nil
	local u89 = nil
	local u90 = nil
	local v91 = nil

	if t3.topicLayoutData then
		v77 = t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]

		if v77 then
			if v77 == OmniFeedConstants.ComponentTypeDataKeys.EventTile then
				s2 = "Event"
			elseif v77 == OmniFeedConstants.ComponentTypeDataKeys.GridTile then
				s2 = "Wide"
			end

			v75 = s2 == "Wide" or s2 == "Event"
		end

		v76 = t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.PlayerCountStyle]
		v78 = t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.PlayButtonStyle]
		v80 = parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HideTileMetadata])
		v81 = parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.HideTileTitle])
		v82 = parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.ContainedTile])
		v83 = parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.EnableExplicitFeedback])
		v84 = if not FFlagLuaAppRfySignalApportioningIxp then nil else parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.EnableSignalApportioning])
		v85 = if not FFlagLuaAppEnableWhyThisAdModal then nil else t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.SponsoredUserCohort]
		v86 = parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.EnableSponsoredFeedback])
		v87 = if not FFlagLuaAppEnableSponsoredReportAd then nil else parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.EnableReportAd])
		v88 = parseBooleanString(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.IsSponsoredRatingFooterAllowed])

		if FFlagLuaAppRfyRevealRows then
			u89 = u62(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.InitialVisibleRows])
			u90 = u62(t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.VisibleRowsPerReveal])
		end

		if FFlagLuaAppSortHeaderAnchorTag then
			v91 = t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.SortHeaderAnchorTag]
		end
	end

	local v92 = nil

	if t3.topicLayoutData then
		local v93 = t3.topicLayoutData[OmniFeedConstants.TopicLayoutDataKeys.IsSponsoredFooterAllowed]

		v92 = v93 ~= nil and v93 == "true"
	end

	local v94 = FFlagLuaAppRfySignalApportioning and (not FFlagLuaAppRfySignalApportioningIxp or v84)
	local appPage = t3[OmniFeedProps.key].appPage
	local v96 = not not FFlagLuaAppCompositionAlways or t3[OmniFeedProps.key].appCompositionEnabled

	assert(appPage == AppPage.Home, "component only supports the Home Page")

	local feedItemStartRow = t3[OmniFeedProps.key].feedItemStartRow
	local topicId = t3.topicId
	local feedItemPosition = t3[OmniFeedProps.key].feedItemPosition
	local sortIndex = t3.sortIndex
	local v101 = t3.topicName or ""
	local numberOfRows = t3.numberOfRows
	local v103 = if not FFlagLuaAppRfySignalApportioning then nil else t3[OmniFeedProps.key].sduiContext
	local v104 = getGameTileCollectionItemSize(s2)
	local v105 = CollectionViews.useCollectionLayout(v104)
	local v106 = if not FFlagLuaAppRfySignalApportioning then nil else getSduiFeedStore(appPage)
	local u107 = nil
	local v108 = nil

	if not FFlagLuaAppCompositionAlways then
		if FFlagLuaAppRfySignalApportioning then
			local v109 = React.useCallback(function(p2) -- line: 234
				-- upvalues: v103 (copy), v104 (copy)
				return v103.getPageLayoutConfig(v104)(p2).numColumns
			end, {
				v104,
				v103.getPageLayoutConfig
			})

			u107 = SignalsReact.useSignalState(v109)
		else
			local v110

			v110, v108 = React.useState(1)
			u107 = v110
		end
	end

	if v96 then
		u107 = v105.itemsPerRow
	end

	local u111 = nil
	local u112 = nil
	local v113 = nil
	local u114 = nil
	local v115 = nil
	local u116 = nil

	if FFlagLuaAppRfyRevealRows then
		local v117, v118 = React.useState(u89)

		u111 = v117
		u112 = v118

		if FFlagLuaAppRfyRevealRowsFocusFix then
			u114 = React.useRef(nil)
			v115 = ReactFocusNavigation.useMostRecentFocusBehavior(u114)
			u116 = ReactFocusNavigation.useFocusGuiObject()
		end

		React.useEffect(function() -- line: 265
			-- upvalues: u112 (ref), u89 (ref)
			u112(u89)
		end, {
			u89,
			t3.topicId,
			t3.sortIndex,
			t3.recommendationsRequestId
		})
		v113 = useLocalization({
			showMoreButtonText = "CommonUI.Controls.Action.ShowMore"
		})
	end

	local v119 = useSelector(function(p3) -- line: 281
		return p3.FormFactor
	end)
	local v120 = useSelector(function(p4) -- line: 285
		-- upvalues: TopicContentsReducer (copy)
		return p4.Personalization[TopicContentsReducer.key]
	end)
	local v121 = useSelector(function(p5) -- line: 289
		-- upvalues: appPage (copy)
		local v142 = p5.OmniRecommendations[appPage]

		if v142 then
			return v142.sorts
		end

		return {}
	end)
	local u122 = nil
	local u123 = nil

	if FFlagLuaAppRfyRevealRows then
		u122 = u89 ~= nil and u90 ~= nil
		u123 = if not u122 then nil else u63(v121, t3.sortIndex, t3.topicId)
		React.useEffect(function() -- line: 307
			-- upvalues: u122 (ref), u123 (ref), DiscoveryEventErrorLogger (copy), t3 (copy)
			if u122 and not u123 then
				DiscoveryEventErrorLogger.reportError("HomeGameGridRevealRowsConfiguredBeforeLastGrid", "Reveal row fields are only supported on the last HomeGameGrid sort for the topic", {
					topicId = t3.topicId,
					sortIndex = t3.sortIndex
				})
			end
		end, {
			u122,
			u123,
			t3.topicId,
			t3.sortIndex
		})
	end

	local v124 = if not numberOfRows or not (numberOfRows > 0) then math.floor(FIntGameGridFlexFeedItemTileNumPerFeed / u107) else numberOfRows
	local v125 = if not FFlagLuaAppRfySignalApportioning or FFlagLuaAppRfySignalApportioningIxp then useGridFlexFeedItemBounds(t3.topicId, feedItemPosition, u107, v124, v120 and (not not v120[topicId] and v120[topicId].entries) or t1) else nil
	local v126 = nil

	if FFlagLuaAppRfySignalApportioning then
		local u127 = v124 or 99999

		if u127 == -1 then
			u127 = 99999
		end

		React.useEffect(function() -- line: 350
			-- upvalues: u107 (ref), u127 (ref), v106 (copy), t3 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy)
			local v143 = u107 * u127

			v106.updateApportioningCapacity(t3.topicId, t3.sortIndex, v143, if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else t3.recommendationsRequestId)
		end, {
			u107,
			u127,
			t3.topicId,
			t3.sortIndex,
			v106,
			if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else t3.recommendationsRequestId
		})

		local v128 = React.useMemo(function() -- line: 370
			-- upvalues: Signals (copy), v106 (copy), t3 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), DiscoveryEventErrorLogger (copy), Cryo (copy)
			return Signals.createComputed(function(p6) -- line: 371
				-- upvalues: v106 (copy), t3 (copy), FFlagLuaAppAddRequestIdToRfySignalApportioning (copy), DiscoveryEventErrorLogger (copy), Cryo (copy)
				local v169 = v106.getApportionedItems(t3.topicId, t3.sortIndex, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else t3.recommendationsRequestId))(p6)

				if not v169 then
					return nil
				end

				local v170 = v106.getSingleGridApportioningMetadata(t3.topicId, t3.sortIndex, (if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else t3.recommendationsRequestId))(p6)
				local v171 = v170 and v170.startingItemIndex

				if not v171 and #v169 > 0 then
					DiscoveryEventErrorLogger.reportError("HomeGameGridRenderingWithMissingStartingItemIndex", "Starting item index not found in apportioning data for topicId {props.topicId} and sortIndex {props.sortIndex}, defaulting to 1", {
						topicId = t3.topicId,
						sortIndex = t3.sortIndex
					})
				end

				local t4 = {}

				for v173, v174 in v169 do
					table.insert(t4, (Cryo.Dictionary.join(v174, {
						topicContentsIndex = (v171 or 1) + v173 - 1
					})))
				end

				return t4
			end)
		end, {
			v106,
			t3.topicId,
			t3.sortIndex,
			if not FFlagLuaAppAddRequestIdToRfySignalApportioning then nil else t3.recommendationsRequestId
		})

		v126 = SignalsReact.useSignalState(v128)
	end

	local v129 = if not FFlagLuaAppRfySignalApportioning or FFlagLuaAppRfySignalApportioningIxp then React.useMemo(function() -- line: 420
		-- upvalues: topicId (copy), v120 (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), v125 (copy), u107 (ref), Cryo (copy)
		local v144 = nil

		if topicId then
			v144 = v120 and v120[topicId] or nil
		end

		local v145 = v144 and v144.entries or {}

		if v144 and v144.hasMoreRows then
			warn(`HomeGameGridFlexFeedItem may need to fetch more metadata for topicId { topicId }`)
		end

		if FFlagLuaAppEnableNxMRoduxApportioning then
			local v146 = v125 and v125.layout

			if not v146 then
				return {}
			end

			local t5 = {}
			local v148 = v125 and v125.firstIndex or 1
			local n2 = 0

			for i = 1, #v146 do
				local v151 = v146[i]

				if v151 then
					for j = 1, u107 do
						local v153 = v151[j]

						if v153 and v153 > 0 then
							local v154 = v145[v153]

							if v154 then
								t5[v153] = Cryo.Dictionary.join(v154, {
									topicContentsIndex = v148 + n2
								})
							end

							n2 += 1
						end
					end
				end
			end

			return t5
		end

		local t6 = {}
		local v156 = v125 and v125.firstIndex or 1
		local v157 = v125 and v125.entryIndices

		if v157 then
			for i, v in ipairs(v157) do
				local v160 = v145[v]

				if v160 then
					table.insert(t6, Cryo.Dictionary.join(v160, {
						topicContentsIndex = v156 + i - 1
					}))
				end
			end
		end

		return t6
	end, {
		topicId,
		v120,
		v121,
		v125,
		if not FFlagLuaAppEnableNxMRoduxApportioning then nil else u107
	}) else nil
	local v130 = if not v94 then v129 else v126
	local v131 = React.useMemo(function() -- line: 488
		-- upvalues: v130 (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), GameCollectionItemTypes (copy), GameCollectionItemBuilder (copy), u107 (ref), appPage (copy), sortIndex (copy), topicId (copy), v94 (copy), v125 (copy)
		if not v130 then
			return v130
		end

		local t7 = {}
		local t8 = {}

		if not FFlagLuaAppEnableNxMRoduxApportioning then
			for v163, v164 in v130 do
				if v164.componentType == GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile then
					t7[v163] = {
						colSpan = 2,
						rowSpan = 1,
						alignmentType = v164.alignmentType,
						minRowPadding = tonumber(v164.minRowPadding) or 0
					}
					t8[v163] = GameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
				end
			end
		end

		return GameCollectionItemBuilder.BuildCollectionEntries(v130, u107, if not FFlagLuaAppEnableNxMRoduxApportioning then t7 else nil, if not FFlagLuaAppEnableNxMRoduxApportioning then t8 else nil, nil, appPage, sortIndex, topicId, if not FFlagLuaAppEnableNxMRoduxApportioning or v94 then nil else v125 and v125.layout or nil)
	end, {
		v130,
		u107,
		appPage,
		sortIndex,
		topicId,
		if not FFlagLuaAppEnableNxMRoduxApportioning then nil else v94,
		if not FFlagLuaAppEnableNxMRoduxApportioning or v94 then nil else v125
	})
	local u132 = nil

	if v94 and v131 or not v94 and v125 then
		u132 = if not FFlagLuaAppEnableNxMRoduxApportioning or (v94 or (not v125 or not v125.layout)) then math.ceil(#v131 / u107) else #v125.layout
	end

	local v133 = nil
	local v134 = nil
	local v135 = nil
	local v136 = nil

	if FFlagLuaAppRfyRevealRows then
		v133 = u122 and (u123 and (u132 ~= nil and u111 ~= nil))
		v134 = if not v133 then u132 else math.min(u111, u132)
		v135 = v133 and v134 < u132
		v136 = React.useCallback(function() -- line: 562
			-- upvalues: u111 (ref), u132 (ref), u90 (ref), DiscoveryEventErrorLogger (copy), t3 (copy), FFlagLuaAppRfyRevealRowsFocusFix (copy), GuiService (copy), u114 (ref), u116 (ref), u112 (ref), showMoreClickEvent (copy), appPage (copy)
			if u111 == nil or (u132 == nil or u90 == nil) then
				DiscoveryEventErrorLogger.reportError("HomeGameGridRevealMoreMissingRowData", "Unable to reveal more HomeGameGrid rows because row data was missing", {
					topicId = t3.topicId,
					sortIndex = t3.sortIndex,
					hasVisibleRows = u111 ~= nil,
					hasActualNumberOfRows = u132 ~= nil,
					hasVisibleRowsPerReveal = u90 ~= nil
				})

				return
			end

			local v165 = u111
			local v166 = math.min(u111 + u90, u132)

			if FFlagLuaAppRfyRevealRowsFocusFix and GuiService.SelectedCoreObject ~= nil then
				local current = u114.current

				if current and u116 then
					u116(current)
				end
			end

			u112(v166)
			showMoreClickEvent(appPage, {
				topicId = t3.topicId,
				sortIndex = t3.sortIndex,
				previousVisibleRows = v165,
				newVisibleRows = v166,
				totalNumberOfRows = u132,
				visibleRowsPerReveal = u90
			})
		end, {
			u111,
			u132,
			u90,
			t3.topicId,
			t3.sortIndex,
			appPage,
			if not FFlagLuaAppRfyRevealRowsFocusFix then nil else u116
		})
	end

	useUpdateFeedItemRenderedRows(appPage, nil, feedItemPosition, if not FFlagLuaAppFixHomeGridPlaceholderFlowIssues then if not FFlagLuaAppRfyRevealRows then u132 else v134 else ((if not FFlagLuaAppRfyRevealRows then u132 else v134)) or -1)

	if (not v94 or v131) and #v131 > 0 then
		if FFlagLuaAppRfySignalApportioning and u60 then
			default:logRobloxTelemetryCounter({
				eventName = "HomeGameGridReturnedGridAfterNil",
				backends = { LoggingProtocol.TelemetryBackends.Counter }
			}, 1, {
				experimentTreatment = if v84 ~= true then v84 ~= false and "not_in_experiment" or "control" else "signal_apportioning_treatment"
			})
			u60 = false
		end

		if v45 and u61 then
			default:logRobloxTelemetryCounter({
				eventName = "HomeGameGridReturnedGridAfterPlaceholder",
				backends = { LoggingProtocol.TelemetryBackends.Counter }
			}, 1, {
				experimentTreatment = if v84 ~= true then v84 ~= false and "not_in_experiment" or "control" else "signal_apportioning_treatment"
			})
			u61 = false
		end

		local v137 = React.createElement(GameCollectionGrid, {
			entries = v131,
			title = v101,
			friendFooterEnabled = true,
			sortIndex = sortIndex,
			gameSortId = topicId,
			pageContext = appPage,
			onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t3[OmniFeedProps.key].onTileImageLoaded,
			scrollViewPositionChangedSignal = t3[OmniFeedProps.key].scrollViewPositionChangedSignal,
			onItemsPerRowChanged = if not v96 then v108 else nil,
			useGridTiles = v75,
			playerCountStyle = v76,
			isSponsoredFooterAllowed = v92,
			componentType = v77,
			gameTileLayoutType = s2,
			gridSupportAllowed = true,
			isHoverSupportEnabled = true,
			verticalScrollingFrameRef = verticalScrollingFrameRef,
			gridContainerRef = if not FFlagLuaAppRfyRevealRowsFocusFix then nil else v115,
			startRow = feedItemStartRow,
			LayoutOrder = if not FFlagLuaAppRfyRevealRows or not v133 then nil else 1,
			ZIndex = if not FFlagLuaAppRfyRevealRows or not v133 then nil else 2,
			maxNumRows = if not FFlagLuaAppRfyRevealRows or not v133 then if not numberOfRows or not (numberOfRows > 0) then nil else numberOfRows else v134,
			playButtonStyle = v78,
			sideMargin = if not v96 then if v119 ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING else nil,
			appCompositionEnabled = v96,
			shouldHideTileMetadata = v80,
			shouldHideTileTitle = v81,
			containedTile = v82,
			numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
			selectionOrderBase = t3[OmniFeedProps.key].selectionOrderBase,
			enableExplicitFeedback = v83,
			sponsoredUserCohort = if not FFlagLuaAppEnableWhyThisAdModal then nil else v85,
			enableSponsoredFeedback = v86,
			enableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else v87,
			isSponsoredRatingFooterAllowed = v88,
			videoPlaybackContext = if not FFlagLuaAppHomeTouchAutoplay then nil else t3[OmniFeedProps.key].videoPlaybackContext,
			headerTag = if not FFlagLuaAppSortHeaderAnchorTag then nil else v91
		})

		if FFlagLuaAppRfyRevealRows and v133 then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, v55)
				}),
				GameGrid = v137,
				RevealMoreButton = if not v135 then nil else if not v54 then React.createElement(Foundation.Chip, {
					LayoutOrder = 2,
					ZIndex = 1,
					text = v113.showMoreButtonText,
					trailing = IconName.ChevronLargeDown,
					size = ChipSize.Large,
					onActivated = v136
				}) else React.createElement(Foundation.View, {
					tag = "row align-y-center gap-xsmall size-full-0 auto-y",
					LayoutOrder = 2,
					ZIndex = 1
				}, {
					LeadingLine = React.createElement(Foundation.View, {
						tag = "grow",
						LayoutOrder = 1
					}, {
						Divider = React.createElement(Foundation.Divider)
					}),
					ButtonOutline = React.createElement(Foundation.View, {
						tag = "auto-xy stroke-default radius-circle",
						LayoutOrder = 2
					}, {
						Chip = React.createElement(Foundation.Chip, {
							text = v113.showMoreButtonText,
							trailing = IconName.ChevronLargeDown,
							size = ChipSize.Large,
							variant = ChipVariant.Utility,
							onActivated = v136
						})
					}),
					TrailingLine = React.createElement(Foundation.View, {
						tag = "grow",
						LayoutOrder = 3
					}, {
						Divider = React.createElement(Foundation.Divider)
					})
				})
			})
		end

		return v137
	end

	if v94 and v131 == nil or not v94 and v125 == nil then
		if FFlagLuaAppRfySignalApportioning and not u61 then
			default:logRobloxTelemetryCounter({
				eventName = "HomeGameGridReturnedPlaceholder",
				backends = { LoggingProtocol.TelemetryBackends.Counter }
			}, 1, {
				experimentTreatment = if v84 ~= true then v84 ~= false and "not_in_experiment" or "control" else "signal_apportioning_treatment"
			})
			u61 = true
		end

		return (React.createElement(PlaceholderGameGrid, {
			gridSupportAllowed = true,
			isHoverSupportEnabled = true,
			title = v101,
			onItemsPerRowChanged = if not v96 then v108 else nil,
			appCompositionEnabled = v96,
			useGridTiles = v75,
			componentType = v77,
			gameTileLayoutType = s2,
			numRows = if not v40 then numberOfRows or 0 else v124,
			sideMargin = if not v96 then if v119 ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING else nil,
			verticalScrollingFrameRef = verticalScrollingFrameRef,
			shouldHideTileMetadata = v80,
			shouldHideTileTitle = v81,
			containedTile = v82
		}))
	end

	if FFlagLuaAppRfySignalApportioning and not u60 then
		default:logRobloxTelemetryCounter({
			eventName = "HomeGameGridReturnedNil",
			backends = { LoggingProtocol.TelemetryBackends.Counter }
		}, 1, {
			experimentTreatment = if v84 ~= true then v84 ~= false and "not_in_experiment" or "control" else "signal_apportioning_treatment"
		})
		u60 = true
	end

	return nil
end
