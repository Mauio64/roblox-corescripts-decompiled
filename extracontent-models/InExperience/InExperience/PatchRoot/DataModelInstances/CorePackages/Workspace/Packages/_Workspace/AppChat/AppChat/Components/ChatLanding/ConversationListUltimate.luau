local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatPerfExperimentation = require(AppChatParent.SocialExperiments).AppChatPerfExperimentation
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local CoreGui = require(AppChatParent.ReactFocusNavigation).EngineInterface.CoreGui
local Cryo = require(AppChatParent.Cryo)
local FocusNavigationService = require(AppChatParent.ReactFocusNavigation).FocusNavigationService
local React = require(AppChatParent.React)
local SharedFlags = require(AppChatParent.SharedFlags)
local Signal = require(AppChatParent.AppCommonLib).Signal
local SocialCarousel = require(AppChatParent.SocialCarousel)
local SocialExperiments = require(AppChatParent.SocialExperiments)
local Foundation = require(AppChatParent.Foundation)
local UltimateList = require(AppChatParent.UltimateList)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createScrollIntervalTracker = require(AppChat.Telemetry.createScrollIntervalTracker)
local Constants = SocialCarousel.Constants
local Enums = SocialCarousel.Enums
local SquadQuickStartExperimentation = SocialExperiments.SquadQuickStartExperimentation
local ChatLandingModalContainer = require(script.Parent.ChatLandingModal.ChatLandingModalContainer)
local ConversationRow = require(script.Parent.ConversationRow)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local PartyQuickStartContainer = require(script.Parent.PartyQuickStartContainer)
local v28 = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local v30 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)
local FFlagAppChatRemoveConversationListDividerIxpEnabled = require(AppChat.Flags.FFlagAppChatRemoveConversationListDividerIxpEnabled)
local FStringAppChatRemoveConversationListDividerIxpLayer = require(AppChat.Flags.FStringAppChatRemoveConversationListDividerIxpLayer)
local v33 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)
local v34 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local v36 = require(script.Parent.Logger):new(script.Name)

local function noop() -- line: 55
end
local function isPartyQuickStartEnabled(p1) -- line: 57
	return p1.isPartyQuickStartEnabled
end
local function getIsSquadEnabledForRows(p2) -- line: 61
	return p2.canAccessParty == true
end
local function getConversationRowListItems(p3) -- line: 65
	local t1 = {}

	for v51, v52 in p3 do
		t1[v51] = {
			id = tostring(v52.id)
		}
	end

	return t1
end
local function getFirstId(p4) -- line: 75
	if p4 and p4[1] then
		return p4[1].id
	end

	return nil
end
local function getLastId(p5) -- line: 79
	if p5 and p5[#p5] then
		return p5[#p5].id
	end

	return nil
end
local function getAutoLoadNextRequestKey(p6) -- line: 83
	return `{ #p6 }:{ tostring((if not p6 or not p6[1] then nil else p6[1].id)) }:{ tostring((if not p6 or not p6[#p6] then nil else p6[#p6].id)) }`
end
local function getKey(p7) -- line: 87
	return (tostring(p7.id))
end
local function MeasuredChatLandingModal(p8) -- line: 91
	-- upvalues: React (copy), ChatLandingModalContainer (copy)
	local v58 = React.useRef(nil)

	React.useEffect(function() -- line: 94
		-- upvalues: v58 (copy), p8 (copy)
		local current = v58.current

		if current ~= nil then
			p8.onHeightChanged(p8.itemId, current.AbsoluteSize.Y)
		end
	end, {
		p8.itemId,
		p8.onHeightChanged
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = v58,
		[React.Change.AbsoluteSize] = function(p9) -- line: 106
			-- upvalues: p8 (copy)
			p8.onHeightChanged(p8.itemId, p9.AbsoluteSize.Y)
		end
	}, {
		ChatLandingModal = React.createElement(ChatLandingModalContainer, {})
	})
end
local function ConversationListUltimate(p10) -- line: 114
	-- upvalues: noop (copy), React (copy), Signal (copy), useTokens (copy), Cryo (copy), AppChatPerfExperimentation (copy), PartyPageCarouselExperimentation (copy), SquadQuickStartExperimentation (copy), FFlagAppChatRemoveConversationListDividerIxpEnabled (copy), IXPService (copy), FStringAppChatRemoveConversationListDividerIxpLayer (copy), FocusNavigationService (copy), CoreGui (copy), FFlagAppChatPerfTracking (copy), createScrollIntervalTracker (copy), AppChatPerfTracker (copy), AppPage (copy), Constants (copy), Enums (copy), getConversationRowListItems (copy), FFlagAppIaScrollAway (copy), v28 (copy), v30 (copy), v36 (copy), v34 (copy), MeasuredChatLandingModal (copy), ConversationGroupsEntryContainer (copy), PartyQuickStartContainer (copy), SocialCarousel (copy), View (copy), ConversationRow (copy), UltimateList (copy), getKey (copy), v33 (copy)
	local v60 = p10.entryHeight or 64
	local v61 = p10.itemList or {}
	local v62 = p10.Size or UDim2.fromScale(1, 1)
	local v63 = p10.LayoutOrder or 1
	local v64 = p10.onScrollUpdate or noop
	local v65 = p10.navigateToConversationFromUserId or noop
	local v66 = p10.navigateToQuickStartSquadInviteFriends or noop
	local v67 = p10.navigateToSquadLobby or noop
	local v68 = p10.fireConversationImpressionEvent or noop
	local v69 = p10.fireConversationClickedEvent or noop
	local v70 = p10.showHeaderEntries ~= false
	local v71 = p10.rowProps or {}
	local v72 = React.useMemo(function() -- line: 127
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v73 = React.useRef(nil)
	local v74 = React.useRef(nil)
	local v75 = React.useRef(nil)
	local v76 = React.useRef(0)
	local v77 = React.useMemo(function() -- line: 134
		-- upvalues: v61 (copy)
		local v107 = v61

		return `{ #v107 }:{ tostring((if not v107 or not v107[1] then nil else v107[1].id)) }:{ tostring((if not v107 or not v107[#v107] then nil else v107[#v107].id)) }`
	end, { v61 })
	local v78 = React.useRef(nil)
	local v79 = React.useRef(false)
	local v80, v81 = React.useState(Vector2.new(0, 0))
	local v82, v83 = React.useState(nil)
	local v84 = useTokens()
	local v85, v86 = React.useState({})
	local v87 = React.useCallback(function(p11, p12) -- line: 143
		-- upvalues: v86 (copy), Cryo (copy)
		if p12 < 0 then
			return
		end

		v86(function(p13) -- line: 148
			-- upvalues: p11 (copy), p12 (copy), Cryo (copy)
			if p13[p11] == p12 then
				return p13
			end

			return Cryo.Dictionary.join(p13, {
				[p11] = p12
			})
		end)
	end, {})
	local v88 = p10.loadNext ~= nil and (not p10.isLoadingNext and not p10.oldestConversationIsFetched)

	React.useEffect(function() -- line: 159
		-- upvalues: v79 (copy), p10 (copy), v78 (copy)
		if v79.current and not p10.isLoadingNext then
			v78.current = nil
		end

		v79.current = p10.isLoadingNext == true
	end, { p10.isLoadingNext })

	local v89 = React.useCallback(function() -- line: 167
		-- upvalues: v88 (copy), v78 (copy), v77 (copy), p10 (copy)
		if not v88 or v78.current == v77 then
			return false
		end

		v78.current = v77
		p10.loadNext()

		return true
	end, {
		v88,
		v77,
		p10.loadNext
	})

	React.useEffect(function() -- line: 179
		-- upvalues: AppChatPerfExperimentation (copy), p10 (copy), PartyPageCarouselExperimentation (copy), SquadQuickStartExperimentation (copy), FFlagAppChatRemoveConversationListDividerIxpEnabled (copy), IXPService (copy), FStringAppChatRemoveConversationListDividerIxpLayer (copy)
		AppChatPerfExperimentation.logExposure()

		if p10.shouldLogHeaderEntryExposures ~= false then
			PartyPageCarouselExperimentation.logExposure()

			if SquadQuickStartExperimentation.isLogExposureEnabled then
				SquadQuickStartExperimentation.logExposure()
			end

			if FFlagAppChatRemoveConversationListDividerIxpEnabled then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatRemoveConversationListDividerIxpLayer)
			end
		end
	end, {})
	React.useEffect(function() -- line: 193
		-- upvalues: FocusNavigationService (copy), CoreGui (copy)
		local v110 = FocusNavigationService.new(CoreGui)

		return function() -- line: 195
			-- upvalues: v110 (copy)
			v110:teardown()
		end
	end, {})

	local v90 = p10.canAccessParty == true

	React.useEffect(function() -- line: 202
		-- upvalues: v82 (copy), FFlagAppChatPerfTracking (copy), v73 (copy), createScrollIntervalTracker (copy), AppChatPerfTracker (copy)
		local v111 = v82

		if v111 == nil then
			return nil
		end

		v111.Selectable = false

		if FFlagAppChatPerfTracking then
			v73.current = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v111)

			return function() -- line: 213
				-- upvalues: v73 (copy)
				if v73.current then
					v73.current.cleanup()
					v73.current = nil
				end
			end
		end

		return nil
	end, { v82 })

	local isPartyQuickStartEnabled2 = p10.isPartyQuickStartEnabled
	local v92 = React.useMemo(function() -- line: 225
		-- upvalues: AppPage (copy), p10 (copy), Constants (copy), v72 (copy)
		return {
			sortId = 0,
			sortIndex = 1,
			appPage = AppPage.Chat,
			impressionTag = if not p10.isInExperience then Constants.ANALYTICS.SRC.PARTY_PAGE_UA else Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP,
			scrollViewPositionChangedSignal = v72
		}
	end, {
		p10.isInExperience,
		v72
	})
	local v93 = React.useCallback(function(p14) -- line: 237
		-- upvalues: v65 (copy)
		v65(p14.id)
	end, { v65 })
	local v94 = React.useMemo(function() -- line: 241
		-- upvalues: Enums (copy), v66 (copy), v93 (copy)
		return {
			{
				tileGroup = Enums.TileGroup.StartSquad,
				onActivated = v66
			},
			{
				tileGroup = Enums.TileGroup.FriendsList,
				onActivated = v93
			}
		}
	end, {
		v66,
		v93
	})
	local v95 = React.useMemo(function() -- line: 255
		-- upvalues: getConversationRowListItems (copy), v61 (copy), p10 (copy), v70 (copy), Cryo (copy), PartyPageCarouselExperimentation (copy), isPartyQuickStartEnabled2 (copy), FFlagAppIaScrollAway (copy)
		local v113 = getConversationRowListItems(v61)
		local v114 = p10.filterText == "" or p10.filterText == nil
		local v115 = v70 and v114

		if v115 and p10.showGroupsLink then
			v113 = Cryo.List.join({{
				id = "ConversationGroupsEntryContainer",
				isGroupLink = true
			}}, v113)
		end

		if v115 and not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and isPartyQuickStartEnabled2 then
			v113 = Cryo.List.join({{
				id = "PartyQuickStartContainer",
				isQuickStartLink = true
			}}, v113)
		end

		if v115 then
			if isPartyQuickStartEnabled2 and PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and (p10.isWideMode or not p10.isInExperience) then
				v113 = Cryo.List.join({{
					id = "SocialCarousel",
					isSocialCarousel = true
				}}, v113)
			end

			v113 = Cryo.List.join({{
				id = "UnfilteredThreadsFtux",
				isChatLandingModal = true
			}}, v113)
		end

		if FFlagAppIaScrollAway and (p10.canvasTopPadding or 0) > 0 then
			v113 = Cryo.List.join({{
				id = "CanvasTopPadding",
				isCanvasTopPadding = true,
				height = p10.canvasTopPadding
			}}, v113)
		end

		return v113
	end, {
		v61,
		p10.filterText,
		p10.showGroupsLink,
		p10.isWideMode,
		p10.isInExperience,
		p10.canvasTopPadding,
		v70,
		isPartyQuickStartEnabled2
	})
	local v96 = React.useMemo(function() -- line: 328
		-- upvalues: v95 (copy), v85 (copy), FFlagAppIaScrollAway (copy), v60 (copy), Cryo (copy)
		local t2 = {}
		local n1 = 0

		for v118, v119 in v95 do
			local v120 = if not v119.isChatLandingModal then if not FFlagAppIaScrollAway or not v119.isCanvasTopPadding then v60 else v119.height else v85[v119.id] or 200

			t2[v118] = Cryo.Dictionary.join(v119, {
				height = v120,
				yOffset = n1
			})
			n1 += v120
		end

		return {
			items = t2,
			contentHeight = n1
		}
	end, {
		v95,
		v60,
		v85
	})

	React.useEffect(function() -- line: 351
		-- upvalues: v88 (copy), v76 (copy), v28 (copy), v61 (copy), v30 (copy), v89 (copy), v36 (copy)
		if v88 and (v76.current < v28 and #v61 < v30) then
			local v121 = v76.current + 1

			if v89() then
				v76.current = v121
				v36:info("Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})", #v61, v30, v76.current, v28)
			end
		end
	end, {
		v61,
		v88,
		v89
	})
	React.useEffect(function() -- line: 371
		-- upvalues: v88 (copy), v96 (copy), v80 (copy), v89 (copy), v36 (copy)
		if v88 and (v96.contentHeight > 0 and v80.Y > 0 and v96.contentHeight <= v80.Y and v89()) then
			v36:info("Not enough UltimateList content to fill the view, loading more conversations")
		end
	end, {
		v96.contentHeight,
		v80.Y,
		v88,
		v89
	})

	local v97 = React.useCallback(function() -- line: 379
		-- upvalues: v89 (copy), v36 (copy)
		if v89() then
			v36:debug("UltimateList onEndReached - Loading more conversations")
		end
	end, { v89 })
	local v98 = React.useCallback(function() -- line: 385
		-- upvalues: p10 (copy), v36 (copy)
		if p10.loadPrevious and not p10.isLoadingPrevious then
			v36:debug("UltimateList onStartReached - Loading previous conversations")
			p10.loadPrevious()
		end
	end, {
		p10.loadPrevious,
		p10.isLoadingPrevious
	})
	local v99 = React.useCallback(function(p15) -- line: 392
		-- upvalues: v81 (copy)
		v81(p15)
	end, {})
	local v100 = React.useCallback(function(p16) -- line: 396
		-- upvalues: FFlagAppChatPerfTracking (copy), v73 (copy), v72 (copy), v60 (copy), v34 (copy), v96 (copy), v80 (copy), v89 (copy), v64 (copy)
		if FFlagAppChatPerfTracking and v73.current then
			v73.current.onScrollTick()
		end

		v72:fire()

		if v60 * v34 >= v96.contentHeight - v80.Y - p16 then
			v89()
		end

		v64({
			CanvasPosition = Vector2.new(0, p16)
		})
	end, {
		v72,
		v64,
		v60,
		v96.contentHeight,
		v80.Y,
		v89
	})
	local v101 = React.useCallback(function(p17) -- line: 422
		-- upvalues: v74 (copy), v83 (copy)
		v74.current = p17
		v83(p17)
	end, {})
	local v102 = if not v61 or not v61[1] then nil else v61[1].id

	React.useEffect(function() -- line: 428
		-- upvalues: v74 (copy), v102 (copy), v75 (copy)
		local current = v74.current

		if current ~= nil and (v102 ~= nil and v75.current ~= nil and v75.current ~= v102 and current.CanvasPosition.Y <= 33) then
			current.CanvasPosition = Vector2.new(0, 0)
		end

		v75.current = v102
	end, { v102 })

	local v103 = React.useCallback(function(p18) -- line: 444
		-- upvalues: React (copy), MeasuredChatLandingModal (copy), v87 (copy), ConversationGroupsEntryContainer (copy), v60 (copy), isPartyQuickStartEnabled2 (copy), PartyQuickStartContainer (copy), PartyPageCarouselExperimentation (copy), SocialCarousel (copy), v94 (copy), p10 (copy), Constants (copy), v92 (copy), FFlagAppIaScrollAway (copy), View (copy), v84 (copy), ConversationRow (copy), v90 (copy), v67 (copy), v68 (copy), v69 (copy), v71 (copy)
		if p18.isChatLandingModal then
			return React.createElement(MeasuredChatLandingModal, {
				itemId = p18.id,
				onHeightChanged = v87
			})
		end

		if p18.isGroupLink then
			return React.createElement(ConversationGroupsEntryContainer, {
				entryHeight = v60
			})
		end

		if isPartyQuickStartEnabled2 and p18.isQuickStartLink then
			return React.createElement(PartyQuickStartContainer, {
				entryHeight = v60
			})
		end

		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and p18.isSocialCarousel then
			return React.createElement(SocialCarousel.Entry, {
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				customTileList = v94,
				source = if not p10.isInExperience then Constants.ANALYTICS.SRC.PARTY_PAGE_UA else Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP,
				unifiedLogging = v92
			})
		end

		if FFlagAppIaScrollAway and p18.isCanvasTopPadding then
			return React.createElement(View, {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, p18.height),
				backgroundStyle = v84.Color.None
			})
		end

		return React.createElement(ConversationRow, {
			entryHeight = v60,
			conversationId = p18.id,
			isSquadEnabled = v90,
			isWideMode = p10.isWideMode,
			onActivated = p10.onActivated,
			onSquadJoinButtonActivated = v67,
			key = "ConversationEntry" .. tostring(p18.id),
			fireImpressionEvent = v68,
			fireClickEvent = v69,
			showBackground = v71.showBackground,
			localUserId = p10.localUserId,
			debugCellValue = if not p10.isDebugEnabled then nil else tostring(p18.id)
		})
	end, {
		v60,
		v90,
		isPartyQuickStartEnabled2,
		v94,
		p10.isInExperience,
		v92,
		p10.onActivated,
		v67,
		v68,
		v69,
		v71,
		p10.isDebugEnabled,
		p10.localUserId,
		p10.isWideMode,
		v87,
		v84
	})

	if #v95 == 0 then
		return React.createElement(View, {
			BorderSizePixel = 0,
			Size = v62,
			backgroundStyle = v84.Color.None,
			LayoutOrder = v63
		})
	end

	local v104 = if not (v80.X > 0) and not (v80.Y > 0) then {} else v96.items

	return React.createElement(View, {
		BorderSizePixel = 0,
		Size = v62,
		backgroundStyle = v84.Color.None,
		LayoutOrder = v63
	}, {
		scroller = React.createElement(UltimateList.Components.ScrollingFrame, {
			direction = "y",
			dataSource = UltimateList.DataSources.array(v104),
			dimensions = UltimateList.Dimensions.getter(function(p19) -- line: 539
				return {
					size = UDim2.new(1, 0, 0, p19.height),
					position = UDim2.fromOffset(0, p19.yOffset)
				}
			end),
			renderer = UltimateList.Renderers.byState(v103),
			getKey = getKey,
			scrollingFrameRef = v101,
			onAbsoluteWindowSizeChanged = v99,
			onScrollAxisChanged = v100,
			onStartReached = v98,
			onEndReached = v97,
			onStartReachedThreshold = v60 * v33,
			onEndReachedThreshold = v60 * v34,
			native = {
				Name = "RCTScrollView",
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				BorderSizePixel = 0
			}
		})
	})
end

return React.memo(ConversationListUltimate)
