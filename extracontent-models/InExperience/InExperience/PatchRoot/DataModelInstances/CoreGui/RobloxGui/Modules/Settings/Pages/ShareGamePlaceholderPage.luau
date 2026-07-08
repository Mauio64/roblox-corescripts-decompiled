local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local ClearShareInviteLink = require(CorePackages.Workspace.Packages.NotificationsCommon).ReducerDependencies.ShareLinksRodux.Actions.ClearShareInviteLink
local OpenPage = require(ShareGame.Actions.OpenPage)
local ClosePage = require(ShareGame.Actions.ClosePage)
local v8 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls
local v10 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

v10.TabHeader = nil
v10.PageListLayout.Parent = nil
v10.ShouldShowBottomBar = false
v10.ShouldShowHubBar = false
v10.IsPageClipped = false
v10.Page.Name = "ShareGameDummy"
v10.Page.Size = UDim2.new(1, 0, 0, 0)

function v10.ConnectHubToApp(_, p2, p3) -- line: 37
	-- upvalues: v10 (copy), Constants (copy), OpenPage (copy), FFlagEnableConsoleExpControls (copy), v8 (copy), RobloxGui (copy), ClosePage (copy)
	v10:SetHub(p2)
	p3.store.changed:connect(function(p4, p5) -- line: 40
		-- upvalues: Constants (copy), v10 (copy)
		local Page = p4.Page
		local IsOpen = p5.Page.IsOpen

		if Page.Route == Constants.PageRoute.SHARE_GAME and (IsOpen and not Page.IsOpen) then
			v10.HubRef:PopMenu(nil, true)
		end
	end)
	v10.Displayed.Event:Connect(function() -- line: 52
		-- upvalues: p3 (copy), OpenPage (copy), Constants (copy), FFlagEnableConsoleExpControls (copy), v8 (copy), RobloxGui (copy)
		if not p3.store:getState().Page.IsOpen then
			p3.store:dispatch(OpenPage(Constants.PageRoute.SETTINGS_HUB))

			if FFlagEnableConsoleExpControls and v8 then
				require(RobloxGui.Modules.Chrome.Service):setHideShortcutBar("ShareGamePlaceholderPage", true)
			end
		end
	end)
	v10.Hidden.Event:Connect(function() -- line: 64
		-- upvalues: p3 (copy), ClosePage (copy), Constants (copy), FFlagEnableConsoleExpControls (copy), v8 (copy), RobloxGui (copy)
		if p3.store:getState().Page.IsOpen then
			p3.store:dispatch(ClosePage(Constants.PageRoute.SETTINGS_HUB))

			if FFlagEnableConsoleExpControls and v8 then
				require(RobloxGui.Modules.Chrome.Service):setHideShortcutBar("ShareGamePlaceholderPage", false)
			end
		end
	end)
	p3.store:dispatch(ClosePage(Constants.PageRoute.SETTINGS_HUB))
end
function v10.ClearShareInviteLink(_, p7) -- line: 81
	-- upvalues: ClearShareInviteLink (copy)
	if p7.store:getState().ShareLinks.Invites.ShareInviteLink ~= nil then
		p7.store:dispatch(ClearShareInviteLink())
	end
end

return v10
