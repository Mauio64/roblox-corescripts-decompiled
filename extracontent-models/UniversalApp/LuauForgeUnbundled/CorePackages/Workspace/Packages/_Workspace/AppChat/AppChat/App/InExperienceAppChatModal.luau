local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local tokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.Style.Tokens
local colorMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Enums.ColorMode

local fFlagSettingsHubIndependentBackgroundVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").getFFlagSettingsHubIndependentBackgroundVisibility()
local getFFlagAppChatInExperienceTabBarAdjustment = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatInExperienceTabBarAdjustment")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local ChatSessionRefCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/ChatSessionRefCount")

local class = {}
class.__index = class

local function getRootedNavigationStore()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetRootedNavigationStore")(false)
end

local function isSupportedRootedRoute(p2): boolean
	local params = p2.params
	local conversationId = if params then params.conversationId else nil
	return p2.screen == EnumScreens.ChatDetails
		and params ~= nil
		and params.rooted == true
		and type(conversationId) == "string"
		and conversationId ~= ""
end

function class._new()
	local v5 = {
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

	setmetatable(v5, class)
	return v5
end

function class:initialize(topMargin, settingsHub, viewportUtil, chatSelector, playerListManager)
	if topMargin then
		self.topMargin = topMargin
	end

	self.settingsHub = settingsHub
	self._foundationTokens = tokens.getFoundationTokensDefaultScale(colorMode.Dark)

	if getFFlagAppChatInExperienceTabBarAdjustment() then
		self.viewportUtil = viewportUtil
	end

	self.chatSelector = chatSelector
	self.playerListManager = playerListManager
end

function class:setVisible(visible, p2)
	if not visible then
		require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetRootedNavigationStore")(false).cancelNavigation()
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
	self.visibilitySignal:Fire(visible, p2)

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
				local v5 = self.viewportUtil.screenSize:get()

				if not (v5 and v5.X and v5.Y) then
					return
				end

				if v5.Y > v5.X then
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

function class.toggleVisibility(p2)
	if p2.default then
		local v5 = not p2.default._visible
		p2.default:setVisible(v5)
	end
end

function class:getVisible()
	return self.default._visible
end

function class.setUnreadCount(p2, unreadCount)
	p2.default.unreadCount = unreadCount
	p2.default.unreadCountSignal:Fire(unreadCount)
end

function class:markInitialUnreadCountReceived(p3)
	if self.default.hasReceivedInitialUnreadCount then
		return
	end

	self.default.hasReceivedInitialUnreadCount = true
	self.default.initialUnreadCountSignal:Fire(p3)
end

function class.setCurrentSquadId(p2, currentSquadId)
	p2.default.currentSquadId = currentSquadId
	p2.default.currentSquadIdSignal:Fire(currentSquadId)
end

function class:reserveChatSessionOnClose()
	self._reserveChatSessionOnClose = true
end

function class:openToScreen(p2)
	local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetRootedNavigationStore")(false)

	local params = p2.params
	local conversationId = if params then params.conversationId else nil
	local v6

	if
		p2.screen == EnumScreens.ChatDetails
		and params ~= nil
		and params.rooted == true
		and type(conversationId) == "string"
	then
		v6 = conversationId ~= ""
	else
		v6 = false
	end

	local v7

	if v6 then
		local clone = table.clone(p2.params)
		clone.rootedNavigationRequestId = v5.beginNavigation()
		v7 = { screen = p2.screen, params = clone }
	else
		v5.cancelNavigation()
		v7 = p2
	end

	self.requestedRoute = v7
	self.requestedRouteSignal:Fire(v7)

	if p2.params and p2.params.rooted == true then
		self:reserveChatSessionOnClose()
	end

	local v8 = if v7.params then v7.params.entryPoint else nil
	self:setVisible(true, v8)
end

function class:clearRequestedRoute()
	self.requestedRoute = nil
	self.requestedRouteSignal:Fire(nil)
end

class.default = class._new()

return class
