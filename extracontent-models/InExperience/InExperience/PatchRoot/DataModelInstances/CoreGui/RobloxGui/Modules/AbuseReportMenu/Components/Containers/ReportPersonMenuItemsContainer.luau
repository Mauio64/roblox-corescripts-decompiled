local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui.RobloxGui
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)

local getMenuItemsFromConfigs = require(AbuseReportMenu.MenuConfigs.getMenuItemsFromConfigs)
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)
local ReportPlayerMenuItemConfigList = require(AbuseReportMenu.MenuConfigs.Players.ReportPlayerMenuItemConfigList)
local reportPersonUIStateReducer = require(AbuseReportMenu.Reducers.reportPersonUIStateReducer)
local handlePreselectedPlayer = require(AbuseReportMenu.Utility.handlePreselectedPlayer)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
require(RobloxGui.Modules.VoiceChat.VoiceUsersByProximity)
local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local constants = VoiceChatCore.Constants

local PlayerMenuActions = Constants.PlayerMenuActions

local defineFastFlag = game:DefineFastFlag("PreselectedPlayerReportBugfix", false)

local function alphabeticalSort(p, p2): boolean
	return p.Name:lower() < p2.Name:lower()
end

local function ReportPersonMenuItemsContainer(p)
	local menuItemSizings = getMenuItemSizings()
	local v, v2 = React.useReducer(reportPersonUIStateReducer, Constants.InitPersonUIState)

	React.useEffect(function()
		if p.utilityProps.isReportTabVisible ~= true then
			return
		end

		p.utilityProps.analyticsDispatch({
			type = Constants.AnalyticsActions.SwitchToPersonInitialSelections
		})

		if
			not defineFastFlag
			or default:UserVoiceEnabled() and default:GetVoiceJoinProgress() ~= constants.VOICE_JOIN_PROGRESS.Suspended
		then
			default:asyncInit():andThen(function()
				if p.utilityProps.preselectedPlayer then
					handlePreselectedPlayer(
						p.utilityProps.preselectedPlayer,
						true,
						v2,
						p.utilityProps.analyticsDispatch
					)
				end

				v2({ type = PlayerMenuActions.SetVoiceEnabled, enabled = true })
			end):catch(function()
				if p.utilityProps.preselectedPlayer then
					handlePreselectedPlayer(
						p.utilityProps.preselectedPlayer,
						false,
						v2,
						p.utilityProps.analyticsDispatch
					)
				end
			end)
			return
		end

		if p.utilityProps.preselectedPlayer then
			handlePreselectedPlayer(p.utilityProps.preselectedPlayer, false, v2, p.utilityProps.analyticsDispatch)
		end

		v2({ type = PlayerMenuActions.SetVoiceEnabled, enabled = false })
	end, { p.utilityProps.isReportTabVisible })

	React.useEffect(function()
		local players = {}

		if v.methodOfAbuse == Constants.AbuseMethods.VoiceChat then
			local recentUsersInteractionData = default:getRecentUsersInteractionData()

			for _, v3 in pairs(recentUsersInteractionData) do
				table.insert(players, v3.player)
			end

			table.sort(players, alphabeticalSort)
		elseif
			v.methodOfAbuse == Constants.AbuseMethods.TextChat
			or v.methodOfAbuse == Constants.AbuseMethods.Other
			or v.methodOfAbuse == Constants.AbuseMethods.Avatar
			or v.methodOfAbuse == nil
		then
			players = Players:GetPlayers()
			table.sort(players, alphabeticalSort)
		end

		local v3 = false
		local v4 = false

		local filtered = Cryo.List.filter(players, function(p2): boolean
			if v.preselectedPlayer and p2.UserId == v.preselectedPlayer.UserId then
				v3 = true
			end

			if v.allegedAbuser and p2.UserId == v.allegedAbuserId then
				v4 = true
			end

			return p2 ~= Players.LocalPlayer and p2.UserId > 0
		end)

		v2({ type = PlayerMenuActions.UpdatePlayerNameMap, playerObjects = filtered })

		if v.preselectedPlayer and v3 then
			v2({
				type = Constants.PlayerMenuActions.UpdateAbuser,
				abuseId = v.preselectedPlayer.UserId,
				abuser = v.preselectedPlayer
			})

			v2({ type = Constants.PlayerMenuActions.SetPreselectedPlayer, player = nil })
		elseif not v4 then
			v2({ type = Constants.PlayerMenuActions.UpdateAbuser, abuseId = nil, abuser = nil })
		end
	end, {
		v.methodOfAbuse,
		v.isVoiceEnabled,
		p.utilityProps.isReportTabVisible,
		v.preselectedPlayer
	})

	local menuItemsFromConfigs = getMenuItemsFromConfigs(
		v,
		v2,
		p.utilityProps,
		ReportPlayerMenuItemConfigList,
		p.isSmallPortraitViewport
	)

	local joined = Cryo.Dictionary.join({
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, menuItemSizings.ItemPadding)
		})
	}, menuItemsFromConfigs)

	return React.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, {
		MenuItems = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, joined)
	})
end

return ReportPersonMenuItemsContainer
