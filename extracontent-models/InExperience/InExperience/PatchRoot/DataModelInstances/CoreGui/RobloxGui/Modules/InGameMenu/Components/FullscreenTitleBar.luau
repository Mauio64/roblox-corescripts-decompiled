local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local GuiService = game:GetService("GuiService")
local AppStorageService = game:GetService("AppStorageService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Promise = InGameMenuDependencies.Promise
local fullscreenTitleBar = UIBlox.App.Bar.FullscreenTitleBar

local parent = script.Parent.Parent
local InGameMenuPolicy = require(parent.InGameMenuPolicy)

local OpenEducationalPopup = require(parent.Thunks.OpenEducationalPopup)
local StartLeavingGame = require(parent.Actions.StartLeavingGame)

local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local UserLocalStore = require(parent.Utility.UserLocalStore)

local GetFIntFullscreenTitleBarTriggerDelayMillis = require(parent.Flags.GetFIntFullscreenTitleBarTriggerDelayMillis)

local GetFFlagFullscreenTitleBarInjectGameServices = require(parent.Flags.GetFFlagFullscreenTitleBarInjectGameServices)
local GetFFlagFixFullscreenTitleBarPromiseCancel = require(parent.Flags.GetFFlagFixFullscreenTitleBarPromiseCancel)

local extended = Roact.PureComponent:extend("FullscreenTitleBar")

extended.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	displayOrder = t.integer,
	isMenuOpen = t.boolean,
	isEducationalPopupEnabled = t.boolean,
	maxDisplayCount = t.integer,
	openEducationalPopup = t.callback,
	startLeavingGame = t.callback,
	userGameSettings = t.optional(t.union(t.Instance, t.table)),
	guiService = t.optional(t.union(t.Instance, t.table)),
	appStorageService = t.optional(t.union(t.Instance, t.table))
})

extended.defaultProps = {
	titleText = "Roblox",
	userGameSettings = UserGameSettings,
	guiService = GuiService,
	appStorageService = AppStorageService
}

function extended:init()
	self.userGameSettings = GetFFlagFullscreenTitleBarInjectGameServices() and self.props.userGameSettings
		or UserGameSettings

	self.guiService = GetFFlagFullscreenTitleBarInjectGameServices() and self.props.guiService or GuiService
	self.appStorageService = GetFFlagFullscreenTitleBarInjectGameServices() and self.props.appStorageService
		or AppStorageService

	self:setState({
		isTriggered = false,
		fullscreenEnabled = self.userGameSettings:InFullScreen()
	})

	function self.onFullscreenChanged(fullscreenEnabled)
		self:setState({ fullscreenEnabled = fullscreenEnabled, isTriggered = false })
	end

	function self.triggerTitleBar()
		local v = GetFIntFullscreenTitleBarTriggerDelayMillis() / 1000

		if v > 0 then
			self.triggerTitleBarPromise = Promise.delay(v):andThenCall(function()
				self.triggerTitleBarPromise = nil

				if not self.state.isTriggered then
					self:setState({ isTriggered = true })
				end
			end)
		elseif not self.state.isTriggered then
			self:setState({ isTriggered = true })
		end
	end

	function self.cancelTriggerTitleBar()
		if self.triggerTitleBarPromise then
			self.triggerTitleBarPromise:cancel()
			self.triggerTitleBarPromise = nil
		end
	end

	function self.hideTitleBar()
		if self.state.isTriggered then
			self:setState({ isTriggered = false })
		end
	end

	function self.exitFullscreen()
		self.hideTitleBar()
		self.guiService:ToggleFullscreen()
	end

	function self.closeRoblox()
		self.hideTitleBar()

		if not self.props.isEducationalPopupEnabled then
			self.props.startLeavingGame()

			return
		end

		local v = UserLocalStore.new()
		self.props.openEducationalPopup(self.guiService, v, self.props.maxDisplayCount)
	end

	function self.onDisappear()
		if self.hideTitleBarPromise then
			if GetFFlagFixFullscreenTitleBarPromiseCancel() then
				self.hideTitleBarPromise:cancel()
			else
				self.hideTitleBarPromise.cancel()
			end

			self.hideTitleBarPromise = nil
		end

		self.hideTitleBarPromise = Promise.delay(0.5):andThenCall(function()
			self.hideTitleBarPromise = nil
			self.hideTitleBar()
		end)
	end

	function self.mouseReenter()
		if self.state.isTriggered and self.hideTitleBarPromise then
			self.hideTitleBarPromise:cancel()
			self.hideTitleBarPromise = nil
		end
	end
end

function extended.render(props)
	return Roact.createFragment({
		FullscreenChangedEvent = Roact.createElement(ExternalEventConnection, {
			event = props.userGameSettings.FullscreenChanged,
			callback = props.onFullscreenChanged
		}),
		FullscreenTitleBar = Roact.createElement(Roact.Portal, { target = CoreGui }, {
			InGameFullscreenTitleBarScreen = Roact.createElement(
				"ScreenGui",
				{
					Enabled = props.state.fullscreenEnabled,
					IgnoreGuiInset = true,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = props.props.displayOrder
				},
				{
					TriggerArea = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 1),
						[Roact.Event.MouseEnter] = props.triggerTitleBar,
						[Roact.Event.MouseLeave] = props.cancelTriggerTitleBar
					}),
					Bar = Roact.createElement(fullscreenTitleBar, {
						title = props.props.titleText,
						isTriggered = props.state.isTriggered,
						onDisappear = props.onDisappear,
						onHover = props.mouseReenter,
						exitFullscreen = props.exitFullscreen,
						closeRoblox = props.closeRoblox
					})
				}
			)
		})
	})
end

function extended.didUpdate(p, p2)
	if not p2.isMenuOpen and p.props.isMenuOpen then
		p.hideTitleBar()
	end
end

function extended.willUnmount(p)
	if p.hideTitleBarPromise then
		p.hideTitleBarPromise:cancel()
	end

	if p.triggerTitleBarPromise then
		p.triggerTitleBarPromise:cancel()
	end
end

local v = InGameMenuPolicy.connect(function(p, _)
	return {
		isEducationalPopupEnabled = p.enableEducationalPopup(),
		maxDisplayCount = p.educationalPopupMaxDisplayCount()
	}
end)(extended)

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isMenuOpen = p.isMenuOpen }
end, function(callback)
	return {
		openEducationalPopup = function(p, p2, p3)
			return callback(OpenEducationalPopup(p, p2, p3))
		end,
		startLeavingGame = function()
			callback(StartLeavingGame())
		end
	}
end)(v)
