local BadgeService = game:GetService("BadgeService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local PointsService = game:GetService("PointsService")
local MarketplaceService = game:GetService("MarketplaceService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local VRService = game:GetService("VRService")
local GroupService = game:GetService("GroupService")
local TeleportService = game:GetService("TeleportService")
local LocalizationService = game:GetService("LocalizationService")
local CorePackages = game:GetService("CorePackages")
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Logging = AppCommonLib.Logging
local RobloxGui = CoreGui.RobloxGui
local gameSettings = UserSettings().GameSettings
local FFlagCoreScriptShowTeleportPrompt = require(RobloxGui.Modules.Flags.FFlagCoreScriptShowTeleportPrompt)
local FriendingUtility = require(RobloxGui.Modules.FriendingUtility)

local engineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")

local GetFFlagClientToastNotificationsRedirect = require(RobloxGui.Modules.Flags.GetFFlagClientToastNotificationsRedirect)
local GetFFlagFriendshipNotifsUseSendr = require(RobloxGui.Modules.Flags.GetFFlagFriendshipNotifsUseSendr)

local defineFastFlag = game:DefineFastFlag("NotificationsRenameFriendRequestToConnection", false)

local shouldSaveScreenshotToAlbum = require(RobloxGui.Modules.shouldSaveScreenshotToAlbum)
local defineFastFlag2 = game:DefineFastFlag("FixOnBadgeAwardedError", false)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function LocalizedGetString(p, p2)
	pcall(function()
		p2 = RobloxTranslator:FormatByKey(p)
	end)
	return p2
end

while not Players.LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

local LocalPlayer = Players.LocalPlayer
local parent = script.Parent
local states = {}
local states2 = {}
local playerSet = {}
local set = {}
local v = gameSettings.SavedQualityLevel.Value
local sendNotificationInfo = Instance.new("BindableEvent")
sendNotificationInfo.Name = "SendNotificationInfo"
sendNotificationInfo.Parent = RobloxGui

local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isEnabled = TenFootInterface:IsEnabled()

local v2 = true
local v3 = true

local SocialUtil = require(RobloxGui.Modules.SocialUtil)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)

local backgroundTransparency2 = 0.6 * gameSettings.PreferredTransparency
local v4 = isEnabled and 72 or 48
local v5 = isEnabled and 145 or 64
local v6 = isEnabled and 450 or 200
local v7 = v4 / 6
local v8 = isEnabled and 42 or 18
local v9 = isEnabled and 84 or 36
local bottomPadding = -v8
local size42 = isEnabled and Enum.FontSize.Size42 or Enum.FontSize.Size18
local v10 = isEnabled and 144 or 56
local size36 = isEnabled and Enum.FontSize.Size36 or Enum.FontSize.Size14

local v11 = v5 / 2
local v12 = v7 / 2
local size42_2 = isEnabled and Enum.FontSize.Size42 or Enum.FontSize.Size18
local maxTextSize = isEnabled and 42 or 18
local minTextSize = isEnabled and 30 or 14
local InOut = Enum.EasingDirection.InOut
local Sine = Enum.EasingStyle.Sine

local _ = {
	ACCEPTED = "InGame.NotificationScript2.Message.FriendRequestEvent.Accepted",
	SENT = "InGame.NotificationScript2.Message.FriendRequestEvent.Sent"
}

local function translateString(p: string, p2)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v13 = Localization.new(robloxLocaleId)
	v13:SetLocale(robloxLocaleId)

	local success, result = pcall(function()
		return v13:Format(p, p2)
	end)

	if success then
		return result
	end

	Logging.warn("Failed to translate string with key: " .. p)
	return ""
end

local success, result = pcall(function()
	return (tonumber(settings():GetFVariable("FriendRequestNotificationThrottle")))
end)
local v13 = (not success or result == nil) and 5 or result
StarterGui:RegisterSetCore("PointsNotificationsActive", function(p)
	if type(p) == "boolean" then
		v2 = p
	end
end)
StarterGui:RegisterSetCore("BadgesNotificationsActive", function(p)
	if type(p) == "boolean" then
		v3 = p
	end
end)

StarterGui:RegisterGetCore("PointsNotificationsActive", function()
	return v2
end)

StarterGui:RegisterGetCore("BadgesNotificationsActive", function()
	return v3
end)

local function createFrame(name, size, position, backgroundTransparency) -- 3 equivalent calls inferred from this helper
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position
	frame.BackgroundTransparency = backgroundTransparency

	return frame
end

local function createTextButton(name, position)
	local textButton = Instance.new("TextButton")
	textButton.Name = name
	textButton.Size = UDim2.new(0.5, -1, 0, v11)
	textButton.Position = position
	textButton.BackgroundTransparency = backgroundTransparency2
	textButton.BackgroundColor3 = Color3.new(0, 0, 0)
	textButton.BorderSizePixel = 0
	textButton.Font = Enum.Font.SourceSansBold
	textButton.FontSize = size42_2
	textButton.TextColor3 = Color3.new(1, 1, 1)
	textButton.TextTruncate = Enum.TextTruncate.AtEnd
	textButton.TextScaled = true

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, v12 / 2)
	uiPadding.PaddingBottom = UDim.new(0, v12 / 2)
	uiPadding.PaddingLeft = UDim.new(0, v12)
	uiPadding.PaddingRight = UDim.new(0, v12)
	uiPadding.Parent = textButton

	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
	uiTextSizeConstraint.MaxTextSize = maxTextSize
	uiTextSizeConstraint.MinTextSize = minTextSize
	uiTextSizeConstraint.Parent = textButton

	return textButton
end

local frame = createFrame("NotificationFrame", UDim2.new(0, v6, 0.42, 0), UDim2.new(1, -v6 - 4, 0.5, 0), 1) -- inferred equivalent call

if FFlagCoreScriptShowTeleportPrompt then
	frame.ZIndex = 3
else
	frame.ZIndex = 2
end

frame.Parent = parent

local function createDefaultNotification()
	local frame2 = createFrame("Notification", UDim2.new(1, 0, 0, v5), UDim2.new(0, 0, 0, 0), backgroundTransparency2) -- inferred equivalent call
	frame2.BackgroundColor3 = Color3.new(0, 0, 0)
	frame2.BorderSizePixel = 0
	return frame2
end

local defaultNotification = createDefaultNotification()

local notificationTitle = Instance.new("TextLabel")
notificationTitle.Name = "NotificationTitle"
notificationTitle.Size = UDim2.new(1, -v7 * 2, 0, v8)
notificationTitle.Position = UDim2.new(0, v7, 0.5, bottomPadding)
notificationTitle.BackgroundTransparency = 1
notificationTitle.Font = Enum.Font.SourceSansBold
notificationTitle.FontSize = size42
notificationTitle.TextColor3 = Color3.new(0.97, 0.97, 0.97)

local notificationText = Instance.new("TextLabel")
notificationText.Name = "NotificationText"
notificationText.Size = UDim2.new(1, -v7 * 2, 0, isEnabled and 72 or 28)
notificationText.Position = UDim2.new(0, v7, 0.5, 1)
notificationText.BackgroundTransparency = 1
notificationText.Font = Enum.Font.SourceSans
notificationText.FontSize = size36
notificationText.TextColor3 = Color3.new(0.92, 0.92, 0.92)
notificationText.TextWrap = true
notificationText.TextYAlignment = Enum.TextYAlignment.Top

local notificationImage = Instance.new("ImageLabel")
notificationImage.Name = "NotificationImage"
notificationImage.Size = UDim2.new(0, v4, 0, v4)
notificationImage.Position = UDim2.new(0, v7, 0, 0.5 * (v5 - v4))
notificationImage.BackgroundTransparency = 1
notificationImage.Image = ""

local frame2 = createFrame("PopupFrame", UDim2.new(0, 360, 0, 160), UDim2.new(0.5, -180, 0.5, -50), 0) -- inferred equivalent call
frame2.Style = Enum.FrameStyle.DropShadow
frame2.ZIndex = 4
frame2.Visible = false
frame2.Parent = parent

local popupAcceptButton = Instance.new("TextButton")
popupAcceptButton.Name = "PopupAcceptButton"
popupAcceptButton.Size = UDim2.new(0, 100, 0, 50)
popupAcceptButton.Position = UDim2.new(0.5, -102, 1, -58)
popupAcceptButton.Style = Enum.ButtonStyle.RobloxRoundButton
popupAcceptButton.Font = Enum.Font.SourceSansBold
popupAcceptButton.FontSize = Enum.FontSize.Size24
popupAcceptButton.TextColor3 = Color3.new(1, 1, 1)
popupAcceptButton.Text = "Accept"
popupAcceptButton.ZIndex = 5
popupAcceptButton.Parent = frame2

local popupDeclineButton = popupAcceptButton:Clone()
popupDeclineButton.Name = "PopupDeclineButton"
popupDeclineButton.Position = UDim2.new(0.5, 2, 1, -58)
popupDeclineButton.Text = "Decline"
popupDeclineButton.Parent = frame2

local popupOKButton = popupAcceptButton:Clone()
popupOKButton.Name = "PopupOKButton"
popupOKButton.Position = UDim2.new(0.5, -50, 1, -58)
popupOKButton.Text = "OK"
popupOKButton.Visible = false
popupOKButton.Parent = frame2

local popupText = Instance.new("TextLabel")
popupText.Name = "PopupText"
popupText.Size = UDim2.new(1, -16, 0.8, 0)
popupText.Position = UDim2.new(0, 8, 0, 8)
popupText.BackgroundTransparency = 1
popupText.Font = Enum.Font.SourceSansBold
popupText.FontSize = Enum.FontSize.Size36
popupText.TextColor3 = Color3.new(0.97, 0.97, 0.97)
popupText.TextWrap = true
popupText.ZIndex = 5
popupText.TextYAlignment = Enum.TextYAlignment.Top
popupText.Text = "This is a popup"
popupText.Parent = frame2

local fn

local function getFriendImage(userId) -- 3 equivalent calls inferred from this helper
	return SocialUtil.GetPlayerImage(userId, Enum.ThumbnailSize.Size48x48, Enum.ThumbnailType.HeadShot, 5)
end

local function createNotification(text, text2, image)
	local clone = defaultNotification:Clone()
	clone.Position = UDim2.new(1, 4, 1, -v5 - 4)

	local clone2 = notificationTitle:Clone()
	clone2.Text = text
	clone2.Parent = clone

	local clone3 = notificationText:Clone()
	clone3.Text = text2
	clone3.Parent = clone

	local v14 = false
	local function updateNotificationForMultiLineTitle()
		v14 = true
		clone2.TextWrapped = true
		clone2.TextTruncate = Enum.TextTruncate.AtEnd

		local v15 = math.min(
			TextService:GetTextSize(clone2.Text, clone2.TextSize, clone2.Font, Vector2.new(clone2.AbsoluteSize.X, 1000)).Y - clone2.Size.Y.Offset,
			v9 - clone2.Size.Y.Offset
		)

		clone2.Size += UDim2.new(0, 0, 0, v15)
		clone2.Position -= UDim2.new(0, 0, 0, v15 / 2)
		clone3.Position += UDim2.new(0, 0, 0, v15 / 2)
		clone.Size += UDim2.new(0, 0, 0, v15)
	end

	clone.Parent = frame

	if image == nil or image == "" then
		if not clone2.TextFits then
			v14 = true
			updateNotificationForMultiLineTitle()
		end

		if not clone3.TextFits then
			local v15 = math.min(
				TextService:GetTextSize(
					clone3.Text,
					clone3.TextSize,
					clone3.Font,
					Vector2.new(clone3.AbsoluteSize.X, 1000)
				).Y - clone3.Size.Y.Offset,
				v10 - clone3.Size.Y.Offset
			)

			clone3.Size += UDim2.new(0, 0, 0, v15)
			clone2.Position -= UDim2.new(0, 0, 0, v15 / 2)
			clone3.Position -= UDim2.new(0, 0, 0, v15 / 2)
			clone.Size += UDim2.new(0, 0, 0, v15)
		end
	else
		local v15 = v4 + v7 * 2
		local v16 = v7

		local clone4 = notificationImage:Clone()
		clone4.Image = image
		clone4.Parent = clone

		clone2.Size = UDim2.new(1, -v15 - v16, 0, clone2.Size.Y.Offset)
		clone2.Position = UDim2.new(0, v15, clone2.Position.Y.Scale, clone2.Position.Y.Offset)
		clone2.TextXAlignment = Enum.TextXAlignment.Left

		clone3.Size = UDim2.new(1, -v15 - v16, 0, clone3.Size.Y.Offset)
		clone3.Position = UDim2.new(0, v15, clone3.Position.Y.Scale, clone3.Position.Y.Offset)
		clone3.TextXAlignment = Enum.TextXAlignment.Left

		if not clone2.TextFits then
			updateNotificationForMultiLineTitle()

			local textSize = clone3.TextSize
			clone3.Size -= UDim2.new(0, 0, 0, textSize)

			clone2.Position += UDim2.new(0, 0, 0, textSize / 2 - 2)
			clone3.Position += UDim2.new(0, 0, 0, textSize / 2 - 2)
			clone.Size -= UDim2.new(0, 0, 0, textSize + 4)
		end

		if not clone3.TextFits then
			local text3 = clone3.Text
			local text4 = nil

			for i = string.len(text3) - 1, 2, -1 do
				if string.sub(text3, i, i) ~= " " then
					continue
				end

				clone3.Text = string.sub(text3, 1, i - 1)

				if clone3.TextFits then
					text4 = string.sub(text3, i + 1)
					break
				end
			end

			if text4 then
				local extraText = notificationText:Clone()
				extraText.TextXAlignment = Enum.TextXAlignment.Left
				extraText.Text = text4
				extraText.Name = "ExtraText"
				extraText.TextTruncate = Enum.TextTruncate.AtEnd
				extraText.Parent = clone

				local v17 = math.min(
					TextService:GetTextSize(
						text4,
						extraText.TextSize,
						extraText.Font,
						Vector2.new(extraText.AbsoluteSize.X, 1000)
					).Y,
					v10 - clone3.Size.Y.Offset
				)

				extraText.Size = UDim2.new(extraText.Size.X.Scale, extraText.Size.X.Offset, 0, v17)
				clone2.Position -= UDim2.new(0, 0, 0, v17 / 2)
				clone3.Position -= UDim2.new(0, 0, 0, v17 / 2)
				clone.Size += UDim2.new(0, 0, 0, v17)

				extraText.AnchorPoint = Vector2.new(0.5, 0)
				extraText.Position = UDim2.new(
					0.5,
					0,
					clone3.Position.Y.Scale,
					clone3.Position.Y.Offset + clone3.AbsoluteSize.Y
				)
			else
				clone3.Text = text3
			end
		end
	end

	if v14 and clone3.TextFits then
		local textSize = TextService:GetTextSize(
			clone3.Text,
			clone3.TextSize,
			clone3.Font,
			Vector2.new(clone3.AbsoluteSize.X, 1000)
		)

		if textSize.Y < clone3.Size.Y.Offset then
			local v15 = clone3.Size.Y.Offset - textSize.Y
			clone3.Size -= UDim2.new(0, 0, 0, v15)
			clone2.Position += UDim2.new(0, 0, 0, v15 / 2)
			clone3.Position += UDim2.new(0, 0, 0, v15 / 2)
			clone.Size -= UDim2.new(0, 0, 0, v15)
		end
	end

	clone.Parent = nil

	GuiService:AddSelectionParent(HttpService:GenerateGUID(false), clone)

	return clone
end

local function findNotification(p) -- 1 equivalent call inferred from this helper
	for notification = 1, #states do
		if states[notification] == p then
			return notification
		end
	end
end

local function updateNotifications()
	local total = 0
	local v14 = 1

	for i = #states, 1, -1 do
		local v15 = states[i]

		if not v15 then
			continue
		end

		local frame3 = v15.Frame

		if not (frame3 and frame3.Parent) then
			continue
		end

		local _ = v15.IsFriend and (v5 + 2) * 1.5

		total += v15.IsFriend and frame3.Size.Y.Offset + (v5 + 2) * 0.5 or frame3.Size.Y.Offset

		frame3:TweenPositionInternal(UDim2.new(0, 0, 1, -total - v14 * 4), InOut, Sine, 0.35, true, function()
			if v15.TweenOutCallback then
				v15.TweenOutCallback()
			end
		end)

		v14 += 1
	end
end

local lastTime = 0
local function fn2(state)
	spawn(function()
		state.IsActive = true
		local count = #states

		if count == 3 then
			states[1].Duration = 0
			states2[#states2 + 1] = state
		else
			states[count + 1] = state
			state.Frame.Parent = frame

			spawn(function()
				wait(0.7)

				while state.Duration > 0 do
					wait(0.2)
					state.Duration -= 0.2
				end

				fn(state)
			end)

			while tick() - lastTime < 0.35 do
				wait()
			end

			lastTime = tick()

			updateNotifications()
		end
	end)
end

fn = function(p)
	if not p then
		return
	end

	local notification = findNotification(p) -- inferred equivalent call
	table.remove(states, notification)
	local frame3 = p.Frame

	if frame3 and frame3.Parent then
		p.IsActive = false
		spawn(function()
			local function doTweenOut()
				if frame3:IsDescendantOf(game) then
					return frame3:TweenPositionInternal(
						UDim2.new(1, 0, 1, frame3.Position.Y.Offset),
						InOut,
						Sine,
						0.35,
						false,
						function()
							frame3:Destroy()
							p = nil
						end
					)
				end

				return false
			end

			if not doTweenOut() then
				p.TweenOutCallback = doTweenOut
			end
		end)
	end

	if #states2 > 0 then
		local v14 = states2[1]
		table.remove(states2, 1)

		fn2(v14)

		if #states2 > 0 and states[1] then
			states[1].Duration = 0
		end
	else
		updateNotifications()
	end
end

local function sendNotificationInfo2(p) -- 10 equivalent calls inferred from this helper
	p.Duration = p.Duration or 5
	sendNotificationInfo:Fire(p)
end

local function createNotificationButtonDetails(text: string, buttonType, callback) -- 2 equivalent calls inferred from this helper
	return {
		Text = text,
		ButtonType = buttonType,
		OnActivated = function()
			if callback and type(callback) ~= "function" then
				pcall(function()
					callback:Invoke(text)
				end)
			elseif type(callback) == "function" then
				callback(text)
			end
		end
	}
end

local function onSendNotificationInfo(data)
	if VRService.VREnabled then
		return
	end

	local callback = data.Callback

	local button1Text = data.Button1Text
	local button2Text = data.Button2Text

	if engineFeature and GetFFlagClientToastNotificationsRedirect() then
		local buttons = {}

		if button1Text and button1Text ~= "" then
			table.insert(
				buttons,
				createNotificationButtonDetails(button1Text, Enum.NotificationButtonType.Primary, callback) -- inferred equivalent call
			)
		end

		if button2Text and button2Text ~= "" then
			table.insert(
				buttons,
				createNotificationButtonDetails(button2Text, Enum.NotificationButtonType.Secondary, callback) -- inferred equivalent call
			)
		end

		local title

		if data.Autolocalize then
			title = GameTranslator:TranslateGameText(CoreGui, data.Title)
		else
			title = data.Title
		end

		local text

		if data.AutoLocalize then
			text = GameTranslator:TranslateGameText(CoreGui, data.Text)
		else
			text = data.Text
		end

		GuiService:SendNotification({
			Title = title,
			Text = text,
			Icon = data.Image,
			OnDisplay = data.OnDisplay,
			OnDismiss = data.OnDismiss,
			Buttons = buttons
		})
	else
		local v14 = {}
		local v15

		if data.AutoLocalize then
			v15 = createNotification(
				GameTranslator:TranslateGameText(CoreGui, data.Title),
				GameTranslator:TranslateGameText(CoreGui, data.Text),
				data.Image
			)
		else
			v15 = createNotification(data.Title, data.Text, data.Image)
		end

		local v16

		if button1Text and button1Text ~= "" then
			v14.IsFriend = true
			v16 = createTextButton("Button1", UDim2.new(0, 0, 1, 2))

			if data.AutoLocalize then
				GameTranslator:TranslateAndRegister(v16, CoreGui, button1Text)
			else
				v16.Text = button1Text
			end

			v16.Parent = v15
			local mouseButton1ClickConnection = nil
			mouseButton1ClickConnection = v16.MouseButton1Click:connect(function()
				if mouseButton1ClickConnection then
					mouseButton1ClickConnection:disconnect()
					mouseButton1ClickConnection = nil
					fn(v14)

					if callback and type(callback) ~= "function" then
						pcall(function()
							callback:Invoke(button1Text)
						end)
					elseif type(callback) == "function" then
						callback(button1Text)
					end
				end
			end)
		end

		if button2Text and button2Text ~= "" then
			v14.IsFriend = true

			local textButton = createTextButton("Button2", UDim2.new(0.5, 1, 1, 2))

			if data.AutoLocalize then
				GameTranslator:TranslateAndRegister(textButton, CoreGui, button2Text)
			else
				textButton.Text = button2Text
			end

			textButton.Parent = v15
			local mouseButton1ClickConnection = nil
			mouseButton1ClickConnection = textButton.MouseButton1Click:connect(function()
				if mouseButton1ClickConnection then
					mouseButton1ClickConnection:disconnect()
					mouseButton1ClickConnection = nil
					fn(v14)

					if callback and type(callback) ~= "function" then
						pcall(function()
							callback:Invoke(button2Text)
						end)
					elseif type(callback) == "function" then
						callback(data.Button2Text)
					end
				end
			end)
		elseif v16 then
			v16.Size = UDim2.new(1, 0, 0, v11)
		end

		v14.Frame = v15
		v14.Duration = data.Duration
		fn2(v14)
	end
end
sendNotificationInfo.Event:connect(onSendNotificationInfo)

local function createDeveloperNotification(data)
	if type(data) == "table" and type(data.Title) == "string" and type(data.Text) == "string" then
		local icon = type(data.Icon) == "string" and data.Icon or ""

		local duration = type(data.Duration) == "number" and data.Duration or 5
		local callback

		if typeof(data.Callback) == "Instance" and data.Callback:IsA("BindableFunction") then
			callback = data.Callback or nil
		end

		local button1, button2

		if engineFeature and GetFFlagClientToastNotificationsRedirect() then
			if type(data.Button1) == "string" then
				button1 = data.Button1 or nil
			end

			if type(data.Button2) == "string" then
				button2 = data.Button2 or nil
			end
		else
			button1 = type(data.Button1) == "string" and data.Button1 or ""
			button2 = type(data.Button2) == "string" and data.Button2 or ""
		end

		local autoLocalize = data.AutoLocalize == nil or data.AutoLocalize == true
		sendNotificationInfo2({ -- inferred equivalent call
			GroupName = "Developer",
			Title = data.Title,
			Text = data.Text,
			Image = icon,
			Duration = duration,
			Callback = callback,
			Button1Text = button1,
			Button2Text = button2,
			AutoLocalize = autoLocalize
		})
	end
end

StarterGui:RegisterSetCore("SendNotification", createDeveloperNotification)

local v14 = {}

local function fn3(player): boolean
	local v15 = v14[player]

	if v15 and tick() < v15 then
		return true
	end

	v14[player] = tick() + v13
	return false
end

local function sendFriendNotification(player)
	if fn3(player) then
		return
	end

	local text = not (defineFastFlag and UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections())
		and "Sent you a friend request!"
		or translateString("InGame.NotificationScript2.Message.FriendRequestEvent.Sent")

	sendNotificationInfo2({ -- inferred equivalent call
		GroupName = "Friends",
		Title = player.DisplayName,
		Text = text,
		DetailText = player.DisplayName,
		Image = getFriendImage(player.UserId), -- inferred equivalent call
		Duration = 8,
		Callback = function(p)
			if p == "Accept" then
				RbxAnalyticsService:ReportCounter("NotificationScript-RequestFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "NotificationScript")

				RbxAnalyticsService:ReportCounter("NotificationScript-AcceptFriendship")
				RbxAnalyticsService:TrackEvent("Game", "AcceptFriendship", "NotificationScript")

				LocalPlayer:RequestFriendship(player)
			else
				RbxAnalyticsService:ReportCounter("NotificationScript-RevokeFriendship")
				RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "NotificationScript")

				LocalPlayer:RevokeFriendship(player)
				playerSet[player] = true
			end
		end,
		Button1Text = "Accept",
		Button2Text = "Decline",
		OnDisplay = function()
			RbxAnalyticsService:ReportCounter("NotificationScript-FriendshipNotificationDisplayed")
			RbxAnalyticsService:TrackEvent("Game", "FriendshipNotificationDisplayed", "NotificationScript")
		end,
		OnDismiss = function()
			RbxAnalyticsService:ReportCounter("NotificationScript-FriendshipNotificationDismissed")
			RbxAnalyticsService:TrackEvent("Game", "FriendshipNotificationDismissed", "NotificationScript")
		end
	})
end

local function onFriendRequestEvent(p, p2, p3)
	if p ~= LocalPlayer and p2 ~= LocalPlayer then
		return
	end

	local title = not (defineFastFlag and UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections())
		and "New Friend"
		or translateString("InGame.NotificationScript2.Message.FriendRequestEvent.Accepted")

	local requiresOSAFriendingEducation = UniversalAppPolicy.getAppFeaturePolicies().getRequiresOSAFriendingEducation()

	local friendCountAsync = FriendingUtility:GetFriendCountAsync(LocalPlayer.UserId)
	local v15 = friendCountAsync == 0 or friendCountAsync == nil

	if p == LocalPlayer then
		if p3 == Enum.FriendRequestEvent.Accept and not GetFFlagFriendshipNotifsUseSendr() then
			local formatByKey = RobloxTranslator:FormatByKey("InGame.NotificationScript2.FriendRequestEvent.Accept", {
				RBX_NAME = p2.Name
			})

			sendNotificationInfo2({ -- inferred equivalent call
				GroupName = "Friends",
				Title = title,
				Text = p2.Name,
				DetailText = formatByKey,
				Image = getFriendImage(p2.UserId), -- inferred equivalent call
				Duration = 5
			})
		end
	elseif p2 == LocalPlayer then
		if p3 == Enum.FriendRequestEvent.Issue and not GetFFlagFriendshipNotifsUseSendr() then
			if playerSet[p] or requiresOSAFriendingEducation and v15 then
				return
			end

			sendFriendNotification(p)
		elseif p3 == Enum.FriendRequestEvent.Accept then
			local formatByKey = RobloxTranslator:FormatByKey("InGame.NotificationScript2.FriendRequestEvent.Accept", {
				RBX_NAME = p.Name
			})

			sendNotificationInfo2({ -- inferred equivalent call
				GroupName = "Friends",
				Title = title,
				Text = p.Name,
				DetailText = formatByKey,
				Image = getFriendImage(p.UserId), -- inferred equivalent call
				Duration = 5
			})
		end
	end
end

local function onPointsAwarded(p, p2, _, _)
	if v2 and p == LocalPlayer.UserId then
		local v15, title

		if p2 == 1 then
			v15 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onPointsAwarded.single", {
				RBX_NUMBER = tostring(1)
			})
			title = "Point Awarded"
		elseif p2 > 0 then
			v15 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onPointsAwarded.multiple", {
				RBX_NUMBER = tostring(p2)
			})
			title = "Points Awarded"
		elseif p2 < 0 then
			v15 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onPointsAwarded.negative", {
				RBX_NUMBER = tostring(p2)
			})
			title = "Points Lost"
		else
			return
		end

		sendNotificationInfo2({ -- inferred equivalent call
			GroupName = "PlayerPoints",
			Title = title,
			Text = v15,
			DetailText = v15,
			Image = "https://www.roblox.com/asset?id=206410433",
			Duration = 5
		})
	end
end

local function onBadgeAwarded(p, p2, p3)
	if not set[p3] and v3 and p == LocalPlayer.UserId then
		set[p3] = true
		local v15 = ""

		if game.CreatorType == Enum.CreatorType.Group then
			local success2, result2 = pcall(function()
				return GroupService:GetGroupInfoAsync(p2)
			end)

			if result2 then
				v15 = result2.Name
			else
				v15 = not success2 and "" or v15
			end
		elseif game.CreatorType == Enum.CreatorType.User then
			local success2, result2 = pcall(function()
				return Players:GetNameFromUserIdAsync(p2)
			end)
			v15 = not success2 and "" or result2
		end

		local success2, result2 = pcall(function()
			return BadgeService:GetBadgeInfoAsync(p3)
		end)

		if not success2 then
			return
		end

		local v16 = defineFastFlag2 and v15 == nil and "" or v15

		local formatByKey = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onBadgeAwardedDetail", {
			RBX_NAME = LocalPlayer.Name,
			CREATOR_NAME = v16,
			BADGE_NAME = result2.DisplayName
		})

		local title = nil
		local v17 = "InGame.NotificationScript2.onBadgeAwardedTitle"
		pcall(function()
			title = RobloxTranslator:FormatByKey(v17)
		end)

		sendNotificationInfo2({ -- inferred equivalent call
			GroupName = "BadgeAwards",
			Title = title,
			Text = formatByKey,
			DetailText = formatByKey,
			Image = "https://www.roblox.com/asset?id=206410289",
			Duration = 5,
			OnDisplay = function()
				RbxAnalyticsService:ReportCounter("NotificationScript-BadgeAwardNotificationDisplayed")
				RbxAnalyticsService:TrackEvent("Game", "BadgeAwardNotificationDisplayed", "NotificationScript")
			end,
			OnDismiss = function()
				RbxAnalyticsService:ReportCounter("NotificationScript-BadgeAwardNotificationDismissed")
				RbxAnalyticsService:TrackEvent("Game", "BadgeAwardNotificationDismissed", "NotificationScript")
			end
		})
	end
end

function onGameSettingsChanged(p, p2)
	if p == "SavedQualityLevel" then
		local v15 = gameSettings.SavedQualityLevel.Value + p2

		local v16 = v15 > 10 and 10 or v15 < 1 and 1 or v15

		if v16 > 0 and v16 ~= v and gameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			("%s to (%d)"):format(v < v16 and "Increased" or "Decreased", v16)
			local v17

			if v < v16 then
				v17 = RobloxTranslator:FormatByKey(
					"InGame.NotificationScrip2.onCurrentGraphicsQualityLevelChanged.Increased",
					{ RBX_NUMBER = tostring(v16) }
				)
			else
				v17 = RobloxTranslator:FormatByKey(
					"InGame.NotificationScrip2.onCurrentGraphicsQualityLevelChanged.Decreased",
					{ RBX_NUMBER = tostring(v16) }
				)
			end

			sendNotificationInfo2({ -- inferred equivalent call
				GroupName = "Graphics",
				Title = "Graphics Quality",
				Text = v17,
				DetailText = v17,
				Image = "",
				Duration = 2
			})

			v = v16
		end
	end
end

if not CachedPolicyService:IsSubjectToChinaPolicies() then
	BadgeService.OnBadgeAwarded:connect(onBadgeAwarded)
end

if not isEnabled then
	Players.FriendRequestEvent:connect(onFriendRequestEvent)
	PointsService.PointsAwarded:connect(onPointsAwarded)

	game.GraphicsQualityChangeRequest:Connect(function(_)
		onGameSettingsChanged("SavedQualityLevel", 0)
	end)
end

if not CachedPolicyService:IsSubjectToChinaPolicies() then
	if not shouldSaveScreenshotToAlbum() then
		game.ScreenshotReady:Connect(function(_)
			local formatByKey = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Screenshot.Title")
			local formatByKey2 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Screenshot.Description")
			local formatByKey3 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Screenshot.ButtonText")

			sendNotificationInfo2({ -- inferred equivalent call
				Title = formatByKey,
				Text = formatByKey2,
				Duration = 3,
				Button1Text = formatByKey3,
				Callback = function(p)
					if p == formatByKey3 then
						game:OpenScreenshotsFolder()
					end
				end
			})
		end)
	end

	local GameSettings = settings():GetService("GameSettings")
	GameSettings.VideoRecordingChangeRequest:Connect(function(p)
		if not p then
			local formatByKey = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Video.Title")
			local formatByKey2 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Video.Description")
			local formatByKey3 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Video.ButtonText")

			sendNotificationInfo2({ -- inferred equivalent call
				Title = formatByKey,
				Text = formatByKey2,
				Duration = 3,
				Button1Text = formatByKey3,
				Callback = function(p2)
					if p2 == formatByKey3 then
						game:OpenVideosFolder()
					end
				end
			})
		end
	end)
end

function GuiService.SendCoreUiNotification(text, text2)
	local notification = createNotification(text, text2, "")
	notification.BackgroundTransparency = 0.5
	notification.Size = UDim2.new(0.5, 0, 0.1, 0)
	notification.Position = UDim2.new(0.25, 0, -0.1, 0)
	notification.NotificationTitle.FontSize = Enum.FontSize.Size36
	notification.NotificationText.FontSize = Enum.FontSize.Size24
	notification.Parent = parent
	notification:TweenPositionInternal(UDim2.new(0.25, 0, 0, 0), InOut, Sine, 0.35, true)
	wait(5)

	if notification then
		notification:Destroy()
	end
end

local function onClientLuaDialogRequested(text, text2, text3): boolean
	popupText.Text = text

	local mouseButton1ClickConnection = nil
	local mouseButton1ClickConnection2 = nil
	local function disconnectCns() -- 2 equivalent calls inferred from this helper
		if mouseButton1ClickConnection then
			mouseButton1ClickConnection:disconnect()
		end

		if mouseButton1ClickConnection2 then
			mouseButton1ClickConnection2:disconnect()
		end

		GuiService:RemoveCenterDialog(frame2)
		frame2.Visible = false
	end

	mouseButton1ClickConnection = popupAcceptButton.MouseButton1Click:connect(function()
		disconnectCns() -- inferred equivalent call
		MarketplaceService:SignalServerLuaDialogClosed(true)
	end)
	mouseButton1ClickConnection2 = popupDeclineButton.MouseButton1Click:connect(function()
		disconnectCns() -- inferred equivalent call
		MarketplaceService:SignalServerLuaDialogClosed(false)
	end)

	if not pcall(function()
		GuiService:AddCenterDialog(frame2, Enum.CenterDialogType.QuitDialog, function()
			popupOKButton.Visible = false
			popupAcceptButton.Visible = true
			popupDeclineButton.Visible = true
			popupAcceptButton.Text = text2
			popupDeclineButton.Text = text3
			frame2.Visible = true
		end, function()
			frame2.Visible = false
		end)
	end) then
		frame2.Visible = true
		popupAcceptButton.Text = text2
		popupDeclineButton.Text = text3
	end

	return true
end

MarketplaceService.ClientLuaDialogRequested:connect(onClientLuaDialogRequested)

local function onPreferredTransparencyChanged()
	backgroundTransparency2 = 0.6 * gameSettings.PreferredTransparency
	defaultNotification.BackgroundTransparency = backgroundTransparency2

	for i = 1, #states do
		states[i].Frame.BackgroundTransparency = backgroundTransparency2
	end
end
gameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(onPreferredTransparencyChanged)

if FFlagCoreScriptShowTeleportPrompt then
	local function onMenuTeleportAttemptNotification()
		local v15 = "Teleporting Paused"
		local v16 = "Feature.SettingsHub.Prompt.TeleportBlock.Title"
		pcall(function()
			v15 = RobloxTranslator:FormatByKey(v16)
		end)
		local title = v15

		local text = "Teleporting will resume upon menu close."
		local v17 = "Feature.SettingsHub.Prompt.TeleportBlock.Subtitle"
		pcall(function()
			text = RobloxTranslator:FormatByKey(v17)
		end)

		sendNotificationInfo2({ -- inferred equivalent call
			GroupName = "Teleport",
			Title = title,
			Text = text,
			Image = "http://www.roblox.com/asset/?id=10961494062",
			Duration = 5,
			BottomPadding = bottomPadding
		})
	end

	local function connectMenuTeleportAttemptEvent()
		TeleportService.MenuTeleportAttempt:Connect(function()
			onMenuTeleportAttemptNotification()
		end)
	end

	TeleportService.MenuTeleportAttempt:Connect(function()
		onMenuTeleportAttemptNotification()
	end)
end
