local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local UIBlox = require(parent.UIBlox)
local Tokens = UIBlox.App.Style.Tokens
local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local SharedFlags = require(parent.SharedFlags)
local fFlagSettingsHubIndependentBackgroundVisibility = SharedFlags.getFFlagSettingsHubIndependentBackgroundVisibility()
local getFFlagAppChatInExperienceTabBarAdjustment = require(AppChat.Flags.getFFlagAppChatInExperienceTabBarAdjustment)
local EnumScreens = require(AppChat.EnumScreens)

local ChatSessionRefCount = require(AppChat.Hooks.ChatSessionRefCount)

local InExperienceAppChatModal = {}
InExperienceAppChatModal.__index = InExperienceAppChatModal

local function getRootedNavigationStore() -- 2 equivalent calls inferred from this helper
	local GetRootedNavigationStore = require(AppChat.Stores.GetRootedNavigationStore)
	return GetRootedNavigationStore(false)
end

local function isSupportedRootedRoute(p): boolean -- 1 equivalent call inferred from this helper
	local params = p.params
	local conversationId

	if params then
		conversationId = params.conversationId
	end

	return p.screen == EnumScreens.ChatDetails
		and params ~= nil
		and params.rooted == true
		and type(conversationId) == "string"
		and conversationId ~= ""
end

function InExperienceAppChatModal._new()
	local v = {
		_visible = false,
		_wasVisible = false,
		visibilitySignal = Instance.new("BindableEvent"),
		unreadCount = 0,
		unreadCountSignal = Instance.new("BindableEvent"),
		hasReceivedInitialUnreadCount = false,
		initialUnreadCountSignal = Instance.new("BindableEvent"),
		currentSquadId = "",
		currentSquadIdSignal = Instance.new("BindableEvent"),
		requestedRoute = nil,
		requestedRouteSignal = Instance.new("BindableEvent"),
		_reserveChatSessionOnClose = false,
		topMargin = 12
	}

	setmetatable(v, InExperienceAppChatModal)
	return v
end

function InExperienceAppChatModal:initialize(topMargin: number?, settingsHub, viewportUtil, chatSelector, playerListManager)
	if topMargin then
		self.topMargin = topMargin
	end

	self.settingsHub = settingsHub
	self._foundationTokens = Tokens.getFoundationTokensDefaultScale(ColorMode.Dark)

	if getFFlagAppChatInExperienceTabBarAdjustment() then
		self.viewportUtil = viewportUtil
	end

	self.chatSelector = chatSelector
	self.playerListManager = playerListManager
end

function InExperienceAppChatModal:setVisible(visible: boolean, p: string?)
	if not visible then
		getRootedNavigationStore().cancelNavigation() -- inferred equivalent call
	end

	if visible == self._visible then
		return
	end

	if not visible and self._reserveChatSessionOnClose then
		self._reserveChatSessionOnClose = false

		if ChatSessionRefCount.getReservations() == 0 then
			ChatSessionRefCount.reserve()
		end
	end

	self._visible = visible
	self.visibilitySignal:Fire(visible, p)

	if visible then
		if self.chatSelector then
			self.chatSelector:HideTemp("AppChat", true)
		end

		if self.playerListManager then
			self.playerListManager:HideTemp("AppChat", true)
		end

		local inExperienceAppChatModal = Instance.new("ScreenGui")
		inExperienceAppChatModal.DisplayOrder = game:DefineFastInt(
			"AppChatInExperienceStandaloneContainerDisplayOrder",
			4
		)
		inExperienceAppChatModal.Parent = CoreGui
		inExperienceAppChatModal.Name = "InExperienceAppChatModal"

		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, self.topMargin)
		uiPadding.PaddingRight = UDim.new(0, 12)
		uiPadding.PaddingBottom = UDim.new(0, 0)
		uiPadding.PaddingLeft = UDim.new(0, 12)
		uiPadding.Parent = inExperienceAppChatModal

		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.Parent = inExperienceAppChatModal

		local imageButton = Instance.new("ImageButton")
		imageButton.BorderSizePixel = 0
		imageButton.AutoButtonColor = false
		imageButton.Modal = true
		imageButton.BackgroundTransparency = self._foundationTokens.Color.OverMedia.OverMedia_0.Transparency
		imageButton.BackgroundColor3 = self._foundationTokens.Color.OverMedia.OverMedia_0.Color3
		imageButton.Size = UDim2.fromScale(1, 1)
		imageButton.Visible = true
		imageButton.Parent = inExperienceAppChatModal

		if getFFlagAppChatInExperienceTabBarAdjustment() and self.viewportUtil then
			local function fn()
				local v = self.viewportUtil.screenSize:get()

				if not (v and v.X and v.Y) then
					return
				end

				if v.Y > v.X then
					uiPadding.PaddingBottom = UDim.new(0, 0)
				else
					uiPadding.PaddingBottom = UDim.new(0, GuiService:GetSafeZoneOffsets().bottom)
				end
			end

			self.viewportUtil.screenSize:connect(fn)

			fn()
		end

		local uiSizeConstraint = Instance.new("UISizeConstraint")
		uiSizeConstraint.MaxSize = Vector2.new(850, 780)
		uiSizeConstraint.Parent = imageButton

		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 8)
		uiCorner.Parent = imageButton

		self.frame = imageButton
	else
		if self.frame and self.frame.Parent then
			self.frame.Parent:Destroy()
			self.frame = nil
		end

		if self.chatSelector then
			self.chatSelector:HideTemp("AppChat", false)
		end

		if self.playerListManager then
			self.playerListManager:HideTemp("AppChat", false)
		end
	end

	if self.settingsHub and fFlagSettingsHubIndependentBackgroundVisibility then
		self.settingsHub:SetBackgroundVisibility(visible, false)
	end
end

function InExperienceAppChatModal.toggleVisibility(p)
	if p.default then
		local v = not p.default._visible
		p.default:setVisible(v)
	end
end

function InExperienceAppChatModal.getVisible(p)
	return p.default._visible
end

function InExperienceAppChatModal.setUnreadCount(p, unreadCount: number)
	p.default.unreadCount = unreadCount
	p.default.unreadCountSignal:Fire(unreadCount)
end

function InExperienceAppChatModal.markInitialUnreadCountReceived(p, p2: number)
	if p.default.hasReceivedInitialUnreadCount then
		return
	end

	p.default.hasReceivedInitialUnreadCount = true
	p.default.initialUnreadCountSignal:Fire(p2)
end

function InExperienceAppChatModal.setCurrentSquadId(p, currentSquadId: string)
	p.default.currentSquadId = currentSquadId
	p.default.currentSquadIdSignal:Fire(currentSquadId)
end

function InExperienceAppChatModal:reserveChatSessionOnClose()
	self._reserveChatSessionOnClose = true
end

function InExperienceAppChatModal:openToScreen(p)
	local rootedNavigationStore = getRootedNavigationStore() -- inferred equivalent call
	local supportedRootedRoute = isSupportedRootedRoute(p) -- inferred equivalent call
	local requestedRoute

	if supportedRootedRoute then
		local clone = table.clone(p.params)
		clone.rootedNavigationRequestId = rootedNavigationStore.beginNavigation()
		requestedRoute = { screen = p.screen, params = clone }
	else
		rootedNavigationStore.cancelNavigation()
		requestedRoute = p
	end

	self.requestedRoute = requestedRoute
	self.requestedRouteSignal:Fire(requestedRoute)

	if p.params and p.params.rooted == true then
		self:reserveChatSessionOnClose()
	end

	local v

	if requestedRoute.params then
		v = requestedRoute.params.entryPoint
	end

	self:setVisible(true, v)
end

function InExperienceAppChatModal:clearRequestedRoute()
	self.requestedRoute = nil
	self.requestedRouteSignal:Fire(nil)
end

InExperienceAppChatModal.default = InExperienceAppChatModal._new()

return InExperienceAppChatModal
