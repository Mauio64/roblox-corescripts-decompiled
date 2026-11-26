local AppStorageService = game:GetService("AppStorageService")

local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module = require("@luauforge/bundled/egZ")
local t = require(CorePackages.Packages.t)
local module2 = require("@luauforge/bundled/dFu")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local linkButton = UIBlox.App.Button.LinkButton
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local module3 = require("@luauforge/bundled/hUt")
local module4 = require("@luauforge/bundled/ehl")
local module5 = require("@luauforge/bundled/ehm")
local module6 = require("@luauforge/bundled/fCM")
local module7 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module8 = require("@luauforge/bundled/fvN")

local extended = Roact.PureComponent:extend("UserAgreementsPrompt")

extended.validateProps = t.strictInterface({
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
	})),
	context = t.optional(t.string),
	screenSize = t.Vector2,
	closePrompt = t.callback,
	setAgreedUserAgreements = t.callback,
	navigateDown = t.callback,
	showSecondPrompt = t.callback,
	shouldShowCameraPermissionInAgreementsPrompt = t.boolean,
	guiService = t.table
})

function extended:init()
	function self.getLocalizationKeys()
		local result = {
			title = "Luobu.Authentication.UserAgreementsPrompt.Title",
			bodyTextPart1 = "Luobu.Authentication.UserAgreementsPrompt.BodyText.Part1",
			bodyTextPart2 = "Luobu.Authentication.UserAgreementsPrompt.BodyText.Part2",
			permissionDesc = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Description",
			permissionStorageTitle = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Storage.Title",
			permissionStorageDesc = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Storage.Description",
			permissionNetworkTitle = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Network.Title",
			permissionNetworkDesc = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Network.Description",
			permissionCameraTitle = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Camera.Title",
			permissionCameraDesc = "Luobu.Authentication.UserAgreementsPrompt.Permissions.Camera.Description",
			consentButton = "Luobu.Authentication.UserAgreementsPrompt.Button.Consent",
			dissentButton = "Luobu.Authentication.UserAgreementsPrompt.Button.Dissent"
		}

		for k, agreement in pairs(self.props.agreements) do
			result[agreement.agreementType] = "Luobu.Authentication.Login.Label.Agreement." .. agreement.agreementType
		end

		return result
	end

	function self.onConsent()
		local closePrompt = self.props.closePrompt
		local agreements = self.props.agreements
		local setAgreedUserAgreements = self.props.setAgreedUserAgreements

		local ids = {}

		for i, agreement in ipairs(agreements) do
			table.insert(ids, agreement.id)
		end

		setAgreedUserAgreements(ids)
		AppStorageService:SetItem("HasAgreedRequiredPermissions", (tostring(true)))
		closePrompt()
	end

	function self.onDissent(p3)
		if self.props.context == module4.UserAgreementsSecondPrompt then
			self.props.guiService:BroadcastNotification("", module8.NATIVE_EXIT)
			return
		end

		local agreements = self.props.agreements
		self.props.showSecondPrompt(agreements, p3)
	end

	function self.renderAgreementsListItems(p3)
		local agreements = self.props.agreements
		local navigateDown = self.props.navigateDown
		local children = {}
		children.Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		local v5 = 1

		for i, agreement in ipairs(agreements) do
			local v6 = p3[agreement.agreementType] or agreement.displayUrl
			children[agreement.agreementType] = Roact.createElement(
				"Frame",
				{
					LayoutOrder = v5,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY
				},
				{ Roact.createElement(linkButton, {
						text = "• " .. v6,
						fontStyle = "CaptionHeader",
						minPaddingY = 5,
						onActivated = function()
							navigateDown({
								name = module2.GenericWebPage,
								detail = agreement.displayUrl,
								extraProps = { title = v6 }
							})
						end
					}) }
			)

			v5 += 1
		end

		return children
	end

	function self.renderMiddleContent(props, p3, p4)
		local v5 = AppStorageService:GetItem("HasAgreedRequiredPermissions") ~= tostring(true)
		local shouldShowCameraPermissionInAgreementsPrompt = self.props.shouldShowCameraPermissionInAgreementsPrompt
		local theme = p3.Theme
		local font = p3.Font

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Agreements = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Prefix = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 12)
						},
						{
							PrefixText = Roact.createElement("TextLabel", {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = 1,
								Text = props.bodyTextPart1,
								Font = font.CaptionHeader.Font,
								TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
								TextColor3 = theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextWrapped = true
							}),
							Padding = Roact.createElement("UIPadding", {
								PaddingBottom = UDim.new(0, 12)
							})
						}
					),
					AgreementsList = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							AutomaticSize = Enum.AutomaticSize.XY
						},
						p4
					),
					Suffix = Roact.createElement(
						"Frame",
						{
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 12)
						},
						{
							Padding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 12)
							}),
							PrefixText = Roact.createElement("TextLabel", {
								Size = UDim2.new(1, 0, 1, 0),
								BackgroundTransparency = 1,
								Text = props.bodyTextPart2,
								Font = font.CaptionHeader.Font,
								TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
								TextColor3 = theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextWrapped = true
							})
						}
					)
				}),
				Permissions = v5 and Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Description = Roact.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 12),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						DescriptionText = Roact.createElement("TextLabel", {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							Text = props.bodyTextPart1,
							Font = font.CaptionHeader.Font,
							TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
							TextColor3 = theme.TextDefault.Color,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextWrapped = true
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, 12)
						})
					}),
					Permissions = Roact.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						StoragePermission = Roact.createElement("Frame", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							Layout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Icon = Roact.createElement(imageSetLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								Image = images["icons/menu/memory"],
								Size = UDim2.new(0, 30, 0, 30),
								ScaleType = Enum.ScaleType.Stretch
							}),
							Content = Roact.createElement(
								"Frame",
								{
									LayoutOrder = 2,
									BackgroundTransparency = 1,
									Size = UDim2.new(1, -30, 0, 36)
								},
								{
									Layout = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Title = Roact.createElement("TextLabel", {
										Size = UDim2.new(1, 0, 0, 12),
										BackgroundTransparency = 1,
										Text = props.permissionStorageTitle,
										Font = font.CaptionHeader.Font,
										TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
										TextColor3 = theme.TextDefault.Color,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										TextWrapped = true
									}),
									DescriptionText = Roact.createElement("TextLabel", {
										Size = UDim2.new(1, 0, 0, 24),
										BackgroundTransparency = 1,
										Text = props.permissionStorageDesc,
										Font = font.CaptionBody.Font,
										TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
										TextColor3 = theme.TextDefault.Color,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										TextWrapped = true
									}),
									Padding = Roact.createElement("UIPadding", {
										PaddingBottom = UDim.new(0, 12)
									})
								}
							)
						}),
						NetworkPermission = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							Layout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Icon = Roact.createElement(imageSetLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								Image = images["icons/menu/mobile"],
								Size = UDim2.new(0, 30, 0, 30),
								ScaleType = Enum.ScaleType.Stretch
							}),
							Content = Roact.createElement(
								"Frame",
								{
									LayoutOrder = 2,
									BackgroundTransparency = 1,
									Size = UDim2.new(1, -30, 0, 36)
								},
								{
									Layout = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Title = Roact.createElement("TextLabel", {
										Size = UDim2.new(1, 0, 0, 12),
										BackgroundTransparency = 1,
										Text = props.permissionNetworkTitle,
										Font = font.CaptionHeader.Font,
										TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
										TextColor3 = theme.TextDefault.Color,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										TextWrapped = true
									}),
									DescriptionText = Roact.createElement("TextLabel", {
										Size = UDim2.new(1, 0, 0, 24),
										BackgroundTransparency = 1,
										Text = props.permissionNetworkDesc,
										Font = font.CaptionBody.Font,
										TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
										TextColor3 = theme.TextDefault.Color,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										TextWrapped = true
									}),
									Padding = shouldShowCameraPermissionInAgreementsPrompt and Roact.createElement("UIPadding", {
										PaddingBottom = UDim.new(0, 12)
									})
								}
							)
						}),
						CameraPermission = shouldShowCameraPermissionInAgreementsPrompt and Roact.createElement("Frame", {
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							Layout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Icon = Roact.createElement(imageSetLabel, {
								LayoutOrder = 1,
								BackgroundTransparency = 1,
								Image = images["icons/menu/mobile"],
								Size = UDim2.new(0, 30, 0, 30),
								ScaleType = Enum.ScaleType.Stretch
							}),
							Content = Roact.createElement(
								"Frame",
								{
									LayoutOrder = 2,
									BackgroundTransparency = 1,
									Size = UDim2.new(1, -30, 0, 36)
								},
								{
									Layout = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Title = Roact.createElement("TextLabel", {
										Size = UDim2.new(1, 0, 0, 12),
										BackgroundTransparency = 1,
										Text = props.permissionCameraTitle,
										Font = font.CaptionHeader.Font,
										TextSize = font.BaseSize * font.CaptionHeader.RelativeSize,
										TextColor3 = theme.TextDefault.Color,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										TextWrapped = true
									}),
									DescriptionText = Roact.createElement("TextLabel", {
										Size = UDim2.new(1, 0, 0, 24),
										BackgroundTransparency = 1,
										Text = props.permissionCameraDesc,
										Font = font.CaptionBody.Font,
										TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
										TextColor3 = theme.TextDefault.Color,
										TextXAlignment = Enum.TextXAlignment.Left,
										TextYAlignment = Enum.TextYAlignment.Center,
										TextWrapped = true
									})
								}
							)
						})
					})
				})
			}
		)
	end
end

function extended.render(data)
	local screenSize = data.props.screenSize

	return withStyle(function(p2)
		return module(data.getLocalizationKeys())(function(props)
			local agreementsListItems = data.renderAgreementsListItems(props)
			return Roact.createElement(interactiveAlert, {
				title = props.title,
				middleContent = function()
					return data.renderMiddleContent(props, p2, agreementsListItems)
				end,
				buttonStackInfo = {
					buttons = {
						{
							props = {
								onActivated = function()
									data.onDissent(agreementsListItems)
								end,
								text = props.dissentButton
							}
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = {
								onActivated = data.onConsent,
								text = props.consentButton
							}
						}
					}
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = screenSize
			})
		end)
	end)
end

local v5 = RoactRodux.connect(function(p2)
	return { screenSize = p2.ScreenSize }
end, function(callback)
	return {
		closePrompt = function()
			callback(module6())
		end,
		setAgreedUserAgreements = function(p2)
			return callback(module3(p2))
		end,
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(module7(p2))
			end
		end,
		showSecondPrompt = function(p2, p3)
			callback(module5(module4.UserAgreementsSecondPrompt, {
				agreements = p2,
				agreementsListItems = p3
			}))
		end
	}
end)(extended)

local v6 = roactAppPolicy.connect(function(p2, p3)
	return {
		shouldShowCameraPermissionInAgreementsPrompt = p2.getShouldShowCameraPermissionInAgreementsPrompt()
	}
end)(v5)

return roactServices.connect({ guiService = appGuiService })(v6)
