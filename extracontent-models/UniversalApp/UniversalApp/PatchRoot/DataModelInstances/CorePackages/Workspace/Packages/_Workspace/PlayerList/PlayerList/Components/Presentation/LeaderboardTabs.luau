local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Signals = require(ParentParentParent.Signals)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local usePlatformLeaderboard = require(ParentParent.Hooks.usePlatformLeaderboard)
local v12 = Signals.createSignal(false)
local t1 = {
	{
		id = "server",
		text = "In this server"
	},
	{
		id = "friends",
		text = "Friends"
	},
	{
		id = "global",
		text = "Global"
	}
}

local function LeaderboardTabs(t2: {[any]: any}) -- line: 38
	-- upvalues: usePlatformLeaderboard (copy), v12 (copy), SignalsReact (copy), React (copy), View (copy), Tabs (copy), InputSize (copy), FillBehavior (copy), t1 (copy)
	local v16 = usePlatformLeaderboard()
	local v17 = if v16 == nil then v12 else v16.getHasActiveLeaderboard
	local v18 = SignalsReact.useSignalState(v17)

	React.useEffect(function() -- line: 47
		-- upvalues: v18 (copy), t2 (copy)
		if not v18 and t2.onPlatformTabsUnavailable then
			t2.onPlatformTabsUnavailable()
		end
	end, {
		v18,
		t2.onPlatformTabsUnavailable
	})

	local v19 = React.useCallback(function(p1) -- line: 56
		-- upvalues: t2 (copy)
		t2.onActivated((tostring(p1)))
	end, { t2.onActivated })

	if not v18 then
		return nil
	end

	return React.createElement(View, {
		Name = "CoreUI_LeaderboardTabs",
		tag = "col size-full-0 auto-y",
		LayoutOrder = t2.layoutOrder
	}, {
		Tabs = React.createElement(Tabs, {
			activeTabId = t2.activeTabId,
			size = InputSize.Small,
			fillBehavior = FillBehavior.Fill,
			onActivated = v19,
			tabs = t1
		})
	})
end

return React.memo(LeaderboardTabs)
