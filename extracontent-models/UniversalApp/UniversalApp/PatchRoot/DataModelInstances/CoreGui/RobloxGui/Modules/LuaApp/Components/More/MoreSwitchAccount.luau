local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local t = require(CorePackages.Packages.t)
local withLocalization = require(Modules.LuaApp.withLocalization)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v14 = Roact.PureComponent:extend("MoreSwitchAccount")
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local OpenAccountSwitcher = require(Modules.LuaApp.Thunks.Authentication.OpenAccountSwitcher)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local GetFFlagUIBloxUseFoundationButton = require(CorePackages.Workspace.Packages.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton

v14.validateProps = t.strictInterface({
	buttonHeight = t.integer,
	buttonMaxWidth = t.integer,
	item = t.table,
	layoutOrder = t.optional(t.integer),
	position = t.optional(t.UDim2),
	navigateDown = t.callback,
	navigateBack = t.callback,
	guiService = t.union(t.Instance, t.table),
	networkImpl = t.callback,
	willActivate = t.optional(t.callback),
	authAnalytics = t.table,
	showAccountSwitcher = t.callback,
	appPolicy = t.optional(t.table),
	omniRecommendationsRequest = t.optional(t.callback),
	enableFoundationDesign = t.optional(t.boolean),
	enableSignedOutAccounts = t.optional(t.boolean),
	showLoginRevamp = t.optional(t.boolean)
})

function v14.init(p1) -- line: 52
	-- upvalues: EventStreamConstants (copy)
	local item = p1.props.item

	function p1.navigateDown() -- line: 54
		-- upvalues: p1 (copy), item (copy)
		p1.props.navigateDown({
			name = item.context.page
		})
	end

	p1.mounted = false
	p1.state = {
		isButtonDisabled = false
	}

	function p1.onActivated() -- line: 66
		-- upvalues: p1 (copy), EventStreamConstants (copy)
		if p1.state.isButtonDisabled then
			return
		end

		p1:setState({
			isButtonDisabled = true
		})
		p1.props.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.MorePage, EventStreamConstants.Button.SwitchAccounts)
		p1.props.showAccountSwitcher(p1.props.networkImpl, p1.props.authAnalytics, p1.props.appPolicy, p1.props.omniRecommendationsRequest, p1.props.enableFoundationDesign, p1.props.enableSignedOutAccounts, p1.props.showLoginRevamp)

		if p1.props.willActivate then
			p1.props.willActivate()
		end

		task.delay(0.25, function() -- line: 89
			-- upvalues: p1 (copy)
			if p1.mounted then
				p1:setState({
					isButtonDisabled = false
				})
			end
		end)
	end
end
function v14.didMount(p2) -- line: 99
	p2.mounted = true
end
function v14.willUnmount(p3) -- line: 103
	p3.mounted = false
end
function v14.render(p4) -- line: 107
	-- upvalues: withLocalization (copy), Roact (copy), Button (copy), ButtonType (copy), GetFFlagUIBloxUseFoundationButton (copy)
	local buttonHeight = p4.props.buttonHeight
	local buttonMaxWidth = p4.props.buttonMaxWidth
	local layoutOrder = p4.props.layoutOrder
	local position = p4.props.position

	return withLocalization({
		switchAccountText = "Authentication.AccountSwitch.Heading.SwitchAccount",
		addAccountText = "Authentication.AccountSwitch.Action.AddAccount",
		maxAccountsReachedText = "Authentication.AccountSwitch.Label.AccountLimitReached.2"
	})(function(p5) -- line: 117
		-- upvalues: Roact (copy), position (copy), layoutOrder (copy), buttonHeight (copy), buttonMaxWidth (copy), Button (copy), ButtonType (copy), p4 (copy), GetFFlagUIBloxUseFoundationButton (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = position,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(1, 0, 0, buttonHeight)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SwitchAccountButtonFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(buttonMaxWidth, buttonHeight)
				}),
				SwitchAccountButton = Roact.createElement(Button, {
					isDisabled = false,
					isLoading = false,
					buttonType = ButtonType.Secondary,
					onActivated = p4.onActivated,
					size = UDim2.new(1, 0, not GetFFlagUIBloxUseFoundationButton() and 1 or 0, not GetFFlagUIBloxUseFoundationButton() and 0 or buttonHeight),
					text = p5.switchAccountText
				})
			})
		})
	end)
end

local v23 = RoactRodux.connect(function(_, _) -- line: 153
	return {}
end, function(p8) -- line: 155
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), NavigateBack (copy), OpenAccountSwitcher (copy), EventStreamConstants (copy)
	return {
		navigateDown = function(p9) -- line: 157
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p8 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v9.down(v9.fromLegacyPage(p9))

				return
			end

			p8(NavigateDown(p9))
		end,
		navigateBack = function() -- line: 164
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), p8 (copy), NavigateBack (copy)
			if FFlagSignalsNavP3Dispatch then
				v9.back()

				return
			end

			p8(NavigateBack())
		end,
		showAccountSwitcher = function(p10, p11, p12, p13, p14, p15, p16) -- line: 171
			-- upvalues: p8 (copy), OpenAccountSwitcher (copy), EventStreamConstants (copy)
			p8(OpenAccountSwitcher(true, p10, EventStreamConstants.Origin.MoreMenu, p11, p12, p13, p14, p15, p16))
		end
	}
end)(v14)
local v24 = RoactAppPolicy.connect(function(p17, _) -- line: 197
	return {
		appPolicy = p17
	}
end)(v23)

return RoactServices.connect({
	guiService = AppGuiService,
	networkImpl = RoactNetworking,
	authAnalytics = RoactAnalyticsAuthEvents
})(v24)
