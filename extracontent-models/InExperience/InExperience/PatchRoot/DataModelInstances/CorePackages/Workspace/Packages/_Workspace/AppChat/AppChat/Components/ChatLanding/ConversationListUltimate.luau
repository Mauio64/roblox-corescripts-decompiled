local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatPerfExperimentation = require(AppChatParent.SocialExperiments).AppChatPerfExperimentation
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local CoreGui = require(AppChatParent.ReactFocusNavigation).EngineInterface.CoreGui
local Cryo = require(AppChatParent.Cryo)
local FocusNavigationService = require(AppChatParent.ReactFocusNavigation).FocusNavigationService
local React = require(AppChatParent.React)
local ReactOtter = require(AppChatParent.ReactOtter)
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
local v29 = game:DefineFastInt("AppChatChatLandingInitialFetchLimit", 5)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagFriendsChatConversationListShowScrollBar = SharedFlags.FFlagFriendsChatConversationListShowScrollBar
local v32 = game:DefineFastInt("AppChatChatLandingInitialFetchMinimumConversations", 30)
local FFlagAppChatRemoveConversationListDividerIxpEnabled = require(AppChat.Flags.FFlagAppChatRemoveConversationListDividerIxpEnabled)
local FStringAppChatRemoveConversationListDividerIxpLayer = require(AppChat.Flags.FStringAppChatRemoveConversationListDividerIxpLayer)
local v35 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnStartReachedUnits", 1)
local v36 = game:DefineFastInt("AppChatPerfChatLandingPaginationOnEndReachedUnits", 10)
local v37 = game:DefineFastInt("AppChatConversationListScrollBarIdleHideMs", 1500)
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local v39 = require(script.Parent.Logger):new(script.Name)
local v40 = v37 / 1000
local t1 = {
	dampingRatio = 1,
	frequency = 2,
	restingVelocityLimit = 0.1,
	restingPositionLimit = 0.1
}

local function noop() -- line: 67
end
local function isPartyQuickStartEnabled(p1) -- line: 69
	return p1.isPartyQuickStartEnabled
end
local function getIsSquadEnabledForRows(p2) -- line: 73
	return p2.canAccessParty == true
end
local function getConversationRowListItems(p3) -- line: 77
	local t2 = {}

	for v56, v57 in p3 do
		t2[v56] = {
			id = tostring(v57.id)
		}
	end

	return t2
end
local function getFirstId(p4) -- line: 87
	if p4 and p4[1] then
		return p4[1].id
	end

	return nil
end
local function getLastId(p5) -- line: 91
	if p5 and p5[#p5] then
		return p5[#p5].id
	end

	return nil
end
local function getAutoLoadNextRequestKey(p6) -- line: 95
	return `{ #p6 }:{ tostring((if not p6 or not p6[1] then nil else p6[1].id)) }:{ tostring((if not p6 or not p6[#p6] then nil else p6[#p6].id)) }`
end
local function getKey(p7) -- line: 99
	return (tostring(p7.id))
end
local function MeasuredChatLandingModal(p8) -- line: 103
	-- upvalues: React (copy), ChatLandingModalContainer (copy)
	local v63 = React.useRef(nil)

	React.useEffect(function() -- line: 106
		-- upvalues: v63 (copy), p8 (copy)
		local current = v63.current

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
		ref = v63,
		[React.Change.AbsoluteSize] = function(p9) -- line: 118
			-- upvalues: p8 (copy)
			p8.onHeightChanged(p8.itemId, p9.AbsoluteSize.Y)
		end
	}, {
		ChatLandingModal = React.createElement(ChatLandingModalContainer, {})
	})
end
local function ConversationListUltimate(p10) -- line: 126
	-- upvalues: noop (copy), React (copy), Signal (copy), FFlagFriendsChatConversationListShowScrollBar (copy), ReactOtter (copy), useTokens (copy), Cryo (copy), AppChatPerfExperimentation (copy), PartyPageCarouselExperimentation (copy), SquadQuickStartExperimentation (copy), FFlagAppChatRemoveConversationListDividerIxpEnabled (copy), IXPService (copy), FStringAppChatRemoveConversationListDividerIxpLayer (copy), FocusNavigationService (copy), CoreGui (copy), FFlagAppChatPerfTracking (copy), createScrollIntervalTracker (copy), AppChatPerfTracker (copy), AppPage (copy), Constants (copy), Enums (copy), getConversationRowListItems (copy), FFlagAppIaScrollAway (copy), v29 (copy), v32 (copy), v39 (copy), v40 (copy), t1 (copy), v36 (copy), MeasuredChatLandingModal (copy), ConversationGroupsEntryContainer (copy), PartyQuickStartContainer (copy), SocialCarousel (copy), View (copy), ConversationRow (copy), UltimateList (copy), getKey (copy), v35 (copy)
	local v65 = p10.entryHeight or 64
	local v66 = p10.itemList or {}
	local v67 = p10.Size or UDim2.fromScale(1, 1)
	local v68 = p10.LayoutOrder or 1
	local v69 = p10.onScrollUpdate or noop
	local v70 = p10.navigateToConversationFromUserId or noop
	local v71 = p10.navigateToQuickStartSquadInviteFriends or noop
	local v72 = p10.navigateToSquadLobby or noop
	local v73 = p10.fireConversationImpressionEvent or noop
	local v74 = p10.fireConversationClickedEvent or noop
	local v75 = p10.showHeaderEntries ~= false
	local v76 = p10.rowProps or {}
	local v77 = React.useMemo(function() -- line: 139
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v78 = React.useRef(nil)
	local v79 = React.useRef(nil)
	local u80 = nil
	local v81 = nil
	local u82 = nil

	if FFlagFriendsChatConversationListShowScrollBar then
		u80 = React.useRef(nil)

		local v83

		v81, v83 = ReactOtter.useAnimatedBinding(1)
		u82 = v83
	end

	local v84 = React.useRef(nil)
	local v85 = React.useRef(0)
	local v86 = React.useMemo(function() -- line: 153
		-- upvalues: v66 (copy)
		local v118 = v66

		return `{ #v118 }:{ tostring((if not v118 or not v118[1] then nil else v118[1].id)) }:{ tostring((if not v118 or not v118[#v118] then nil else v118[#v118].id)) }`
	end, { v66 })
	local v87 = React.useRef(nil)
	local v88 = React.useRef(false)
	local v89, v90 = React.useState(Vector2.new(0, 0))
	local v91, v92 = React.useState(nil)
	local v93 = useTokens()
	local v94, v95 = React.useState({})
	local v96 = React.useCallback(function(p11, p12) -- line: 162
		-- upvalues: v95 (copy), Cryo (copy)
		if p12 < 0 then
			return
		end

		v95(function(p13) -- line: 167
			-- upvalues: p11 (copy), p12 (copy), Cryo (copy)
			if p13[p11] == p12 then
				return p13
			end

			return Cryo.Dictionary.join(p13, {
				[p11] = p12
			})
		end)
	end, {})
	local v97 = p10.loadNext ~= nil and (not p10.isLoadingNext and not p10.oldestConversationIsFetched)

	React.useEffect(function() -- line: 178
		-- upvalues: v88 (copy), p10 (copy), v87 (copy)
		if v88.current and not p10.isLoadingNext then
			v87.current = nil
		end

		v88.current = p10.isLoadingNext == true
	end, { p10.isLoadingNext })

	local v98 = React.useCallback(function() -- line: 186
		-- upvalues: v97 (copy), v87 (copy), v86 (copy), p10 (copy)
		if not v97 or v87.current == v86 then
			return false
		end

		v87.current = v86
		p10.loadNext()

		return true
	end, {
		v97,
		v86,
		p10.loadNext
	})

	React.useEffect(function() -- line: 198
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
	React.useEffect(function() -- line: 212
		-- upvalues: FocusNavigationService (copy), CoreGui (copy)
		local v121 = FocusNavigationService.new(CoreGui)

		return function() -- line: 214
			-- upvalues: v121 (copy)
			v121:teardown()
		end
	end, {})

	local v99 = p10.canAccessParty == true

	React.useEffect(function() -- line: 221
		-- upvalues: v91 (copy), FFlagAppChatPerfTracking (copy), v78 (copy), createScrollIntervalTracker (copy), AppChatPerfTracker (copy)
		local v122 = v91

		if v122 == nil then
			return nil
		end

		v122.Selectable = false

		if FFlagAppChatPerfTracking then
			v78.current = createScrollIntervalTracker(AppChatPerfTracker.Events.ScrollConversationList, v122)

			return function() -- line: 232
				-- upvalues: v78 (copy)
				if v78.current then
					v78.current.cleanup()
					v78.current = nil
				end
			end
		end

		return nil
	end, { v91 })

	local isPartyQuickStartEnabled2 = p10.isPartyQuickStartEnabled
	local v101 = React.useMemo(function() -- line: 244
		-- upvalues: AppPage (copy), p10 (copy), Constants (copy), v77 (copy)
		return {
			sortId = 0,
			sortIndex = 1,
			appPage = AppPage.Chat,
			impressionTag = if not p10.isInExperience then Constants.ANALYTICS.SRC.PARTY_PAGE_UA else Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP,
			scrollViewPositionChangedSignal = v77
		}
	end, {
		p10.isInExperience,
		v77
	})
	local v102 = React.useCallback(function(p14) -- line: 256
		-- upvalues: v70 (copy)
		v70(p14.id)
	end, { v70 })
	local v103 = React.useMemo(function() -- line: 260
		-- upvalues: Enums (copy), v71 (copy), v102 (copy)
		return {
			{
				tileGroup = Enums.TileGroup.StartSquad,
				onActivated = v71
			},
			{
				tileGroup = Enums.TileGroup.FriendsList,
				onActivated = v102
			}
		}
	end, {
		v71,
		v102
	})
	local v104 = React.useMemo(function() -- line: 274
		-- upvalues: getConversationRowListItems (copy), v66 (copy), p10 (copy), v75 (copy), Cryo (copy), PartyPageCarouselExperimentation (copy), isPartyQuickStartEnabled2 (copy), FFlagAppIaScrollAway (copy)
		local v124 = getConversationRowListItems(v66)
		local v125 = p10.filterText == "" or p10.filterText == nil
		local v126 = v75 and v125

		if v126 and p10.showGroupsLink then
			v124 = Cryo.List.join({{
				id = "ConversationGroupsEntryContainer",
				isGroupLink = true
			}}, v124)
		end

		if v126 and not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and isPartyQuickStartEnabled2 then
			v124 = Cryo.List.join({{
				id = "PartyQuickStartContainer",
				isQuickStartLink = true
			}}, v124)
		end

		if v126 then
			if isPartyQuickStartEnabled2 and PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and (p10.isWideMode or not p10.isInExperience) then
				v124 = Cryo.List.join({{
					id = "SocialCarousel",
					isSocialCarousel = true
				}}, v124)
			end

			v124 = Cryo.List.join({{
				id = "UnfilteredThreadsFtux",
				isChatLandingModal = true
			}}, v124)
		end

		if FFlagAppIaScrollAway and (p10.canvasTopPadding or 0) > 0 then
			v124 = Cryo.List.join({{
				id = "CanvasTopPadding",
				isCanvasTopPadding = true,
				height = p10.canvasTopPadding
			}}, v124)
		end

		return v124
	end, {
		v66,
		p10.filterText,
		p10.showGroupsLink,
		p10.isWideMode,
		p10.isInExperience,
		p10.canvasTopPadding,
		v75,
		isPartyQuickStartEnabled2
	})
	local v105 = React.useMemo(function() -- line: 347
		-- upvalues: v104 (copy), v94 (copy), FFlagAppIaScrollAway (copy), v65 (copy), Cryo (copy)
		local t3 = {}
		local n1 = 0

		for v129, v130 in v104 do
			local v131 = if not v130.isChatLandingModal then if not FFlagAppIaScrollAway or not v130.isCanvasTopPadding then v65 else v130.height else v94[v130.id] or 200

			t3[v129] = Cryo.Dictionary.join(v130, {
				height = v131,
				yOffset = n1
			})
			n1 += v131
		end

		return {
			items = t3,
			contentHeight = n1
		}
	end, {
		v104,
		v65,
		v94
	})

	React.useEffect(function() -- line: 370
		-- upvalues: v97 (copy), v85 (copy), v29 (copy), v66 (copy), v32 (copy), v98 (copy), v39 (copy)
		if v97 and (v85.current < v29 and #v66 < v32) then
			local v132 = v85.current + 1

			if v98() then
				v85.current = v132
				v39:info("Loading more conversations because the list (count: {} out of {}) is not enough (attempt {} out of {})", #v66, v32, v85.current, v29)
			end
		end
	end, {
		v66,
		v97,
		v98
	})
	React.useEffect(function() -- line: 390
		-- upvalues: v97 (copy), v105 (copy), v89 (copy), v98 (copy), v39 (copy)
		if v97 and (v105.contentHeight > 0 and v89.Y > 0 and v105.contentHeight <= v89.Y and v98()) then
			v39:info("Not enough UltimateList content to fill the view, loading more conversations")
		end
	end, {
		v105.contentHeight,
		v89.Y,
		v97,
		v98
	})

	local v106 = React.useCallback(function() -- line: 398
		-- upvalues: v98 (copy), v39 (copy)
		if v98() then
			v39:debug("UltimateList onEndReached - Loading more conversations")
		end
	end, { v98 })
	local v107 = React.useCallback(function() -- line: 404
		-- upvalues: p10 (copy), v39 (copy)
		if p10.loadPrevious and not p10.isLoadingPrevious then
			v39:debug("UltimateList onStartReached - Loading previous conversations")
			p10.loadPrevious()
		end
	end, {
		p10.loadPrevious,
		p10.isLoadingPrevious
	})
	local v108 = React.useCallback(function(p15) -- line: 411
		-- upvalues: v90 (copy)
		v90(p15)
	end, {})
	local u109 = nil

	if FFlagFriendsChatConversationListShowScrollBar then
		u109 = React.useCallback(function() -- line: 417
			-- upvalues: u80 (ref), u82 (ref), ReactOtter (copy), v40 (copy), t1 (copy)
			if u80.current ~= nil then
				pcall(task.cancel, u80.current)
				u80.current = nil
			end

			u82(ReactOtter.instant(0))
			u80.current = task.delay(v40, function() -- line: 425
				-- upvalues: u80 (ref), u82 (ref), ReactOtter (copy), t1 (copy)
				u80.current = nil
				u82(ReactOtter.spring(1, t1))
			end)
		end, { u82 })
		React.useEffect(function() -- line: 431
			-- upvalues: u80 (ref)
			return function() -- line: 432
				-- upvalues: u80 (ref)
				if u80.current ~= nil then
					pcall(task.cancel, u80.current)
					u80.current = nil
				end
			end
		end, {})
	end

	local v110 = React.useCallback(function(p16) -- line: 441
		-- upvalues: FFlagAppChatPerfTracking (copy), v78 (copy), FFlagFriendsChatConversationListShowScrollBar (copy), p10 (copy), u109 (ref), v77 (copy), v65 (copy), v36 (copy), v105 (copy), v89 (copy), v98 (copy), v69 (copy)
		if FFlagAppChatPerfTracking and v78.current then
			v78.current.onScrollTick()
		end

		if FFlagFriendsChatConversationListShowScrollBar and p10.showScrollbarOnScroll then
			u109()
		end

		v77:fire()

		if v65 * v36 >= v105.contentHeight - v89.Y - p16 then
			v98()
		end

		v69({
			CanvasPosition = Vector2.new(0, p16)
		})
	end, {
		v77,
		v69,
		v65,
		v105.contentHeight,
		v89.Y,
		v98,
		if not FFlagFriendsChatConversationListShowScrollBar then nil else p10.showScrollbarOnScroll,
		if not FFlagFriendsChatConversationListShowScrollBar then nil else u109
	})
	local v111 = React.useCallback(function(p17) -- line: 473
		-- upvalues: v79 (copy), v92 (copy)
		v79.current = p17
		v92(p17)
	end, {})
	local v112 = if not v66 or not v66[1] then nil else v66[1].id

	React.useEffect(function() -- line: 479
		-- upvalues: v79 (copy), v112 (copy), v84 (copy)
		local current = v79.current

		if current ~= nil and (v112 ~= nil and v84.current ~= nil and v84.current ~= v112 and current.CanvasPosition.Y <= 33) then
			current.CanvasPosition = Vector2.new(0, 0)
		end

		v84.current = v112
	end, { v112 })

	local v113 = React.useCallback(function(p18) -- line: 495
		-- upvalues: React (copy), MeasuredChatLandingModal (copy), v96 (copy), ConversationGroupsEntryContainer (copy), v65 (copy), isPartyQuickStartEnabled2 (copy), PartyQuickStartContainer (copy), PartyPageCarouselExperimentation (copy), SocialCarousel (copy), v103 (copy), p10 (copy), Constants (copy), v101 (copy), FFlagAppIaScrollAway (copy), View (copy), v93 (copy), ConversationRow (copy), v99 (copy), v72 (copy), v73 (copy), v74 (copy), v76 (copy)
		if p18.isChatLandingModal then
			return React.createElement(MeasuredChatLandingModal, {
				itemId = p18.id,
				onHeightChanged = v96
			})
		end

		if p18.isGroupLink then
			return React.createElement(ConversationGroupsEntryContainer, {
				entryHeight = v65
			})
		end

		if isPartyQuickStartEnabled2 and p18.isQuickStartLink then
			return React.createElement(PartyQuickStartContainer, {
				entryHeight = v65
			})
		end

		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and p18.isSocialCarousel then
			return React.createElement(SocialCarousel.Entry, {
				roduxKey = "ChatAppReducer",
				hideCarouselHeader = true,
				customTileList = v103,
				source = if not p10.isInExperience then Constants.ANALYTICS.SRC.PARTY_PAGE_UA else Constants.ANALYTICS.SRC.PARTY_PAGE_IN_EXP,
				unifiedLogging = v101
			})
		end

		if FFlagAppIaScrollAway and p18.isCanvasTopPadding then
			return React.createElement(View, {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, p18.height),
				backgroundStyle = v93.Color.None
			})
		end

		return React.createElement(ConversationRow, {
			entryHeight = v65,
			conversationId = p18.id,
			isSquadEnabled = v99,
			isWideMode = p10.isWideMode,
			onActivated = p10.onActivated,
			onSquadJoinButtonActivated = v72,
			key = "ConversationEntry" .. tostring(p18.id),
			fireImpressionEvent = v73,
			fireClickEvent = v74,
			showBackground = v76.showBackground,
			localUserId = p10.localUserId,
			debugCellValue = if not p10.isDebugEnabled then nil else tostring(p18.id)
		})
	end, {
		v65,
		v99,
		isPartyQuickStartEnabled2,
		v103,
		p10.isInExperience,
		v101,
		p10.onActivated,
		v72,
		v73,
		v74,
		v76,
		p10.isDebugEnabled,
		p10.localUserId,
		p10.isWideMode,
		v96,
		v93
	})

	if #v104 == 0 then
		return React.createElement(View, {
			BorderSizePixel = 0,
			Size = v67,
			backgroundStyle = v93.Color.None,
			LayoutOrder = v68
		})
	end

	local v114 = if not (v89.X > 0) and not (v89.Y > 0) then {} else v105.items
	local t4 = {
		Name = "RCTScrollView",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = (not FFlagFriendsChatConversationListShowScrollBar or not p10.showScrollbarOnScroll) and 0 or (p10.scrollbarThickness or 8),
		ScrollBarImageColor3 = if not FFlagFriendsChatConversationListShowScrollBar or not p10.showScrollbarOnScroll then nil else v93.Color.Content.Emphasis.Color3,
		ScrollBarImageTransparency = if not FFlagFriendsChatConversationListShowScrollBar or not p10.showScrollbarOnScroll then nil else v81
	}

	return React.createElement(View, {
		BorderSizePixel = 0,
		Size = v67,
		backgroundStyle = v93.Color.None,
		LayoutOrder = v68
	}, {
		scroller = React.createElement(UltimateList.Components.ScrollingFrame, {
			direction = "y",
			dataSource = UltimateList.DataSources.array(v114),
			dimensions = UltimateList.Dimensions.getter(function(p19) -- line: 606
				return {
					size = UDim2.new(1, 0, 0, p19.height),
					position = UDim2.fromOffset(0, p19.yOffset)
				}
			end),
			renderer = UltimateList.Renderers.byState(v113),
			getKey = getKey,
			scrollingFrameRef = v111,
			onAbsoluteWindowSizeChanged = v108,
			onScrollAxisChanged = v110,
			onStartReached = v107,
			onEndReached = v106,
			onStartReachedThreshold = v65 * v35,
			onEndReachedThreshold = v65 * v36,
			native = t4
		})
	})
end

return React.memo(ConversationListUltimate)
