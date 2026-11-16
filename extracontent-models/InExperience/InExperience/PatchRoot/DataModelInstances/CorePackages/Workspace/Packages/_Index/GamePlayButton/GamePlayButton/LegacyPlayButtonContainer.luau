local parent = script:FindFirstAncestor("GamePlayButton").Parent

local Cryo = require(parent.Cryo)
local t = require(parent.t)
local GameProductInfoRodux = require(parent.GameProductInfoRodux)
local GamesProductInfoReducer = GameProductInfoRodux.GamesProductInfoReducer
local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local PlayButtonStates = require(script.Parent.PlayButtonStates)
local useOnPlayButtonCallback = require(script.Parent.useOnPlayButtonCallback)
local useOnPlaySquadButtonCallback = require(script.Parent.useOnPlaySquadButtonCallback)
local usePlayButtonState = require(script.Parent.usePlayButtonState)
local PlayButtonView = require(script.Parent.PlayButtonView)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local UIBlox = require(parent.UIBlox)
local MenuDirection = UIBlox.App.Menu.MenuDirection

local LegacyPlayButton = require(script.Parent.LegacyPlayButton)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonLoadingDurationTelemetry = SharedFlags2.FFlagLuaAppPlayButtonLoadingDurationTelemetry

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP = SharedFlags3.FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP

local SharedFlags4 = require(parent.SharedFlags)
local FIntLuaAppPlayButtonSecondaryButtonGap = SharedFlags4.FIntLuaAppPlayButtonSecondaryButtonGap
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppPlayButtonPrivatePT = SharedFlags5.FFlagLuaAppPlayButtonPrivatePT

local function fn(props)
	local localized = useLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		play = "Feature.ExperienceDetails.PlayButtonText.Play",
		playDemo = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtest = FFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil,
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty"
	})

	local tokens = useTokens()

	return Roact.createElement(
		"Frame",
		{
			Size = props.Size,
			LayoutOrder = props.LayoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			PlayButtonView = Roact.createElement(PlayButtonView, {
				playButtonState = props.playButtonState,
				gameProductInfo = props.gameProductInfo,
				localized = localized,
				tokens = tokens,
				onPlayButtonActivated = props.onPlayButtonActivated,
				onPlaySquadButtonActivated = props.onPlaySquadButtonActivated or function() end,
				shouldLaunchWhenLoading = false,
				shouldLaunchOnReleaseAfterUnmount = false,
				squadButtonMenuDirection = MenuDirection.Up,
				buttonSize = InputSize.Large,
				width = UDim.new(1, 0),
				useUIBloxButton = true,
				testId = props.testId
			})
		}
	)
end

local extended = Roact.PureComponent:extend("PlayButtonContainer")

local strictInterface = t.strictInterface
local v = {
	universeId = t.string,
	Size = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	referralSource = t.optional(t.string),
	experienceJoinData = t.optional(t.table),
	placeId = t.optional(t.string),
	testId = t.optional(t.string),
	shouldUseUnifiedPlayButtonView = 0,
	onPlayButtonCallback = 0,
	onPlaySquadButtonCallback = 0,
	playButtonState = 0,
	secondaryPlayButtonState = 0,
	gameProductInfo = 0
}
local shouldUseUnifiedPlayButtonView

if FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then
	shouldUseUnifiedPlayButtonView = t.optional(t.boolean)
end

v.shouldUseUnifiedPlayButtonView = shouldUseUnifiedPlayButtonView

v.onPlayButtonCallback = t.callback
local onPlaySquadButtonCallback

if GetFFlagIsSquadEnabled() then
	onPlaySquadButtonCallback = t.callback
end

v.onPlaySquadButtonCallback = onPlaySquadButtonCallback
v.playButtonState = t.string
v.secondaryPlayButtonState = t.optional(t.string)

v.gameProductInfo = t.optional(t.table)
extended.validateProps = strictInterface(v)

function extended:init()
	self.isMounted = false

	function self.onPlayButtonActivated()
		if not self.isMounted then
			return
		end

		self.props.onPlayButtonCallback(self.props.playButtonState)
	end

	function self.onSecondaryPlayButtonActivated()
		if not self.isMounted then
			return
		end

		self.props.onPlayButtonCallback(self.props.secondaryPlayButtonState)
	end

	self.onPlaySquadButtonActivated = GetFFlagIsSquadEnabled() and function(p)
		if not self.isMounted then
			return
		end

		self.props.onPlaySquadButtonCallback(p)
	end or nil
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

function extended.render(props)
	local size = props.props.Size
	local layoutOrder = props.props.LayoutOrder
	local playButtonState = props.props.playButtonState
	local gameProductInfo = props.props.gameProductInfo
	local price = gameProductInfo and gameProductInfo.price or 0

	if FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP and props.props.shouldUseUnifiedPlayButtonView then
		if props.props.secondaryPlayButtonState == nil then
			return Roact.createElement(fn, {
				Size = size,
				LayoutOrder = layoutOrder,
				playButtonState = playButtonState,
				gameProductInfo = gameProductInfo,
				onPlayButtonActivated = props.onPlayButtonActivated,
				onPlaySquadButtonActivated = props.onPlaySquadButtonActivated,
				testId = props.props.testId
			})
		end

		local udim = UDim2.new(0.5, -FIntLuaAppPlayButtonSecondaryButtonGap / 2, 1, 0)

		local createElement = Roact.createElement

		local v2 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, FIntLuaAppPlayButtonSecondaryButtonGap)
			}),
			PlayButton = Roact.createElement(fn, {
				Size = udim,
				LayoutOrder = 1,
				playButtonState = playButtonState,
				gameProductInfo = gameProductInfo,
				onPlayButtonActivated = props.onPlayButtonActivated,
				onPlaySquadButtonActivated = props.onPlaySquadButtonActivated,
				testId = props.props.testId
			}),
			SecondaryPlayButton = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			Size = udim,
			LayoutOrder = 2,
			playButtonState = props.props.secondaryPlayButtonState,
			gameProductInfo = gameProductInfo,
			onPlayButtonActivated = props.onSecondaryPlayButtonActivated,
			onPlaySquadButtonActivated = props.onPlaySquadButtonActivated,
			testId = 0
		}
		local testId

		if props.props.testId then
			testId = props.props.testId .. "--secondary"
		end

		v3.testId = testId
		v2.SecondaryPlayButton = createElement2(fn, v3)
		return createElement(
			"Frame",
			{
				Size = size,
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			v2
		)
	elseif props.props.secondaryPlayButtonState == nil then
		local createElement = Roact.createElement
		local v2 = {
			Size = size,
			LayoutOrder = layoutOrder,
			playButtonState = playButtonState,
			price = price,
			localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
			onPlayButtonActivated = props.onPlayButtonActivated,
			onPlaySquadButtonActivated = 0,
			testId = 0
		}
		local onPlaySquadButtonActivated

		if GetFFlagIsSquadEnabled() then
			onPlaySquadButtonActivated = props.onPlaySquadButtonActivated
		end

		v2.onPlaySquadButtonActivated = onPlaySquadButtonActivated
		v2.testId = props.props.testId
		return createElement(LegacyPlayButton, v2)
	else
		local udim = UDim2.new(0.5, -FIntLuaAppPlayButtonSecondaryButtonGap / 2, 1, 0)

		local createElement = Roact.createElement

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, FIntLuaAppPlayButtonSecondaryButtonGap)
			}),
			PlayButton = 0,
			SecondaryPlayButton = 0
		}

		local createElement2 = Roact.createElement
		local v2 = {
			Size = udim,
			LayoutOrder = 1,
			playButtonState = playButtonState,
			price = price,
			localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
			onPlayButtonActivated = props.onPlayButtonActivated,
			onPlaySquadButtonActivated = 0,
			testId = 0
		}
		local onPlaySquadButtonActivated

		if GetFFlagIsSquadEnabled() then
			onPlaySquadButtonActivated = props.onPlaySquadButtonActivated
		end

		v2.onPlaySquadButtonActivated = onPlaySquadButtonActivated
		v2.testId = props.props.testId
		children.PlayButton = createElement2(LegacyPlayButton, v2)

		local createElement3 = Roact.createElement
		local v3 = {
			Size = udim,
			LayoutOrder = 2,
			playButtonState = props.props.secondaryPlayButtonState,
			price = price,
			localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
			onPlayButtonActivated = props.onSecondaryPlayButtonActivated,
			onPlaySquadButtonActivated = 0,
			testId = 0
		}
		local onPlaySquadButtonActivated2

		if GetFFlagIsSquadEnabled() then
			onPlaySquadButtonActivated2 = props.onPlaySquadButtonActivated
		end

		v3.onPlaySquadButtonActivated = onPlaySquadButtonActivated2
		local testId

		if props.props.testId then
			testId = props.props.testId .. "--secondary"
		end

		v3.testId = testId
		children.SecondaryPlayButton = createElement3(LegacyPlayButton, v3)
		return createElement(
			"Frame",
			{
				Size = size,
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			children
		)
	end
end

return (RoactRodux.connect(function(p, p2)
	local universeId = p2.universeId
	return { gameProductInfo = p[GamesProductInfoReducer.key][universeId] }
end)(function(props)
	local v2 = usePlayButtonState(
		useRoactService(RoactNetworking),
		props.universeId,
		nil,
		nil,
		FFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil,
		FFlagLuaAppPlayButtonLoadingDurationTelemetry and "PlayButton" or nil
	)

	local onPlayButtonCallback = useOnPlayButtonCallback(
		props.universeId,
		props.referralSource,
		"PlayButton",
		nil,
		"LuaGameCard",
		props.experienceJoinData,
		props.placeId
	)
	local onPlaySquadButtonCallback2

	if GetFFlagIsSquadEnabled() then
		onPlaySquadButtonCallback2 = useOnPlaySquadButtonCallback(
			MenuDirection.Up,
			v2.playButtonState,
			props.referralSource,
			props.universeId
		)
	end

	local playButtonState = v2.playButtonState
	local secondaryPlayButtonState = v2.secondaryPlayButtonState

	if secondaryPlayButtonState ~= nil then
		local v3 = playButtonState == PlayButtonStates.UnplayableOther
		local v4 = secondaryPlayButtonState == PlayButtonStates.UnplayableOther

		if v3 and not v4 then
			playButtonState = secondaryPlayButtonState
			secondaryPlayButtonState = nil
		elseif v4 then
			secondaryPlayButtonState = nil
		end
	end

	local joined = Cryo.Dictionary.join(props, {
		onPlayButtonCallback = onPlayButtonCallback,
		onPlaySquadButtonCallback = onPlaySquadButtonCallback2,
		playButtonState = playButtonState,
		secondaryPlayButtonState = secondaryPlayButtonState
	})

	return Roact.createElement(extended, joined)
end))
