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
local usePlatformLeaderboard = require(ParentParent.Hooks.usePlatformLeaderboard)
local PlatformEntryView = require(ParentParent.Components.Presentation.PlatformEntryView)
local EmptyAndErrorStates = require(ParentParent.Components.Presentation.EmptyAndErrorStates)
local resolveDisplayName = require(ParentParent.Common.resolveDisplayName)
local getPeopleHeaderLabel = require(ParentParent.Common.getPeopleHeaderLabel)
local LoadingState = EmptyAndErrorStates.LoadingState
local EmptyFriendsState = EmptyAndErrorStates.EmptyFriendsState
local ServiceUnavailableState = EmptyAndErrorStates.ServiceUnavailableState
local v21 = Signals.createSignal(nil)
local v22 = Signals.createSignal(nil)
local v23 = require(ParentParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap()

local function formatRelativeTime(n1: number?, n2: number) -- line: 44
	if n1 == nil then
		return "Unable to load"
	end

	return `Last updated { math.max(0, (math.floor((n2 - n1) / 60))) } min ago`
end
local function PlatformLeaderboardViewImpl(t1: {[any]: any}) -- line: 58
	-- upvalues: usePlatformLeaderboard (copy), useTokens (copy), Constants (copy), v23 (copy), v21 (copy), v22 (copy), React (copy), SignalsReact (copy), Signals (copy), Players (copy), resolveDisplayName (copy), getPeopleHeaderLabel (copy), ServiceUnavailableState (copy), LoadingState (copy), EmptyFriendsState (copy), PlatformEntryView (copy), ScrollView (copy), View (copy), FoundationText (copy)
	local tab = t1.tab
	local v30 = tab == "Friends"
	local v31 = usePlatformLeaderboard()
	local UIScale = useTokens().Config.UI.Scale
	local v33 = Constants.PLATFORM_ROW_HEIGHT * UIScale
	local v34 = Constants.PLATFORM_HEADER_HEIGHT * UIScale
	local v35 = 26 * UIScale
	local v36 = Constants.PLATFORM_RANK_WIDTH * UIScale
	local v37 = Constants.PLATFORM_SCORE_WIDTH * UIScale
	local v38 = if not v31 then v23 else if not v30 then v31.globalEntries else v31.friendsEntries
	local v39 = if not v31 then v21 else if not v30 then v31.getGlobalLastRefreshedAt else v31.getFriendsLastRefreshedAt
	local v40 = if not v31 then v21 else v31.getUserScore
	local v41 = if not v31 then v21 else v31.getUserRank
	local v42 = if not v31 then v22 else v31.getUnit
	local v43, v44 = React.useState("loading")
	local v45, v46 = React.useState(0)
	local v47 = React.useRef(false)
	local v48 = SignalsReact.useSignalState(v38.getAllData)
	local v49 = React.useMemo(function() -- line: 89
		-- upvalues: Signals (copy), v39 (copy)
		return Signals.createComputed(function(p1) -- line: 90
			-- upvalues: v39 (copy)
			return v39(p1) ~= nil
		end)
	end, { v39 })
	local v50 = SignalsReact.useSignalState(v49)
	local n3 = 0

	for _ in pairs(v48) do
		n3 += 1
	end

	local v53 = SignalsReact.useSignalBinding(v39)
	local v54, v55 = React.useBinding(os.time())

	React.useEffect(function() -- line: 104
		-- upvalues: v55 (copy)
		local thread = nil

		local function schedule() -- line: 106
			-- upvalues: thread (ref), v55 (copy), schedule (copy)
			thread = task.delay(300, function() -- line: 107
				-- upvalues: v55 (copy), schedule (copy)
				v55(os.time())
				schedule()
			end)
		end

		thread = task.delay(300, function() -- line: 107
			-- upvalues: v55 (copy), schedule (copy)
			v55(os.time())
			schedule()
		end)

		return function() -- line: 113
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, {})

	local v56 = React.useMemo(function() -- line: 120
		-- upvalues: React (copy), v53 (copy), v54 (copy)
		return React.joinBindings({
			lastRefreshedAt = v53,
			tick = v54
		}):map(function(p2) -- line: 124
			local lastRefreshedAt = p2.lastRefreshedAt
			local timestamp = os.time()

			if lastRefreshedAt == nil then
				return "Unable to load"
			end

			return `Last updated { math.max(0, (math.floor((timestamp - lastRefreshedAt) / 60))) } min ago`
		end)
	end, {
		v53,
		v54
	})

	React.useEffect(function() -- line: 129
		-- upvalues: v31 (copy), tab (copy)
		if v31 then
			v31:fireTabOpened(tab)
		end

		return function() -- line: 133
			-- upvalues: v31 (copy), tab (copy)
			if v31 then
				v31:fireTabClosed(tab)
			end
		end
	end, {
		v31,
		tab
	})
	React.useEffect(function() -- line: 140
		-- upvalues: v47 (copy), v44 (copy), v50 (copy)
		v47.current = false
		v44("loading")

		if v50 then
			return function() -- line: 144
				-- upvalues: v47 (copy)
				v47.current = true
			end
		end

		local thread = task.delay(30, function() -- line: 148
			-- upvalues: v47 (copy), v44 (copy)
			if not v47.current then
				v44("error")
			end
		end)

		return function() -- line: 153
			-- upvalues: v47 (copy), thread (copy)
			v47.current = true
			task.cancel(thread)
		end
	end, {
		v31,
		tab,
		v50,
		v45
	})

	local LocalPlayer = Players.LocalPlayer
	local v58 = React.useMemo(function() -- line: 160
		-- upvalues: LocalPlayer (copy), resolveDisplayName (copy)
		if LocalPlayer then
			return (resolveDisplayName(LocalPlayer))
		end

		return nil
	end, { LocalPlayer })
	local v59 = SignalsReact.useSignalState(v42)
	local v60 = getPeopleHeaderLabel()

	if v31 == nil or not v50 then
		if v43 == "error" then
			return React.createElement(ServiceUnavailableState, {
				onRetry = function() -- line: 170
					-- upvalues: v31 (copy), tab (copy), v44 (copy), v46 (copy)
					if v31 then
						v31:fireTabClosed(tab)
						v31:fireTabOpened(tab)
					end

					v44("loading")
					v46(function(p3) -- line: 176
						return p3 + 1
					end)
				end,
				layoutOrder = t1.layoutOrder
			})
		end

		return React.createElement(LoadingState, {
			layoutOrder = t1.layoutOrder
		})
	end

	if v30 and n3 == 0 then
		return React.createElement(EmptyFriendsState, {
			layoutOrder = t1.layoutOrder
		})
	end

	local t2 = {}

	for k, v in pairs(v48) do
		t2[`Row_{ k }`] = React.createElement(PlatformEntryView, {
			isViewer = false,
			showDivider = true,
			scoreGetter = v.getScore,
			rankGetter = v.getRank,
			displayName = v.displayName,
			rowHeight = v33,
			rankWidth = v36,
			scoreWidth = v37
		})
	end

	local v64 = React.createElement(ScrollView, {
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
			scoreLabel = v59,
			peopleHeaderText = v60,
			rowHeight = v34,
			rankWidth = v36,
			scoreWidth = v37
		}),
		PinnedViewer = React.createElement(PlatformEntryView, {
			isViewer = true,
			layoutOrder = 3,
			scoreGetter = v40,
			rankGetter = v41,
			displayName = v58,
			rowHeight = v33,
			rankWidth = v36,
			scoreWidth = v37
		}),
		RowList = React.createElement(View, {
			tag = "col fill size-full-0",
			LayoutOrder = 5
		}, {
			Rows = v64
		}),
		Footer = React.createElement(View, {
			tag = "row align-x-right align-y-center size-full-0 padding-x-medium padding-y-xsmall stroke-standard stroke-default bg-surface-100",
			LayoutOrder = 6,
			Size = UDim2.new(1, 0, 0, v35)
		}, {
			FooterText = React.createElement(FoundationText, {
				tag = "auto-xy text-caption-small text-align-x-right content-muted",
				Text = v56
			})
		})
	})
end

return React.memo(PlatformLeaderboardViewImpl)
