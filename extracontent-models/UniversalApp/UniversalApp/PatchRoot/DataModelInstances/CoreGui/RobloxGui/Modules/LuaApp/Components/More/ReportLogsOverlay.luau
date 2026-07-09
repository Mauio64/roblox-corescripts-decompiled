local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local LogReporterService = game:GetService("LogReporterService")
local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local reportDeviceLogs = require(CorePackages.Workspace.Packages.LogReporting).reportDeviceLogs

local function ReportLogsOverlay() -- line: 25
	-- upvalues: useDispatch (copy), React (copy), Players (copy), VoiceChatService (copy), reportDeviceLogs (copy), LogReporterService (copy), CloseCentralOverlay (copy), useLocalization (copy), useStyle (copy), useSelector (copy), InteractiveAlert (copy), default (copy), ButtonType (copy)
	local v19 = useDispatch()
	local v20, v21 = React.useState("")
	local v22, v23 = React.useState("")
	local v24, v25 = React.useState(false)
	local v26 = React.useCallback(function() -- line: 31
		-- upvalues: Players (copy), VoiceChatService (copy), reportDeviceLogs (copy), LogReporterService (copy), v21 (copy), v23 (copy), v25 (copy)
		local PlaceId = game.PlaceId
		local LocalPlayer = Players.LocalPlayer
		local v33 = LocalPlayer and LocalPlayer.UserId or 0
		local ok, result = pcall(function() -- line: 36
			-- upvalues: LocalPlayer (copy), VoiceChatService (copy), v33 (copy)
			if LocalPlayer then
				return VoiceChatService:IsVoiceEnabledForUserIdAsync(v33)
			end

			return false, false
		end)
		local v36 = not not ok and (result or false)
		local v37 = reportDeviceLogs(LogReporterService, v33, PlaceId, v36)

		v21(v37.url)
		v23(v37.reportId)
		v25(true)
	end, { game.PlaceId })
	local v27 = React.useCallback(function() -- line: 53
		-- upvalues: v19 (copy), CloseCentralOverlay (copy)
		v19(CloseCentralOverlay())
	end, {})
	local v28 = useLocalization({
		cancelButtonText = "CommonUI.Features.Action.Close",
		sendButtonText = "CommonUI.Features.Action.Send",
		dialogTitle = "CommonUI.Features.Label.ReportLogs",
		promptText = "CommonUI.Features.Prompt.ReportLogsQuestion",
		resultText = "CommonUI.Features.Prompt.ReportLogsResult"
	})
	local v29 = useStyle()
	local v30 = useSelector(function(p1) -- line: 65
		return p1.ScreenSize
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Active = true,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v29.Theme.BackgroundUIDefault.Color
	}, {
		AlertWindow = React.createElement(InteractiveAlert, {
			title = v28.dialogTitle,
			screenSize = v30,
			bodyText = if not v24 then v28.promptText else string.format("%s\nreportId: %s", v28.resultText, v22),
			middleContent = function() -- line: 82
				-- upvalues: React (copy), v20 (copy), v29 (copy), v24 (copy), default (copy)
				return React.createElement("TextButton", {
					Text = v20,
					TextColor3 = v29.Tokens.Color.Content.Link.Color3,
					TextWrapped = true,
					TextSize = v29.Tokens.FontSize.FontSize_300,
					Size = if not v24 then UDim2.new(0, 0, 0, 0) else UDim2.new(1, 0, 0, 75),
					BackgroundTransparency = 1,
					[React.Event.Activated] = function() -- line: 90
						-- upvalues: default (copy), v20 (copy)
						default:shareUrl({
							context = "ReportLogsUrlShare",
							url = v20
						})
					end
				})
			end,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = v27,
							text = v28.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							text = v28.sendButtonText,
							userInteractionEnabled = not v24,
							isDisabled = v24,
							onActivated = v26
						}
					}
				}
			}
		})
	})
end

return ReportLogsOverlay
