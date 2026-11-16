local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Players = game:GetService("Players")

local React = require(parent2.React)
local CoreGuiCommon = require(parent2.CoreGuiCommon)
local Signals = require(parent2.Signals)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local ScrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens

local Constants = require(parent.Common.Constants)
local useGamepadStickScroll = CoreGuiCommon.Hooks.useGamepadStickScroll
local useReportPanelContentHeight = require(parent.Hooks.useReportPanelContentHeight)
local usePlatformLeaderboard = require(parent.Hooks.usePlatformLeaderboard)
local PlatformEntryView = require(parent.Components.Presentation.PlatformEntryView)
local EmptyAndErrorStates = require(parent.Components.Presentation.EmptyAndErrorStates)
local resolveDisplayName = require(parent.Common.resolveDisplayName)
local getPeopleHeaderLabel = require(parent.Common.getPeopleHeaderLabel)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local FFlagPlayerListReskin = require(parent.Flags.FFlagPlayerListReskin)
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization

local LoadingState = EmptyAndErrorStates.LoadingState
local EmptyFriendsState = EmptyAndErrorStates.EmptyFriendsState
local ServiceUnavailableState = EmptyAndErrorStates.ServiceUnavailableState

local leaderboardViewChangeTelemetry = nil
local function getLeaderboardViewChangeTelemetry() -- 2 equivalent calls inferred from this helper
	if leaderboardViewChangeTelemetry == nil then
		local LeaderboardViewChangeTelemetry = require(parent.Common.LeaderboardViewChangeTelemetry)
		leaderboardViewChangeTelemetry = LeaderboardViewChangeTelemetry
	end

	return leaderboardViewChangeTelemetry
end

local signal = Signals.createSignal(nil)
local signal2 = Signals.createSignal(nil)
local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local signalMap = CoreScriptsRoactCommon.Utilities.createSignalMap()

local function formatRelativeTimeLegacy(lastRefreshedAt: number?, now: number) -- 1 equivalent call inferred from this helper
	if lastRefreshedAt == nil then
		return "Unable to load"
	end

	return `Last updated {math.max(0, (math.floor((now - lastRefreshedAt) / 60)))} min ago`
end

local function PlatformLeaderboardViewImpl(props)
	local tab = props.tab
	local v = tab == "Friends"
	local useLegacyPanelStyling = props.legacyPanelBackgroundColor ~= nil
	local v2 = usePlatformLeaderboard()

	local scale = useTokens().Config.UI.Scale
	local rowHeight = Constants.PLATFORM_ROW_HEIGHT * scale
	local rowHeight2 = Constants.PLATFORM_HEADER_HEIGHT * scale
	local v3 = Constants.PLATFORM_FOOTER_HEIGHT * scale
	local rankWidth = Constants.PLATFORM_RANK_WIDTH * scale
	local scoreWidth = Constants.PLATFORM_SCORE_WIDTH * scale

	local v4 = useReportPanelContentHeight(rowHeight2 + rowHeight + v3)
	local ref = React.useRef(nil)
	local scrollingFrameRef = React.useCallback(function(current)
		ref.current = current
		v4(current)
	end, { v4 })

	useGamepadStickScroll({
		actionName = "RbxPlayerListReskinGamepadStickScroll",
		scrollingFrameRef = ref,
		enabled = not useLegacyPanelStyling
	})
	local v5

	if v2 then
		v5 = if v then v2.friendsEntries else v2.globalEntries
	else
		v5 = signalMap
	end

	local v6

	if v2 then
		if v then
			v6 = v2.getFriendsLastRefreshedAt
		else
			v6 = v2.getGlobalLastRefreshedAt
		end
	else
		v6 = signal
	end

	local scoreGetter

	if v2 then
		if v then
			scoreGetter = v2.getUserFriendScore
		else
			scoreGetter = v2.getUserScore
		end
	else
		scoreGetter = signal
	end

	local rankGetter

	if v2 then
		rankGetter = if v then v2.getUserFriendRank else v2.getUserRank
	else
		rankGetter = signal
	end

	local v7 = if v2 then v2.getUnit else signal2

	local state, setState = React.useState("loading")
	local state2, setState2 = React.useState(0)
	local ref2 = React.useRef(false)

	local v8 = SignalsReact.useSignalState(v5.getAllData)

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return v6(p) ~= nil
		end)
	end, { v6 })
	local v10 = SignalsReact.useSignalState(v9)
	local count = 0

	for _ in pairs(v8) do
		count += 1
	end

	local rankHeader = nil
	local text

	if FFlagPlayerListLocalizeGameText then
		local v11 = SignalsReact.useSignalState(v6)

		local _, setState3 = React.useState(0)
		React.useEffect(function()
			local thread = nil
			local function schedule()
				thread = task.delay(300, function()
					setState3(function(p)
						return p + 1
					end)

					schedule()
				end)
			end

			thread = task.delay(300, function()
				setState3(function(p)
					return p + 1
				end)

				schedule()
			end)

			return function()
				if thread then
					task.cancel(thread)
					thread = nil
				end
			end
		end, {})

		local v12 = useLocalization({
			rankHeader = "InGame.PlayerList.RankHeader",
			footerUnableToLoad = "InGame.PlayerList.FooterUnableToLoad",
			footerLastUpdated = {
				"InGame.PlayerList.FooterLastUpdated",
				minutes = v11 == nil and 0 or math.max(0, (math.floor((os.time() - v11) / 60)))
			}
		})

		rankHeader = v12.rankHeader

		if v11 == nil then
			text = v12.footerUnableToLoad
		else
			text = v12.footerLastUpdated
		end
	else
		local lastRefreshedAt = SignalsReact.useSignalBinding(v6)

		local tick, v11 = React.useBinding(os.time())
		React.useEffect(function()
			local thread = nil
			local function schedule()
				thread = task.delay(300, function()
					v11(os.time())
					schedule()
				end)
			end

			thread = task.delay(300, function()
				v11(os.time())
				schedule()
			end)

			return function()
				if thread then
					task.cancel(thread)
					thread = nil
				end
			end
		end, {})
		text = React.useMemo(function()
			return React.joinBindings({ lastRefreshedAt = lastRefreshedAt, tick = tick }):map(function(p)
				return formatRelativeTimeLegacy(p.lastRefreshedAt, os.time()) -- inferred equivalent call
			end)
		end, { lastRefreshedAt, tick })
	end

	React.useEffect(function()
		if v2 then
			v2:fireTabOpened(tab)
		end

		return function()
			if v2 then
				v2:fireTabClosed(tab)
			end
		end
	end, { v2, tab })

	React.useEffect(function()
		ref2.current = false
		setState("loading")

		if v10 then
			return function()
				ref2.current = true
			end
		end

		local thread = task.delay(30, function()
			if not ref2.current then
				setState("error")
			end
		end)
		return function()
			ref2.current = true
			task.cancel(thread)
		end
	end, { v2, tab, v10, state2 })

	if FFlagPlayerListReskin then
		React.useEffect(function()
			if useLegacyPanelStyling or state ~= "error" then
				return
			end

			getLeaderboardViewChangeTelemetry().logLoadError(string.lower(tab)) -- inferred equivalent call
		end, { state, useLegacyPanelStyling })
	end

	local localPlayer = Players.LocalPlayer
	local displayName = React.useMemo(function()
		if localPlayer then
			return (resolveDisplayName(localPlayer))
		end

		return nil
	end, { localPlayer })

	local scoreLabel = SignalsReact.useSignalState(v7)

	local peopleHeaderLabel = getPeopleHeaderLabel()

	local onRetry = React.useCallback(function()
		if FFlagPlayerListReskin and not useLegacyPanelStyling then
			getLeaderboardViewChangeTelemetry().logRetryError(string.lower(tab)) -- inferred equivalent call
		end

		if v2 then
			v2:fireTabClosed(tab)
			v2:fireTabOpened(tab)
		end

		setState("loading")
		setState2(function(p)
			return p + 1
		end)
	end, { v2, tab, useLegacyPanelStyling })

	if v2 == nil or not v10 then
		if state == "error" then
			return React.createElement(ServiceUnavailableState, {
				onRetry = onRetry,
				layoutOrder = props.layoutOrder,
				useLegacyPanelStyling = useLegacyPanelStyling
			})
		end

		return React.createElement(LoadingState, {
			layoutOrder = props.layoutOrder,
			useLegacyPanelStyling = useLegacyPanelStyling
		})
	else
		if v and count == 0 then
			return React.createElement(EmptyFriendsState, {
				layoutOrder = props.layoutOrder,
				useLegacyPanelStyling = useLegacyPanelStyling
			})
		end

		local children = {}

		for k, v11 in pairs(v8) do
			children[`Row_{k}`] = React.createElement(PlatformEntryView, {
				scoreGetter = v11.getScore,
				rankGetter = v11.getRank,
				displayName = v11.displayName,
				isViewer = false,
				showDivider = true,
				rowHeight = rowHeight,
				rankWidth = rankWidth,
				scoreWidth = scoreWidth
			})
		end

		local createElement = React.createElement
		local v11 = {
			tag = "fill size-full-0",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder
			},
			scroll = 0,
			scrollingFrameRef = 0,
			selection = 0
		}
		local automaticCanvasSize

		if useLegacyPanelStyling then
			automaticCanvasSize = Enum.AutomaticSize.Y
		end

		v11.scroll = {
			AutomaticCanvasSize = automaticCanvasSize,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}

		if useLegacyPanelStyling then
			scrollingFrameRef = nil
		end

		v11.scrollingFrameRef = scrollingFrameRef
		v11.selection = Constants.NOT_SELECTABLE
		local element = createElement(ScrollView, v11, children)
		local columnHeader

		if useLegacyPanelStyling then
			columnHeader = React.createElement("Frame", {
				Name = "LegacyPlatformColumnHeader",
				Size = UDim2.new(1, 0, 0, rowHeight2),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				Header = React.createElement(PlatformEntryView, {
					isHeader = true,
					scoreLabel = scoreLabel,
					peopleHeaderText = peopleHeaderLabel,
					rankHeaderText = rankHeader,
					rowHeight = rowHeight2,
					rankWidth = rankWidth,
					scoreWidth = scoreWidth
				})
			})
		else
			columnHeader = React.createElement(
				View,
				{
					tag = "size-full-0 bg-surface-100",
					Size = UDim2.new(1, 0, 0, rowHeight2),
					LayoutOrder = 1
				},
				{
					Header = React.createElement(PlatformEntryView, {
						isHeader = true,
						scoreLabel = scoreLabel,
						peopleHeaderText = peopleHeaderLabel,
						rankHeaderText = rankHeader,
						rowHeight = rowHeight2,
						rankWidth = rankWidth,
						scoreWidth = scoreWidth
					})
				}
			)
		end

		local footer

		if useLegacyPanelStyling then
			footer = React.createElement("Frame", {
				Name = "LegacyPlatformFooter",
				Size = UDim2.new(1, 0, 0, v3),
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				FooterInner = React.createElement(
					View,
					{
						tag = "row align-x-right align-y-center size-full padding-x-medium padding-y-xsmall",
						Size = UDim2.fromScale(1, 1)
					},
					{
						FooterText = React.createElement(Text, {
							Text = text,
							tag = "auto-xy text-caption-small text-align-x-right content-muted"
						})
					}
				)
			})
		else
			footer = React.createElement(
				View,
				{
					tag = "row align-x-right align-y-center size-full-0 padding-x-medium padding-y-xsmall stroke-standard stroke-default bg-surface-100",
					Size = UDim2.new(1, 0, 0, v3),
					LayoutOrder = 6
				},
				{
					FooterText = React.createElement(Text, {
						Text = text,
						tag = "auto-xy text-caption-small text-align-x-right content-muted"
					})
				}
			)
		end

		return React.createElement(View, {
			tag = "col fill size-full-0",
			LayoutOrder = props.layoutOrder
		}, {
			ColumnHeader = columnHeader,
			PinnedViewer = React.createElement(PlatformEntryView, {
				scoreGetter = scoreGetter,
				rankGetter = rankGetter,
				displayName = displayName,
				isViewer = true,
				highlightViewerRow = not useLegacyPanelStyling,
				layoutOrder = 3,
				rowHeight = rowHeight,
				rankWidth = rankWidth,
				scoreWidth = scoreWidth
			}),
			RowList = React.createElement(View, { tag = "col fill size-full-0", LayoutOrder = 5 }, {
				Rows = element
			}),
			Footer = footer
		})
	end
end

return React.memo(PlatformLeaderboardViewImpl)
