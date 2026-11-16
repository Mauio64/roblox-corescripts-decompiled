local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local RobloxTranslator = require(parent2.RobloxTranslator)
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper

local View = Foundation.View
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local usePlatformLeaderboard = require(parent.Hooks.usePlatformLeaderboard)
local FallbackSignals = require(parent.Common.FallbackSignals)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local PlayerListVisibilityStore = require(parent.Common.PlayerListVisibilityStore)

local FFlagPlatformLeaderboardsExposure3Enabled = require(parent.Flags.FFlagPlatformLeaderboardsExposure3Enabled)
local FStringPlatformLeaderboardsExposure3Layer = require(parent.Flags.FStringPlatformLeaderboardsExposure3Layer)

local function translateOrLegacy(p: string, p2: string) -- 3 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return RobloxTranslator:FormatByKey(p)
	end)
	return if success and result and result ~= "" then result else p2
end

local v = {
	{
		id = "server",
		text = translateOrLegacy("CoreScripts.TextChat.ChannelTabs.Here", "Here") -- inferred equivalent call
	},
	{
		id = "friends",
		text = translateOrLegacy("CommonUI.Features.Label.Friends", "Friends") -- inferred equivalent call
	},
	{
		id = "global",
		text = translateOrLegacy("CoreScripts.TextChat.ChannelTabs.Global2", "Global") -- inferred equivalent call
	}
}

local function LeaderboardTabs(props)
	local v2 = usePlatformLeaderboard()
	local v3

	if v2 == nil then
		v3 = FallbackSignals.getHasActiveLeaderboard
	else
		v3 = v2.getHasActiveLeaderboard
	end

	local v4 = SignalsReact.useSignalState(v3)

	if FFlagPlatformLeaderboardsExposure3Enabled then
		local v5 = SignalsReact.useSignalState(PlayerListVisibilityStore.getEffectiveVisible)

		if props.isVisible ~= nil then
			v5 = props.isVisible
		end

		local ref = React.useRef(false)

		React.useEffect(function()
			if v5 and v4 and not ref.current then
				ref.current = true
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(FStringPlatformLeaderboardsExposure3Layer)
			end
		end, { v4, v5 })
	end

	local tabs

	if FFlagPlayerListLocalizeGameText then
		local v5 = useLocalization({
			here = "CoreScripts.InGameMenu.Controls.Playerlist.Here",
			friends = "CoreScripts.InGameMenu.Controls.Playerlist.Friends",
			global = "CoreScripts.InGameMenu.Controls.Playerlist.Global"
		})

		tabs = {
			{ id = "server", text = v5.here },
			{ id = "friends", text = v5.friends },
			{ id = "global", text = v5.global }
		}
	else
		tabs = v
	end

	React.useEffect(function()
		if not v4 and props.onPlatformTabsUnavailable then
			props.onPlatformTabsUnavailable()
		end
	end, { v4, props.onPlatformTabsUnavailable })

	local onActivated = React.useCallback(function(p)
		props.onActivated((tostring(p)))
	end, { props.onActivated })

	if v4 then
		return React.createElement(
			View,
			{
				Name = "CoreUI_LeaderboardTabs",
				LayoutOrder = props.layoutOrder,
				tag = "col size-full-0 auto-y"
			},
			{
				Tabs = React.createElement(Tabs, {
					activeTabId = props.activeTabId,
					size = InputSize.Small,
					fillBehavior = FillBehavior.Fill,
					onActivated = onActivated,
					tabs = tabs
				})
			}
		)
	end

	return nil
end

return React.memo(LeaderboardTabs)
