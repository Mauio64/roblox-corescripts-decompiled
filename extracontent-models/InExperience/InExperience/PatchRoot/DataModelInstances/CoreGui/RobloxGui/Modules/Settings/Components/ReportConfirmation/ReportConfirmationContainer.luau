local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local enumerate = require(CorePackages.Packages.enumerate)

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Core.Style.withStyle

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)

local GetFFlagVoiceARUnblockingUnmutingEnabled = require(RobloxGui.Modules.Flags.GetFFlagVoiceARUnblockingUnmutingEnabled)

local ReportActionSelection = require(script.Parent.ReportActionSelection)
local ReportActionAreYouSure = require(script.Parent.ReportActionAreYouSure)

local v = enumerate("ReportPages", { SelectActions = 1, ConfirmAction = 2 })

local extended = Roact.PureComponent:extend("ReportConfirmationContainer")

extended.defaultProps = {
	blockingUtility = BlockingUtility,
	voiceChatServiceManager = default,
	isVoiceReport = false,
	closeMenu = function() end
}

extended.validateProps = t.interface({
	player = t.strictInterface({ UserId = t.number, Name = t.string, DisplayName = t.string }),
	isVoiceReport = t.boolean,
	closeMenu = t.callback,
	blockingAnalytics = t.optional(t.table),
	reportAbuseAnalytics = t.optional(t.table)
})

local function getIsPlayerBlockedByUserId(blockingUtility, userId) -- 1 equivalent call inferred from this helper
	return Promise.new(function(callback, _)
		callback(blockingUtility:IsPlayerBlockedByUserId(userId))
	end)
end

function extended:init()
	local player = self.props.player
	local participants = self.props.voiceChatServiceManager.participants

	self:setState({ absoluteWidth = 0 })

	if self.props.onSizeChanged then
		self.props.onSizeChanged:Connect(function(p)
			self:setState({ absoluteWidth = p.X })
		end)
	end

	local participant = participants[tostring(player.UserId)]

	self.userFullName = player.DisplayName .. "(@" .. player.Name .. ")"

	function self.onMuteCheckboxActivated(muteFlipped)
		self:setState({ muteFlipped = muteFlipped })
	end

	function self.onBlockCheckboxActivated(blockFlipped)
		self:setState({ blockFlipped = blockFlipped })
	end

	function self.processMuteAndBlocking()
		local blockFlipped = self.state.blockFlipped
		local muteFlipped = self.state.muteFlipped

		if blockFlipped and not self.state.targetInitiallyBlocked then
			if self.props.blockingUtility:BlockPlayerAsync(player) then
				self.props.blockingAnalytics:action("SettingsHub", "blockUser", {
					blockeeUserId = player.UserId
				})
			end
		elseif
			not blockFlipped
			and self.state.targetInitiallyBlocked
			and GetFFlagVoiceARUnblockingUnmutingEnabled()
			and self.props.blockingUtility:UnblockPlayerAsync(player)
		then
			self.props.blockingAnalytics:action("SettingsHub", "unblockUser", {
				blockeeUserId = player.UserId
			})
		end

		local participant2 = self.props.voiceChatServiceManager.participants[tostring(player.UserId)]

		if muteFlipped and not self.state.targetInitiallyVoiceMuted then
			self.props.blockingUtility:MutePlayer(player)
			self.props.reportAbuseAnalytics:reportEventAndIncrement("muteUser")

			if participant2 and not participant2.isMutedLocally then
				self.props.voiceChatServiceManager:ToggleMutePlayer(
					player.UserId,
					Constants.VOICE_CONTEXT_TYPE.REPORT_MENU
				)
			end
		elseif
			not muteFlipped
			and self.state.targetInitiallyVoiceMuted
			and GetFFlagVoiceARUnblockingUnmutingEnabled()
		then
			self.props.blockingUtility:UnmutePlayer(player)
			self.props.reportAbuseAnalytics:reportEventAndIncrement("unmuteUser")

			if participant2 and participant2.isMutedLocally then
				self.props.voiceChatServiceManager:ToggleMutePlayer(
					player.UserId,
					Constants.VOICE_CONTEXT_TYPE.REPORT_MENU
				)
			end
		end

		self.props.closeMenu()
	end

	function self.onActionSelectionDoneActivated(blockFlipped, muteFlipped)
		self:setState({ blockFlipped = blockFlipped, muteFlipped = muteFlipped })

		if
			(blockFlipped or muteFlipped)
			and (muteFlipped ~= self.state.targetInitiallyVoiceMuted or blockFlipped ~= self.state.targetInitiallyBlocked)
		then
			self:setState({ currentPage = v.ConfirmAction })
		else
			self.processMuteAndBlocking()
		end
	end

	function self.onYesOrNoConfirmation()
		self.processMuteAndBlocking()
	end

	function self.onYesOrNoCancel()
		self:setState({ currentPage = v.SelectActions })
	end

	self:setState({ currentPage = v.SelectActions })

	if participant then
		self:setState({
			targetInitiallyVoiceMuted = participant.isMutedLocally,
			muteFlipped = participant.isMutedLocally
		})
	else
		self:setState({ targetInitiallyVoiceMuted = false, muteFlipped = false })
	end

	getIsPlayerBlockedByUserId(self.props.blockingUtility, player.UserId):andThen(function(p) -- inferred equivalent call
		self:setState({ targetInitiallyBlocked = p, blockFlipped = p })
	end)
end

function extended:renderContent()
	local currentPage = self.state.currentPage
	local uiScale

	if self.props.onSizeChanged then
		local absoluteWidth = self.state.absoluteWidth

		uiScale = absoluteWidth >= 800 and 1.3 or absoluteWidth > 600 and 1 or absoluteWidth / 600
	else
		uiScale = 1.3
	end

	local v2

	if self.state.muteFlipped == nil then
		v2 = false
	else
		v2 = self.state.muteFlipped
	end

	local v3

	if self.state.blockFlipped == nil then
		v3 = false
	else
		v3 = self.state.blockFlipped
	end

	local element = Roact.createElement(ReportActionSelection, {
		titleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.Heading.Report.ThanksForReport"),
		subtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.ThankYou"),
		instructionText = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.OtherActionsHeader"),
		muteText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.MutePlayer", {
			Player = self.userFullName
		}),
		blockText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.BlockPlayer", {
			Player = self.userFullName
		}),
		doneText = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Report.Done"),
		showVoiceMuting = self.props.isVoiceReport,
		isVoiceMuted = v2 or self.state.targetInitiallyVoiceMuted,
		isBlocked = v3 or self.state.targetInitiallyBlocked,
		onMuteCheckboxActivated = self.onMuteCheckboxActivated,
		onBlockCheckboxActivated = self.onBlockCheckboxActivated,
		onDoneActivated = self.onActionSelectionDoneActivated,
		uiScale = uiScale,
		ZIndex = self.props.ZIndex
	})

	local element2 = Roact.createElement(ReportActionAreYouSure, {
		mutedTitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.MutePlayer", {
			Player = self.userFullName
		}),
		blockedTitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.BlockPlayer", {
			Player = self.userFullName
		}),
		mutedAndBlockedTitleText = RobloxTranslator:FormatByKey(
			"Feature.SettingsHub.ReportSubmitted.Label.MuteAndBlockPlayer",
			{ DisplayName = self.userFullName }
		),
		mutedSubtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.MutedSubtitleText", {
			Player = self.userFullName
		}),
		blockedSubtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.BlockedSubtitleText", {
			Player = self.userFullName
		}),
		mutedAndBlockedSubtitleText = RobloxTranslator:FormatByKey(
			"Feature.SettingsHub.ReportSubmitted.Label.MuteAndBlockWarning",
			{ Player = self.userFullName }
		),
		cancelText = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel"),
		confirmText = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Confirm"),
		isMuted = self.state.muteFlipped,
		isBlocked = self.state.blockFlipped,
		onCancelActivated = self.onYesOrNoCancel,
		onConfirmActivated = self.onYesOrNoConfirmation,
		uiScale = uiScale,
		ZIndex = self.props.ZIndex
	})

	local v4 = nil

	if currentPage == v.SelectActions then
		return element
	end

	return if currentPage == v.ConfirmAction then element2 else v4
end

function extended:render()
	if FFlagCoreUiMigrateUIBloxToFoundation then
		return self:renderContent()
	end

	return withStyle(function(_)
		return self:renderContent()
	end)
end

return extended
