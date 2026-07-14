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
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local RobloxGui = CoreGui.RobloxGui
local GameSettings = UserSettings().GameSettings
local FFlagCoreScriptShowTeleportPrompt = require(RobloxGui.Modules.Flags.FFlagCoreScriptShowTeleportPrompt)
local FriendingUtility = require(RobloxGui.Modules.FriendingUtility)
local EngineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")
local GetFFlagClientToastNotificationsRedirect = require(RobloxGui.Modules.Flags.GetFFlagClientToastNotificationsRedirect)
local GetFFlagFriendshipNotifsUseSendr = require(RobloxGui.Modules.Flags.GetFFlagFriendshipNotifsUseSendr)
local v26 = game:DefineFastFlag("NotificationsRenameFriendRequestToConnection", false)
local shouldSaveScreenshotToAlbum = require(RobloxGui.Modules.shouldSaveScreenshotToAlbum)
local v28 = game:DefineFastFlag("FixOnBadgeAwardedError", false)
local FFlagConnectionsToFriendsRename = require(CorePackages.Workspace.Packages.SharedFlags).FFlagConnectionsToFriendsRename
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function LocalizedGetString(p1, p2) -- line: 56
	-- upvalues: RobloxTranslator (copy)
	pcall(function() -- line: 57
		-- upvalues: p2 (ref), RobloxTranslator (copy), p1 (copy)
		p2 = RobloxTranslator:FormatByKey(p1)
	end)

	return p2
end

while not Players.LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

local LocalPlayer = Players.LocalPlayer
local scriptParent = script.Parent
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local SavedQualityLevelValue = GameSettings.SavedQualityLevel.Value
local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Name = "SendNotificationInfo"
BindableEvent.Parent = RobloxGui

local v40 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local u41 = true
local u42 = true
local SocialUtil = require(RobloxGui.Modules.SocialUtil)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local u46 = 0.6 * GameSettings.PreferredTransparency
local v47 = not v40 and 48 or 72
local v48 = not v40 and 64 or 145
local v49 = not v40 and 200 or 450
local v50 = v47 / 6
local v51 = not v40 and 18 or 42
local v52 = not v40 and 36 or 84
local v53 = -v51
local v54 = v40 and Enum.FontSize.Size42 or Enum.FontSize.Size18
local v55 = not v40 and 28 or 72
local v56 = not v40 and 56 or 144
local v57 = v40 and Enum.FontSize.Size36 or Enum.FontSize.Size14
local v58 = v48 / 2
local v59 = v50 / 2
local v60 = v40 and Enum.FontSize.Size42 or Enum.FontSize.Size18
local v61 = not v40 and 18 or 42
local v62 = not v40 and 14 or 30
local InOut = Enum.EasingDirection.InOut
local Sine = Enum.EasingStyle.Sine
local n1 = 5
local t5 = {
	ACCEPTED = not FFlagConnectionsToFriendsRename and "InGame.NotificationScript2.Message.ConnectionRequestEvent.Accepted" or "InGame.NotificationScript2.Message.FriendRequestEvent.Accepted",
	SENT = not FFlagConnectionsToFriendsRename and "InGame.NotificationScript2.Message.ConnectionRequestEvent.Sent" or "InGame.NotificationScript2.Message.FriendRequestEvent.Sent"
}

local function translateString(s1: string, t6: {[any]: any}?) -- line: 131
	-- upvalues: LocalizationService (copy), Localization (copy), Logging (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v116 = Localization.new(RobloxLocaleId)

	v116:SetLocale(RobloxLocaleId)

	local ok, result = pcall(function() -- line: 136
		-- upvalues: v116 (copy), s1 (copy), t6 (copy)
		return v116:Format(s1, t6)
	end)

	if ok then
		return result
	end

	Logging.warn("Failed to translate string with key: " .. s1)

	return ""
end

local ok, result = pcall(function() -- line: 146
	return (tonumber(settings():GetFVariable("FriendRequestNotificationThrottle")))
end)

if ok and result ~= nil then
	n1 = result
end

StarterGui:RegisterSetCore("PointsNotificationsActive", function(p3) -- line: 153
	-- upvalues: u41 (ref)
	if type(p3) == "boolean" then
		u41 = p3
	end
end)
StarterGui:RegisterSetCore("BadgesNotificationsActive", function(p4) -- line: 158
	-- upvalues: u42 (ref)
	if type(p4) == "boolean" then
		u42 = p4
	end
end)
StarterGui:RegisterGetCore("PointsNotificationsActive", function() -- line: 164
	-- upvalues: u41 (ref)
	return u41
end)
StarterGui:RegisterGetCore("BadgesNotificationsActive", function() -- line: 167
	-- upvalues: u42 (ref)
	return u42
end)

local function createFrame(p5, p6, p7, p8) -- line: 174
	local Frame = Instance.new("Frame")

	Frame.Name = p5
	Frame.Size = p6
	Frame.Position = p7
	Frame.BackgroundTransparency = p8

	return Frame
end
local function createTextButton(p9, p10) -- line: 184
	-- upvalues: v58 (copy), u46 (ref), v60 (copy), v59 (copy), v61 (copy), v62 (copy)
	local TextButton = Instance.new("TextButton")

	TextButton.Name = p9
	TextButton.Size = UDim2.new(0.5, -1, 0, v58)
	TextButton.Position = p10
	TextButton.BackgroundTransparency = u46
	TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
	TextButton.BorderSizePixel = 0
	TextButton.Font = Enum.Font.SourceSansBold
	TextButton.FontSize = v60
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.TextTruncate = Enum.TextTruncate.AtEnd
	TextButton.TextScaled = true

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingTop = UDim.new(0, v59 / 2)
	UIPadding.PaddingBottom = UDim.new(0, v59 / 2)
	UIPadding.PaddingLeft = UDim.new(0, v59)
	UIPadding.PaddingRight = UDim.new(0, v59)
	UIPadding.Parent = TextButton

	local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

	UITextSizeConstraint.MaxTextSize = v61
	UITextSizeConstraint.MinTextSize = v62
	UITextSizeConstraint.Parent = TextButton

	return TextButton
end

local uDim2 = UDim2.new(0, v49, 0.42, 0)
local uDim2_2 = UDim2.new(1, -v49 - 4, 0.5, 0)
local Frame = Instance.new("Frame")

Frame.Name = "NotificationFrame"
Frame.Size = uDim2
Frame.Position = uDim2_2
Frame.BackgroundTransparency = 1

local v75 = Frame

if FFlagCoreScriptShowTeleportPrompt then
	v75.ZIndex = 3
else
	v75.ZIndex = 2
end

v75.Parent = scriptParent

local function createDefaultNotification() -- line: 226
	-- upvalues: v48 (copy), u46 (ref)
	local uDim2_3 = UDim2.new(1, 0, 0, v48)
	local uDim2_4 = UDim2.new(0, 0, 0, 0)
	local v133 = u46
	local Frame2 = Instance.new("Frame")

	Frame2.Name = "Notification"
	Frame2.Size = uDim2_3
	Frame2.Position = uDim2_4
	Frame2.BackgroundTransparency = v133
	Frame2.BackgroundColor3 = Color3.new(0, 0, 0)
	Frame2.BorderSizePixel = 0

	return Frame2
end

local v77 = createDefaultNotification()
local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "NotificationTitle"
TextLabel.Size = UDim2.new(1, -v50 * 2, 0, v51)
TextLabel.Position = UDim2.new(0, v50, 0.5, v53)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.FontSize = v54
TextLabel.TextColor3 = Color3.new(0.97, 0.97, 0.97)

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "NotificationText"
TextLabel2.Size = UDim2.new(1, -v50 * 2, 0, v55)
TextLabel2.Position = UDim2.new(0, v50, 0.5, 1)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = Enum.Font.SourceSans
TextLabel2.FontSize = v57
TextLabel2.TextColor3 = Color3.new(0.92, 0.92, 0.92)
TextLabel2.TextWrap = true
TextLabel2.TextYAlignment = Enum.TextYAlignment.Top

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "NotificationImage"
ImageLabel.Size = UDim2.new(0, v47, 0, v47)
ImageLabel.Position = UDim2.new(0, v50, 0, 0.5 * (v48 - v47))
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = ""

local uDim2_5 = UDim2.new(0, 360, 0, 160)
local uDim2_6 = UDim2.new(0.5, -180, 0.5, -50)
local Frame3 = Instance.new("Frame")

Frame3.Name = "PopupFrame"
Frame3.Size = uDim2_5
Frame3.Position = uDim2_6
Frame3.BackgroundTransparency = 0

local v84 = Frame3

v84.Style = Enum.FrameStyle.DropShadow
v84.ZIndex = 4
v84.Visible = false
v84.Parent = scriptParent

local TextButton = Instance.new("TextButton")

TextButton.Name = "PopupAcceptButton"
TextButton.Size = UDim2.new(0, 100, 0, 50)
TextButton.Position = UDim2.new(0.5, -102, 1, -58)
TextButton.Style = Enum.ButtonStyle.RobloxRoundButton
TextButton.Font = Enum.Font.SourceSansBold
TextButton.FontSize = Enum.FontSize.Size24
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Text = "Accept"
TextButton.ZIndex = 5
TextButton.Parent = v84

local clone = TextButton:Clone()

clone.Name = "PopupDeclineButton"
clone.Position = UDim2.new(0.5, 2, 1, -58)
clone.Text = "Decline"
clone.Parent = v84

local clone2 = TextButton:Clone()

clone2.Name = "PopupOKButton"
clone2.Position = UDim2.new(0.5, -50, 1, -58)
clone2.Text = "OK"
clone2.Visible = false
clone2.Parent = v84

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Name = "PopupText"
TextLabel3.Size = UDim2.new(1, -16, 0.8, 0)
TextLabel3.Position = UDim2.new(0, 8, 0, 8)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Font = Enum.Font.SourceSansBold
TextLabel3.FontSize = Enum.FontSize.Size36
TextLabel3.TextColor3 = Color3.new(0.97, 0.97, 0.97)
TextLabel3.TextWrap = true
TextLabel3.ZIndex = 5
TextLabel3.TextYAlignment = Enum.TextYAlignment.Top
TextLabel3.Text = "This is a popup"
TextLabel3.Parent = v84

local u89 = nil

local function getFriendImage(p11) -- line: 311
	-- upvalues: SocialUtil (copy)
	return SocialUtil.GetPlayerImage(p11, Enum.ThumbnailSize.Size48x48, Enum.ThumbnailType.HeadShot, 5)
end
local function createNotification(p12, p13, p14) -- line: 322
	-- upvalues: v77 (copy), v48 (copy), TextLabel (copy), TextLabel2 (copy), TextService (copy), v52 (copy), v75 (copy), v56 (copy), v47 (copy), v50 (copy), ImageLabel (copy), GuiService (copy), HttpService (copy)
	local clone3 = v77:Clone()

	clone3.Position = UDim2.new(1, 4, 1, -v48 - 4)

	local clone4 = TextLabel:Clone()

	clone4.Text = p12
	clone4.Parent = clone3

	local clone5 = TextLabel2:Clone()

	clone5.Text = p13
	clone5.Parent = clone3

	local u142 = false

	local function updateNotificationForMultiLineTitle() -- line: 335
		-- upvalues: u142 (ref), clone4 (copy), TextService (copy), v52 (copy), clone5 (copy), clone3 (copy)
		u142 = true
		clone4.TextWrapped = true
		clone4.TextTruncate = Enum.TextTruncate.AtEnd

		local v274 = math.min(TextService:GetTextSize(clone4.Text, clone4.TextSize, clone4.Font, Vector2.new(clone4.AbsoluteSize.X, 1000)).Y - clone4.Size.Y.Offset, v52 - clone4.Size.Y.Offset)

		clone4.Size = clone4.Size + UDim2.new(0, 0, 0, v274)
		clone4.Position = clone4.Position - UDim2.new(0, 0, 0, v274 / 2)
		clone5.Position = clone5.Position + UDim2.new(0, 0, 0, v274 / 2)
		clone3.Size = clone3.Size + UDim2.new(0, 0, 0, v274)
	end

	clone3.Parent = v75

	if p14 == nil or p14 == "" then
		if not clone4.TextFits then
			u142 = true
			updateNotificationForMultiLineTitle()
		end

		if not clone5.TextFits then
			local v144 = math.min(TextService:GetTextSize(clone5.Text, clone5.TextSize, clone5.Font, Vector2.new(clone5.AbsoluteSize.X, 1000)).Y - clone5.Size.Y.Offset, v56 - clone5.Size.Y.Offset)

			clone5.Size = clone5.Size + UDim2.new(0, 0, 0, v144)
			clone4.Position = clone4.Position - UDim2.new(0, 0, 0, v144 / 2)
			clone5.Position = clone5.Position - UDim2.new(0, 0, 0, v144 / 2)
			clone3.Size = clone3.Size + UDim2.new(0, 0, 0, v144)
		end
	else
		local v145 = v47 + v50 * 2
		local v146 = v50
		local clone6 = ImageLabel:Clone()

		clone6.Image = p14
		clone6.Parent = clone3
		clone4.Size = UDim2.new(1, -v145 - v146, 0, clone4.Size.Y.Offset)
		clone4.Position = UDim2.new(0, v145, clone4.Position.Y.Scale, clone4.Position.Y.Offset)
		clone4.TextXAlignment = Enum.TextXAlignment.Left
		clone5.Size = UDim2.new(1, -v145 - v146, 0, clone5.Size.Y.Offset)
		clone5.Position = UDim2.new(0, v145, clone5.Position.Y.Scale, clone5.Position.Y.Offset)
		clone5.TextXAlignment = Enum.TextXAlignment.Left

		if not clone4.TextFits then
			updateNotificationForMultiLineTitle()

			local clone5TextSize = clone5.TextSize

			clone5.Size = clone5.Size - UDim2.new(0, 0, 0, clone5TextSize)
			clone4.Position = clone4.Position + UDim2.new(0, 0, 0, clone5TextSize / 2 - 2)
			clone5.Position = clone5.Position + UDim2.new(0, 0, 0, clone5TextSize / 2 - 2)
			clone3.Size = clone3.Size - UDim2.new(0, 0, 0, clone5TextSize + 4)
		end

		if not clone5.TextFits then
			local v149 = nil
			local clone5Text = clone5.Text

			for i = string.len(clone5Text) - 1, 2, -1 do
				if string.sub(clone5Text, i, i) ~= " " then
					continue
				end

				clone5.Text = string.sub(clone5Text, 1, i - 1)

				if clone5.TextFits then
					v149 = string.sub(clone5Text, i + 1)

					break
				end
			end

			if v149 then
				local clone7 = TextLabel2:Clone()

				clone7.TextXAlignment = Enum.TextXAlignment.Left
				clone7.Text = v149
				clone7.Name = "ExtraText"
				clone7.TextTruncate = Enum.TextTruncate.AtEnd
				clone7.Parent = clone3

				local v153 = math.min(TextService:GetTextSize(v149, clone7.TextSize, clone7.Font, Vector2.new(clone7.AbsoluteSize.X, 1000)).Y, v56 - clone5.Size.Y.Offset)

				clone7.Size = UDim2.new(clone7.Size.X.Scale, clone7.Size.X.Offset, 0, v153)
				clone4.Position = clone4.Position - UDim2.new(0, 0, 0, v153 / 2)
				clone5.Position = clone5.Position - UDim2.new(0, 0, 0, v153 / 2)
				clone3.Size = clone3.Size + UDim2.new(0, 0, 0, v153)
				clone7.AnchorPoint = Vector2.new(0.5, 0)
				clone7.Position = UDim2.new(0.5, 0, clone5.Position.Y.Scale, clone5.Position.Y.Offset + clone5.AbsoluteSize.Y)
			else
				clone5.Text = clone5Text
			end
		end
	end

	if u142 and clone5.TextFits then
		local TextSize = TextService:GetTextSize(clone5.Text, clone5.TextSize, clone5.Font, Vector2.new(clone5.AbsoluteSize.X, 1000))

		if TextSize.Y < clone5.Size.Y.Offset then
			local v155 = clone5.Size.Y.Offset - TextSize.Y

			clone5.Size = clone5.Size - UDim2.new(0, 0, 0, v155)
			clone4.Position = clone4.Position + UDim2.new(0, 0, 0, v155 / 2)
			clone5.Position = clone5.Position + UDim2.new(0, 0, 0, v155 / 2)
			clone3.Size = clone3.Size - UDim2.new(0, 0, 0, v155)
		end
	end

	clone3.Parent = nil
	GuiService:AddSelectionParent(HttpService:GenerateGUID(false), clone3)

	return clone3
end
local function findNotification(p15) -- line: 491
	-- upvalues: t1 (copy)
	for i = 1, #t1 do
		if p15 == t1[i] then
			return i
		end
	end
end
local function updateNotifications() -- line: 500
	-- upvalues: t1 (copy), v48 (copy), InOut (copy), Sine (copy)
	local n2 = 1
	local n3 = 0

	for i = #t1, 1, -1 do
		local v161 = t1[i]

		if v161 then
			local Frame4 = v161.Frame

			if Frame4 and Frame4.Parent then
				if not v161.IsFriend or not ((v48 + 2) * 1.5) then
					local _ = v48
				end

				n3 += v161.IsFriend and Frame4.Size.Y.Offset + (v48 + 2) * 0.5 or Frame4.Size.Y.Offset
				Frame4:TweenPositionInternal(UDim2.new(0, 0, 1, -n3 - n2 * 4), InOut, Sine, 0.35, true, function() -- line: 520
					-- upvalues: v161 (copy)
					if v161.TweenOutCallback then
						v161.TweenOutCallback()
					end
				end)
				n2 += 1
			end
		end
	end
end

local n4 = 0

local function u95(p16) -- line: 533
	-- upvalues: t1 (copy), t2 (copy), v75 (copy), u89 (ref), n4 (ref), updateNotifications (copy)
	spawn(function() -- line: 534
		-- upvalues: p16 (copy), t1 (copy), t2 (copy), v75 (copy), u89 (ref), n4 (ref), updateNotifications (copy)
		p16.IsActive = true

		local v275 = #t1

		if v275 == 3 then
			t1[1].Duration = 0
			t2[#t2 + 1] = p16

			return
		end

		t1[v275 + 1] = p16
		p16.Frame.Parent = v75
		spawn(function() -- line: 549
			-- upvalues: p16 (copy), u89 (ref)
			wait(0.7)

			while p16.Duration > 0 do
				wait(0.2)
				p16.Duration = p16.Duration - 0.2
			end

			u89(p16)
		end)

		while tick() - n4 < 0.35 do
			wait()
		end

		n4 = tick()
		updateNotifications()
	end)
end

function u89(p17) -- line: 572
	-- upvalues: t1 (copy), InOut (copy), Sine (copy), t2 (copy), u95 (ref), updateNotifications (copy)
	if not p17 then
		return
	end

	local v167 = p17
	local g170 = nil
	local v169 = nil

	for i = 1, #t1 do
		if v167 == t1[i] then
			v169 = i
			g170 = true
		end

		if g170 then
			break
		end
	end

	if not g170 then
		v169 = nil
	end

	g170 = false
	table.remove(t1, v169)

	local Frame5 = p17.Frame

	if Frame5 and Frame5.Parent then
		p17.IsActive = false
		spawn(function() -- line: 582
			-- upvalues: Frame5 (copy), InOut (copy), Sine (copy), p17 (ref)
			local function doTweenOut() -- line: 588
				-- upvalues: Frame5 (copy), InOut (copy), Sine (copy), p17 (ref)
				if Frame5:IsDescendantOf(game) then
					return Frame5:TweenPositionInternal(UDim2.new(1, 0, 1, Frame5.Position.Y.Offset), InOut, Sine, 0.35, false, function() -- line: 596
						-- upvalues: Frame5 (copy), p17 (ref)
						Frame5:Destroy()
						p17 = nil
					end)
				end

				return false
			end

			if not doTweenOut() then
				p17.TweenOutCallback = doTweenOut
			end
		end)
	end

	if #t2 > 0 then
		local v172 = t2[1]

		table.remove(t2, 1)
		u95(v172)

		if #t2 > 0 and t1[1] then
			t1[1].Duration = 0
		end
	else
		updateNotifications()
	end
end

local function sendNotificationInfo(p18) -- line: 625
	-- upvalues: BindableEvent (copy)
	p18.Duration = p18.Duration or 5
	BindableEvent:Fire(p18)
end
local function createNotificationButtonDetails(s2: string, p19, p20) -- line: 630
	return {
		Text = s2,
		ButtonType = p19,
		OnActivated = function() -- line: 634
			-- upvalues: p20 (copy), s2 (copy)
			if p20 and type(p20) ~= "function" then
				pcall(function() -- line: 636
					-- upvalues: p20 (copy), s2 (copy)
					p20:Invoke(s2)
				end)

				return
			end

			if type(p20) == "function" then
				p20(s2)
			end
		end
	}
end
local function onSendNotificationInfo(p21) -- line: 646
	-- upvalues: VRService (copy), EngineFeature (copy), GetFFlagClientToastNotificationsRedirect (copy), GameTranslator (copy), CoreGui (copy), GuiService (copy), createNotification (copy), createTextButton (copy), u89 (ref), v58 (copy), u95 (ref)
	if VRService.VREnabled then
		return
	end

	local Callback = p21.Callback
	local Button1Text = p21.Button1Text
	local Button2Text = p21.Button2Text

	if EngineFeature and GetFFlagClientToastNotificationsRedirect() then
		local t7 = {}

		if Button1Text and Button1Text ~= "" then
			local Primary = Enum.NotificationButtonType.Primary

			table.insert(t7, {
				Text = Button1Text,
				ButtonType = Primary,
				OnActivated = function() -- line: 634
					-- upvalues: Callback (copy), Button1Text (copy)
					if Callback and type(Callback) ~= "function" then
						pcall(function() -- line: 636
							-- upvalues: Callback (copy), Button1Text (copy)
							Callback:Invoke(Button1Text)
						end)

						return
					end

					if type(Callback) == "function" then
						Callback(Button1Text)
					end
				end
			})
		end

		if Button2Text and Button2Text ~= "" then
			local Secondary = Enum.NotificationButtonType.Secondary

			table.insert(t7, {
				Text = Button2Text,
				ButtonType = Secondary,
				OnActivated = function() -- line: 634
					-- upvalues: Callback (copy), Button2Text (copy)
					if Callback and type(Callback) ~= "function" then
						pcall(function() -- line: 636
							-- upvalues: Callback (copy), Button2Text (copy)
							Callback:Invoke(Button2Text)
						end)

						return
					end

					if type(Callback) == "function" then
						Callback(Button2Text)
					end
				end
			})
		end

		local t8 = {
			Title = if not p21.Autolocalize then p21.Title else GameTranslator:TranslateGameText(CoreGui, p21.Title),
			Text = if not p21.AutoLocalize then p21.Text else GameTranslator:TranslateGameText(CoreGui, p21.Text),
			Icon = p21.Image,
			OnDisplay = p21.OnDisplay,
			OnDismiss = p21.OnDismiss,
			Buttons = t7
		}

		GuiService:SendNotification(t8)

		return
	end

	local t9 = {}
	local v186 = if not p21.AutoLocalize then createNotification(p21.Title, p21.Text, p21.Image) else createNotification(GameTranslator:TranslateGameText(CoreGui, p21.Title), GameTranslator:TranslateGameText(CoreGui, p21.Text), p21.Image)
	local v187 = nil

	if Button1Text and Button1Text ~= "" then
		t9.IsFriend = true
		v187 = createTextButton("Button1", UDim2.new(0, 0, 1, 2))

		if p21.AutoLocalize then
			GameTranslator:TranslateAndRegister(v187, CoreGui, Button1Text)
		else
			v187.Text = Button1Text
		end

		v187.Parent = v186

		local u188 = nil

		u188 = v187.MouseButton1Click:connect(function() -- line: 715
			-- upvalues: u188 (ref), u89 (ref), t9 (copy), Callback (copy), Button1Text (copy)
			if u188 then
				u188:disconnect()
				u188 = nil
				u89(t9)

				if Callback and type(Callback) ~= "function" then
					pcall(function() -- line: 721
						-- upvalues: Callback (copy), Button1Text (copy)
						Callback:Invoke(Button1Text)
					end)

					return
				end

				if type(Callback) == "function" then
					Callback(Button1Text)
				end
			end
		end)
	end

	if Button2Text and Button2Text ~= "" then
		t9.IsFriend = true

		local v189 = createTextButton("Button2", UDim2.new(0.5, 1, 1, 2))

		if p21.AutoLocalize then
			GameTranslator:TranslateAndRegister(v189, CoreGui, Button2Text)
		else
			v189.Text = Button2Text
		end

		v189.Parent = v186

		local u190 = nil

		u190 = v189.MouseButton1Click:connect(function() -- line: 745
			-- upvalues: u190 (ref), u89 (ref), t9 (copy), Callback (copy), Button2Text (copy), p21 (copy)
			if u190 then
				u190:disconnect()
				u190 = nil
				u89(t9)

				if Callback and type(Callback) ~= "function" then
					pcall(function() -- line: 751
						-- upvalues: Callback (copy), Button2Text (copy)
						Callback:Invoke(Button2Text)
					end)

					return
				end

				if type(Callback) == "function" then
					Callback(p21.Button2Text)
				end
			end
		end)
	elseif v187 then
		v187.Size = UDim2.new(1, 0, 0, v58)
	end

	t9.Frame = v186
	t9.Duration = p21.Duration
	u95(t9)
end

BindableEvent.Event:connect(onSendNotificationInfo)

local function createDeveloperNotification(p22) -- line: 772
	-- upvalues: EngineFeature (copy), GetFFlagClientToastNotificationsRedirect (copy), BindableEvent (copy)
	if type(p22) == "table" and (type(p22.Title) == "string" and type(p22.Text) == "string") then
		local v192 = type(p22.Icon) == "string" and p22.Icon or ""
		local v193 = type(p22.Duration) == "number" and p22.Duration or 5
		local v194 = typeof(p22.Callback) == "Instance" and (not not p22.Callback:IsA("BindableFunction") and p22.Callback) or nil
		local v195, v196

		if EngineFeature and GetFFlagClientToastNotificationsRedirect() then
			v195 = type(p22.Button1) == "string" and p22.Button1 or nil
			v196 = type(p22.Button2) == "string" and p22.Button2 or nil
		else
			v195 = type(p22.Button1) == "string" and p22.Button1 or ""
			v196 = type(p22.Button2) == "string" and p22.Button2 or ""
		end

		local v197 = p22.AutoLocalize == nil or p22.AutoLocalize == true
		local p22Title = p22.Title
		local p22Text = p22.Text
		local t10 = {
			GroupName = "Developer",
			Title = p22Title,
			Text = p22Text,
			Image = v192,
			Duration = v193,
			Callback = v194,
			Button1Text = v195,
			Button2Text = v196,
			AutoLocalize = v197
		}

		t10.Duration = t10.Duration or 5
		BindableEvent:Fire(t10)
	end
end

StarterGui:RegisterSetCore("SendNotification", createDeveloperNotification)

local t11 = {}

local function u101(p23) -- line: 823
	-- upvalues: t11 (copy), n1 (ref)
	local v202 = t11[p23]

	if v202 and v202 > tick() then
		return true
	end

	t11[p23] = tick() + n1

	return false
end
local function sendFriendNotification(p24) -- line: 837
	-- upvalues: u101 (ref), v26 (copy), UniversalAppPolicy (copy), translateString (copy), t5 (copy), SocialUtil (copy), RbxAnalyticsService (copy), LocalPlayer (ref), t3 (copy), BindableEvent (copy)
	if u101(p24) then
		return
	end

	local v204 = not (v26 and UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()) and "Sent you a friend request!" or translateString(t5.SENT)
	local t12 = {
		GroupName = "Friends",
		Duration = 8,
		Button1Text = "Accept",
		Button2Text = "Decline",
		Title = p24.DisplayName,
		Text = v204,
		DetailText = p24.DisplayName
	}
	local UserId = p24.UserId

	t12.Image = SocialUtil.GetPlayerImage(UserId, Enum.ThumbnailSize.Size48x48, Enum.ThumbnailType.HeadShot, 5)

	function t12.Callback(p25) -- line: 858
		-- upvalues: RbxAnalyticsService (copy), LocalPlayer (ref), p24 (copy), t3 (copy)
		if p25 == "Accept" then
			RbxAnalyticsService:ReportCounter("NotificationScript-RequestFriendship")
			RbxAnalyticsService:TrackEvent("Game", "RequestFriendship", "NotificationScript")
			RbxAnalyticsService:ReportCounter("NotificationScript-AcceptFriendship")
			RbxAnalyticsService:TrackEvent("Game", "AcceptFriendship", "NotificationScript")
			LocalPlayer:RequestFriendship(p24)

			return
		end

		RbxAnalyticsService:ReportCounter("NotificationScript-RevokeFriendship")
		RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "NotificationScript")
		LocalPlayer:RevokeFriendship(p24)
		t3[p24] = true
	end
	function t12.OnDisplay() -- line: 877
		-- upvalues: RbxAnalyticsService (copy)
		RbxAnalyticsService:ReportCounter("NotificationScript-FriendshipNotificationDisplayed")
		RbxAnalyticsService:TrackEvent("Game", "FriendshipNotificationDisplayed", "NotificationScript")
	end
	function t12.OnDismiss() -- line: 881
		-- upvalues: RbxAnalyticsService (copy)
		RbxAnalyticsService:ReportCounter("NotificationScript-FriendshipNotificationDismissed")
		RbxAnalyticsService:TrackEvent("Game", "FriendshipNotificationDismissed", "NotificationScript")
	end

	t12.Duration = t12.Duration or 5
	BindableEvent:Fire(t12)
end
local function onFriendRequestEvent(p26, p27, p28) -- line: 888
	-- upvalues: LocalPlayer (ref), v26 (copy), UniversalAppPolicy (copy), translateString (copy), t5 (copy), FriendingUtility (copy), GetFFlagFriendshipNotifsUseSendr (copy), RobloxTranslator (copy), SocialUtil (copy), BindableEvent (copy), t3 (copy), sendFriendNotification (copy)
	if p26 ~= LocalPlayer and p27 ~= LocalPlayer then
		return
	end

	local v210 = not (v26 and UniversalAppPolicy.getAppFeaturePolicies().getRenameFriendsToConnections()) and "New Friend" or translateString(t5.ACCEPTED)
	local v211 = UniversalAppPolicy.getAppFeaturePolicies().getRequiresOSAFriendingEducation()
	local FriendCountAsync = FriendingUtility:GetFriendCountAsync(LocalPlayer.UserId)
	local v213 = FriendCountAsync == 0 or FriendCountAsync == nil

	if p26 == LocalPlayer then
		if p28 == Enum.FriendRequestEvent.Accept and not GetFFlagFriendshipNotifsUseSendr() then
			local v214 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.FriendRequestEvent.Accept", {
				RBX_NAME = p27.Name
			})
			local t13 = {
				GroupName = "Friends",
				Duration = 5,
				Title = v210,
				Text = p27.Name,
				DetailText = v214
			}
			local UserId = p27.UserId

			t13.Image = SocialUtil.GetPlayerImage(UserId, Enum.ThumbnailSize.Size48x48, Enum.ThumbnailType.HeadShot, 5)
			t13.Duration = t13.Duration or 5
			BindableEvent:Fire(t13)

			return
		end
	elseif p27 == LocalPlayer then
		if p28 == Enum.FriendRequestEvent.Issue and not GetFFlagFriendshipNotifsUseSendr() then
			if t3[p26] then
				return
			end

			if v211 and v213 then
				return
			end

			sendFriendNotification(p26)

			return
		end

		if p28 == Enum.FriendRequestEvent.Accept then
			local v217 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.FriendRequestEvent.Accept", {
				RBX_NAME = p26.Name
			})
			local t14 = {
				GroupName = "Friends",
				Duration = 5,
				Title = v210,
				Text = p26.Name,
				DetailText = v217
			}
			local UserId = p26.UserId

			t14.Image = SocialUtil.GetPlayerImage(UserId, Enum.ThumbnailSize.Size48x48, Enum.ThumbnailType.HeadShot, 5)
			t14.Duration = t14.Duration or 5
			BindableEvent:Fire(t14)
		end
	end
end
local function onPointsAwarded(p29, p30, _, _) -- line: 948
	-- upvalues: u41 (ref), LocalPlayer (ref), RobloxTranslator (copy), BindableEvent (copy)
	if u41 and p29 == LocalPlayer.UserId then
		local s3, v225

		if p30 == 1 then
			s3 = "Point Awarded"
			v225 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onPointsAwarded.single", {
				RBX_NUMBER = tostring(p30)
			})
		elseif p30 > 0 then
			s3 = "Points Awarded"
			v225 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onPointsAwarded.multiple", {
				RBX_NUMBER = tostring(p30)
			})
		else
			if not (p30 < 0) then
				return
			end

			s3 = "Points Lost"
			v225 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onPointsAwarded.negative", {
				RBX_NUMBER = tostring(p30)
			})
		end

		local t15 = {
			GroupName = "PlayerPoints",
			Image = "https://www.roblox.com/asset?id=206410433",
			Duration = 5,
			Title = s3,
			Text = v225,
			DetailText = v225
		}

		t15.Duration = t15.Duration or 5
		BindableEvent:Fire(t15)
	end
end
local function onBadgeAwarded(p33, p34, p35) -- line: 986
	-- upvalues: t4 (copy), u42 (ref), LocalPlayer (ref), GroupService (copy), Players (copy), BadgeService (copy), v28 (copy), RobloxTranslator (copy), RbxAnalyticsService (copy), BindableEvent (copy)
	if not t4[p35] and (u42 and p33 == LocalPlayer.UserId) then
		t4[p35] = true

		local s4 = ""

		if game.CreatorType == Enum.CreatorType.Group then
			local ok2, result2 = pcall(function() -- line: 991
				-- upvalues: GroupService (copy), p34 (copy)
				return GroupService:GetGroupInfoAsync(p34)
			end)

			if not ok2 then
				s4 = ""
			end

			if result2 then
				s4 = result2.Name
			end
		elseif game.CreatorType == Enum.CreatorType.User then
			local ok3

			ok3, s4 = pcall(function() -- line: 1003
				-- upvalues: Players (copy), p34 (copy)
				return Players:GetNameFromUserIdAsync(p34)
			end)

			if not ok3 then
				s4 = ""
			end
		end

		local ok4, result3 = pcall(function() -- line: 1011
			-- upvalues: BadgeService (copy), p35 (copy)
			return BadgeService:GetBadgeInfoAsync(p35)
		end)

		if not ok4 then
			return
		end

		if v28 and s4 == nil then
			s4 = ""
		end

		local v236 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.onBadgeAwardedDetail", {
			RBX_NAME = LocalPlayer.Name,
			CREATOR_NAME = s4,
			BADGE_NAME = result3.DisplayName
		})
		local u237 = nil
		local s5 = "InGame.NotificationScript2.onBadgeAwardedTitle"

		pcall(function() -- line: 57
			-- upvalues: u237 (ref), RobloxTranslator (copy), s5 (copy)
			u237 = RobloxTranslator:FormatByKey(s5)
		end)

		local v239 = u237
		local t16 = {
			GroupName = "BadgeAwards",
			Image = "https://www.roblox.com/asset?id=206410289",
			Duration = 5,
			Title = v239,
			Text = v236,
			DetailText = v236,
			OnDisplay = function() -- line: 1036
				-- upvalues: RbxAnalyticsService (copy)
				RbxAnalyticsService:ReportCounter("NotificationScript-BadgeAwardNotificationDisplayed")
				RbxAnalyticsService:TrackEvent("Game", "BadgeAwardNotificationDisplayed", "NotificationScript")
			end,
			OnDismiss = function() -- line: 1040
				-- upvalues: RbxAnalyticsService (copy)
				RbxAnalyticsService:ReportCounter("NotificationScript-BadgeAwardNotificationDismissed")
				RbxAnalyticsService:TrackEvent("Game", "BadgeAwardNotificationDismissed", "NotificationScript")
			end
		}

		t16.Duration = t16.Duration or 5
		BindableEvent:Fire(t16)
	end
end

function onGameSettingsChanged(p36, p37) -- line: 1048
	-- upvalues: GameSettings (copy), SavedQualityLevelValue (ref), RobloxTranslator (copy), BindableEvent (copy)
	if p36 == "SavedQualityLevel" then
		local v243 = GameSettings.SavedQualityLevel.Value + p37

		if v243 > 10 then
			v243 = 10
		elseif v243 < 1 then
			v243 = 1
		end

		if v243 > 0 and v243 ~= SavedQualityLevelValue and GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			("%s to (%d)"):format(not (v243 > SavedQualityLevelValue) and "Decreased" or "Increased", v243)

			local v244 = if not (v243 > SavedQualityLevelValue) then RobloxTranslator:FormatByKey("InGame.NotificationScrip2.onCurrentGraphicsQualityLevelChanged.Decreased", {
				RBX_NUMBER = tostring(v243)
			}) else RobloxTranslator:FormatByKey("InGame.NotificationScrip2.onCurrentGraphicsQualityLevelChanged.Increased", {
				RBX_NUMBER = tostring(v243)
			})
			local t17 = {
				GroupName = "Graphics",
				Title = "Graphics Quality",
				Image = "",
				Duration = 2,
				Text = v244,
				DetailText = v244
			}

			t17.Duration = t17.Duration or 5
			BindableEvent:Fire(t17)
			SavedQualityLevelValue = v243
		end
	end
end

if not CachedPolicyService:IsSubjectToChinaPolicies() then
	BadgeService.OnBadgeAwarded:connect(onBadgeAwarded)
end

if not v40 then
	Players.FriendRequestEvent:connect(onFriendRequestEvent)
	PointsService.PointsAwarded:connect(onPointsAwarded)
	game.GraphicsQualityChangeRequest:Connect(function(_) -- line: 1099
		onGameSettingsChanged("SavedQualityLevel", 0)
	end)
end

if not CachedPolicyService:IsSubjectToChinaPolicies() then
	if not shouldSaveScreenshotToAlbum() then
		game.ScreenshotReady:Connect(function(_) -- line: 1109
			-- upvalues: RobloxTranslator (copy), BindableEvent (copy)
			local v248 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Screenshot.Title")
			local v249 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Screenshot.Description")
			local v250 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Screenshot.ButtonText")
			local t18 = {
				Duration = 3,
				Title = v248,
				Text = v249,
				Button1Text = v250,
				Callback = function(p40) -- line: 1119
					-- upvalues: v250 (copy)
					if p40 == v250 then
						game:OpenScreenshotsFolder()
					end
				end
			}

			t18.Duration = t18.Duration or 5
			BindableEvent:Fire(t18)
		end)
	end

	settings():GetService("GameSettings").VideoRecordingChangeRequest:Connect(function(p41) -- line: 1129
		-- upvalues: RobloxTranslator (copy), BindableEvent (copy)
		if not p41 then
			local v253 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Video.Title")
			local v254 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Video.Description")
			local v255 = RobloxTranslator:FormatByKey("InGame.NotificationScript2.Video.ButtonText")
			local t19 = {
				Duration = 3,
				Title = v253,
				Text = v254,
				Button1Text = v255,
				Callback = function(p42) -- line: 1140
					-- upvalues: v255 (copy)
					if p42 == v255 then
						game:OpenVideosFolder()
					end
				end
			}

			t19.Duration = t19.Duration or 5
			BindableEvent:Fire(t19)
		end
	end)
end

function GuiService.SendCoreUiNotification(p43, p44) -- line: 1150
	-- upvalues: createNotification (copy), scriptParent (copy), InOut (copy), Sine (copy)
	local v259 = createNotification(p43, p44, "")

	v259.BackgroundTransparency = 0.5
	v259.Size = UDim2.new(0.5, 0, 0.1, 0)
	v259.Position = UDim2.new(0.25, 0, -0.1, 0)
	v259.NotificationTitle.FontSize = Enum.FontSize.Size36
	v259.NotificationText.FontSize = Enum.FontSize.Size24
	v259.Parent = scriptParent
	v259:TweenPositionInternal(UDim2.new(0.25, 0, 0, 0), InOut, Sine, 0.35, true)
	wait(5)

	if v259 then
		v259:Destroy()
	end
end

local function onClientLuaDialogRequested(p45, p46, p47) -- line: 1166
	-- upvalues: TextLabel3 (copy), GuiService (copy), v84 (copy), TextButton (copy), MarketplaceService (copy), clone (copy), clone2 (copy)
	TextLabel3.Text = p45

	local u263 = nil
	local u264 = nil

	local function disconnectCns() -- line: 1170
		-- upvalues: u263 (ref), u264 (ref), GuiService (copy), v84 (copy)
		if u263 then
			u263:disconnect()
		end

		if u264 then
			u264:disconnect()
		end

		GuiService:RemoveCenterDialog(v84)
		v84.Visible = false
	end

	u263 = TextButton.MouseButton1Click:connect(function() -- line: 1182
		-- upvalues: u263 (ref), u264 (ref), GuiService (copy), v84 (copy), MarketplaceService (copy)
		if u263 then
			u263:disconnect()
		end

		if u264 then
			u264:disconnect()
		end

		GuiService:RemoveCenterDialog(v84)
		v84.Visible = false
		MarketplaceService:SignalServerLuaDialogClosed(true)
	end)
	u264 = clone.MouseButton1Click:connect(function() -- line: 1186
		-- upvalues: u263 (ref), u264 (ref), GuiService (copy), v84 (copy), MarketplaceService (copy)
		if u263 then
			u263:disconnect()
		end

		if u264 then
			u264:disconnect()
		end

		GuiService:RemoveCenterDialog(v84)
		v84.Visible = false
		MarketplaceService:SignalServerLuaDialogClosed(false)
	end)

	if not pcall(function() -- line: 1191
		-- upvalues: GuiService (copy), v84 (copy), clone2 (copy), TextButton (copy), clone (copy), p46 (copy), p47 (copy)
		GuiService:AddCenterDialog(v84, Enum.CenterDialogType.QuitDialog, function() -- line: 1192
			-- upvalues: clone2 (copy), TextButton (copy), clone (copy), p46 (copy), p47 (copy), v84 (copy)
			clone2.Visible = false
			TextButton.Visible = true
			clone.Visible = true
			TextButton.Text = p46
			clone.Text = p47
			v84.Visible = true
		end, function() -- line: 1199
			-- upvalues: v84 (copy)
			v84.Visible = false
		end)
	end) then
		v84.Visible = true
		TextButton.Text = p46
		clone.Text = p47
	end

	return true
end

MarketplaceService.ClientLuaDialogRequested:connect(onClientLuaDialogRequested)

local function onPreferredTransparencyChanged() -- line: 1214
	-- upvalues: u46 (ref), GameSettings (copy), v77 (copy), t1 (copy)
	u46 = 0.6 * GameSettings.PreferredTransparency
	v77.BackgroundTransparency = u46

	for i = 1, #t1 do
		t1[i].Frame.BackgroundTransparency = u46
	end
end

GameSettings:GetPropertyChangedSignal("PreferredTransparency"):connect(onPreferredTransparencyChanged)

if FFlagCoreScriptShowTeleportPrompt then
	local function onMenuTeleportAttemptNotification() -- line: 1225
		-- upvalues: RobloxTranslator (copy), v53 (copy), BindableEvent (copy)
		local s6 = "Teleporting Paused"
		local s7 = "Feature.SettingsHub.Prompt.TeleportBlock.Title"

		pcall(function() -- line: 57
			-- upvalues: s6 (ref), RobloxTranslator (copy), s7 (copy)
			s6 = RobloxTranslator:FormatByKey(s7)
		end)

		local v269 = s6
		local s8 = "Teleporting will resume upon menu close."
		local s9 = "Feature.SettingsHub.Prompt.TeleportBlock.Subtitle"

		pcall(function() -- line: 57
			-- upvalues: s8 (ref), RobloxTranslator (copy), s9 (copy)
			s8 = RobloxTranslator:FormatByKey(s9)
		end)

		local v272 = s8
		local t20 = {
			GroupName = "Teleport",
			Image = "http://www.roblox.com/asset/?id=10961494062",
			Duration = 5,
			Title = v269,
			Text = v272,
			BottomPadding = v53
		}

		t20.Duration = t20.Duration or 5
		BindableEvent:Fire(t20)
	end
	local function connectMenuTeleportAttemptEvent() -- line: 1242
		-- upvalues: TeleportService (copy), onMenuTeleportAttemptNotification (copy)
		TeleportService.MenuTeleportAttempt:Connect(function() -- line: 1243
			-- upvalues: onMenuTeleportAttemptNotification (copy)
			onMenuTeleportAttemptNotification()
		end)
	end

	TeleportService.MenuTeleportAttempt:Connect(function() -- line: 1243
		-- upvalues: onMenuTeleportAttemptNotification (copy)
		onMenuTeleportAttemptNotification()
	end)
end
