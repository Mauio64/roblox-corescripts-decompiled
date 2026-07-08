local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui").RobloxGui
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local getMenuItemsFromConfigs = require(AbuseReportMenu.MenuConfigs.getMenuItemsFromConfigs)
local getMenuItemSizings = require(AbuseReportMenu.Utility.getMenuItemSizings)

require(AbuseReportMenu.Components.Types)

local Constants = require(AbuseReportMenu.Components.Constants)
local ReportPlayerMenuItemConfigList = require(AbuseReportMenu.MenuConfigs.Players.ReportPlayerMenuItemConfigList)
local reportPersonUIStateReducer = require(AbuseReportMenu.Reducers.reportPersonUIStateReducer)
local handlePreselectedPlayer = require(AbuseReportMenu.Utility.handlePreselectedPlayer)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

require(RobloxGui.Modules.VoiceChat.VoiceUsersByProximity)

local Constants2 = require(CorePackages.Workspace.Packages.VoiceChatCore).Constants
local PlayerMenuActions = Constants.PlayerMenuActions
local v16 = game:DefineFastFlag("PreselectedPlayerReportBugfix", false)

local function alphabeticalSort(p1, p2) -- line: 31
	return p1.Name:lower() < p2.Name:lower()
end
local function ReportPersonMenuItemsContainer(t1: {[any]: any}) -- line: 35
	-- upvalues: getMenuItemSizings (copy), React (copy), reportPersonUIStateReducer (copy), Constants (copy), v16 (copy), default (copy), Constants2 (copy), handlePreselectedPlayer (copy), PlayerMenuActions (copy), alphabeticalSort (copy), Players (copy), Cryo (copy), getMenuItemsFromConfigs (copy), ReportPlayerMenuItemConfigList (copy)
	local v22 = getMenuItemSizings()
	local v23, v24 = React.useReducer(reportPersonUIStateReducer, Constants.InitPersonUIState)

	React.useEffect(function() -- line: 39
		-- upvalues: t1 (copy), Constants (copy), v16 (copy), default (copy), Constants2 (copy), handlePreselectedPlayer (copy), v24 (copy), PlayerMenuActions (copy)
		if t1.utilityProps.isReportTabVisible ~= true then
			return
		end

		t1.utilityProps.analyticsDispatch({
			type = Constants.AnalyticsActions.SwitchToPersonInitialSelections
		})

		if v16 and (not default:UserVoiceEnabled() or default:GetVoiceJoinProgress() == Constants2.VOICE_JOIN_PROGRESS.Suspended) then
			if t1.utilityProps.preselectedPlayer then
				handlePreselectedPlayer(t1.utilityProps.preselectedPlayer, false, v24, t1.utilityProps.analyticsDispatch)
			end

			v24({
				enabled = false,
				type = PlayerMenuActions.SetVoiceEnabled
			})

			return
		end

		default:asyncInit():andThen(function() -- line: 67
			-- upvalues: t1 (copy), handlePreselectedPlayer (copy), v24 (copy), PlayerMenuActions (copy)
			if t1.utilityProps.preselectedPlayer then
				handlePreselectedPlayer(t1.utilityProps.preselectedPlayer, true, v24, t1.utilityProps.analyticsDispatch)
			end

			v24({
				enabled = true,
				type = PlayerMenuActions.SetVoiceEnabled
			})
		end):catch(function() -- line: 81
			-- upvalues: t1 (copy), handlePreselectedPlayer (copy), v24 (copy)
			if t1.utilityProps.preselectedPlayer then
				handlePreselectedPlayer(t1.utilityProps.preselectedPlayer, false, v24, t1.utilityProps.analyticsDispatch)
			end
		end)
	end, { t1.utilityProps.isReportTabVisible })
	React.useEffect(function() -- line: 96
		-- upvalues: v23 (copy), Constants (copy), default (copy), alphabeticalSort (copy), Players (copy), Cryo (copy), v24 (copy), PlayerMenuActions (copy)
		local t2 = {}

		if v23.methodOfAbuse == Constants.AbuseMethods.VoiceChat then
			local v28 = default:getRecentUsersInteractionData()

			for _, v in pairs(v28) do
				table.insert(t2, v.player)
			end

			table.sort(t2, alphabeticalSort)
		elseif v23.methodOfAbuse == Constants.AbuseMethods.TextChat or v23.methodOfAbuse == Constants.AbuseMethods.Other or v23.methodOfAbuse == Constants.AbuseMethods.Avatar or v23.methodOfAbuse == nil then
			t2 = Players:GetPlayers()
			table.sort(t2, alphabeticalSort)
		end

		local u31 = false
		local u32 = false
		local v33 = Cryo.List.filter(t2, function(p3) -- line: 175
			-- upvalues: v23 (copy), u31 (ref), u32 (ref), Players (copy)
			if v23.preselectedPlayer and p3.UserId == v23.preselectedPlayer.UserId then
				u31 = true
			end

			if v23.allegedAbuser and p3.UserId == v23.allegedAbuserId then
				u32 = true
			end

			return p3 ~= Players.LocalPlayer and p3.UserId > 0
		end)

		v24({
			type = PlayerMenuActions.UpdatePlayerNameMap,
			playerObjects = v33
		})

		if v23.preselectedPlayer and u31 then
			v24({
				type = Constants.PlayerMenuActions.UpdateAbuser,
				abuseId = v23.preselectedPlayer.UserId,
				abuser = v23.preselectedPlayer
			})
			v24({
				player = nil,
				type = Constants.PlayerMenuActions.SetPreselectedPlayer
			})
		elseif not u32 then
			v24({
				abuseId = nil,
				abuser = nil,
				type = Constants.PlayerMenuActions.UpdateAbuser
			})
		end
	end, {
		v23.methodOfAbuse,
		v23.isVoiceEnabled,
		t1.utilityProps.isReportTabVisible,
		v23.preselectedPlayer
	})

	local v25 = getMenuItemsFromConfigs(v23, v24, t1.utilityProps, ReportPlayerMenuItemConfigList, t1.isSmallPortraitViewport)
	local v26 = Cryo.Dictionary.join({
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v22.ItemPadding)
		})
	}, v25)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		MenuItems = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, v26)
	})
end

return ReportPersonMenuItemsContainer
