local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local Promise = require(CorePackages.Packages.Promise)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useIsInFullScreen = require(CorePackages.Workspace.Packages.Responsive).useIsInFullScreen
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local FullscreenTitleBar = require(CorePackages.Packages.UIBlox).App.Bar.FullscreenTitleBar
local GetFIntFullscreenTitleBarTriggerDelayMillis = require(Modules.LuaApp.Flags.GetFIntFullscreenTitleBarTriggerDelayMillis)
local GetFFlagFixFullscreenTitleBarPromiseCancel = require(Modules.LuaApp.Flags.GetFFlagFixFullscreenTitleBarPromiseCancel)
local v16 = Roact.PureComponent:extend("FullscreenTitleBar")

v16.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	displayOrder = t.integer,
	isInFullScreen = t.boolean,
	guiService = t.optional(t.union(t.Instance, t.table))
})
v16.defaultProps = {
	titleText = "Roblox",
	displayOrder = 1
}

function v16.init(p1) -- line: 45
	-- upvalues: GetFIntFullscreenTitleBarTriggerDelayMillis (copy), Promise (copy), GetFFlagFixFullscreenTitleBarPromiseCancel (copy), NotificationType (copy)
	p1:setState({
		isTriggered = false
	})

	function p1.triggerTitleBar() -- line: 50
		-- upvalues: GetFIntFullscreenTitleBarTriggerDelayMillis (copy), p1 (copy), Promise (copy)
		local v25 = GetFIntFullscreenTitleBarTriggerDelayMillis() / 1000

		if v25 > 0 then
			p1.triggerTitleBarPromise = Promise.delay(v25):andThenCall(function() -- line: 53
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
	function p1.cancelTriggerTitleBar() -- line: 70
		-- upvalues: p1 (copy)
		if p1.triggerTitleBarPromise then
			p1.triggerTitleBarPromise:cancel()
			p1.triggerTitleBarPromise = nil
		end
	end
	function p1.onDisappear() -- line: 77
		-- upvalues: p1 (copy), GetFFlagFixFullscreenTitleBarPromiseCancel (copy), Promise (copy)
		if p1.hideTitleBarPromise then
			if GetFFlagFixFullscreenTitleBarPromiseCancel() then
				p1.hideTitleBarPromise:cancel()
			else
				p1.hideTitleBarPromise.cancel()
			end

			p1.hideTitleBarPromise = nil
		end

		p1.hideTitleBarPromise = Promise.delay(0.5):andThenCall(function() -- line: 87
			-- upvalues: p1 (copy)
			p1.hideTitleBarPromise = nil

			if p1.state.isTriggered then
				p1:setState({
					isTriggered = false
				})
			end
		end)
	end
	function p1.exitFullscreen() -- line: 97
		-- upvalues: p1 (copy)
		if p1.state.isTriggered then
			p1:setState({
				isTriggered = false
			})
		end

		p1.props.guiService:ToggleFullscreen()
	end
	function p1.closeRoblox() -- line: 106
		-- upvalues: p1 (copy), NotificationType (copy)
		p1.props.guiService:BroadcastNotification("", NotificationType.NATIVE_EXIT)
	end
	function p1.mouseReenter() -- line: 110
		-- upvalues: p1 (copy)
		if p1.state.isTriggered and p1.hideTitleBarPromise then
			p1.hideTitleBarPromise:cancel()
			p1.hideTitleBarPromise = nil
		end
	end
end
function v16.render(p2) -- line: 118
	-- upvalues: Roact (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), FullscreenTitleBar (copy)
	if not p2.props.isInFullScreen then
		return nil
	end

	return Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		FullscreenTitleBarScreen = Roact.createElement(ScreenGuiWithBlurControl, {
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = p2.props.displayOrder
		}, {
			TriggerArea = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				[Roact.Event.MouseEnter] = p2.triggerTitleBar,
				[Roact.Event.MouseLeave] = p2.cancelTriggerTitleBar
			}),
			Bar = Roact.createElement(FullscreenTitleBar, {
				title = p2.props.titleText,
				isTriggered = p2.state.isTriggered,
				onDisappear = p2.onDisappear,
				onHover = p2.mouseReenter,
				exitFullscreen = p2.exitFullscreen,
				closeRoblox = p2.closeRoblox
			})
		})
	})
end
function v16.willUnmount(p3) -- line: 149
	if p3.hideTitleBarPromise then
		p3.hideTitleBarPromise:cancel()
	end

	if p3.triggerTitleBarPromise then
		p3.triggerTitleBarPromise:cancel()
	end
end

local function FullscreenTitleBarWrapper(p4) -- line: 159
	-- upvalues: useRoactService (copy), AppGuiService (copy), useIsInFullScreen (copy), Cryo (copy), Roact (copy), v16 (copy)
	local v22 = useRoactService(AppGuiService)
	local v23 = useIsInFullScreen()
	local v24 = Cryo.Dictionary.join(p4, {
		guiService = v22,
		isInFullScreen = v23
	})

	return Roact.createElement(v16, v24)
end

return FullscreenTitleBarWrapper
