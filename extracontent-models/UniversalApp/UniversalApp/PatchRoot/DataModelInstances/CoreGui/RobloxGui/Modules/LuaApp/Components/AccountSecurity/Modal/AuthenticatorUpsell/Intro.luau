local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local ModalBase = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBase)
local ModalBodyText = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalBodyText)
local ModalButtonConfig = require(Modules.LuaApp.Components.AccountSecurity.Common.ModalButtonConfig)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local PromptAssignmentAction = require(Modules.LuaApp.Enum.AccountSecurity.PromptAssignmentAction)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UpdatePromptAssignment = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptAssignment)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t1 = {
	action = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellSetupAuthenticatorButtonMessage",
	descriptionEnd = "Feature.AccountSecurityPrompt.Description.ChangeYourPassword",
	descriptionStart = "Feature.AccountSecurityPrompt.Description.UnusualActivity",
	header = "Feature.AccountSecurityPrompt.Header.AuthenticatorUpsellWelcomeMessage",
	keepBadActorsOutHeadline = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellBadActorHeadline",
	keepBadActorsOutMessage = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellBadActorMessage",
	protectGamesRobuxHeadline = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellProtectRobuxHeadline",
	protectGamesRobuxMessage = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellProtectRobuxMessage",
	twoFactorsBetterThanOneHeadline = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellTwoFactorHeadline",
	twoFactorsBetterThanOneMessage = "Feature.AccountSecurityPrompt.Label.AuthenticatorUpsellTwoFactorMessage"
}
local v24 = Roact.PureComponent:extend("Intro")
local XLarge = IconSize.XLarge
local v26 = getIconSize(XLarge) + 6 - 13
local uDim = UDim.new(0, 10)
local uDim2 = UDim.new(0, 3)
local uDim3 = UDim.new(6, 6)

function v24.init(p1) -- line: 52
	-- upvalues: ModalState (copy), PromptAssignmentAction (copy)
	p1:setState({
		requestInFlight = false
	})

	function p1.continueToAuthenticatorAppScreen(_) -- line: 59
		-- upvalues: p1 (copy), ModalState (copy)
		return function() -- line: 60
			-- upvalues: p1 (copy), ModalState (copy)
			p1:setState({
				requestInFlight = true
			})
			p1.props.navigateToModalState(ModalState.AuthenticatorUpsellInstallApps)
		end
	end
	function p1.closeCallback() -- line: 70
		-- upvalues: p1 (copy), PromptAssignmentAction (copy)
		p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, PromptAssignmentAction.DismissPrompt)
	end
end
function v24.render(p3) -- line: 79
	-- upvalues: UIBlox (copy), withLocalization (copy), t1 (copy), Roact (copy), ModalBase (copy), uDim (copy), uDim3 (copy), ImageSetLabel (copy), Images (copy), getIconSizeUDim2 (copy), XLarge (copy), uDim2 (copy), ModalBodyText (copy), v26 (copy), ModalButtonConfig (copy), ButtonType (copy)
	local requestInFlight = p3.state.requestInFlight

	return UIBlox.Style.withStyle(function(_) -- line: 82
		-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), ModalBase (copy), p3 (copy), uDim (copy), uDim3 (copy), ImageSetLabel (copy), Images (copy), getIconSizeUDim2 (copy), XLarge (copy), uDim2 (copy), ModalBodyText (copy), v26 (copy), ModalButtonConfig (copy), requestInFlight (copy), ButtonType (copy)
		return withLocalization(t1)(function(p5) -- line: 83
			-- upvalues: Roact (copy), ModalBase (copy), p3 (copy), uDim (copy), uDim3 (copy), ImageSetLabel (copy), Images (copy), getIconSizeUDim2 (copy), XLarge (copy), uDim2 (copy), ModalBodyText (copy), v26 (copy), ModalButtonConfig (copy), requestInFlight (copy), ButtonType (copy)
			return Roact.createElement(ModalBase, {
				title = p5.header,
				closeCallback = p3.closeCallback,
				makeBodyFragment = function(p6) -- line: 87
					-- upvalues: Roact (copy), uDim (copy), uDim3 (copy), ImageSetLabel (copy), Images (copy), getIconSizeUDim2 (copy), XLarge (copy), uDim2 (copy), ModalBodyText (copy), v26 (copy), p5 (copy)
					return Roact.createFragment({
						ROWS_WRAPPER = Roact.createElement("Frame", {
							Transparency = 1,
							AutomaticSize = Enum.AutomaticSize.XY
						}, {
							WrappingListWrapper = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = uDim
							}),
							FIRST_ROW = Roact.createElement("Frame", {
								Transparency = 1,
								AutomaticSize = Enum.AutomaticSize.Y
							}, {
								WrappingListB = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = uDim3
								}),
								Left_ProtectGamesRobuxImage = Roact.createElement(ImageSetLabel, {
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Image = Images["icons/graphic/connectdevices_2xl"],
									Size = getIconSizeUDim2(XLarge)
								}),
								SubFrame = Roact.createElement("Frame", {
									Transparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY
								}, {
									ASubList = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										Padding = uDim2
									}),
									Right_TwoFactorsTextA = Roact.createElement(ModalBodyText, {
										useBold = true,
										alignLeft = true,
										contentWidth = p6 - v26,
										text = p5.twoFactorsBetterThanOneHeadline
									}),
									Right_TwoFactorsTextB = Roact.createElement(ModalBodyText, {
										useBold = false,
										alignLeft = true,
										contentWidth = p6 - v26,
										text = p5.twoFactorsBetterThanOneMessage
									})
								})
							}),
							SECOND_ROW = Roact.createElement("Frame", {
								Transparency = 1,
								AutomaticSize = Enum.AutomaticSize.Y
							}, {
								WrappingListB = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = uDim3
								}),
								Left_ProtectGamesRobuxImage = Roact.createElement(ImageSetLabel, {
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Image = Images["icons/graphic/gamesanditems_2xl"],
									Size = getIconSizeUDim2(XLarge)
								}),
								SubFrame = Roact.createElement("Frame", {
									Transparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY
								}, {
									ASubList = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										Padding = uDim2
									}),
									Right_ProtectGamesRobuxHeadline = Roact.createElement(ModalBodyText, {
										useBold = true,
										alignLeft = true,
										contentWidth = p6 - v26,
										text = p5.protectGamesRobuxHeadline
									}),
									Right_ProtectGamesRobuxMessage = Roact.createElement(ModalBodyText, {
										useBold = false,
										alignLeft = true,
										contentWidth = p6 - v26,
										text = p5.protectGamesRobuxMessage
									})
								})
							}),
							THIRD_ROW = Roact.createElement("Frame", {
								Transparency = 1,
								AutomaticSize = Enum.AutomaticSize.Y
							}, {
								WrappingListC = Roact.createElement("UIListLayout", {
									FillDirection = Enum.FillDirection.Horizontal,
									VerticalAlignment = Enum.VerticalAlignment.Center,
									Padding = uDim3
								}),
								Left_KeepBadActorsImage = Roact.createElement(ImageSetLabel, {
									BorderSizePixel = 0,
									BackgroundTransparency = 1,
									Image = Images["icons/graphic/blocktheft_2xl"],
									Size = getIconSizeUDim2(XLarge)
								}),
								SubFrame = Roact.createElement("Frame", {
									Transparency = 1,
									AutomaticSize = Enum.AutomaticSize.XY
								}, {
									ASubList = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										Padding = uDim2
									}),
									Right_TwoFactorsTextA = Roact.createElement(ModalBodyText, {
										useBold = true,
										alignLeft = true,
										contentWidth = p6 - v26,
										text = p5.keepBadActorsOutHeadline
									}),
									Right_TwoFactorsTextB = Roact.createElement(ModalBodyText, {
										useBold = false,
										alignLeft = true,
										contentWidth = p6 - v26,
										text = p5.keepBadActorsOutMessage
									})
								})
							})
						})
					})
				end,
				buttonConfig = ModalButtonConfig({{
					isDisabled = requestInFlight,
					isLoading = requestInFlight,
					onActivated = p3.continueToAuthenticatorAppScreen(p5),
					text = p5.action,
					type = ButtonType.PrimarySystem
				}})
			})
		end)
	end)
end

local v30 = RoactRodux.connect(function(_, _) -- line: 226
	return {}
end, function(p9) -- line: 228
	-- upvalues: CloseCentralOverlay (copy), UpdatePromptAssignment (copy)
	return {
		closeOverlay = function() -- line: 230
			-- upvalues: p9 (copy), CloseCentralOverlay (copy)
			return p9(CloseCentralOverlay())
		end,
		updatePromptAssignment = function(p10, p11, p12) -- line: 233
			-- upvalues: p9 (copy), UpdatePromptAssignment (copy)
			return p9(UpdatePromptAssignment(p10, p11, p12))
		end
	}
end)(v24)

return (RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v30))
