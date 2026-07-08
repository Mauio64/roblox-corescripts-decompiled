local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Promise = InGameMenuDependencies.Promise

require(CorePackages.Packages.Dash)

local t = InGameMenuDependencies.t
local InGameMenu = RobloxGui.Modules.InGameMenu
local Constants = require(InGameMenu.Resources.Constants)
local FullscreenTitleBar = UIBlox.App.Bar.FullscreenTitleBar
local ExternalEventConnection = require(InGameMenu.Utility.ExternalEventConnection)
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local GetFIntFullscreenTitleBarTriggerDelayMillis = require(InGameMenu.Flags.GetFIntFullscreenTitleBarTriggerDelayMillis)
local v19 = Roact.PureComponent:extend("SettingsFullScreenTitleBar")

v19.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	onClose = t.optional(t.callback),
	_mockFullScreen = t.optional(t.boolean)
})
v19.defaultProps = {
	titleText = "Roblox"
}

function v19.init(p1) -- line: 44
	p1:setState({
		isTriggered = false
	})

	function p1.show() -- line: 49
		-- upvalues: p1 (copy)
		p1:setTriggered(true)
	end
	function p1.hide() -- line: 52
		-- upvalues: p1 (copy)
		p1:setTriggered(false)
	end
	function p1.cancel() -- line: 55
		-- upvalues: p1 (copy)
		p1:unsetTriggered()
	end
	function p1.onFullscreenChanged() -- line: 58
		-- upvalues: p1 (copy)
		p1:unsetTriggered()
		p1:setState({
			isTriggered = false
		})
	end
end
function v19.setTriggered(p2, p3) -- line: 66
	-- upvalues: UserGameSettings (copy), Promise (copy), GetFIntFullscreenTitleBarTriggerDelayMillis (copy)
	p2:unsetTriggered()

	if UserGameSettings:InFullScreen() or p2.props._mockFullScreen then
		p2.triggerPromise = Promise.delay(GetFIntFullscreenTitleBarTriggerDelayMillis() / 1000):andThenCall(function() -- line: 69
			-- upvalues: p2 (copy), p3 (copy)
			p2.triggerPromise = nil
			p2:setState({
				isTriggered = p3
			})
		end)
	end
end
function v19.unsetTriggered(p4) -- line: 78
	if p4.triggerPromise then
		p4.triggerPromise:cancel()
		p4.triggerPromise = nil
	end
end
function v19.toggleFullscreen(_) -- line: 85
	-- upvalues: GuiService (copy)
	GuiService:ToggleFullscreen()
end
function v19.leaveGame(_) -- line: 89
	-- upvalues: GuiService (copy), RunService (copy), GetDefaultQualityLevel (copy)
	GuiService.SelectedCoreObject = nil
	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()
	game:Shutdown()
	settings().Rendering.QualityLevel = GetDefaultQualityLevel()
end
function v19.render(p7) -- line: 103
	-- upvalues: Roact (copy), CoreGui (copy), Constants (copy), ExternalEventConnection (copy), UserGameSettings (copy), FullscreenTitleBar (copy), renderWithCoreScriptsStyleProvider (copy)
	local v27 = Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		InGameFullscreenTitleBarScreen = Roact.createElement("ScreenGui", {
			Enabled = true,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = Constants.DisplayOrder.FullscreenTitleBar
		}, {
			FullscreenChangedEvent = Roact.createElement(ExternalEventConnection, {
				event = UserGameSettings.FullscreenChanged,
				callback = p7.onFullscreenChanged
			}),
			TriggerArea = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				[Roact.Event.MouseEnter] = p7.show,
				[Roact.Event.MouseLeave] = p7.cancel
			}),
			Bar = Roact.createElement(FullscreenTitleBar, {
				title = p7.props.titleText,
				isTriggered = p7.state.isTriggered,
				onDisappear = p7.hide,
				onHover = p7.cancel,
				exitFullscreen = p7.toggleFullscreen,
				closeRoblox = p7.props.onClose or p7.leaveGame
			})
		})
	})

	return renderWithCoreScriptsStyleProvider({
		FullscreenTitleBar = v27
	})
end
function v19.willUnmount(p8) -- line: 139
	p8:unsetTriggered()
end

return {
	mount = function(p9, p10, s1: string?) -- line: 144
		-- upvalues: Roact (copy), v19 (copy)
		return Roact.mount(Roact.createElement(v19, p9 or {}), p10, s1)
	end,
	update = function(p11, p12) -- line: 147
		-- upvalues: Roact (copy), v19 (copy)
		return Roact.update(p11, Roact.createElement(v19, p12))
	end,
	unmount = function(p13) -- line: 150
		-- upvalues: Roact (copy)
		return Roact.unmount(p13)
	end
}
