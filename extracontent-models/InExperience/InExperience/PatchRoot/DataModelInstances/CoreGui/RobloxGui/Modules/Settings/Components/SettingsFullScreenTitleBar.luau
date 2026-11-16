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

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib.GetDefaultQualityLevel

local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)

local GetFIntFullscreenTitleBarTriggerDelayMillis = require(InGameMenu.Flags.GetFIntFullscreenTitleBarTriggerDelayMillis)

local extended = Roact.PureComponent:extend("SettingsFullScreenTitleBar")

extended.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	onClose = t.optional(t.callback),
	_mockFullScreen = t.optional(t.boolean)
})

extended.defaultProps = { titleText = "Roblox" }

function extended:init()
	self:setState({ isTriggered = false })

	function self.show()
		self:setTriggered(true)
	end
	function self.hide()
		self:setTriggered(false)
	end
	function self.cancel()
		self:unsetTriggered()
	end
	function self.onFullscreenChanged()
		self:unsetTriggered()
		self:setState({ isTriggered = false })
	end
end

function extended:setTriggered(isTriggered)
	self:unsetTriggered()

	if UserGameSettings:InFullScreen() or self.props._mockFullScreen then
		self.triggerPromise = Promise.delay(GetFIntFullscreenTitleBarTriggerDelayMillis() / 1000):andThenCall(function()
			self.triggerPromise = nil
			self:setState({ isTriggered = isTriggered })
		end)
	end
end

function extended:unsetTriggered()
	if self.triggerPromise then
		self.triggerPromise:cancel()
		self.triggerPromise = nil
	end
end

function extended.toggleFullscreen(_)
	GuiService:ToggleFullscreen()
end

function extended.leaveGame(_)
	GuiService.SelectedCoreObject = nil

	RunService.RenderStepped:Wait()
	RunService.RenderStepped:Wait()

	game:Shutdown()

	local settings = settings()
	settings.Rendering.QualityLevel = GetDefaultQualityLevel()
end

function extended.render(props)
	return renderWithCoreScriptsStyleProvider({
		FullscreenTitleBar = Roact.createElement(Roact.Portal, { target = CoreGui }, {
			InGameFullscreenTitleBarScreen = Roact.createElement(
				"ScreenGui",
				{
					Enabled = true,
					IgnoreGuiInset = true,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = Constants.DisplayOrder.FullscreenTitleBar
				},
				{
					FullscreenChangedEvent = Roact.createElement(ExternalEventConnection, {
						event = UserGameSettings.FullscreenChanged,
						callback = props.onFullscreenChanged
					}),
					TriggerArea = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
						[Roact.Event.MouseEnter] = props.show,
						[Roact.Event.MouseLeave] = props.cancel
					}),
					Bar = Roact.createElement(FullscreenTitleBar, {
						title = props.props.titleText,
						isTriggered = props.state.isTriggered,
						onDisappear = props.hide,
						onHover = props.cancel,
						exitFullscreen = props.toggleFullscreen,
						closeRoblox = props.props.onClose or props.leaveGame
					})
				}
			)
		})
	})
end

function extended:willUnmount()
	self:unsetTriggered()
end

local SettingsFullScreenTitleBar = {}

function SettingsFullScreenTitleBar.mount(options, p, p2: string?)
	return Roact.mount(Roact.createElement(extended, options or {}), p, p2)
end

function SettingsFullScreenTitleBar.update(p, p2)
	return Roact.update(p, Roact.createElement(extended, p2))
end

function SettingsFullScreenTitleBar.unmount(p)
	return Roact.unmount(p)
end

return SettingsFullScreenTitleBar
