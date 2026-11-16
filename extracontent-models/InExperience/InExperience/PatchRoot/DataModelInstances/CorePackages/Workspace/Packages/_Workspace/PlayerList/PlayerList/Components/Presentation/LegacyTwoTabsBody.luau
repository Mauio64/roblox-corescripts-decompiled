local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local View = Foundation.View
local Theme = Foundation.Enums.Theme

local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = require(parent2.Localization)
local LocalizationProvider = Localization.LocalizationProvider

local useLegacyVisibilityMirror = require(parent.Hooks.useLegacyVisibilityMirror)
local LeaderboardTabs = require(parent.Components.Presentation.LeaderboardTabs)
local PlatformLeaderboardView = require(parent.Components.Presentation.PlatformLeaderboardView)
local Constants = require(parent.Common.Constants)
local FFlagPlayerListFixPlatformLeaderboardSizing = require(parent.Flags.FFlagPlayerListFixPlatformLeaderboardSizing)
local FFlagPlayerListLocalizeGameText = require(parent.Flags.FFlagPlayerListLocalizeGameText)
local FFlagPlayerListTwoTabsOnLegacyPerformance = require(parent.Flags.FFlagPlayerListTwoTabsOnLegacyPerformance)
local FFlagPlatformLeaderboardsExposure3Enabled = require(parent.Flags.FFlagPlatformLeaderboardsExposure3Enabled)

local function LegacyTwoTabsBody(props)
	local state, setState = React.useState("server")
	local localization

	if FFlagPlayerListLocalizeGameText then
		localization = React.useMemo(function()
			return InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)
		end, {})
	end

	local onPlatformTabsUnavailable = React.useCallback(function()
		setState("server")
	end, {})
	local v

	if FFlagPlayerListTwoTabsOnLegacyPerformance then
		v = props.isVisible
	else
		local v2 = useLegacyVisibilityMirror(props.isVisible)
		v = SignalsReact.useSignalState(v2)
	end

	local v2 = state == "server" or not v
	local v3 = props.platformBodyHeight == nil
	local body

	if v2 then
		if v3 then
			body = React.createElement("Frame", {
				Name = "LegacyTwoTabsServerBody",
				LayoutOrder = 3,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { ServerBody = props.serverBody })
		else
			body = props.serverBody
		end
	else
		local tab = state == "friends" and "Friends" or "Global"
		local platformBodyHeight = props.platformBodyHeight

		if FFlagPlayerListFixPlatformLeaderboardSizing and platformBodyHeight ~= nil then
			platformBodyHeight = math.max(platformBodyHeight, Constants.PLATFORM_BODY_MIN_HEIGHT)
		end

		local size

		if platformBodyHeight then
			size = UDim2.new(1, 0, 0, platformBodyHeight)
		else
			size = UDim2.new(1, 0, 1, 0)
		end

		body = React.createElement("Frame", {
			Name = "LegacyTwoTabsPlatformBody",
			LayoutOrder = 3,
			Size = size,
			BackgroundColor3 = props.backgroundColor,
			BackgroundTransparency = props.backgroundTransparency,
			BorderSizePixel = 0,
			ClipsDescendants = true
		}, {
			FlexRoot = React.createElement(View, { Size = UDim2.fromScale(1, 1), tag = "col" }, {
				PlatformLeaderboardView = React.createElement(PlatformLeaderboardView, {
					tab = tab,
					layoutOrder = 1,
					legacyPanelBackgroundColor = props.backgroundColor,
					legacyPanelBackgroundTransparency = props.backgroundTransparency
				})
			})
		})
	end

	local v4 = { LayoutOrder = props.layoutOrder, Size = 0, BackgroundTransparency = 1 }
	local size

	if v3 then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	v4.Size = size

	if not v3 then
		v4.AutomaticSize = Enum.AutomaticSize.Y
	end

	local createElement = React.createElement
	local v5 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		TabsRow = 0,
		TitleBar = 0,
		Body = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		Name = "LegacyTwoTabsTabsRow",
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = props.backgroundColor,
		BackgroundTransparency = props.backgroundTransparency,
		BorderSizePixel = 0
	}

	local createElement3 = React.createElement
	local v7 = {
		activeTabId = state,
		onActivated = setState,
		onPlatformTabsUnavailable = onPlatformTabsUnavailable,
		isVisible = 0
	}
	local isVisible

	if FFlagPlatformLeaderboardsExposure3Enabled then
		isVisible = props.isVisible
	end

	v7.isVisible = isVisible
	v5.TabsRow = createElement2("Frame", v6, {
		LeaderboardTabs = createElement3(LeaderboardTabs, v7)
	})
	local titleBar

	if v2 then
		titleBar = props.titleBar
	end

	v5.TitleBar = titleBar
	v5.Body = body
	local column = createElement("Frame", v4, v5)

	if FFlagPlayerListLocalizeGameText then
		column = React.createElement(LocalizationProvider, { localization = localization }, {
			Column = column
		})
	end

	return React.createElement(FoundationProvider, { theme = Theme.Dark }, { Column = column })
end

return React.memo(LegacyTwoTabsBody)
