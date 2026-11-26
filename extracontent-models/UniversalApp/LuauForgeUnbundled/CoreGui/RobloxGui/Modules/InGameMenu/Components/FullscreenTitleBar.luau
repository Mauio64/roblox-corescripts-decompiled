local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)

local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useIsInFullScreen = require("@game/CorePackages/Workspace/Packages/Responsive").useIsInFullScreen

local module = require("@luauforge/bundled/fvN")

local module2 = require("@luauforge/bundled/gIF")

local UIBlox = require(CorePackages.Packages.UIBlox)
local fullscreenTitleBar = UIBlox.App.Bar.FullscreenTitleBar

local GetFIntFullscreenTitleBarTriggerDelayMillis = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Flags/GetFIntFullscreenTitleBarTriggerDelayMillis")

local GetFFlagFixFullscreenTitleBarPromiseCancel = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Flags/GetFFlagFixFullscreenTitleBarPromiseCancel")

local extended = Roact.PureComponent:extend("FullscreenTitleBar")

extended.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	displayOrder = t.integer,
	isInFullScreen = t.boolean,
	guiService = t.optional(t.union(t.Instance, t.table))
})

extended.defaultProps = { titleText = "Roblox", displayOrder = 1 }

function extended:init()
	self:setState({ isTriggered = false })

	function self.triggerTitleBar()
		local v5 = GetFIntFullscreenTitleBarTriggerDelayMillis() / 1000

		if v5 > 0 then
			self.triggerTitleBarPromise = Promise.delay(v5):andThenCall(function()
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

			if self.state.isTriggered then
				self:setState({ isTriggered = false })
			end
		end)
	end

	function self.exitFullscreen()
		if self.state.isTriggered then
			self:setState({ isTriggered = false })
		end

		self.props.guiService:ToggleFullscreen()
	end

	function self.closeRoblox()
		self.props.guiService:BroadcastNotification("", module.NATIVE_EXIT)
	end

	function self.mouseReenter()
		if self.state.isTriggered and self.hideTitleBarPromise then
			self.hideTitleBarPromise:cancel()
			self.hideTitleBarPromise = nil
		end
	end
end

function extended.render(props)
	if not props.props.isInFullScreen then
		return nil
	end

	return Roact.createElement(Roact.Portal, { target = CoreGui }, {
		FullscreenTitleBarScreen = Roact.createElement(
			module2,
			{
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
end

function extended.willUnmount(p2)
	if p2.hideTitleBarPromise then
		p2.hideTitleBarPromise:cancel()
	end

	if p2.triggerTitleBarPromise then
		p2.triggerTitleBarPromise:cancel()
	end
end

local function FullscreenTitleBarWrapper(p2)
	local v5 = useRoactService(appGuiService)
	local v6 = useIsInFullScreen()
	local joined = Cryo.Dictionary.join(p2, { guiService = v5, isInFullScreen = v6 })

	return Roact.createElement(extended, joined)
end

return FullscreenTitleBarWrapper
