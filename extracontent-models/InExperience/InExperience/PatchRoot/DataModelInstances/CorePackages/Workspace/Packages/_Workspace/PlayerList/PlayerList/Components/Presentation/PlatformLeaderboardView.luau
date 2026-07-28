local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Players = game:GetService("Players")
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ScrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens
local Constants = require(ParentParent.Common.Constants)
local FFlagPlayerListReskinOptimization = require(ParentParent.Flags.FFlagPlayerListReskinOptimization)
local usePlatformLeaderboard = require(ParentParent.Hooks.usePlatformLeaderboard)
local PlatformEntryView = require(ParentParent.Components.Presentation.PlatformEntryView)
local EmptyAndErrorStates = require(ParentParent.Components.Presentation.EmptyAndErrorStates)
local resolveDisplayName = require(ParentParent.Common.resolveDisplayName)
local getPeopleHeaderLabel = require(ParentParent.Common.getPeopleHeaderLabel)
local LoadingState = EmptyAndErrorStates.LoadingState
local EmptyFriendsState = EmptyAndErrorStates.EmptyFriendsState
local ServiceUnavailableState = EmptyAndErrorStates.ServiceUnavailableState
local v22 = Signals.createSignal(nil)
local v23 = Signals.createSignal(nil)
local v24 = require(ParentParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap()

local function formatRelativeTime(n1: number?, n2: number) -- line: 45
	if n1 == nil then
		return "Unable to load"
	end

	return `Last updated { math.max(0, (math.floor((n2 - n1) / 60))) } min ago`
end
local function PlatformLeaderboardViewImpl(t1: {[any]: any}) -- line: 59
	-- upvalues: usePlatformLeaderboard (copy), useTokens (copy), Constants (copy), v24 (copy), v22 (copy), v23 (copy), React (copy), SignalsReact (copy), Signals (copy), Players (copy), resolveDisplayName (copy), getPeopleHeaderLabel (copy), FFlagPlayerListReskinOptimization (copy), ServiceUnavailableState (copy), LoadingState (copy), EmptyFriendsState (copy), PlatformEntryView (copy), ScrollView (copy), View (copy), FoundationText (copy)
	local tab = t1.tab
	local v31 = tab == "Friends"
	local v32 = usePlatformLeaderboard()
	local UIScale = useTokens().Config.UI.Scale
	local v34 = Constants.PLATFORM_ROW_HEIGHT * UIScale
	local v35 = Constants.PLATFORM_HEADER_HEIGHT * UIScale
	local v36 = 26 * UIScale
	local v37 = Constants.PLATFORM_RANK_WIDTH * UIScale
	local v38 = Constants.PLATFORM_SCORE_WIDTH * UIScale
	local v39 = if not v32 then v24 else if not v31 then v32.globalEntries else v32.friendsEntries
	local v40 = if not v32 then v22 else if not v31 then v32.getGlobalLastRefreshedAt else v32.getFriendsLastRefreshedAt
	local v41 = if not v32 then v22 else if not v31 then v32.getUserScore else v32.getUserFriendScore
	local v42 = if not v32 then v22 else if not v31 then v32.getUserRank else v32.getUserFriendRank
	local v43 = if not v32 then v23 else v32.getUnit
	local v44, v45 = React.useState("loading")
	local v46, v47 = React.useState(0)
	local v48 = React.useRef(false)
	local v49 = SignalsReact.useSignalState(v39.getAllData)
	local v50 = React.useMemo(function() -- line: 94
		-- upvalues: Signals (copy), v40 (copy)
		return Signals.createComputed(function(p1) -- line: 95
			-- upvalues: v40 (copy)
			return v40(p1) ~= nil
		end)
	end, { v40 })
	local v51 = SignalsReact.useSignalState(v50)
	local n3 = 0

	for _ in pairs(v49) do
		n3 += 1
	end

	local v54 = SignalsReact.useSignalBinding(v40)
	local v55, v56 = React.useBinding(os.time())

	React.useEffect(function() -- line: 109
		-- upvalues: v56 (copy)
		local thread = nil

		local function schedule() -- line: 111
			-- upvalues: thread (ref), v56 (copy), schedule (copy)
			thread = task.delay(300, function() -- line: 112
				-- upvalues: v56 (copy), schedule (copy)
				v56(os.time())
				schedule()
			end)
		end

		thread = task.delay(300, function() -- line: 112
			-- upvalues: v56 (copy), schedule (copy)
			v56(os.time())
			schedule()
		end)

		return function() -- line: 118
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, {})

	local v57 = React.useMemo(function() -- line: 125
		-- upvalues: React (copy), v54 (copy), v55 (copy)
		return React.joinBindings({
			lastRefreshedAt = v54,
			tick = v55
		}):map(function(p2) -- line: 129
			local lastRefreshedAt = p2.lastRefreshedAt
			local timestamp = os.time()

			if lastRefreshedAt == nil then
				return "Unable to load"
			end

			return `Last updated { math.max(0, (math.floor((timestamp - lastRefreshedAt) / 60))) } min ago`
		end)
	end, {
		v54,
		v55
	})

	React.useEffect(function() -- line: 134
		-- upvalues: v32 (copy), tab (copy)
		if v32 then
			v32:fireTabOpened(tab)
		end

		return function() -- line: 138
			-- upvalues: v32 (copy), tab (copy)
			if v32 then
				v32:fireTabClosed(tab)
			end
		end
	end, {
		v32,
		tab
	})
	React.useEffect(function() -- line: 145
		-- upvalues: v48 (copy), v45 (copy), v51 (copy)
		v48.current = false
		v45("loading")

		if v51 then
			return function() -- line: 149
				-- upvalues: v48 (copy)
				v48.current = true
			end
		end

		local thread = task.delay(30, function() -- line: 153
			-- upvalues: v48 (copy), v45 (copy)
			if not v48.current then
				v45("error")
			end
		end)

		return function() -- line: 158
			-- upvalues: v48 (copy), thread (copy)
			v48.current = true
			task.cancel(thread)
		end
	end, {
		v32,
		tab,
		v51,
		v46
	})

	local LocalPlayer = Players.LocalPlayer
	local v59 = React.useMemo(function() -- line: 165
		-- upvalues: LocalPlayer (copy), resolveDisplayName (copy)
		if LocalPlayer then
			return (resolveDisplayName(LocalPlayer))
		end

		return nil
	end, { LocalPlayer })
	local v60 = SignalsReact.useSignalState(v43)
	local v61 = getPeopleHeaderLabel()
	local v62 = nil

	if FFlagPlayerListReskinOptimization then
		v62 = React.useCallback(function() -- line: 175
			-- upvalues: v32 (copy), tab (copy), v45 (copy), v47 (copy)
			if v32 then
				v32:fireTabClosed(tab)
				v32:fireTabOpened(tab)
			end

			v45("loading")
			v47(function(p3) -- line: 181
				return p3 + 1
			end)
		end, {
			v32,
			tab
		})
	end

	if v32 == nil or not v51 then
		if v44 == "error" then
			local v63 = not FFlagPlayerListReskinOptimization and function() -- line: 193
				-- upvalues: v32 (copy), tab (copy), v45 (copy), v47 (copy)
				if v32 then
					v32:fireTabClosed(tab)
					v32:fireTabOpened(tab)
				end

				v45("loading")
				v47(function(p4) -- line: 199
					return p4 + 1
				end)
			end or v62

			return React.createElement(ServiceUnavailableState, {
				onRetry = v63,
				layoutOrder = t1.layoutOrder
			})
		end

		return React.createElement(LoadingState, {
			layoutOrder = t1.layoutOrder
		})
	end

	if v31 and n3 == 0 then
		return React.createElement(EmptyFriendsState, {
			layoutOrder = t1.layoutOrder
		})
	end

	local t2 = {}

	for k, v in pairs(v49) do
		t2[`Row_{ k }`] = React.createElement(PlatformEntryView, {
			isViewer = false,
			showDivider = true,
			scoreGetter = v.getScore,
			rankGetter = v.getRank,
			displayName = v.displayName,
			rowHeight = v34,
			rankWidth = v37,
			scoreWidth = v38
		})
	end

	local v67 = React.createElement(ScrollView, {
		tag = "fill size-full-0",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y
		}
	}, t2)

	return React.createElement(View, {
		tag = "col fill size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		ColumnHeader = React.createElement(PlatformEntryView, {
			isHeader = true,
			layoutOrder = 1,
			scoreLabel = v60,
			peopleHeaderText = v61,
			rowHeight = v35,
			rankWidth = v37,
			scoreWidth = v38
		}),
		PinnedViewer = React.createElement(PlatformEntryView, {
			isViewer = true,
			layoutOrder = 3,
			scoreGetter = v41,
			rankGetter = v42,
			displayName = v59,
			rowHeight = v34,
			rankWidth = v37,
			scoreWidth = v38
		}),
		RowList = React.createElement(View, {
			tag = "col fill size-full-0",
			LayoutOrder = 5
		}, {
			Rows = v67
		}),
		Footer = React.createElement(View, {
			tag = "row align-x-right align-y-center size-full-0 padding-x-medium padding-y-xsmall stroke-standard stroke-default bg-surface-100",
			LayoutOrder = 6,
			Size = UDim2.new(1, 0, 0, v36)
		}, {
			FooterText = React.createElement(FoundationText, {
				tag = "auto-xy text-caption-small text-align-x-right content-muted",
				Text = v57
			})
		})
	})
end

return React.memo(PlatformLeaderboardViewImpl)
