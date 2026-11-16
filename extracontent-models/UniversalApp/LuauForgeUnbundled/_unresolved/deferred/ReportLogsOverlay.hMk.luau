local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local UIBlox = require(CorePackages.Packages.UIBlox)

local module2 = require("@luauforge/bundled/fvl")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local module3 = require("@luauforge/bundled/fTi")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle

local default = require("@luauforge/bundled/bXs").ExternalContentSharingProtocol.default

local LogReporterService = game:GetService("LogReporterService")
local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")

local reportDeviceLogs = require("@luauforge/deferred/hMl").reportDeviceLogs

local function ReportLogsOverlay()
	local v5 = useDispatch()
	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)

	local v6 = React.useCallback(function()
		local placeId = game.PlaceId
		local localPlayer = Players.LocalPlayer
		local userId = localPlayer and localPlayer.UserId or 0

		local success, result = pcall(function()
			if localPlayer then
				return VoiceChatService:IsVoiceEnabledForUserIdAsync(userId)
			end

			return false, false
		end)

		local v7 = reportDeviceLogs(LogReporterService, userId, placeId, success and result or false)

		setState(v7.url)
		setState2(v7.reportId)
		setState3(true)
	end, { game.PlaceId })

	local v7 = React.useCallback(function()
		v5(module2())
	end, {})

	local v8 = module3({
		cancelButtonText = "CommonUI.Features.Action.Close",
		sendButtonText = "CommonUI.Features.Action.Send",
		dialogTitle = "CommonUI.Features.Label.ReportLogs",
		promptText = "CommonUI.Features.Prompt.ReportLogsQuestion",
		resultText = "CommonUI.Features.Prompt.ReportLogsResult"
	})

	local v9 = useStyle()
	local v10 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local createElement = React.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v9.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = 1,
		Active = true,
		Selectable = false
	}

	local createElement2 = React.createElement
	local v15 = {
		title = v8.dialogTitle,
		screenSize = v10,
		bodyText = 0,
		middleContent = 0,
		buttonStackInfo = 0
	}

	local v16 = if state3 then string.format("%s\nreportId: %s", v8.resultText, state2) else v8.promptText
	v15.bodyText = v16

	function v15.middleContent()
		local createElement3 = React.createElement
		local v18 = {}
		v18.Text = state
		v18.TextColor3 = v9.Tokens.Color.Content.Link.Color3
		v18.TextWrapped = true
		v18.TextSize = v9.Tokens.FontSize.FontSize_300
		local v19 = if state3 then UDim2.new(1, 0, 0, 75) else UDim2.new(0, 0, 0, 0)
		v18.Size = v19
		v18.BackgroundTransparency = 1
		v18[React.Event.Activated] = function()
			default:shareUrl({ url = state, context = "ReportLogsUrlShare" })
		end

		return createElement3("TextButton", v18)
	end

	v15.buttonStackInfo = {
		buttons = {
			{
				buttonType = buttonType.Secondary,
				props = { onActivated = v7, text = v8.cancelButtonText }
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					text = v8.sendButtonText,
					userInteractionEnabled = not state3,
					isDisabled = state3,
					onActivated = v6
				}
			}
		}
	}
	return createElement("Frame", v12, {
		AlertWindow = createElement2(interactiveAlert, v15)
	})
end

return ReportLogsOverlay
