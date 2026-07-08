local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Promise = require(CorePackages.Packages.Promise)
local enumerate = require(CorePackages.Packages.enumerate)
local withStyle = require(CorePackages.Packages.UIBlox).Core.Style.withStyle
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local GetFFlagVoiceARUnblockingUnmutingEnabled = require(RobloxGui.Modules.Flags.GetFFlagVoiceARUnblockingUnmutingEnabled)
local ReportActionSelection = require(script.Parent.ReportActionSelection)
local ReportActionAreYouSure = require(script.Parent.ReportActionAreYouSure)
local v16 = enumerate("ReportPages", {
	SelectActions = 1,
	ConfirmAction = 2
})
local v17 = Roact.PureComponent:extend("ReportConfirmationContainer")

v17.defaultProps = {
	isVoiceReport = false,
	blockingUtility = BlockingUtility,
	voiceChatServiceManager = default,
	closeMenu = function() -- line: 36
	end
}
v17.validateProps = t.interface({
	player = t.strictInterface({
		UserId = t.number,
		Name = t.string,
		DisplayName = t.string
	}),
	isVoiceReport = t.boolean,
	closeMenu = t.callback,
	blockingAnalytics = t.optional(t.table),
	reportAbuseAnalytics = t.optional(t.table)
})

local function getIsPlayerBlockedByUserId(p1, p2) -- line: 57
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 58
		-- upvalues: p1 (copy), p2 (copy)
		resolve(p1:IsPlayerBlockedByUserId(p2))
	end)
end

function v17.init(p4) -- line: 63
	-- upvalues: GetFFlagVoiceARUnblockingUnmutingEnabled (copy), Constants (copy), v16 (copy), Promise (copy)
	local player = p4.props.player
	local participants = p4.props.voiceChatServiceManager.participants

	p4:setState({
		absoluteWidth = 0
	})

	if p4.props.onSizeChanged then
		p4.props.onSizeChanged:Connect(function(p5) -- line: 72
			-- upvalues: p4 (copy)
			p4:setState({
				absoluteWidth = p5.X
			})
		end)
	end

	local v24 = participants[tostring(player.UserId)]

	p4.userFullName = player.DisplayName .. "(@" .. player.Name .. ")"

	function p4.onMuteCheckboxActivated(p6) -- line: 82
		-- upvalues: p4 (copy)
		p4:setState({
			muteFlipped = p6
		})
	end
	function p4.onBlockCheckboxActivated(p7) -- line: 88
		-- upvalues: p4 (copy)
		p4:setState({
			blockFlipped = p7
		})
	end
	function p4.processMuteAndBlocking() -- line: 94
		-- upvalues: p4 (copy), player (copy), GetFFlagVoiceARUnblockingUnmutingEnabled (copy), Constants (copy)
		local blockFlipped = p4.state.blockFlipped
		local muteFlipped = p4.state.muteFlipped

		if blockFlipped and not p4.state.targetInitiallyBlocked then
			if p4.props.blockingUtility:BlockPlayerAsync(player) then
				p4.props.blockingAnalytics:action("SettingsHub", "blockUser", {
					blockeeUserId = player.UserId
				})
			end
		elseif not blockFlipped and p4.state.targetInitiallyBlocked and GetFFlagVoiceARUnblockingUnmutingEnabled() and p4.props.blockingUtility:UnblockPlayerAsync(player) then
			p4.props.blockingAnalytics:action("SettingsHub", "unblockUser", {
				blockeeUserId = player.UserId
			})
		end

		local v44 = p4.props.voiceChatServiceManager.participants[tostring(player.UserId)]

		if muteFlipped and not p4.state.targetInitiallyVoiceMuted then
			p4.props.blockingUtility:MutePlayer(player)
			p4.props.reportAbuseAnalytics:reportEventAndIncrement("muteUser")

			if v44 and not v44.isMutedLocally then
				p4.props.voiceChatServiceManager:ToggleMutePlayer(player.UserId, Constants.VOICE_CONTEXT_TYPE.REPORT_MENU)
			end
		elseif not muteFlipped and p4.state.targetInitiallyVoiceMuted and GetFFlagVoiceARUnblockingUnmutingEnabled() then
			p4.props.blockingUtility:UnmutePlayer(player)
			p4.props.reportAbuseAnalytics:reportEventAndIncrement("unmuteUser")

			if v44 and v44.isMutedLocally then
				p4.props.voiceChatServiceManager:ToggleMutePlayer(player.UserId, Constants.VOICE_CONTEXT_TYPE.REPORT_MENU)
			end
		end

		p4.props.closeMenu()
	end
	function p4.onActionSelectionDoneActivated(p8, p9) -- line: 151
		-- upvalues: p4 (copy), v16 (copy)
		p4:setState({
			blockFlipped = p8,
			muteFlipped = p9
		})

		if not p8 and not p9 or p9 == p4.state.targetInitiallyVoiceMuted and p8 == p4.state.targetInitiallyBlocked then
			p4.processMuteAndBlocking()

			return
		end

		p4:setState({
			currentPage = v16.ConfirmAction
		})
	end
	function p4.onYesOrNoConfirmation() -- line: 174
		-- upvalues: p4 (copy)
		p4.processMuteAndBlocking()
	end
	function p4.onYesOrNoCancel() -- line: 178
		-- upvalues: p4 (copy), v16 (copy)
		p4:setState({
			currentPage = v16.SelectActions
		})
	end

	p4:setState({
		currentPage = v16.SelectActions
	})

	if v24 then
		p4:setState({
			targetInitiallyVoiceMuted = v24.isMutedLocally,
			muteFlipped = v24.isMutedLocally
		})
	else
		p4:setState({
			targetInitiallyVoiceMuted = false,
			muteFlipped = false
		})
	end

	local blockingUtility = p4.props.blockingUtility
	local UserId = player.UserId

	Promise.new(function(resolve, _) -- line: 58
		-- upvalues: blockingUtility (copy), UserId (copy)
		resolve(blockingUtility:IsPlayerBlockedByUserId(UserId))
	end):andThen(function(p11) -- line: 201
		-- upvalues: p4 (copy)
		p4:setState({
			targetInitiallyBlocked = p11,
			blockFlipped = p11
		})
	end)
end
function v17.renderContent(p12) -- line: 209
	-- upvalues: Roact (copy), ReportActionSelection (copy), RobloxTranslator (copy), ReportActionAreYouSure (copy), v16 (copy)
	local currentPage = p12.state.currentPage
	local n1 = 1.3

	if p12.props.onSizeChanged then
		local absoluteWidth = p12.state.absoluteWidth

		n1 = if not (absoluteWidth >= 800) then if not (absoluteWidth > 600) then absoluteWidth / 600 else 1 else 1.3
	end

	local v31 = p12.state.muteFlipped ~= nil and p12.state.muteFlipped
	local v32 = p12.state.blockFlipped ~= nil and p12.state.blockFlipped
	local v33 = Roact.createElement(ReportActionSelection, {
		titleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.Heading.Report.ThanksForReport"),
		subtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.ThankYou"),
		instructionText = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Report.OtherActionsHeader"),
		muteText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.MutePlayer", {
			Player = p12.userFullName
		}),
		blockText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.BlockPlayer", {
			Player = p12.userFullName
		}),
		doneText = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Report.Done"),
		showVoiceMuting = p12.props.isVoiceReport,
		isVoiceMuted = v31 or p12.state.targetInitiallyVoiceMuted,
		isBlocked = v32 or p12.state.targetInitiallyBlocked,
		onMuteCheckboxActivated = p12.onMuteCheckboxActivated,
		onBlockCheckboxActivated = p12.onBlockCheckboxActivated,
		onDoneActivated = p12.onActionSelectionDoneActivated,
		uiScale = n1,
		ZIndex = p12.props.ZIndex
	})
	local v34 = Roact.createElement(ReportActionAreYouSure, {
		mutedTitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.MutePlayer", {
			Player = p12.userFullName
		}),
		blockedTitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.BlockPlayer", {
			Player = p12.userFullName
		}),
		mutedAndBlockedTitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.Label.MuteAndBlockPlayer", {
			DisplayName = p12.userFullName
		}),
		mutedSubtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.MutedSubtitleText", {
			Player = p12.userFullName
		}),
		blockedSubtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.BlockedSubtitleText", {
			Player = p12.userFullName
		}),
		mutedAndBlockedSubtitleText = RobloxTranslator:FormatByKey("Feature.SettingsHub.ReportSubmitted.Label.MuteAndBlockWarning", {
			Player = p12.userFullName
		}),
		cancelText = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Cancel"),
		confirmText = RobloxTranslator:FormatByKey("InGame.InspectMenu.Action.Confirm"),
		isMuted = p12.state.muteFlipped,
		isBlocked = p12.state.blockFlipped,
		onCancelActivated = p12.onYesOrNoCancel,
		onConfirmActivated = p12.onYesOrNoConfirmation,
		uiScale = n1,
		ZIndex = p12.props.ZIndex
	})
	local v35 = nil

	if currentPage == v16.SelectActions then
		return v33
	end

	if currentPage == v16.ConfirmAction then
		v35 = v34
	end

	return v35
end
function v17.render(p13) -- line: 297
	-- upvalues: FFlagCoreUiMigrateUIBloxToFoundation (copy), withStyle (copy)
	if FFlagCoreUiMigrateUIBloxToFoundation then
		return p13:renderContent()
	end

	return withStyle(function(_) -- line: 301
		-- upvalues: p13 (copy)
		return p13:renderContent()
	end)
end

return v17
