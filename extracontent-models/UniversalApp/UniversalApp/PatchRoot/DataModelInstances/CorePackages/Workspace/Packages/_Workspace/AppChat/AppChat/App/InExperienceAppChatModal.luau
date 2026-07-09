local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local UIBlox = require(AppChatParent.UIBlox)
local Tokens = UIBlox.App.Style.Tokens
local Constants = UIBlox.App.Style.Constants
local v8 = require(AppChatParent.SharedFlags).getFFlagSettingsHubIndependentBackgroundVisibility()
local getFFlagAppChatInExperienceTabBarAdjustment = require(AppChat.Flags.getFFlagAppChatInExperienceTabBarAdjustment)
local t1 = {}

t1.__index = t1

function t1._new() -- line: 52
	-- upvalues: t1 (copy)
	local t2 = {
		_visible = false,
		_wasVisible = false,
		unreadCount = 0,
		currentSquadId = "",
		topMargin = 12,
		visibilitySignal = Instance.new("BindableEvent"),
		unreadCountSignal = Instance.new("BindableEvent"),
		currentSquadIdSignal = Instance.new("BindableEvent")
	}

	setmetatable(t2, t1)

	return t2
end
function t1.initialize(p1, n1: number?, p2, p3, p4, p5) -- line: 68
	-- upvalues: Tokens (copy), Constants (copy), getFFlagAppChatInExperienceTabBarAdjustment (copy)
	if n1 then
		p1.topMargin = n1
	end

	p1.settingsHub = p2
	p1._foundationTokens = Tokens.getFoundationTokensDefaultScale(Constants.ThemeName.Dark)

	if getFFlagAppChatInExperienceTabBarAdjustment() then
		p1.viewportUtil = p3
	end

	p1.chatSelector = p4
	p1.playerListManager = p5
end
function t1.setVisible(p6, b1: boolean) -- line: 92
	-- upvalues: CoreGui (copy), getFFlagAppChatInExperienceTabBarAdjustment (copy), GuiService (copy), v8 (copy)
	if b1 == p6._visible then
		return
	end

	p6._visible = b1
	p6.visibilitySignal:Fire(b1)

	if b1 then
		if p6.chatSelector then
			p6.chatSelector:HideTemp("AppChat", true)
		end

		if p6.playerListManager then
			p6.playerListManager:HideTemp("AppChat", true)
		end

		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.DisplayOrder = game:DefineFastInt("AppChatInExperienceStandaloneContainerDisplayOrder", 4)
		ScreenGui.Parent = CoreGui
		ScreenGui.Name = "InExperienceAppChatModal"

		local UIPadding = Instance.new("UIPadding")

		UIPadding.PaddingTop = UDim.new(0, p6.topMargin)
		UIPadding.PaddingRight = UDim.new(0, 12)
		UIPadding.PaddingBottom = UDim.new(0, 0)
		UIPadding.PaddingLeft = UDim.new(0, 12)
		UIPadding.Parent = ScreenGui

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Parent = ScreenGui

		local ImageButton = Instance.new("ImageButton")

		ImageButton.BorderSizePixel = 0
		ImageButton.AutoButtonColor = false
		ImageButton.Modal = true
		ImageButton.BackgroundTransparency = p6._foundationTokens.Color.OverMedia.OverMedia_0.Transparency
		ImageButton.BackgroundColor3 = p6._foundationTokens.Color.OverMedia.OverMedia_0.Color3
		ImageButton.Size = UDim2.fromScale(1, 1)
		ImageButton.Visible = true
		ImageButton.Parent = ScreenGui

		if getFFlagAppChatInExperienceTabBarAdjustment() and p6.viewportUtil then
			local function v24() -- line: 137
				-- upvalues: p6 (copy), UIPadding (copy), GuiService (copy)
				local v34 = p6.viewportUtil.screenSize:get()

				if not v34 or (not v34.X or not v34.Y) then
					return
				end

				if v34.Y > v34.X then
					UIPadding.PaddingBottom = UDim.new(0, 0)

					return
				end

				UIPadding.PaddingBottom = UDim.new(0, GuiService:GetSafeZoneOffsets().bottom)
			end

			p6.viewportUtil.screenSize:connect(v24)
			v24()
		end

		local UISizeConstraint = Instance.new("UISizeConstraint")

		UISizeConstraint.MaxSize = Vector2.new(850, 780)
		UISizeConstraint.Parent = ImageButton

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 8)
		UICorner.Parent = ImageButton
		p6.frame = ImageButton
	else
		if p6.frame and p6.frame.Parent then
			p6.frame.Parent:Destroy()
			p6.frame = nil
		end

		if p6.chatSelector then
			p6.chatSelector:HideTemp("AppChat", false)
		end

		if p6.playerListManager then
			p6.playerListManager:HideTemp("AppChat", false)
		end
	end

	if p6.settingsHub and v8 then
		p6.settingsHub:SetBackgroundVisibility(b1, false)
	end
end
function t1.toggleVisibility(p7) -- line: 188
	if p7.default then
		local _visible = p7.default._visible

		p7.default:setVisible(not _visible)
	end
end
function t1.getVisible(p8) -- line: 196
	return p8.default._visible
end
function t1.setUnreadCount(t3: {[any]: any}, n2: number) -- line: 201
	t3.default.unreadCount = n2
	t3.default.unreadCountSignal:Fire(n2)
end
function t1.setCurrentSquadId(t4: {[any]: any}, s1: string) -- line: 206
	t4.default.currentSquadId = s1
	t4.default.currentSquadIdSignal:Fire(s1)
end

t1.default = t1._new()

return t1
