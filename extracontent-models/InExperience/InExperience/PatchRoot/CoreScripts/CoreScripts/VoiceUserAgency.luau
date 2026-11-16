local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Images = InGameMenuDependencies.UIBlox.App.ImageSet.Images

local Modules = CoreGui.RobloxGui.Modules
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local VoiceChatServiceManager = require(Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Constants = require(Modules.VoiceChat.Constants)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local Migration = BuilderIcons.Migration

local GetFFlagVoiceUserAgencyEnableIXP = require(Modules.Flags.GetFFlagVoiceUserAgencyEnableIXP)
local GetFStringVoiceUserAgencyIXPLayerName = require(Modules.Flags.GetFStringVoiceUserAgencyIXPLayerName)

local defineFastInt = game:DefineFastInt("VoiceUserAgencyAlertInitTimeOffset", 5)
local defineFastInt2 = game:DefineFastInt("VoiceUserAgencyAlertStartTimeOffset", 3)
local defineFastInt3 = game:DefineFastInt("VoiceUserAgencyAlertTimerDuration", 7)

local defineFastFlag = game:DefineFastFlag("VoiceUserAgencyAddMuteDecisionAnalytics", false)
local defineFastFlag2 = game:DefineFastFlag("VoiceUserAgencyAdjustDescriptionText", false)

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.Remember")

local placeId = tostring(game.PlaceId)
local UserId = Players.LocalPlayer.UserId

local function getAppStorageTable()
	local success, result = pcall(function()
		return AppStorageService:GetItem("VoiceUserAgencyPlaceIds")
	end)

	if success then
		local success2, result2 = pcall(function()
			return HttpService:JSONDecode(result)
		end)

		if success2 then
			return result2
		end
	end

	return {}
end

local flag = false
local function resetHistory()
	if flag then
		return
	end

	local success, result = pcall(function()
		local appStorageTable = getAppStorageTable()

		for k, _ in appStorageTable do
			if k == placeId then
				appStorageTable[k] = nil
				AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(appStorageTable))
				AppStorageService:Flush()
				flag = true
				break
			end
		end
	end)

	if not success then
		v:trace(result)
	end
end

local function bindResetHistory()
	default.muteAllChanged.Event:Connect(function(_)
		if flag then
			return
		end

		local success, result = pcall(function()
			local appStorageTable = getAppStorageTable()

			for k, _ in appStorageTable do
				if k == placeId then
					appStorageTable[k] = nil
					AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(appStorageTable))
					AppStorageService:Flush()
					flag = true
					break
				end
			end
		end)

		if not success then
			v:trace(result)
		end
	end)
	default.mutedNonFriends.Event:Connect(function()
		if flag then
			return
		end

		local success, result = pcall(function()
			local appStorageTable = getAppStorageTable()

			for k, _ in appStorageTable do
				if k == placeId then
					appStorageTable[k] = nil
					AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(appStorageTable))
					AppStorageService:Flush()
					flag = true
					break
				end
			end
		end)

		if not success then
			v:trace(result)
		end
	end)
end

local function removeUserAgencyPrompt(voiceUserAgency, isRememberSetting, isMuteAll)
	voiceUserAgency:Destroy()

	if isRememberSetting then
		local appStorageTable = getAppStorageTable()
		appStorageTable[placeId] = isMuteAll
		AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(appStorageTable))
		AppStorageService:Flush()
	end

	if defineFastFlag then
		RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "SelectJoinWithVoice", {
			userId = UserId,
			voiceSessionId = default:getService():GetSessionId(),
			voiceExperienceId = default:getService():GetVoiceExperienceId(),
			isMuteAll = isMuteAll,
			isRememberSetting = isRememberSetting
		})
	end

	default:FireUserAgencySelectedEvent(isMuteAll)

	bindResetHistory()
end

local function showUserAgencyPrompt()
	local v2 = false
	local shouldRememberStatus = false

	if GetFFlagVoiceUserAgencyEnableIXP() then
		local success, result = pcall(function()
			return IXPServiceWrapper:GetLayerData(GetFStringVoiceUserAgencyIXPLayerName())
		end)

		if not (success and result and result.VoiceUserAgencyEnabled) then
			return
		end
	end

	local success, result = pcall(function()
		local appStorageTable = getAppStorageTable()

		for k, v3 in pairs(appStorageTable) do
			if k == placeId and v3 ~= nil then
				return v3
			end
		end
	end)

	if not success then
		v:trace(result)
	elseif result == nil then
		local voiceUserAgency = Instance.new("ScreenGui")
		voiceUserAgency.Name = "VoiceUserAgency"
		voiceUserAgency.ResetOnSpawn = false
		voiceUserAgency.DisplayOrder = -1
		voiceUserAgency.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		voiceUserAgency.Parent = CoreGui

		local v3 = Create("TextButton")({
			Name = "MuteAllButton",
			BorderSizePixel = 0,
			Size = UDim2.new(0.5, -6, 0, 36),
			Font = AppFonts.default:getDefault(),
			Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinMuted"),
			TextSize = 16,
			BackgroundColor3 = Color3.fromRGB(57, 59, 61),
			TextColor3 = Color3.fromRGB(178, 178, 178),
			LayoutOrder = 1,
			Create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
			Create("UIStroke")({
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(178, 178, 178)
			})
		})

		v3.Activated:Connect(function()
			v2 = true
			default:MuteAll(v2, Constants.VOICE_CONTEXT_TYPE.USER_AGENCY)
			removeUserAgencyPrompt(voiceUserAgency, shouldRememberStatus, v2)
		end)

		local v4 = Create("TextButton")({
			Name = "UnmuteAllButton",
			BorderSizePixel = 0,
			Size = UDim2.new(0.5, -6, 0, 36),
			Font = AppFonts.default:getDefault(),
			Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinUnmuted"),
			TextSize = 16,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextColor3 = Color3.fromRGB(57, 59, 61),
			LayoutOrder = 2,
			Create("UICorner")({ CornerRadius = UDim.new(0, 8) })
		})

		v4.Activated:Connect(function()
			v2 = false
			default:MuteAll(v2, Constants.VOICE_CONTEXT_TYPE.USER_AGENCY)
			removeUserAgencyPrompt(voiceUserAgency, shouldRememberStatus, v2)
		end)

		local v5 = Create("Frame")({
			Name = "TimerBar",
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0
		})

		local v6 = { Size = UDim2.fromScale(1, 1) }
		local tween = TweenService:Create(v5, TweenInfo.new(defineFastInt3, Enum.EasingStyle.Sine), v6)
		tween.Completed:Connect(function(p)
			if p == Enum.PlaybackState.Completed then
				removeUserAgencyPrompt(voiceUserAgency, shouldRememberStatus, v2)
			end
		end)

		local v7 = Create("TextLabel")({
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = BuilderIcons.Migration["icons/status/success_small"].name,
			FontFace = BuilderIcons.Font[BuilderIcons.Migration["icons/status/success_small"].variant]
		})

		local parent = Create("ImageButton")({
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundTransparency = 1,
			Image = Images["squircles/hollow"].Image,
			ImageRectOffset = Images["squircles/hollow"].ImageRectOffset,
			ImageRectSize = Images["squircles/hollow"].ImageRectSize
		})

		v7.Visible = false
		v7.Parent = parent
		parent.Activated:Connect(function()
			v7.Visible = not v7.Visible
			shouldRememberStatus = v7.Visible
			tween:Pause()

			RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "RememberJoinWithVoice", {
				userId = UserId,
				voiceSessionId = default:getService():GetSessionId(),
				voiceExperienceId = default:getService():GetVoiceExperienceId(),
				shouldRememberStatus = shouldRememberStatus
			})
		end)

		local v8 = Create("TextLabel")({
			Name = "CheckboxTextLabel",
			Font = AppFonts.default:getDefault(),
			Text = formatByKey,
			TextColor3 = Color3.fromRGB(190, 190, 190),
			TextSize = 16,
			TextWrapped = true,
			Size = UDim2.new(0, 350, 0, 24),
			BackgroundTransparency = 1,
			TextTransparency = 0,
			LayoutOrder = 2
		})

		local textSize = TextService:GetTextSize(formatByKey, 16, AppFonts.default:getDefault(), Vector2.new(350, 24))

		v8.Size = UDim2.new(0, textSize.X + 10, 0, 24)

		local instance = Create("Frame")({
			Name = "VoiceUserAgencyFrame",
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(0.9, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 4),
			BackgroundColor3 = Color3.fromRGB(57, 59, 61),
			BorderSizePixel = 0,
			Create("UICorner")({ CornerRadius = UDim.new(0, 8) }),
			Create("UISizeConstraint")({ MaxSize = Vector2.new(400, 216) }),
			Create("UIPadding")({
				PaddingTop = UDim.new(0, 24),
				PaddingLeft = UDim.new(0, 24),
				PaddingRight = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			Create("UIListLayout")({
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Create("TextLabel")({
				Name = "Title",
				Font = AppFonts.default:getBold(),
				Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinUnmuted.Title"),
				TextSize = 20,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0,
				LayoutOrder = 1
			}),
			Create("TextLabel")({
				Name = "Lower",
				Font = AppFonts.default:getDefault(),
				Text = defineFastFlag2 and RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinUnmuted.Description") or RobloxTranslator:FormatByKey("Feature.SettingsHub.VoiceUserAgency.JoinUnmuted.Description"),
				TextColor3 = Color3.fromRGB(190, 190, 190),
				TextSize = 16,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 60),
				BackgroundTransparency = 1,
				TextTransparency = 0,
				LayoutOrder = 2
			}),
			Create("Frame")({
				Name = "TimerFrame",
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Size = UDim2.new(1, 48, 0, 3),
				BackgroundTransparency = 0,
				LayoutOrder = 3,
				v5
			}),
			Create("Frame")({
				Name = "ButtonsContainer",
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 62),
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Create("UIListLayout")({
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12)
				}),
				v4,
				v3
			}),
			Create("Frame")({
				Name = "CheckboxContainer",
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundTransparency = 1,
				LayoutOrder = 5,
				Create("UIListLayout")({
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8)
				}),
				parent,
				v8
			})
		})

		instance.Parent = voiceUserAgency

		task.delay(defineFastInt2, function()
			RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "ShowJoinWithVoice", {
				userId = UserId,
				voiceSessionId = default:getService():GetSessionId(),
				voiceExperienceId = default:getService():GetVoiceExperienceId()
			})

			tween:Play()
		end)
	else
		default:MuteAll(result, Constants.VOICE_CONTEXT_TYPE.USER_AGENCY)
		default:FireUserAgencySelectedEvent(result)

		bindResetHistory()
		RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "JoinWithVoice", {
			userId = UserId,
			voiceSessionId = default:getService():GetSessionId(),
			voiceExperienceId = default:getService():GetVoiceExperienceId(),
			isMutedAll = result
		})
	end
end

task.delay(defineFastInt, function()
	default:asyncInit():andThen(function()
		showUserAgencyPrompt()
	end):catch(function()
		v:trace("VoiceChatServiceManager did not initialize for VoiceUserAgency")
	end)
end)
