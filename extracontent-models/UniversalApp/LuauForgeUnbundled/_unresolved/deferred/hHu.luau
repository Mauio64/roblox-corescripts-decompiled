local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/eee")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local t = require(CorePackages.Packages.t)
local module3 = require("@luauforge/bundled/edC")

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local extended = Roact.PureComponent:extend("MoreSwitchAccount")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module4 = require("@luauforge/bundled/fMG")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local module5 = require("@luauforge/bundled/eda")
local module6 = require("@luauforge/bundled/fPh")
local module7 = require("@luauforge/bundled/fsy")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagUIBloxUseFoundationButton = SharedFlags.UIBlox.GetFFlagUIBloxUseFoundationButton
local fFlagCTAChangeMorePageFlyoutButtonText = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonText

extended.validateProps = t.strictInterface({
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
	enableSignedOutAccounts = t.optional(t.boolean),
	showLoginRevamp = t.optional(t.boolean)
})

function extended:init()
	local item = self.props.item
	function self.navigateDown()
		self.props.navigateDown({ name = item.context.page })
	end
	self.mounted = false

	self.state = { isButtonDisabled = false }

	function self.onActivated()
		if self.state.isButtonDisabled then
			return
		end

		self:setState({ isButtonDisabled = true })

		self.props.authAnalytics.reportAuthButtonClick(
			module7.Context.MorePage,
			module7.Button.SwitchAccounts
		)

		self.props.showAccountSwitcher(
			self.props.networkImpl,
			self.props.authAnalytics,
			self.props.appPolicy,
			self.props.omniRecommendationsRequest,
			self.props.enableSignedOutAccounts,
			self.props.showLoginRevamp
		)

		if self.props.willActivate then
			self.props.willActivate()
		end

		task.delay(0.25, function()
			if self.mounted then
				self:setState({ isButtonDisabled = false })
			end
		end)
	end
end

function extended:didMount()
	self.mounted = true
end

function extended:willUnmount()
	self.mounted = false
end

function extended.render(p2)
	local buttonHeight = p2.props.buttonHeight
	local buttonMaxWidth = p2.props.buttonMaxWidth
	local layoutOrder = p2.props.layoutOrder
	local position = p2.props.position

	return module3({
		switchAccountText = fFlagCTAChangeMorePageFlyoutButtonText and "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase" or "Authentication.AccountSwitch.Heading.SwitchAccount",
		addAccountText = "Authentication.AccountSwitch.Action.AddAccount",
		maxAccountsReachedText = "Authentication.AccountSwitch.Label.AccountLimitReached.2"
	})(function(p3)
		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = position,
				LayoutOrder = layoutOrder,
				Size = UDim2.new(1, 0, 0, buttonHeight)
			},
			{
				UIListLayout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				SwitchAccountButtonFrame = Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
					{
						UISizeConstraint = Roact.createElement("UISizeConstraint", {
							MaxSize = Vector2.new(buttonMaxWidth, buttonHeight)
						}),
						SwitchAccountButton = Roact.createElement(button, {
							buttonType = buttonType.Secondary,
							isDisabled = false,
							isLoading = false,
							onActivated = p2.onActivated,
							size = UDim2.new(
								1,
								0,
								getFFlagUIBloxUseFoundationButton() and 0 or 1,
								not getFFlagUIBloxUseFoundationButton() and 0 or buttonHeight
							),
							text = p3.switchAccountText
						})
					}
				)
			}
		)
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module(p2))
			end
		end,
		navigateBack = function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				callback(RobloxAppToastsRodux())
			end
		end,
		showAccountSwitcher = function(p2, p3, p4, p5, p6, p7)
			callback(module6(true, p2, module7.Origin.MoreMenu, p3, p4, p5, p6, p7))
		end
	}
end)(extended)

local v6 = roactAppPolicy.connect(function(p2, p3)
	return { appPolicy = p2 }
end)(v5)

return roactServices.connect({
	guiService = appGuiService,
	networkImpl = module5,
	authAnalytics = module4
})(v6)
