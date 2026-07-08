local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local transferLocaleFormat = require(CurrencyTransfers.Localization.transferLocaleFormat)
local React = require(CurrencyTransfersParent.React)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local Foundation = require(CurrencyTransfersParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local FillBehavior = Foundation.Enums.FillBehavior
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local RobuxText = require(CurrencyTransfers.Components.Generic.RobuxText)
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local TransferAmountOptionChips = require(CurrencyTransfers.Components.Generic.TransferAmountOptionChips)
local TransferProfileThumbnail = require(CurrencyTransfers.Components.Generic.TransferProfileThumbnail)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local useTextBoxOnChangeRef = require(CurrencyTransfers.Hooks.useTextBoxOnChangeRef)
local useAutoFocusTextBoxOnMount = require(CurrencyTransfers.Hooks.useAutoFocusTextBoxOnMount)
local proceedToConfirm = require(CurrencyTransfers.Actions.Send.proceedToConfirm)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local GetFIntCurrencyTransferMinAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMinAmount)
local GetFIntCurrencyTransferMaxAmount = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferMaxAmount)
local GetFFlagCurrencyTransferFixTextBoxInput = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixTextBoxInput)
local GetFFlagCurrencyTransferFixBalanceReRender = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixBalanceReRender)
local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)
local GetFFlagCurrencyTransferFixDesktopInput = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixDesktopInput)
local GetFFlagCurrencyTransferUseBackendTransferLimits = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferUseBackendTransferLimits)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)
local formatNumber = require(CurrencyTransfers.Utils.formatNumber)

local function TransferRobuxInputSheet(_: {[any]: any}) -- line: 69
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), useTokens (copy), GetFFlagCurrencyTransferFixDesktopInput (copy), UserInputService (copy), useTransferStore (copy), React (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), SignalsReact (copy), GetFFlagCurrencyTransferFixBalanceReRender (copy), GetFFlagCurrencyTransferUseBackendTransferLimits (copy), GetFIntCurrencyTransferMinAmount (copy), GetFIntCurrencyTransferMaxAmount (copy), setTransferPromptState (copy), PromptState (copy), proceedToConfirm (copy), useTextBoxOnChangeRef (copy), useAutoFocusTextBoxOnMount (copy), GetFFlagCurrencyTransferFlowUIImprovementFix (copy), formatNumber (copy), LocalizationService (copy), transferLocaleFormat (copy), useScaledValue (copy), Sheet (copy), TransferRobuxHeader (copy), View (copy), GetFFlagCurrencyTransferFixTextBoxInput (copy), TransferProfileThumbnail (copy), RobuxText (copy), Icon (copy), FoundationText (copy), TransferAmountOptionChips (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v45 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxInputSheet)
	local v46 = useTokens()
	local v47 = GetFFlagCurrencyTransferFixDesktopInput() and not UserInputService.TouchEnabled
	local v48 = useTransferStore()

	React.useEffect(function() -- line: 77
		-- upvalues: logCurrencyTransferCounter (copy), v48 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy)
		logCurrencyTransferCounter(v48, CurrencyTransferTelemetry.CurrencyTransferInputSheetShownCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v48, RobuxTransferFlowEventName.input_shown)
		end

		return nil
	end, { v48 })

	local v49 = SignalsReact.useSignalState(v48.getSelectedAmount) or 0
	local setSelectedAmount = v48.setSelectedAmount
	local v51, v52 = React.useState(false)
	local v53 = if not GetFFlagCurrencyTransferFixBalanceReRender() then v48.getRobuxBalanceAmount(false) else SignalsReact.useSignalState(v48.getRobuxBalanceAmount) or 0
	local v54 = v48.getRecipient(false)
	local v55 = React.useRef(nil)
	local v56 = SignalsReact.useSignalState(v48.getMinimumTransferAmount)
	local v57 = SignalsReact.useSignalState(v48.getMaximumTransferAmount)
	local v58 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v56 or GetFIntCurrencyTransferMinAmount()
	local v59 = GetFFlagCurrencyTransferUseBackendTransferLimits() and v57 or GetFIntCurrencyTransferMaxAmount()

	React.useEffect(function() -- line: 102
		-- upvalues: v49 (copy), v58 (copy), v59 (copy), v52 (copy)
		if v49 == 0 or v49 >= v58 and v49 <= v59 then
			v52(false)
		end
	end, {
		v49,
		v58,
		v59
	})

	local v60 = React.useCallback(function() -- line: 108
		-- upvalues: v49 (copy), v58 (copy), v59 (copy), v52 (copy), v53 (copy), setTransferPromptState (copy), v48 (copy), PromptState (copy), proceedToConfirm (copy)
		if v49 and (v49 < v58 or v49 > v59) then
			v52(true)

			return
		end

		if v49 and v49 > v53 then
			setTransferPromptState(v48, PromptState.TransferInsufficientBalance)

			return
		end

		proceedToConfirm(v48, v49 or 0)
	end, {
		v48,
		v49,
		v53,
		v58,
		v59
	})
	local v61 = React.useCallback(function(n1: number?) -- line: 122
		-- upvalues: setSelectedAmount (copy)
		setSelectedAmount(n1 or 0)
	end, { setSelectedAmount })
	local v62 = React.useCallback(function(b1: boolean, b2: boolean) -- line: 126
		-- upvalues: v49 (copy), v58 (copy), v59 (copy), v52 (copy), v60 (copy)
		if not b1 and b2 then
			if v49 and v49 > 0 and (v49 < v58 or v49 > v59) then
				v52(true)

				return
			end

			v60()
		end
	end, {
		v60,
		v49,
		v58,
		v59
	})
	local v63 = useTextBoxOnChangeRef(v61, v62)
	local triggerOnClose = v48.triggerOnClose
	local v65 = useAutoFocusTextBoxOnMount(v63, 0.05)
	local v66 = React.useCallback(function(p1) -- line: 145
		-- upvalues: v55 (copy), v65 (copy)
		if p1 then
			v55.current = p1
			v65(p1)
		end
	end, { v65 })
	local v67 = React.useMemo(function() -- line: 152
		return {
			{
				amount = 25,
				text = "25"
			},
			{
				amount = 50,
				text = "50"
			},
			{
				amount = 100,
				text = "100"
			},
			{
				amount = 200,
				text = "200"
			}
		}
	end, {})
	local v68 = React.useCallback(function(n2: number) -- line: 161
		-- upvalues: setSelectedAmount (copy), GetFFlagCurrencyTransferFlowUIImprovementFix (copy), v55 (copy)
		setSelectedAmount(n2)

		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			local current = v55.current

			if current then
				current:ReleaseFocus()
			end
		end
	end, { setSelectedAmount })
	local v69 = v49 > 0 and (v49 < v58 or v59 < v49)
	local v70 = v51 and v69
	local v71 = React.useMemo(function() -- line: 177
		-- upvalues: v70 (copy), v49 (copy), v58 (copy), formatNumber (copy), LocalizationService (copy), transferLocaleFormat (copy), v45 (copy), v59 (copy)
		if not v70 or (not v49 or v49 <= 0) then
			return nil
		end

		if v49 < v58 then
			local v81 = formatNumber(LocalizationService.RobloxLocaleId, v58)

			return transferLocaleFormat.substituteAmount(v45.LowerThanMinAmount or "", (tostring(v81)))
		end

		if v49 > v59 then
			local v82 = formatNumber(LocalizationService.RobloxLocaleId, v59)

			return transferLocaleFormat.substituteAmount(v45.GreaterThanMaxAmount or "", (tostring(v82)))
		end

		return nil
	end, {
		v70,
		v49,
		v58,
		v59,
		v45.LowerThanMinAmount,
		v45.GreaterThanMaxAmount
	})
	local v72 = React.useMemo(function() -- line: 200
		-- upvalues: v49 (copy)
		return not v49 or v49 <= 0
	end, { v49 })
	local v73 = useScaledValue(500)
	local v74 = React.useMemo(function() -- line: 210
		-- upvalues: v73 (copy)
		return {
			v73,
			0.62
		}
	end, { v73 })

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		snapPoints = v74,
		onClose = triggerOnClose
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v45.SendRobux,
				robuxBalanceAmount = v53
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col align-x-center items-center gap-large size-full-0 auto-y padding-x-large padding-top-xxlarge"
			}, {
				RobuxInputWrapper = if v47 then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					LayoutOrder = 0,
					Size = UDim2.new(0, 0, 0, 0)
				}, {
					RobuxInput = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 80, 0, 40),
						Position = UDim2.new(0, -10000, 0, 0)
					}, {
						TextBox = React.createElement("TextBox", {
							PlaceholderText = "",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 1, 0),
							Text = if not v49 or not (v49 > 0) then not GetFFlagCurrencyTransferFixTextBoxInput() and "0" or "" else tostring(v49),
							TextInputType = Enum.TextInputType.Number,
							ClearTextOnFocus = not GetFFlagCurrencyTransferFlowUIImprovementFix(),
							ref = v66
						})
					})
				}),
				ThumbnailAndAmountArea = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Content = React.createElement(View, {
						tag = "col align-x-center items-center gap-xlarge size-full-0 auto-y padding-top-xlarge"
					}, {
						RecipientProfile = if not v54 or not v54.targetId then nil else React.createElement(TransferProfileThumbnail, {
							showUsername = true,
							layoutOrder = 1,
							userId = tostring(v54.targetId),
							username = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then v54.targetName else nil,
							displayName = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then nil else v54.targetDisplayName,
							size = UDim2.fromOffset(60, 60),
							thumbnailSize = Enum.ThumbnailSize.Size48x48
						}),
						AmountContainer = React.createElement(View, {
							tag = "col align-x-center gap-large size-full-1600",
							LayoutOrder = 2
						}, {
							ThumbnailAmountGap = React.createElement(View, {
								tag = "size-full-0",
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 0, 20)
							}),
							AmountRow = React.createElement(View, {
								tag = "row align-x-center align-y-center",
								LayoutOrder = 2
							}, {
								AmountWrapper = React.createElement("Frame", {
									BackgroundTransparency = 1,
									LayoutOrder = 1,
									AutomaticSize = Enum.AutomaticSize.XY
								}, {
									SelectedAmountDisplay = if v47 then nil else React.createElement(RobuxText, {
										layoutOrder = 1,
										amount = v49
									}),
									DesktopInputRow = if not v47 then nil else React.createElement("Frame", {
										BackgroundTransparency = 1,
										LayoutOrder = 1,
										AutomaticSize = Enum.AutomaticSize.XY
									}, {
										Layout = React.createElement("UIListLayout", {
											FillDirection = Enum.FillDirection.Horizontal,
											VerticalAlignment = Enum.VerticalAlignment.Center,
											SortOrder = Enum.SortOrder.LayoutOrder,
											Padding = UDim.new(0, 4)
										}),
										RobuxIconWrapper = React.createElement("Frame", {
											BackgroundTransparency = 1,
											LayoutOrder = 1,
											Size = UDim2.fromOffset(math.round(v46.Typography.HeadingLarge.FontSize), (math.round(v46.Typography.DisplaySmall.FontSize)))
										}, {
											RobuxIcon = React.createElement(Icon, {
												name = "robux",
												size = v46.Typography.HeadingLarge.FontSize,
												style = v46.Color.Content.Emphasis,
												AnchorPoint = Vector2.new(0.5, 0.5),
												Position = UDim2.new(0.5, 0, 0.5, 4)
											})
										}),
										DesktopTextBox = React.createElement("TextBox", {
											PlaceholderText = "0",
											BackgroundTransparency = 1,
											ClearTextOnFocus = false,
											LayoutOrder = 2,
											Text = (not v49 or not (v49 > 0)) and "" or tostring(v49),
											TextInputType = Enum.TextInputType.Number,
											Font = v46.Typography.DisplaySmall.Font,
											TextSize = v46.Typography.DisplaySmall.FontSize,
											TextColor3 = v46.Color.Content.Emphasis.Color3,
											PlaceholderColor3 = v46.Color.Content.Emphasis.Color3,
											AutomaticSize = Enum.AutomaticSize.X,
											Size = UDim2.fromOffset(0, (math.round(v46.Typography.DisplaySmall.FontSize))),
											ref = v66
										})
									}),
									AmountTapTarget = if v47 then nil else React.createElement("TextButton", {
										Size = UDim2.new(1, 0, 1, 0),
										Position = UDim2.new(0, 0, 0, 0),
										Text = "",
										BackgroundTransparency = 1,
										ZIndex = 2,
										[React.Event.Activated] = function() -- line: 374
											-- upvalues: v55 (copy)
											if v55.current then
												v55.current:CaptureFocus()
											end
										end
									})
								})
							}),
							ErrorSlot = React.createElement(View, {
								tag = "col align-x-center align-y-center size-full-0 padding-top-medium",
								LayoutOrder = 3,
								Size = UDim2.new(1, 0, 0, 40)
							}, {
								ValidationErrorText = if not v71 then nil else React.createElement(FoundationText, {
									tag = "auto-xy text-caption-small text-align-x-center content-system-alert",
									LayoutOrder = 1,
									Text = v71
								})
							})
						})
					}),
					TapToFocusOverlay = if v47 then nil else React.createElement("TextButton", {
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						Text = "",
						BackgroundTransparency = 1,
						ZIndex = 2,
						[React.Event.Activated] = function() -- line: 407
							-- upvalues: v55 (copy)
							if v55.current then
								v55.current:CaptureFocus()
							end
						end
					})
				}),
				AmountChips = React.createElement(View, {
					tag = "col align-x-center size-full-1600 auto-y",
					LayoutOrder = 2,
					ZIndex = 3
				}, {
					Chips = React.createElement(TransferAmountOptionChips, {
						layoutOrder = 1,
						chips = v67,
						onChipSelected = v68,
						selectedAmount = v49
					})
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			tag = "col align-x-center align-y-center gap-medium size-full-1000"
		}, {
			React.createElement(View, {
				tag = "row gap-small size-full-0 auto-y",
				LayoutOrder = 1
			}, { React.createElement(Button, {
				text = v45.Next,
				onActivated = v60,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isDisabled = v72
			}) }),
			Disclaimer = React.createElement(FoundationText, {
				tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-center",
				LayoutOrder = 2,
				Text = v45.Disclaimer
			})
		}) })
	})
end

return TransferRobuxInputSheet
