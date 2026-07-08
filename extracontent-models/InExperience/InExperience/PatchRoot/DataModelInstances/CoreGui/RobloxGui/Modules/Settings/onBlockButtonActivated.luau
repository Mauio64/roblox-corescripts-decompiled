local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local BlockingAnalytics = require(script.Parent.Analytics.BlockingAnalytics)
local BlockingModalScreen = require(script.Parent.Components.Blocking.BlockingModalScreen)
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local u13 = nil

return function(p1, p2, p3, p4) -- line: 32
	-- upvalues: Promise (copy), BlockingAnalytics (copy), u13 (ref), Roact (copy), ContextActionService (copy), FFlagAddNewPlayerListMobileFocusNav (copy), GuiService (copy), BlockingModalScreen (copy), CoreScriptsRootProvider (copy), RobloxGui (copy)
	return Promise.new(function(resolve) -- line: 33
		-- upvalues: p2 (copy), BlockingAnalytics (copy), p1 (copy), p3 (copy), u13 (ref), Roact (copy), ContextActionService (copy), FFlagAddNewPlayerListMobileFocusNav (copy), p4 (copy), GuiService (copy), BlockingModalScreen (copy), CoreScriptsRootProvider (copy), RobloxGui (copy)
		local v19 = p2 or BlockingAnalytics.new()

		v19:action("SettingsHub", "blockUserButtonClick", {
			blockeeUserId = p1.UserId,
			source = p3
		})

		if u13 ~= nil then
			Roact.unmount(u13)
			u13 = nil
			ContextActionService:UnbindCoreAction("BlockingModalScreen")
		end

		local function v20() -- line: 42
			-- upvalues: u13 (ref), Roact (copy), ContextActionService (copy), resolve (copy), FFlagAddNewPlayerListMobileFocusNav (copy), p4 (copy), GuiService (copy)
			if u13 ~= nil then
				Roact.unmount(u13)
				u13 = nil
				ContextActionService:UnbindCoreAction("BlockingModalScreen")
			end

			resolve()

			if FFlagAddNewPlayerListMobileFocusNav then
				if p4 and p4.onBlockingModalClose then
					p4.onBlockingModalClose()

					return
				end
			elseif FFlagAddNewPlayerListMobileFocusNav then
				GuiService.SelectedCoreObject = nil
			end
		end

		local v21 = Roact.createElement(BlockingModalScreen, {
			player = p1,
			closeModal = v20,
			analytics = v19,
			source = p3,
			onBlockingSuccess = p4 and p4.onBlockingSuccess or nil
		})
		local v22 = Roact.createElement(CoreScriptsRootProvider, {}, {
			BlockingModalScreen = v21
		})

		u13 = Roact.mount(v22, RobloxGui, "BlockingContainer")
		ContextActionService:BindCoreAction("BlockingModalScreen", v20, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
	end)
end
