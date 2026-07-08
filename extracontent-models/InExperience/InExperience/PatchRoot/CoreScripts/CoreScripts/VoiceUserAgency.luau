local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local Images = require(CorePackages.Packages.InGameMenuDependencies).UIBlox.App.ImageSet.Images
local Modules = CoreGui.RobloxGui.Modules
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local v13 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local default = require(Modules.VoiceChat.VoiceChatServiceManager).default
local Constants = require(Modules.VoiceChat.Constants)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local _ = BuilderIcons.Migration
local GetFFlagVoiceUserAgencyEnableIXP = require(Modules.Flags.GetFFlagVoiceUserAgencyEnableIXP)
local GetFStringVoiceUserAgencyIXPLayerName = require(Modules.Flags.GetFStringVoiceUserAgencyIXPLayerName)
local FFlagManuallyMigrateDeprecatedIconUsage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagManuallyMigrateDeprecatedIconUsage
local v23 = game:DefineFastInt("VoiceUserAgencyAlertInitTimeOffset", 5)
local v24 = game:DefineFastInt("VoiceUserAgencyAlertStartTimeOffset", 3)
local v25 = game:DefineFastInt("VoiceUserAgencyAlertTimerDuration", 7)
local v26 = game:DefineFastFlag("VoiceUserAgencyAddMuteDecisionAnalytics", false)
local v27 = game:DefineFastFlag("VoiceUserAgencyAdjustDescriptionText", false)
local v28 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.Remember")
local str = tostring(game.PlaceId)
local UserId = Players.LocalPlayer.UserId

local function getAppStorageTable() -- line: 48
	-- upvalues: AppStorageService (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 49
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("VoiceUserAgencyPlaceIds")
	end)

	if ok then
		local ok2, result2 = pcall(function() -- line: 53
			-- upvalues: HttpService (copy), result (copy)
			return HttpService:JSONDecode(result)
		end)

		if ok2 then
			return result2
		end
	end

	return {}
end

local u32 = false

local function resetHistory() -- line: 64
	-- upvalues: u32 (ref), getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), v13 (copy)
	if u32 then
		return
	end

	local ok, result = pcall(function() -- line: 68
		-- upvalues: getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), u32 (ref)
		local v64 = getAppStorageTable()

		for v65, _ in v64 do
			if v65 == str then
				v64[v65] = nil
				AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(v64))
				AppStorageService:Flush()
				u32 = true

				return
			end
		end
	end)

	if not ok then
		v13:trace(result)
	end
end
local function bindResetHistory() -- line: 85
	-- upvalues: default (copy), u32 (ref), getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), v13 (copy)
	default.muteAllChanged.Event:Connect(function(_) -- line: 87
		-- upvalues: u32 (ref), getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), v13 (copy)
		if u32 then
			return
		end

		local ok, result = pcall(function() -- line: 68
			-- upvalues: getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), u32 (ref)
			local v76 = getAppStorageTable()

			for v77, _ in v76 do
				if v77 == str then
					v76[v77] = nil
					AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(v76))
					AppStorageService:Flush()
					u32 = true

					return
				end
			end
		end)

		if not ok then
			v13:trace(result)
		end
	end)
	default.mutedNonFriends.Event:Connect(function() -- line: 90
		-- upvalues: u32 (ref), getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), v13 (copy)
		if u32 then
			return
		end

		local ok, result = pcall(function() -- line: 68
			-- upvalues: getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), u32 (ref)
			local v79 = getAppStorageTable()

			for v80, _ in v79 do
				if v80 == str then
					v79[v80] = nil
					AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(v79))
					AppStorageService:Flush()
					u32 = true

					return
				end
			end
		end)

		if not ok then
			v13:trace(result)
		end
	end)
end
local function removeUserAgencyPrompt(p2, p3, p4) -- line: 95
	-- upvalues: getAppStorageTable (copy), str (copy), AppStorageService (copy), HttpService (copy), v26 (copy), RbxAnalyticsService (copy), UserId (copy), default (copy), bindResetHistory (copy)
	p2:Destroy()

	if p3 then
		local v46 = getAppStorageTable()

		v46[str] = p4
		AppStorageService:SetItem("VoiceUserAgencyPlaceIds", HttpService:JSONEncode(v46))
		AppStorageService:Flush()
	end

	if v26 then
		RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "SelectJoinWithVoice", {
			userId = UserId,
			voiceSessionId = default:getService():GetSessionId(),
			voiceExperienceId = default:getService():GetVoiceExperienceId(),
			isMuteAll = p4,
			isRememberSetting = p3
		})
	end

	default:FireUserAgencySelectedEvent(p4)
	bindResetHistory()
end
local function showUserAgencyPrompt() -- line: 120
	-- upvalues: GetFFlagVoiceUserAgencyEnableIXP (copy), IXPServiceWrapper (copy), GetFStringVoiceUserAgencyIXPLayerName (copy), getAppStorageTable (copy), str (copy), v13 (copy), default (copy), Constants (copy), bindResetHistory (copy), RbxAnalyticsService (copy), UserId (copy), CoreGui (copy), Create (copy), AppFonts (copy), RobloxTranslator (copy), removeUserAgencyPrompt (copy), v25 (copy), TweenService (copy), FFlagManuallyMigrateDeprecatedIconUsage (copy), BuilderIcons (copy), Images (copy), v28 (copy), TextService (copy), v27 (copy), v24 (copy)
	local u47 = false
	local u48 = false

	if GetFFlagVoiceUserAgencyEnableIXP() then
		local ok, result = pcall(function() -- line: 126
			-- upvalues: IXPServiceWrapper (copy), GetFStringVoiceUserAgencyIXPLayerName (copy)
			return IXPServiceWrapper:GetLayerData(GetFStringVoiceUserAgencyIXPLayerName())
		end)

		if not ok then
			return
		end

		if not result then
			return
		end

		if not result.VoiceUserAgencyEnabled then
			return
		end
	end

	local ok, result = pcall(function() -- line: 145
		-- upvalues: getAppStorageTable (copy), str (copy)
		local v72 = getAppStorageTable()

		for k, v in pairs(v72) do
			if k == str and v ~= nil then
				return v
			end
		end
	end)

	if not ok then
		v13:trace(result)

		return
	end

	if result ~= nil then
		default:MuteAll(result, Constants.VOICE_CONTEXT_TYPE.USER_AGENCY)
		default:FireUserAgencySelectedEvent(result)
		bindResetHistory()
		RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "JoinWithVoice", {
			userId = UserId,
			voiceSessionId = default:getService():GetSessionId(),
			voiceExperienceId = default:getService():GetVoiceExperienceId(),
			isMutedAll = result
		})

		return
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "VoiceUserAgency"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = -1
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = CoreGui

	local v54 = Create("TextButton")({
		Name = "MuteAllButton",
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, -6, 0, 36),
		Font = AppFonts.default:getDefault(),
		Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinMuted"),
		TextSize = 16,
		BackgroundColor3 = Color3.fromRGB(57, 59, 61),
		TextColor3 = Color3.fromRGB(178, 178, 178),
		LayoutOrder = 1,
		Create("UICorner")({
			CornerRadius = UDim.new(0, 8)
		}),
		Create("UIStroke")({
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(178, 178, 178)
		})
	})

	v54.Activated:Connect(function() -- line: 200
		-- upvalues: u47 (ref), default (copy), Constants (copy), removeUserAgencyPrompt (copy), ScreenGui (copy), u48 (ref)
		u47 = true
		default:MuteAll(u47, Constants.VOICE_CONTEXT_TYPE.USER_AGENCY)
		removeUserAgencyPrompt(ScreenGui, u48, u47)
	end)

	local v55 = Create("TextButton")({
		Name = "UnmuteAllButton",
		BorderSizePixel = 0,
		Size = UDim2.new(0.5, -6, 0, 36),
		Font = AppFonts.default:getDefault(),
		Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinUnmuted"),
		TextSize = 16,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextColor3 = Color3.fromRGB(57, 59, 61),
		LayoutOrder = 2,
		Create("UICorner")({
			CornerRadius = UDim.new(0, 8)
		})
	})

	v55.Activated:Connect(function() -- line: 221
		-- upvalues: u47 (ref), default (copy), Constants (copy), removeUserAgencyPrompt (copy), ScreenGui (copy), u48 (ref)
		u47 = false
		default:MuteAll(u47, Constants.VOICE_CONTEXT_TYPE.USER_AGENCY)
		removeUserAgencyPrompt(ScreenGui, u48, u47)
	end)

	local v56 = Create("Frame")({
		Name = "TimerBar",
		BorderSizePixel = 0,
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	})
	local t1 = {
		Size = UDim2.fromScale(1, 1)
	}
	local tweenInfo = TweenInfo.new(v25, Enum.EasingStyle.Sine)
	local tween = TweenService:Create(v56, tweenInfo, t1)

	tween.Completed:Connect(function(p5) -- line: 238
		-- upvalues: removeUserAgencyPrompt (copy), ScreenGui (copy), u48 (ref), u47 (ref)
		if p5 == Enum.PlaybackState.Completed then
			removeUserAgencyPrompt(ScreenGui, u48, u47)
		end
	end)

	local v60 = if not FFlagManuallyMigrateDeprecatedIconUsage then Create("ImageLabel")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Image = Images["icons/status/success_small"].Image,
		ImageRectOffset = Images["icons/status/success_small"].ImageRectOffset,
		ImageRectSize = Images["icons/status/success_small"].ImageRectSize
	}) else Create("TextLabel")({
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Text = BuilderIcons.Migration["icons/status/success_small"].name,
		FontFace = BuilderIcons.Font[BuilderIcons.Migration["icons/status/success_small"].variant]
	})
	local v61 = Create("ImageButton")({
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 14, 0, 14),
		Image = Images["squircles/hollow"].Image,
		ImageRectOffset = Images["squircles/hollow"].ImageRectOffset,
		ImageRectSize = Images["squircles/hollow"].ImageRectSize
	})

	v60.Visible = false
	v60.Parent = v61
	v61.Activated:Connect(function() -- line: 267
		-- upvalues: v60 (copy), u48 (ref), tween (copy), RbxAnalyticsService (copy), UserId (copy), default (copy)
		v60.Visible = not v60.Visible
		u48 = v60.Visible
		tween:Pause()
		RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "RememberJoinWithVoice", {
			userId = UserId,
			voiceSessionId = default:getService():GetSessionId(),
			voiceExperienceId = default:getService():GetVoiceExperienceId(),
			shouldRememberStatus = u48
		})
	end)

	local v62 = Create("TextLabel")({
		Name = "CheckboxTextLabel",
		TextSize = 16,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextTransparency = 0,
		LayoutOrder = 2,
		Font = AppFonts.default:getDefault(),
		Text = v28,
		TextColor3 = Color3.fromRGB(190, 190, 190),
		Size = UDim2.new(0, 350, 0, 24)
	})
	local TextSize = TextService:GetTextSize(v28, 16, AppFonts.default:getDefault(), Vector2.new(350, 24))

	v62.Size = UDim2.new(0, TextSize.X + 10, 0, 24)
	Create("Frame")({
		Name = "VoiceUserAgencyFrame",
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0.9, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 4),
		BackgroundColor3 = Color3.fromRGB(57, 59, 61),
		BorderSizePixel = 0,
		Create("UICorner")({
			CornerRadius = UDim.new(0, 8)
		}),
		Create("UISizeConstraint")({
			MaxSize = Vector2.new(400, 216)
		}),
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
			TextSize = 20,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextTransparency = 0,
			LayoutOrder = 1,
			Font = AppFonts.default:getBold(),
			Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinUnmuted.Title"),
			Size = UDim2.new(1, 0, 0, 22),
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}),
		Create("TextLabel")({
			Name = "Lower",
			TextSize = 16,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextTransparency = 0,
			LayoutOrder = 2,
			Font = AppFonts.default:getDefault(),
			Text = v27 and RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceUserAgency.JoinUnmuted.Description") or RobloxTranslator:FormatByKey("Feature.SettingsHub.VoiceUserAgency.JoinUnmuted.Description"),
			TextColor3 = Color3.fromRGB(190, 190, 190),
			Size = UDim2.new(1, 0, 0, 60)
		}),
		Create("Frame")({
			Name = "TimerFrame",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, 48, 0, 3),
			BackgroundTransparency = 0,
			LayoutOrder = 3,
			v56
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
			v55,
			v54
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
			v61,
			v62
		})
	}).Parent = ScreenGui
	task.delay(v24, function() -- line: 408
		-- upvalues: RbxAnalyticsService (copy), UserId (copy), default (copy), tween (copy)
		RbxAnalyticsService:SendEventDeferred("client", "voiceChat", "ShowJoinWithVoice", {
			userId = UserId,
			voiceSessionId = default:getService():GetSessionId(),
			voiceExperienceId = default:getService():GetVoiceExperienceId()
		})
		tween:Play()
	end)
end

task.delay(v23, function() -- line: 421
	-- upvalues: default (copy), showUserAgencyPrompt (copy), v13 (copy)
	default:asyncInit():andThen(function() -- line: 423
		-- upvalues: showUserAgencyPrompt (copy)
		showUserAgencyPrompt()
	end):catch(function() -- line: 426
		-- upvalues: v13 (copy)
		v13:trace("VoiceChatServiceManager did not initialize for VoiceUserAgency")
	end)
end)
