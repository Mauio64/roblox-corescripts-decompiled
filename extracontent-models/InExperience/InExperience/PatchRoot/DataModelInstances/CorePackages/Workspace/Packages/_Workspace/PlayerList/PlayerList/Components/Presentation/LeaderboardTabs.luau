local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local RobloxTranslator = require(ParentParentParent.RobloxTranslator)
local View = Foundation.View
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local usePlatformLeaderboard = require(ParentParent.Hooks.usePlatformLeaderboard)
local FallbackSignals = require(ParentParent.Common.FallbackSignals)

local function translateOr(s1: string, s2: string) -- line: 19
	-- upvalues: RobloxTranslator (copy)
	local ok, result = pcall(function() -- line: 20
		-- upvalues: RobloxTranslator (copy), s1 (copy)
		return RobloxTranslator:FormatByKey(s1)
	end)

	if ok and (result and result ~= "") then
		return result
	end

	return s2
end

local t1 = {}
local t2 = {
	id = "server"
}
local s3 = "CoreScripts.TextChat.ChannelTabs.Here"
local ok, result = pcall(function() -- line: 20
	-- upvalues: RobloxTranslator (copy), s3 (copy)
	return RobloxTranslator:FormatByKey(s3)
end)

t2.text = (not ok or (not result or result == "")) and "Here" or result

local t3 = {
	id = "friends"
}
local s4 = "CommonUI.Features.Label.Friends"
local ok2, result2 = pcall(function() -- line: 20
	-- upvalues: RobloxTranslator (copy), s4 (copy)
	return RobloxTranslator:FormatByKey(s4)
end)

t3.text = (not ok2 or (not result2 or result2 == "")) and "Friends" or result2

local t4 = {
	id = "global"
}
local s5 = "CoreScripts.TextChat.ChannelTabs.Global2"
local ok3, result3 = pcall(function() -- line: 20
	-- upvalues: RobloxTranslator (copy), s5 (copy)
	return RobloxTranslator:FormatByKey(s5)
end)

t4.text = (not ok3 or (not result3 or result3 == "")) and "Global" or result3
t1[1] = t2
t1[2] = t3
t1[3] = t4

local function LeaderboardTabs(t5: {[any]: any}) -- line: 42
	-- upvalues: usePlatformLeaderboard (copy), FallbackSignals (copy), SignalsReact (copy), React (copy), View (copy), Tabs (copy), InputSize (copy), FillBehavior (copy), t1 (copy)
	local v33 = usePlatformLeaderboard()
	local v34 = if v33 == nil then FallbackSignals.getHasActiveLeaderboard else v33.getHasActiveLeaderboard
	local v35 = SignalsReact.useSignalState(v34)

	React.useEffect(function() -- line: 51
		-- upvalues: v35 (copy), t5 (copy)
		if not v35 and t5.onPlatformTabsUnavailable then
			t5.onPlatformTabsUnavailable()
		end
	end, {
		v35,
		t5.onPlatformTabsUnavailable
	})

	local v36 = React.useCallback(function(p1) -- line: 57
		-- upvalues: t5 (copy)
		t5.onActivated((tostring(p1)))
	end, { t5.onActivated })

	if not v35 then
		return nil
	end

	return React.createElement(View, {
		Name = "CoreUI_LeaderboardTabs",
		tag = "col size-full-0 auto-y",
		LayoutOrder = t5.layoutOrder
	}, {
		Tabs = React.createElement(Tabs, {
			activeTabId = t5.activeTabId,
			size = InputSize.Small,
			fillBehavior = FillBehavior.Fill,
			onActivated = v36,
			tabs = t1
		})
	})
end

return React.memo(LeaderboardTabs)
