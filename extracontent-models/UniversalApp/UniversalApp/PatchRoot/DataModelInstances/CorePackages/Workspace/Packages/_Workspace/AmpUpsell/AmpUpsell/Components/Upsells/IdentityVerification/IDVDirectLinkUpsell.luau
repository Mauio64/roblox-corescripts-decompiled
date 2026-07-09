local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local UIBlox = require(AmpUpsellParent.UIBlox)
local React = require(AmpUpsellParent.React)
local Roact = require(AmpUpsellParent.Roact)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useStyle = UIBlox.Core.Style.useStyle
local LinkButton = UIBlox.App.Button.LinkButton
local idvWithQRCodeUpsellStrings = require(AmpUpsell.Common.LocalizationStrings).idvWithQRCodeUpsellStrings
local DirectionsTile = require(script.Parent.DirectionsTile)
local ProgressChecklist = require(script.Parent.ProgressChecklist)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useSelector = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector

local function IDVDirectLinkUpsell(t1: {[any]: any}) -- line: 35
	-- upvalues: useLocalization (copy), idvWithQRCodeUpsellStrings (copy), useStyle (copy), AnalyticsService (copy), useSelector (copy), React (copy), PartialPageModal (copy), sendButtonClickEvent (copy), AppScreens (copy), ButtonType (copy), DirectionsTile (copy), ProgressChecklist (copy), Roact (copy), LinkButton (copy)
	local featureName = t1.featureName
	local v21 = useLocalization(idvWithQRCodeUpsellStrings)
	local v22 = useStyle()
	local onClose = t1.onClose
	local openPrivacyPolicyLink = t1.openPrivacyPolicyLink
	local BodyFont = v22.Font.Body.Font
	local BaseSize = v22.Font.BaseSize
	local TextEmphasisTransparency = v22.Theme.TextEmphasis.Transparency
	local v28 = BaseSize * v22.Font.CaptionBody.RelativeSize
	local v29 = t1.analyticsService or AnalyticsService.EventStream
	local idvLink = t1.idvLink
	local latestStepCompleted = t1.latestStepCompleted
	local v32 = latestStepCompleted > 0
	local openIdvLink = t1.openIdvLink
	local v34 = useSelector(function(p1) -- line: 50
		return p1.ScreenSize
	end)

	return React.createElement(PartialPageModal, {
		title = v21.title,
		screenSize = v34,
		onCloseClicked = React.useCallback(function() -- line: 57
			-- upvalues: sendButtonClickEvent (copy), v29 (copy), AppScreens (copy), featureName (copy), onClose (copy)
			sendButtonClickEvent(v29, AppScreens.IDVDirectLinkUpsell, featureName, "CloseModal")
			onClose()
		end, {
			v29,
			featureName
		}),
		buttonStackProps = {
			buttonHeight = 36,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = React.useCallback(function() -- line: 69
							-- upvalues: sendButtonClickEvent (copy), v29 (copy), AppScreens (copy), featureName (copy), onClose (copy)
							sendButtonClickEvent(v29, AppScreens.IDVDirectLinkUpsell, featureName, "CloseModal")
							onClose()
						end, {
							v29,
							featureName
						}),
						text = v21.cancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = React.useCallback(function() -- line: 80
							-- upvalues: idvLink (copy), sendButtonClickEvent (copy), v29 (copy), AppScreens (copy), featureName (copy), openIdvLink (copy)
							if idvLink ~= nil then
								sendButtonClickEvent(v29, AppScreens.IDVDirectLinkUpsell, featureName, "OpenIdvLink")
								openIdvLink(idvLink)
							end
						end, {
							openIdvLink,
							idvLink,
							v29,
							featureName
						}),
						text = v21.startVerification
					}
				}
			}
		}
	}, {
		DirectLinkViewFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			DirectionsFrameOrProgressChecklist = if v32 then React.createElement(ProgressChecklist, {
				entryHeight = 18,
				layoutOrder = 1,
				latestStepCompleted = latestStepCompleted
			}) else React.createElement("Frame", {
				BackgroundTransparency = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 72),
				BackgroundColor3 = v22.Theme.BackgroundContrast.Color
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
				IDDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/document",
					frameHeight = 48,
					headerText = v21.idDirectionsHeader,
					descriptionText = v21.idDirectionsBody
				})
			}),
			DisclaimerFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 100)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Disclaimer = React.createElement("TextLabel", {
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Text = v21.disclaimer,
					Font = BodyFont,
					TextSize = v28,
					TextColor3 = v22.Theme.TextDefault.Color,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.XY
				}),
				PrivacyPolicy = Roact.createElement(LinkButton, {
					layoutOrder = 2,
					fontStyle = "CaptionBody",
					underlineAlwaysEnabled = true,
					text = v21.privacyLinkText,
					onActivated = function() -- line: 172
						-- upvalues: sendButtonClickEvent (copy), v29 (copy), AppScreens (copy), featureName (copy), openPrivacyPolicyLink (copy)
						sendButtonClickEvent(v29, AppScreens.IDVDirectLinkUpsell, featureName, "OpenPrivacyPolicy")
						openPrivacyPolicyLink()
					end
				})
			})
		})
	})
end

return IDVDirectLinkUpsell
