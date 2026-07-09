local AppStorageService = game:GetService("AppStorageService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local withLocalization = require(Modules.LuaApp.withLocalization)
local t = require(CorePackages.Packages.t)
local AppPage = require(Modules.LuaApp.AppPage)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LinkButton = UIBlox.App.Button.LinkButton
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local SetAgreedUserAgreements = require(Modules.Luobu.Actions.SetAgreedUserAgreements)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v25 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local v27 = Roact.PureComponent:extend("UserAgreementsPrompt")

v27.validateProps = t.strictInterface({
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

function v27.init(p1) -- line: 59
	-- upvalues: AppStorageService (copy), OverlayType (copy), NotificationType (copy), Roact (copy), LinkButton (copy), AppPage (copy), ImageSetLabel (copy), Images (copy)
	function p1.getLocalizationKeys() -- line: 60
		-- upvalues: p1 (copy)
		local t1 = {
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

		for _, v in pairs(p1.props.agreements) do
			t1[v.agreementType] = "Luobu.Authentication.Login.Label.Agreement." .. v.agreementType
		end

		return t1
	end
	function p1.onConsent() -- line: 83
		-- upvalues: p1 (copy), AppStorageService (copy)
		local closePrompt = p1.props.closePrompt
		local agreements = p1.props.agreements
		local setAgreedUserAgreements = p1.props.setAgreedUserAgreements
		local t2 = {}

		for _, v in ipairs(agreements) do
			table.insert(t2, v.id)
		end

		setAgreedUserAgreements(t2)
		AppStorageService:SetItem("HasAgreedRequiredPermissions", (tostring(true)))
		closePrompt()
	end
	function p1.onDissent(p2) -- line: 97
		-- upvalues: p1 (copy), OverlayType (copy), NotificationType (copy)
		if p1.props.context == OverlayType.UserAgreementsSecondPrompt then
			p1.props.guiService:BroadcastNotification("", NotificationType.NATIVE_EXIT)

			return
		end

		local agreements = p1.props.agreements

		p1.props.showSecondPrompt(agreements, p2)
	end
	function p1.renderAgreementsListItems(p3) -- line: 109
		-- upvalues: p1 (copy), Roact (copy), LinkButton (copy), AppPage (copy)
		local agreements = p1.props.agreements
		local navigateDown = p1.props.navigateDown
		local t3 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}
		local n1 = 1

		for _, v in ipairs(agreements) do
			local v55 = p3[v.agreementType] or v.displayUrl

			t3[v.agreementType] = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = n1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, { Roact.createElement(LinkButton, {
				fontStyle = "CaptionHeader",
				minPaddingY = 5,
				text = "• " .. v55,
				onActivated = function() -- line: 131
					-- upvalues: navigateDown (copy), AppPage (copy), v (copy), v55 (copy)
					navigateDown({
						name = AppPage.GenericWebPage,
						detail = v.displayUrl,
						extraProps = {
							title = v55
						}
					})
				end
			}) })
			n1 += 1
		end

		return t3
	end
	function p1.renderMiddleContent(p4, t4: {[any]: any}, p5) -- line: 147
		-- upvalues: AppStorageService (copy), p1 (copy), Roact (copy), ImageSetLabel (copy), Images (copy)
		local v59 = AppStorageService:GetItem("HasAgreedRequiredPermissions") ~= tostring(true)
		local shouldShowCameraPermissionInAgreementsPrompt = p1.props.shouldShowCameraPermissionInAgreementsPrompt
		local Theme = t4.Theme
		local t4Font = t4.Font

		return Roact.createElement("Frame", {
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
				Prefix = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 12)
				}, {
					PrefixText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, 0),
						Text = p4.bodyTextPart1,
						Font = t4Font.CaptionHeader.Font,
						TextSize = t4Font.BaseSize * t4Font.CaptionHeader.RelativeSize,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					Padding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 12)
					})
				}),
				AgreementsList = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY
				}, p5),
				Suffix = Roact.createElement("Frame", {
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 12)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 12)
					}),
					PrefixText = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, 0),
						Text = p4.bodyTextPart2,
						Font = t4Font.CaptionHeader.Font,
						TextSize = t4Font.BaseSize * t4Font.CaptionHeader.RelativeSize,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					})
				})
			}),
			Permissions = v59 and Roact.createElement("Frame", {
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
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, 0),
						Text = p4.bodyTextPart1,
						Font = t4Font.CaptionHeader.Font,
						TextSize = t4Font.BaseSize * t4Font.CaptionHeader.RelativeSize,
						TextColor3 = Theme.TextDefault.Color,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
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
						Icon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Image = Images["icons/menu/memory"],
							Size = UDim2.new(0, 30, 0, 30),
							ScaleType = Enum.ScaleType.Stretch
						}),
						Content = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -30, 0, 36)
						}, {
							Layout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Title = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 12),
								Text = p4.permissionStorageTitle,
								Font = t4Font.CaptionHeader.Font,
								TextSize = t4Font.BaseSize * t4Font.CaptionHeader.RelativeSize,
								TextColor3 = Theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							}),
							DescriptionText = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 24),
								Text = p4.permissionStorageDesc,
								Font = t4Font.CaptionBody.Font,
								TextSize = t4Font.BaseSize * t4Font.CaptionBody.RelativeSize,
								TextColor3 = Theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							}),
							Padding = Roact.createElement("UIPadding", {
								PaddingBottom = UDim.new(0, 12)
							})
						})
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
						Icon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Image = Images["icons/menu/mobile"],
							Size = UDim2.new(0, 30, 0, 30),
							ScaleType = Enum.ScaleType.Stretch
						}),
						Content = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -30, 0, 36)
						}, {
							Layout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Title = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 12),
								Text = p4.permissionNetworkTitle,
								Font = t4Font.CaptionHeader.Font,
								TextSize = t4Font.BaseSize * t4Font.CaptionHeader.RelativeSize,
								TextColor3 = Theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							}),
							DescriptionText = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 24),
								Text = p4.permissionNetworkDesc,
								Font = t4Font.CaptionBody.Font,
								TextSize = t4Font.BaseSize * t4Font.CaptionBody.RelativeSize,
								TextColor3 = Theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							}),
							Padding = shouldShowCameraPermissionInAgreementsPrompt and Roact.createElement("UIPadding", {
								PaddingBottom = UDim.new(0, 12)
							})
						})
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
						Icon = Roact.createElement(ImageSetLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							Image = Images["icons/menu/mobile"],
							Size = UDim2.new(0, 30, 0, 30),
							ScaleType = Enum.ScaleType.Stretch
						}),
						Content = Roact.createElement("Frame", {
							LayoutOrder = 2,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -30, 0, 36)
						}, {
							Layout = Roact.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder
							}),
							Title = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 12),
								Text = p4.permissionCameraTitle,
								Font = t4Font.CaptionHeader.Font,
								TextSize = t4Font.BaseSize * t4Font.CaptionHeader.RelativeSize,
								TextColor3 = Theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							}),
							DescriptionText = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 24),
								Text = p4.permissionCameraDesc,
								Font = t4Font.CaptionBody.Font,
								TextSize = t4Font.BaseSize * t4Font.CaptionBody.RelativeSize,
								TextColor3 = Theme.TextDefault.Color,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center
							})
						})
					})
				})
			})
		})
	end
end
function v27.render(p6) -- line: 444
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local screenSize = p6.props.screenSize

	return withStyle(function(p7) -- line: 447
		-- upvalues: withLocalization (copy), p6 (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy), screenSize (copy)
		return withLocalization(p6.getLocalizationKeys())(function(p8) -- line: 448
			-- upvalues: p6 (copy), Roact (copy), InteractiveAlert (copy), p7 (copy), ButtonType (copy), screenSize (copy)
			local v69 = p6.renderAgreementsListItems(p8)

			return Roact.createElement(InteractiveAlert, {
				title = p8.title,
				middleContent = function() -- line: 452
					-- upvalues: p6 (copy), p8 (copy), p7 (copy), v69 (copy)
					return p6.renderMiddleContent(p8, p7, v69)
				end,
				buttonStackInfo = {
					buttons = {
						{
							props = {
								onActivated = function() -- line: 459
									-- upvalues: p6 (copy), v69 (copy)
									p6.onDissent(v69)
								end,
								text = p8.dissentButton
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = p6.onConsent,
								text = p8.consentButton
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

local v28 = RoactRodux.connect(function(p9) -- line: 481
	return {
		screenSize = p9.ScreenSize
	}
end, function(p10) -- line: 485
	-- upvalues: CloseCentralOverlay (copy), SetAgreedUserAgreements (copy), FFlagSignalsNavP3Dispatch (copy), v25 (copy), NavigateDown (copy), SetCentralOverlay (copy), OverlayType (copy)
	return {
		closePrompt = function() -- line: 487
			-- upvalues: p10 (copy), CloseCentralOverlay (copy)
			p10(CloseCentralOverlay())
		end,
		setAgreedUserAgreements = function(p11) -- line: 490
			-- upvalues: p10 (copy), SetAgreedUserAgreements (copy)
			return p10(SetAgreedUserAgreements(p11))
		end,
		navigateDown = function(p12) -- line: 493
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v25 (copy), p10 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v25.down(v25.fromLegacyPage(p12))

				return
			end

			p10(NavigateDown(p12))
		end,
		showSecondPrompt = function(p13, p14) -- line: 500
			-- upvalues: p10 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p10(SetCentralOverlay(OverlayType.UserAgreementsSecondPrompt, {
				agreements = p13,
				agreementsListItems = p14
			}))
		end
	}
end)(v27)
local v29 = RoactAppPolicy.connect(function(p15, _) -- line: 509
	return {
		shouldShowCameraPermissionInAgreementsPrompt = p15.getShouldShowCameraPermissionInAgreementsPrompt()
	}
end)(v28)

return RoactServices.connect({
	guiService = AppGuiService
})(v29)
