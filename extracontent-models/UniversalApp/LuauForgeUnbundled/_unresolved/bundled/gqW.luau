local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/ggi")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module2 = require("@luauforge/bundled/egx")
local module3 = require("@luauforge/bundled/ggp")
local module4 = require("@luauforge/bundled/gqX")
local module5 = require("@luauforge/bundled/gqY")
local module6 = require("@luauforge/bundled/gqZ")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local module7 = require("@luauforge/bundled/ego")

local UIBlox = require(CorePackages.Packages.UIBlox)
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local fullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local withStyle = UIBlox.Style.withStyle
local module8 = require("@luauforge/bundled/egZ")

local v5 = {
	AgeBlock = "CommonUI.Messages.Label.AgeBlock",
	FeatureNotAvailableForAccount = "CommonUI.Messages.Label.FeatureNotAvailableForAccount"
}

local extended = React.PureComponent:extend("UAppBlockPage")

local strictInterface = t.strictInterface

local v7 = if module6 then t.Vector2 else nil
local v6 = {
	screenSize = v7,
	logoutWithoutShowConfirmation = t.callback,
	shouldDisableLogOut = 0,
	uAppBlockPageTextMapKey = 0,
	guiService = 0,
	networkImpl = 0
}

local v8 = if module5 then t.optional(t.boolean) else nil
v6.shouldDisableLogOut = v8
v6.uAppBlockPageTextMapKey = t.optional(t.string)

v6.guiService = t.any
v6.networkImpl = t.any
extended.validateProps = strictInterface(v6)

function LUAUFORGE_MODULE_GLOBALS_gqW_getBlockTextLocalizationKeyFromMapKey(p2)
	if p2 == nil or not v5[p2] then
		return "CommonUI.Messages.Label.FeatureNotAvailableForAccount"
	end

	return v5[p2]
end

function extended:init()
	function self.logOut()
		if module5 and self.props.shouldDisableLogOut then
			return
		end

		self.props.logoutWithoutShowConfirmation(self.props.networkImpl, self.props.guiService)
	end
end

function extended.render(p2)
	return module8({
		blockText = not module4 and "CommonUI.Messages.Label.AgeBlock" or LUAUFORGE_MODULE_GLOBALS_gqW_getBlockTextLocalizationKeyFromMapKey(p2.props.uAppBlockPageTextMapKey),
		logOutText = "Application.Logout.Action.Logout"
	})(function(p3)
		return withStyle(function(p4)
			local createElement = module7.createElement

			local v11 = if module6 then p2.props.screenSize else Vector2.new(1920, 1080)
			local v10 = {
				screenSize = v11,
				marginSize = not module6 and 0 or nil,
				distanceFromTop = module6 and 37 or 400,
				onCloseClicked = 0,
				buttonStackProps = 0
			}

			local v12 = if not (module5 and p2.props.shouldDisableLogOut) then p2.logOut else nil
			v10.onCloseClicked = v12

			v10.buttonStackProps = not (module5 and p2.props.shouldDisableLogOut) and {
				buttons = {
					{
						props = {
							isDisabled = false,
							onActivated = p2.logOut,
							text = p3.logOutText
						}
					}
				}
			} or nil
			return createElement(fullPageModal, v10, {
				UIListLayout = module7.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical
				}),
				TextLabel = module7.createElement(styledTextLabel, {
					automaticSize = Enum.AutomaticSize.Y,
					colorStyle = { Color = Color3.new(0, 0, 0), Transparency = 0 },
					fontStyle = p4.Font.Body,
					lineHeight = 1,
					size = UDim2.new(1, 0, 0, 0),
					text = p3.blockText,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Bottom,
					textWrapped = module6 and true or nil
				})
			})
		end)
	end)
end

local function mapStateToProps(p2)
	return { screenSize = p2.ScreenSize }
end

local v9 = RoactRodux.connect(not module6 and function(p2, p3) end or mapStateToProps, function(callback)
	return {
		logoutWithoutShowConfirmation = function(p2, p3)
			callback(module(p2, p3, module3.MoreLogOut))
		end
	}
end)(extended)

local v10 = roactAppPolicy.connect(function(p2, p3)
	local v12 = if module5 then p2.getUAppBlockPageShouldDisableLogOut() else nil

	local v13 = if module4 then p2.getUAppBlockPageTextMapKey() else nil
	return { shouldDisableLogOut = v12, uAppBlockPageTextMapKey = v13 }
end)(v9)

return roactServices.connect({ guiService = appGuiService, networkImpl = module2 })(v10)
