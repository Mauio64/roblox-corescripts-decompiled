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
local GameInviteEvents = require(CorePackages.Workspace.Packages.GameInvite).GameInviteEvents
local ShareGame = Settings.Pages.ShareGame
local FullModalShareGameComponent = require(ShareGame.Components.FullModalShareGameComponent)
local AppReducer = require(ShareGame.AppReducer)
local renderWithCoreScriptsStyleProvider = require(Modules.Common.renderWithCoreScriptsStyleProvider)
local InviteStore = require(ShareGame.InviteStore)
local GetFFlagEnableSharedInviteStore = require(Modules.Flags.GetFFlagEnableSharedInviteStore)
local GetFFlagAbuseReportAnalyticsHasLaunchData = require(Modules.Settings.Flags.GetFFlagAbuseReportAnalyticsHasLaunchData)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 40
	-- upvalues: t1 (copy)
	local t2 = {
		isActive = false,
		mountTarget = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.withSocialServiceAndLocalPlayer(p2, p3, p4) -- line: 50
	p2.socialService = p3
	p2.localPlayer = p4

	return p2
end
function t1.withAnalytics(p5, p6) -- line: 56
	p5.analytics = p6

	return p5
end
function t1._createTree(t3: {[any]: any}, b1: boolean, t4: {[any]: any}?) -- line: 61
	-- upvalues: GetFFlagEnableSharedInviteStore (copy), InviteStore (copy), Rodux (copy), AppReducer (copy), renderWithCoreScriptsStyleProvider (copy), Roact (copy), FullModalShareGameComponent (copy)
	local v30 = if not GetFFlagEnableSharedInviteStore() then Rodux.Store.new(AppReducer, nil, { Rodux.thunkMiddleware }) else InviteStore

	return renderWithCoreScriptsStyleProvider({
		FullModalShareGame = Roact.createElement(FullModalShareGameComponent, {
			store = v30,
			isVisible = b1,
			analytics = t3.analytics,
			promptMessage = t4 and t4.promptMessage,
			inviteUserId = t4 and t4.inviteUserId,
			inviteMessageId = t4 and t4.inviteMessageId,
			launchData = t4 and t4.launchData,
			isLoading = t4 and t4.isLoading,
			onAfterClosePage = function(_) -- line: 75
				-- upvalues: t3 (copy)
				t3:hide({})
			end
		})
	})
end
function t1.show(t5: {[any]: any}, t6: {[any]: any}?) -- line: 89
	-- upvalues: Constants (copy), GameInviteEvents (copy), GetFFlagAbuseReportAnalyticsHasLaunchData (copy), Roact (copy), ContextActionService (copy)
	if t5.isActive then
		return
	end

	t5.isLoading = t6 and t6.isLoading
	t5.isActive = not t5.isLoading

	if t6 then
		local v33 = if not t6.inviteUserId then Constants.Triggers.DeveloperMultiple else Constants.Triggers.DeveloperSingle
		local v34 = t6.launchData ~= nil and t6.launchData ~= ""

		t5.analytics:sendEvent(v33, GameInviteEvents.ModalOpened, if not GetFFlagAbuseReportAnalyticsHasLaunchData() then nil else {
			isLaunchDataProvided = v34
		})
	end

	if not t5.instance then
		t5.instance = Roact.mount(t5:_createTree(true, t6), t5.mountTarget, "invitePrompt")
	else
		t5.instance = Roact.update(t5.instance, t5:_createTree(true, t6))
	end

	if t5.analytics and not t5.isLoading then
		t5.analytics:inputShareGameEntryPoint()
	end

	ContextActionService:BindCoreAction("hideInvitePrompt", function(_, p9, _) -- line: 118
		-- upvalues: t5 (copy)
		if p9 == Enum.UserInputState.Begin then
			t5:hide()
		end
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Backspace)
end
function t1.hide(p11, _) -- line: 125
	-- upvalues: Roact (copy), ContextActionService (copy), GuiService (copy)
	if not p11.isActive and not p11.isLoading then
		return
	end

	p11.isLoading = false
	p11.isActive = false
	p11.instance = Roact.update(p11.instance, p11:_createTree(false))

	if p11.socialService and p11.localPlayer then
		p11.socialService:InvokeGameInvitePromptClosed(p11.localPlayer, {})
	end

	ContextActionService:UnbindCoreAction("hideInvitePrompt")
	GuiService.SelectedCoreObject = nil
	GuiService:RemoveSelectionGroup("invitePrompt")
end
function t1.destruct(p13) -- line: 142
	-- upvalues: Roact (copy)
	if p13.instance then
		Roact.unmount(p13.instance)
	end
end

return t1
