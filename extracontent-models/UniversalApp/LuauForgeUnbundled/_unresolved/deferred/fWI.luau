local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local gamesProductInfoReducer = require("@luauforge/bundled/cyL").GamesProductInfoReducer
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local module = require("@luauforge/bundled/fWH")
local playButtonStates = module.PlayButtonStates
local useOnPlayButtonCallback = module.useOnPlayButtonCallback
local useOnPlaySquadButtonCallback = module.useOnPlaySquadButtonCallback
local usePlayButtonState = module.usePlayButtonState
local playButtonView = module.PlayButtonView
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local Foundation = require(CorePackages.Packages.Foundation)
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local UIBlox = require(CorePackages.Packages.UIBlox)
local menuDirection = UIBlox.App.Menu.MenuDirection

local module2 = require("@luauforge/deferred/fWJ")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local fFlagLuaAppPlayButtonLoadingDurationTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPlayButtonLoadingDurationTelemetry

local fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP

local fFlagLuaAppPlayButtonPrivatePT = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppPlayButtonPrivatePT

local fIntLuaAppPlayButtonSecondaryButtonGap = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntLuaAppPlayButtonSecondaryButtonGap

local function fn(props)
	local v5 = useLocalization({
		join = "Feature.ExperienceDetails.PlayButtonText.ActionNeeded",
		play = "Feature.ExperienceDetails.PlayButtonText.Play",
		playDemo = "Feature.ExperienceDetails.PlayButtonText.PlayDemo",
		playtest = fFlagLuaAppPlayButtonPrivatePT and "Feature.ExperienceDetails.PlayButtonText.Playtest" or nil,
		unlock = "Feature.ExperienceDetails.PlayButtonText.Unlock",
		joinWithParty = "Feature.Squads.Action.JoinWithParty",
		unavailable = "Feature.ExperienceDetails.PlayButtonText.Unavailable",
		waitingForParty = "Feature.Squads.Action.WaitingForParty"
	})

	local v6 = useTokens()

	return Roact.createElement(
		"Frame",
		{
			Size = props.Size,
			LayoutOrder = props.LayoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		{
			PlayButtonView = Roact.createElement(playButtonView, {
				playButtonState = props.playButtonState,
				gameProductInfo = props.gameProductInfo,
				localized = v5,
				tokens = v6,
				onPlayButtonActivated = props.onPlayButtonActivated,
				onPlaySquadButtonActivated = props.onPlaySquadButtonActivated or function() end,
				shouldLaunchWhenLoading = false,
				shouldLaunchOnReleaseAfterUnmount = false,
				squadButtonMenuDirection = menuDirection.Up,
				buttonSize = inputSize.Large,
				width = UDim.new(1, 0),
				useUIBloxButton = true,
				testId = props.testId
			})
		}
	)
end

local extended = Roact.PureComponent:extend("PlayButtonContainer")

local strictInterface = t.strictInterface
local v5 = {
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

local v6 = if fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP then t.optional(t.boolean) else nil
v5.shouldUseUnifiedPlayButtonView = v6

v5.onPlayButtonCallback = t.callback
local v7 = if getFFlagIsSquadEnabled() then t.callback else nil
v5.onPlaySquadButtonCallback = v7
v5.playButtonState = t.string
v5.secondaryPlayButtonState = t.optional(t.string)

v5.gameProductInfo = t.optional(t.table)
extended.validateProps = strictInterface(v5)

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

	self.onPlaySquadButtonActivated = getFFlagIsSquadEnabled() and function(p2)
		if not self.isMounted then
			return
		end

		self.props.onPlaySquadButtonCallback(p2)
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

	if
		fFlagLuaAppMobileEdpPlayButtonPartialUnificationIXP
		and props.props.shouldUseUnifiedPlayButtonView
	then
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

		local udim = UDim2.new(0.5, -fIntLuaAppPlayButtonSecondaryButtonGap / 2, 1, 0)

		local createElement = Roact.createElement

		local v10 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fIntLuaAppPlayButtonSecondaryButtonGap)
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
		local v12 = {
			Size = udim,
			LayoutOrder = 2,
			playButtonState = props.props.secondaryPlayButtonState,
			gameProductInfo = gameProductInfo,
			onPlayButtonActivated = props.onSecondaryPlayButtonActivated,
			onPlaySquadButtonActivated = props.onPlaySquadButtonActivated,
			testId = 0
		}
		local v13 = if props.props.testId then props.props.testId .. "--secondary" else nil
		v12.testId = v13
		v10.SecondaryPlayButton = createElement2(fn, v12)
		return createElement(
			"Frame",
			{
				Size = size,
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			v10
		)
	elseif props.props.secondaryPlayButtonState == nil then
		local createElement = Roact.createElement
		local v9 = {
			Size = size,
			LayoutOrder = layoutOrder,
			playButtonState = playButtonState,
			price = price,
			localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
			onPlayButtonActivated = props.onPlayButtonActivated,
			onPlaySquadButtonActivated = 0,
			testId = 0
		}
		local v10 = if getFFlagIsSquadEnabled() then props.onPlaySquadButtonActivated else nil
		v9.onPlaySquadButtonActivated = v10
		v9.testId = props.props.testId
		return createElement(module2, v9)
	else
		local udim = UDim2.new(0.5, -fIntLuaAppPlayButtonSecondaryButtonGap / 2, 1, 0)

		local createElement = Roact.createElement

		local children = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fIntLuaAppPlayButtonSecondaryButtonGap)
			}),
			PlayButton = 0,
			SecondaryPlayButton = 0
		}

		local createElement2 = Roact.createElement
		local v11 = {
			Size = udim,
			LayoutOrder = 1,
			playButtonState = playButtonState,
			price = price,
			localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
			onPlayButtonActivated = props.onPlayButtonActivated,
			onPlaySquadButtonActivated = 0,
			testId = 0
		}
		local v12 = if getFFlagIsSquadEnabled() then props.onPlaySquadButtonActivated else nil
		v11.onPlaySquadButtonActivated = v12
		v11.testId = props.props.testId
		children.PlayButton = createElement2(module2, v11)

		local createElement3 = Roact.createElement
		local v14 = {
			Size = udim,
			LayoutOrder = 2,
			playButtonState = props.props.secondaryPlayButtonState,
			price = price,
			localizedFiatPrice = gameProductInfo and gameProductInfo.localizedFiatPrice or "",
			onPlayButtonActivated = props.onSecondaryPlayButtonActivated,
			onPlaySquadButtonActivated = 0,
			testId = 0
		}
		local v15 = if getFFlagIsSquadEnabled() then props.onPlaySquadButtonActivated else nil
		v14.onPlaySquadButtonActivated = v15
		local v16 = if props.props.testId then props.props.testId .. "--secondary" else nil
		v14.testId = v16
		children.SecondaryPlayButton = createElement3(module2, v14)
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

return (RoactRodux.connect(function(p2, p3)
	local universeId = p3.universeId
	return { gameProductInfo = p2[gamesProductInfoReducer.key][universeId] }
end)(function(props)
	local v9 = usePlayButtonState(
		useRoactService(roactNetworking),
		props.universeId,
		nil,
		nil,
		fFlagLuaAppPlayButtonLoadingDurationTelemetry and true or nil,
		fFlagLuaAppPlayButtonLoadingDurationTelemetry and "PlayButton" or nil
	)

	local v10 = useOnPlayButtonCallback(
		props.universeId,
		props.referralSource,
		"PlayButton",
		nil,
		"LuaGameCard",
		props.experienceJoinData,
		props.placeId
	)
	local v11

	if getFFlagIsSquadEnabled() then
		v11 = useOnPlaySquadButtonCallback(
			menuDirection.Up,
			v9.playButtonState,
			props.referralSource,
			props.universeId
		)
	end

	local v12 = v9.playButtonState
	local secondaryPlayButtonState = v9.secondaryPlayButtonState

	if secondaryPlayButtonState ~= nil then
		local v13 = v12 == playButtonStates.UnplayableOther
		local v14 = secondaryPlayButtonState == playButtonStates.UnplayableOther

		if v13 and not v14 then
			v12 = secondaryPlayButtonState
			secondaryPlayButtonState = nil
		elseif v14 then
			secondaryPlayButtonState = nil
		end
	end

	local joined = Cryo.Dictionary.join(props, {
		onPlayButtonCallback = v10,
		onPlaySquadButtonCallback = v11,
		playButtonState = v12,
		secondaryPlayButtonState = secondaryPlayButtonState
	})

	return Roact.createElement(extended, joined)
end))
