local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

local BlockingAnalytics = require(script.Parent.Analytics.BlockingAnalytics)
local BlockingModalScreen = require(script.Parent.Components.Blocking.BlockingModalScreen)

local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

local v = nil

local function fn() -- 2 equivalent calls inferred from this helper
	if v ~= nil then
		Roact.unmount(v)
		v = nil
		ContextActionService:UnbindCoreAction("BlockingModalScreen")
	end
end

return function(player, p, source, p2)
	return Promise.new(function(callback)
		local analytics = p or BlockingAnalytics.new()
		analytics:action("SettingsHub", "blockUserButtonClick", {
			blockeeUserId = player.UserId,
			source = source
		})
		fn() -- inferred equivalent call

		local function fn2()
			fn() -- inferred equivalent call
			callback()

			if FFlagAddNewPlayerListMobileFocusNav then
				if p2 and p2.onBlockingModalClose then
					p2.onBlockingModalClose()
				end
			elseif FFlagAddNewPlayerListMobileFocusNav then
				GuiService.SelectedCoreObject = nil
			end
		end

		local element = Roact.createElement(BlockingModalScreen, {
			player = player,
			closeModal = fn2,
			analytics = analytics,
			source = source,
			onBlockingSuccess = p2 and p2.onBlockingSuccess or nil
		})

		local element2 = Roact.createElement(CoreScriptsRootProvider, {}, {
			BlockingModalScreen = element
		})

		v = Roact.mount(element2, RobloxGui, "BlockingContainer")
		ContextActionService:BindCoreAction(
			"BlockingModalScreen",
			fn2,
			false,
			Enum.KeyCode.ButtonB,
			Enum.KeyCode.Escape
		)
	end)
end
