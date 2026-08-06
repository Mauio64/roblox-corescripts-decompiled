local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local UIBlox = require(AppChatParent.UIBlox)
local Tokens = UIBlox.App.Style.Tokens
local Constants = UIBlox.App.Style.Constants
local SharedFlags = require(AppChatParent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local v10 = SharedFlags.getFFlagSettingsHubIndependentBackgroundVisibility()
local getFFlagAppChatInExperienceTabBarAdjustment = require(AppChat.Flags.getFFlagAppChatInExperienceTabBarAdjustment)
local EnumScreens = require(AppChat.EnumScreens)
local t1 = {}

t1.__index = t1

local function getFFlagAppChatEnableRootedNavigation() -- line: 22
	-- upvalues: AppChat (copy)
	return require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)()
end
local function getRootedNavigationStore() -- line: 26
	-- upvalues: AppChat (copy)
	return require(AppChat.Stores.GetRootedNavigationStore)(false)
end
local function isSupportedRootedRoute(t2: {[any]: any}) -- line: 40
	-- upvalues: EnumScreens (copy)
	local params = t2.params
	local v19 = if not params then nil else params.conversationId

	return t2.screen == EnumScreens.ChatDetails and (params ~= nil and (params.rooted == true and (type(v19) == "string" and v19 ~= "")))
end

function t1._new() -- line: 89
	-- upvalues: t1 (copy)
	local t3 = {
		_visible = false,
		_wasVisible = false,
		unreadCount = 0,
		hasReceivedInitialUnreadCount = false,
		currentSquadId = "",
		requestedRoute = nil,
		topMargin = 12,
		visibilitySignal = Instance.new("BindableEvent"),
		unreadCountSignal = Instance.new("BindableEvent"),
		initialUnreadCountSignal = Instance.new("BindableEvent"),
		currentSquadIdSignal = Instance.new("BindableEvent"),
		requestedRouteSignal = Instance.new("BindableEvent")
	}

	setmetatable(t3, t1)

	return t3
end
function t1.initialize(p1, n1: number?, p2, p3, p4, p5) -- line: 109
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
function t1.setVisible(p6, b1: boolean, s1: string?) -- line: 133
	-- upvalues: AppChat (copy), CoreGui (copy), getFFlagAppChatInExperienceTabBarAdjustment (copy), GuiService (copy), v10 (copy)
	if not b1 and require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)() then
		require(AppChat.Stores.GetRootedNavigationStore)(false).cancelNavigation()
	end

	if b1 == p6._visible then
		return
	end

	p6._visible = b1
	p6.visibilitySignal:Fire(b1, s1)

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
			local function v34() -- line: 182
				-- upvalues: p6 (copy), UIPadding (copy), GuiService (copy)
				local v53 = p6.viewportUtil.screenSize:get()

				if not v53 or (not v53.X or not v53.Y) then
					return
				end

				if v53.Y > v53.X then
					UIPadding.PaddingBottom = UDim.new(0, 0)

					return
				end

				UIPadding.PaddingBottom = UDim.new(0, GuiService:GetSafeZoneOffsets().bottom)
			end

			p6.viewportUtil.screenSize:connect(v34)
			v34()
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

	if p6.settingsHub and v10 then
		p6.settingsHub:SetBackgroundVisibility(b1, false)
	end
end
function t1.toggleVisibility(p7) -- line: 233
	if p7.default then
		local _visible = p7.default._visible

		p7.default:setVisible(not _visible)
	end
end
function t1.getVisible(p8) -- line: 241
	return p8.default._visible
end
function t1.setUnreadCount(t4: {[any]: any}, n2: number) -- line: 246
	t4.default.unreadCount = n2
	t4.default.unreadCountSignal:Fire(n2)
end
function t1.markInitialUnreadCountReceived(t5: {[any]: any}, n3: number) -- line: 254
	if t5.default.hasReceivedInitialUnreadCount then
		return
	end

	t5.default.hasReceivedInitialUnreadCount = true
	t5.default.initialUnreadCountSignal:Fire(n3)
end
function t1.setCurrentSquadId(t6: {[any]: any}, s2: string) -- line: 262
	t6.default.currentSquadId = s2
	t6.default.currentSquadIdSignal:Fire(s2)
end
function t1.openToScreen(p9, t7: {[any]: any}) -- line: 267
	-- upvalues: AppChat (copy), EnumScreens (copy), FFlagExpChatEnableFriendsTab (copy)
	if require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)() then
		local v48 = require(AppChat.Stores.GetRootedNavigationStore)(false)
		local params = t7.params
		local v50 = if not params then nil else params.conversationId

		if t7.screen == EnumScreens.ChatDetails and (params ~= nil and (params.rooted == true and (type(v50) == "string" and v50 ~= ""))) then
			local v51 = table.clone(t7.params)

			v51.rootedNavigationRequestId = v48.beginNavigation()
			t7 = {
				screen = t7.screen,
				params = v51
			}
		else
			v48.cancelNavigation()
		end
	end

	p9.requestedRoute = t7
	p9.requestedRouteSignal:Fire(t7)
	p9:setVisible(true, if not FFlagExpChatEnableFriendsTab or not t7.params then nil else t7.params.entryPoint)
end
function t1.clearRequestedRoute(p10) -- line: 291
	p10.requestedRoute = nil
	p10.requestedRouteSignal:Fire(nil)
end

t1.default = t1._new()

return t1
