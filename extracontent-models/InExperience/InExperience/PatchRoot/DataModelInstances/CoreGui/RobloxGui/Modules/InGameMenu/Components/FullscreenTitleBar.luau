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
local FullscreenTitleBar = UIBlox.App.Bar.FullscreenTitleBar
local ParentParent = script.Parent.Parent
local InGameMenuPolicy = require(ParentParent.InGameMenuPolicy)
local OpenEducationalPopup = require(ParentParent.Thunks.OpenEducationalPopup)
local StartLeavingGame = require(ParentParent.Actions.StartLeavingGame)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local UserLocalStore = require(ParentParent.Utility.UserLocalStore)
local GetFIntFullscreenTitleBarTriggerDelayMillis = require(ParentParent.Flags.GetFIntFullscreenTitleBarTriggerDelayMillis)
local GetFFlagFullscreenTitleBarInjectGameServices = require(ParentParent.Flags.GetFFlagFullscreenTitleBarInjectGameServices)
local GetFFlagFixFullscreenTitleBarPromiseCancel = require(ParentParent.Flags.GetFFlagFixFullscreenTitleBarPromiseCancel)
local v22 = Roact.PureComponent:extend("FullscreenTitleBar")

v22.validateProps = t.strictInterface({
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
v22.defaultProps = {
	titleText = "Roblox",
	userGameSettings = UserGameSettings,
	guiService = GuiService,
	appStorageService = AppStorageService
}

function v22.init(p1) -- line: 55
	-- upvalues: GetFFlagFullscreenTitleBarInjectGameServices (copy), UserGameSettings (copy), GuiService (copy), AppStorageService (copy), GetFIntFullscreenTitleBarTriggerDelayMillis (copy), Promise (copy), UserLocalStore (copy), GetFFlagFixFullscreenTitleBarPromiseCancel (copy)
	p1.userGameSettings = GetFFlagFullscreenTitleBarInjectGameServices() and p1.props.userGameSettings or UserGameSettings
	p1.guiService = GetFFlagFullscreenTitleBarInjectGameServices() and p1.props.guiService or GuiService
	p1.appStorageService = GetFFlagFullscreenTitleBarInjectGameServices() and p1.props.appStorageService or AppStorageService
	p1:setState({
		isTriggered = false,
		fullscreenEnabled = p1.userGameSettings:InFullScreen()
	})

	function p1.onFullscreenChanged(p2) -- line: 67
		-- upvalues: p1 (copy)
		p1:setState({
			isTriggered = false,
			fullscreenEnabled = p2
		})
	end
	function p1.triggerTitleBar() -- line: 74
		-- upvalues: GetFIntFullscreenTitleBarTriggerDelayMillis (copy), p1 (copy), Promise (copy)
		local v35 = GetFIntFullscreenTitleBarTriggerDelayMillis() / 1000

		if v35 > 0 then
			p1.triggerTitleBarPromise = Promise.delay(v35):andThenCall(function() -- line: 77
				-- upvalues: p1 (copy)
				p1.triggerTitleBarPromise = nil

				if not p1.state.isTriggered then
					p1:setState({
						isTriggered = true
					})
				end
			end)

			return
		end

		if not p1.state.isTriggered then
			p1:setState({
				isTriggered = true
			})
		end
	end
	function p1.cancelTriggerTitleBar() -- line: 94
		-- upvalues: p1 (copy)
		if p1.triggerTitleBarPromise then
			p1.triggerTitleBarPromise:cancel()
			p1.triggerTitleBarPromise = nil
		end
	end
	function p1.hideTitleBar() -- line: 101
		-- upvalues: p1 (copy)
		if p1.state.isTriggered then
			p1:setState({
				isTriggered = false
			})
		end
	end
	function p1.exitFullscreen() -- line: 109
		-- upvalues: p1 (copy)
		p1.hideTitleBar()
		p1.guiService:ToggleFullscreen()
	end
	function p1.closeRoblox() -- line: 114
		-- upvalues: p1 (copy), UserLocalStore (copy)
		p1.hideTitleBar()

		if p1.props.isEducationalPopupEnabled then
			local v36 = UserLocalStore.new()

			p1.props.openEducationalPopup(p1.guiService, v36, p1.props.maxDisplayCount)

			return
		end

		p1.props.startLeavingGame()
	end
	function p1.onDisappear() -- line: 125
		-- upvalues: p1 (copy), GetFFlagFixFullscreenTitleBarPromiseCancel (copy), Promise (copy)
		if p1.hideTitleBarPromise then
			if GetFFlagFixFullscreenTitleBarPromiseCancel() then
				p1.hideTitleBarPromise:cancel()
			else
				p1.hideTitleBarPromise.cancel()
			end

			p1.hideTitleBarPromise = nil
		end

		p1.hideTitleBarPromise = Promise.delay(0.5):andThenCall(function() -- line: 135
			-- upvalues: p1 (copy)
			p1.hideTitleBarPromise = nil
			p1.hideTitleBar()
		end)
	end
	function p1.mouseReenter() -- line: 141
		-- upvalues: p1 (copy)
		if p1.state.isTriggered and p1.hideTitleBarPromise then
			p1.hideTitleBarPromise:cancel()
			p1.hideTitleBarPromise = nil
		end
	end
end
function v22.render(p3) -- line: 149
	-- upvalues: Roact (copy), ExternalEventConnection (copy), CoreGui (copy), FullscreenTitleBar (copy)
	return Roact.createFragment({
		FullscreenChangedEvent = Roact.createElement(ExternalEventConnection, {
			event = p3.userGameSettings.FullscreenChanged,
			callback = p3.onFullscreenChanged
		}),
		FullscreenTitleBar = Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			InGameFullscreenTitleBarScreen = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				Enabled = p3.state.fullscreenEnabled,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = p3.props.displayOrder
			}, {
				TriggerArea = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					[Roact.Event.MouseEnter] = p3.triggerTitleBar,
					[Roact.Event.MouseLeave] = p3.cancelTriggerTitleBar
				}),
				Bar = Roact.createElement(FullscreenTitleBar, {
					title = p3.props.titleText,
					isTriggered = p3.state.isTriggered,
					onDisappear = p3.onDisappear,
					onHover = p3.mouseReenter,
					exitFullscreen = p3.exitFullscreen,
					closeRoblox = p3.closeRoblox
				})
			})
		})
	})
end
function v22.didUpdate(p4, p5) -- line: 184
	if not p5.isMenuOpen and p4.props.isMenuOpen then
		p4.hideTitleBar()
	end
end
function v22.willUnmount(p6) -- line: 190
	if p6.hideTitleBarPromise then
		p6.hideTitleBarPromise:cancel()
	end

	if p6.triggerTitleBarPromise then
		p6.triggerTitleBarPromise:cancel()
	end
end

local v23 = InGameMenuPolicy.connect(function(p7, _) -- line: 200
	return {
		isEducationalPopupEnabled = p7.enableEducationalPopup(),
		maxDisplayCount = p7.educationalPopupMaxDisplayCount()
	}
end)(v22)

return RoactRodux.UNSTABLE_connect2(function(p9, _) -- line: 207
	return {
		isMenuOpen = p9.isMenuOpen
	}
end, function(p11) -- line: 211
	-- upvalues: OpenEducationalPopup (copy), StartLeavingGame (copy)
	return {
		openEducationalPopup = function(p12, p13, p14) -- line: 213
			-- upvalues: p11 (copy), OpenEducationalPopup (copy)
			return p11(OpenEducationalPopup(p12, p13, p14))
		end,
		startLeavingGame = function() -- line: 216
			-- upvalues: p11 (copy), StartLeavingGame (copy)
			p11(StartLeavingGame())
		end
	}
end)(v23)
