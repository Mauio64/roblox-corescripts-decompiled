local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)
local FFlagUAppBlockPageUseTextFromGUAC = require(Modules.LuaApp.Flags.FFlagUAppBlockPageUseTextFromGUAC)
local FFlagUAppBlockPageDisableLogOutFromGUAC = require(Modules.LuaApp.Flags.FFlagUAppBlockPageDisableLogOutFromGUAC)
local FFlagUAppBlockPageResponsiveLayout = require(Modules.LuaApp.Flags.FFlagUAppBlockPageResponsiveLayout)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local Roact = require(Modules.Common.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)
local t1 = {
	AgeBlock = "CommonUI.Messages.Label.AgeBlock",
	FeatureNotAvailableForAccount = "CommonUI.Messages.Label.FeatureNotAvailableForAccount"
}
local v22 = React.PureComponent:extend("UAppBlockPage")

v22.validateProps = t.strictInterface({
	screenSize = if not FFlagUAppBlockPageResponsiveLayout then nil else t.Vector2,
	logoutWithoutShowConfirmation = t.callback,
	shouldDisableLogOut = if not FFlagUAppBlockPageDisableLogOutFromGUAC then nil else t.optional(t.boolean),
	uAppBlockPageTextMapKey = t.optional(t.string),
	guiService = t.any,
	networkImpl = t.any
})

function getBlockTextLocalizationKeyFromMapKey(p1) -- line: 49
	-- upvalues: t1 (copy)
	if p1 ~= nil and t1[p1] then
		return t1[p1]
	end

	return t1.FeatureNotAvailableForAccount
end
function v22.init(p2) -- line: 56
	-- upvalues: FFlagUAppBlockPageDisableLogOutFromGUAC (copy)
	function p2.logOut() -- line: 57
		-- upvalues: FFlagUAppBlockPageDisableLogOutFromGUAC (copy), p2 (copy)
		if FFlagUAppBlockPageDisableLogOutFromGUAC and p2.props.shouldDisableLogOut then
			return
		end

		p2.props.logoutWithoutShowConfirmation(p2.props.networkImpl, p2.props.guiService)
	end
end
function v22.render(p3) -- line: 66
	-- upvalues: withLocalization (copy), FFlagUAppBlockPageUseTextFromGUAC (copy), withStyle (copy), Roact (copy), FullPageModal (copy), FFlagUAppBlockPageResponsiveLayout (copy), FFlagUAppBlockPageDisableLogOutFromGUAC (copy), StyledTextLabel (copy)
	return withLocalization({
		logOutText = "Application.Logout.Action.Logout",
		blockText = not FFlagUAppBlockPageUseTextFromGUAC and "CommonUI.Messages.Label.AgeBlock" or getBlockTextLocalizationKeyFromMapKey(p3.props.uAppBlockPageTextMapKey)
	})(function(p4) -- line: 72
		-- upvalues: withStyle (copy), Roact (copy), FullPageModal (copy), FFlagUAppBlockPageResponsiveLayout (copy), p3 (copy), FFlagUAppBlockPageDisableLogOutFromGUAC (copy), StyledTextLabel (copy)
		return withStyle(function(p5) -- line: 73
			-- upvalues: Roact (copy), FullPageModal (copy), FFlagUAppBlockPageResponsiveLayout (copy), p3 (copy), FFlagUAppBlockPageDisableLogOutFromGUAC (copy), p4 (copy), StyledTextLabel (copy)
			return Roact.createElement(FullPageModal, {
				screenSize = if not FFlagUAppBlockPageResponsiveLayout then Vector2.new(1920, 1080) else p3.props.screenSize,
				marginSize = not FFlagUAppBlockPageResponsiveLayout and 0 or nil,
				distanceFromTop = not FFlagUAppBlockPageResponsiveLayout and 400 or 37,
				onCloseClicked = if not FFlagUAppBlockPageDisableLogOutFromGUAC or not p3.props.shouldDisableLogOut then p3.logOut else nil,
				buttonStackProps = if not FFlagUAppBlockPageDisableLogOutFromGUAC or not p3.props.shouldDisableLogOut then {
					buttons = {{
						props = {
							isDisabled = false,
							onActivated = p3.logOut,
							text = p4.logOutText
						}
					}}
				} else nil
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Vertical
				}),
				TextLabel = Roact.createElement(StyledTextLabel, {
					lineHeight = 1,
					automaticSize = Enum.AutomaticSize.Y,
					colorStyle = {
						Transparency = 0,
						Color = Color3.new(0, 0, 0)
					},
					fontStyle = p5.Font.Body,
					size = UDim2.new(1, 0, 0, 0),
					text = p4.blockText,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Bottom,
					textWrapped = not not FFlagUAppBlockPageResponsiveLayout or nil
				})
			})
		end)
	end)
end

local function mapStateToProps(p6) -- line: 123
	return {
		screenSize = p6.ScreenSize
	}
end

local v24 = RoactRodux.connect(not FFlagUAppBlockPageResponsiveLayout and function(_, _) -- line: 130
end or mapStateToProps, function(p9) -- line: 131
	-- upvalues: Logout (copy), luaLogoutReasonNames (copy)
	return {
		logoutWithoutShowConfirmation = function(p10, p11) -- line: 133
			-- upvalues: p9 (copy), Logout (copy), luaLogoutReasonNames (copy)
			p9(Logout(p10, p11, luaLogoutReasonNames.MoreLogOut))
		end
	}
end)(v22)
local v25 = RoactAppPolicy.connect(function(p12, _) -- line: 140
	-- upvalues: FFlagUAppBlockPageDisableLogOutFromGUAC (copy), FFlagUAppBlockPageUseTextFromGUAC (copy)
	return {
		shouldDisableLogOut = if not FFlagUAppBlockPageDisableLogOutFromGUAC then nil else p12.getUAppBlockPageShouldDisableLogOut(),
		uAppBlockPageTextMapKey = if not FFlagUAppBlockPageUseTextFromGUAC then nil else p12.getUAppBlockPageTextMapKey()
	}
end)(v24)

return RoactServices.connect({
	guiService = AppGuiService,
	networkImpl = RoactNetworking
})(v25)
