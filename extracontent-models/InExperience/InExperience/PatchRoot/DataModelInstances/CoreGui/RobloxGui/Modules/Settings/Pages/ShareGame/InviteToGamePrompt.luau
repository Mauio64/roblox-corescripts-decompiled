local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)

local Modules = RobloxGui.Modules
local Settings = Modules.Settings
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteEvents = GameInvite.GameInviteEvents

local ShareGame = Settings.Pages.ShareGame
local FullModalShareGameComponent = require(ShareGame.Components.FullModalShareGameComponent)
local AppReducer = require(ShareGame.AppReducer)

local renderWithCoreScriptsStyleProvider = require(Modules.Common.renderWithCoreScriptsStyleProvider)

local InviteStore = require(ShareGame.InviteStore)
local GetFFlagEnableSharedInviteStore = require(Modules.Flags.GetFFlagEnableSharedInviteStore)

local GetFFlagAbuseReportAnalyticsHasLaunchData = require(Modules.Settings.Flags.GetFFlagAbuseReportAnalyticsHasLaunchData)

local InviteToGamePrompt = {}
InviteToGamePrompt.__index = InviteToGamePrompt

function InviteToGamePrompt.new(mountTarget)
	local v = { mountTarget = mountTarget, isActive = false }

	setmetatable(v, InviteToGamePrompt)

	return v
end

function InviteToGamePrompt:withSocialServiceAndLocalPlayer(socialService, localPlayer)
	self.socialService = socialService
	self.localPlayer = localPlayer
	return self
end

function InviteToGamePrompt:withAnalytics(analytics)
	self.analytics = analytics
	return self
end

function InviteToGamePrompt:withRequestImpl(requestImpl)
	self.requestImpl = requestImpl
	return self
end

function InviteToGamePrompt:_createTree(isVisible: boolean, props)
	local store

	if GetFFlagEnableSharedInviteStore() then
		store = InviteStore
	else
		store = Rodux.Store.new(AppReducer, nil, { Rodux.thunkMiddleware })
	end

	return renderWithCoreScriptsStyleProvider({
		FullModalShareGame = Roact.createElement(FullModalShareGameComponent, {
			store = store,
			isVisible = isVisible,
			analytics = self.analytics,
			promptMessage = props and props.promptMessage,
			inviteUserId = props and props.inviteUserId,
			inviteMessageId = props and props.inviteMessageId,
			launchData = props and props.launchData,
			isLoading = props and props.isLoading,
			requestImpl = self.requestImpl,
			onAfterClosePage = function(_)
				self:hide({})
			end
		})
	})
end

function InviteToGamePrompt:show(data)
	if self.isActive then
		return
	end

	self.isLoading = data and data.isLoading
	self.isActive = not self.isLoading

	if data then
		local v

		if data.inviteUserId then
			v = Constants.Triggers.DeveloperSingle
		else
			v = Constants.Triggers.DeveloperMultiple
		end

		local isLaunchDataProvided = data.launchData ~= nil and data.launchData ~= ""
		self.analytics:sendEvent(
			v,
			GameInviteEvents.ModalOpened,
			GetFFlagAbuseReportAnalyticsHasLaunchData() and {
				isLaunchDataProvided = isLaunchDataProvided
			} or nil
		)
	end

	if self.instance then
		self.instance = Roact.update(self.instance, self:_createTree(true, data))
	else
		self.instance = Roact.mount(self:_createTree(true, data), self.mountTarget, "invitePrompt")
	end

	if self.analytics and not self.isLoading then
		self.analytics:inputShareGameEntryPoint()
	end

	ContextActionService:BindCoreAction("hideInvitePrompt", function(_, p, _)
		if p == Enum.UserInputState.Begin then
			self:hide()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)
end

function InviteToGamePrompt:hide(_)
	if not (self.isActive or self.isLoading) then
		return
	end

	self.isLoading = false
	self.isActive = false

	self.instance = Roact.update(self.instance, self:_createTree(false))

	if self.socialService and self.localPlayer then
		self.socialService:InvokeGameInvitePromptClosed(self.localPlayer, {})
	end

	ContextActionService:UnbindCoreAction("hideInvitePrompt")
	GuiService.SelectedCoreObject = nil
	GuiService:RemoveSelectionGroup("invitePrompt")
end

function InviteToGamePrompt.destruct(p)
	if p.instance then
		Roact.unmount(p.instance)
	end
end

return InviteToGamePrompt
