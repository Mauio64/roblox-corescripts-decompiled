local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local Cryo = require(AccountRecoveryParent.Cryo)
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local Foundation = require(AccountRecoveryParent.Foundation)
local List = Foundation.List
local SystemBanner = Foundation.SystemBanner
local AlertVariant = Foundation.Enums.AlertVariant
local AlertSeverity = Foundation.Enums.AlertSeverity
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local RecoveryMethodInputType = require(AccountRecovery.Enums.RecoveryMethodInputType)
local EventService = require(AccountRecovery.Analytics.EventService)

local function ChooseVerificationMethodScreen(t1: {[any]: any}) -- line: 49
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useLocalization (copy), useClearFocusOnUnmount (copy), EventService (copy), AccountRecoveryPageState (copy), Cryo (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), ScrollView (copy), Visibility (copy), SystemBanner (copy), AlertSeverity (copy), AlertVariant (copy), List (copy), IconName (copy), RecoveryMethodInputType (copy)
	local v28 = React.useContext(AccountRecoveryContext)
	local v29 = useStyle()
	local v30 = useTokens()
	local v31 = useDesignTokens()
	local v32, v33 = React.useState(Vector2.new(0, 0))
	local v34 = t1.navigation.getParam("sendCodeRouteParams")
	local v35 = v34 and v34.previousRecoveryMethod or ""
	local v36 = useLocalization({
		chooseVerificationMethodHeadingText = "Authentication.AccountRecovery.Heading.ChooseVerificationMethod",
		phoneText = "Authentication.AccountRecovery.LabelPhone",
		emailText = "Authentication.AccountRecovery.LabelEmail",
		backupCodeText = "Authentication.AccountRecovery.Label.BackupCode",
		enterPhoneBackupCodeOrAnotherEmailText = "Authentication.AccountRecovery.Description.EnterPhoneBackupCodeOrAnotherEmail",
		previousMethodVerifiedText = {
			"Authentication.AccountRecovery.Label.PreviousContactMethodVerification",
			contactMethod = v35
		}
	})

	useClearFocusOnUnmount()

	local function v37(p1) -- line: 86
		-- upvalues: v34 (copy), EventService (copy), v28 (copy), t1 (copy), AccountRecoveryPageState (copy), Cryo (copy)
		if v34 then
			EventService.sendRecoveryMethodInputSwitchEvent(v28.state.recoverySessionId, p1, "chooseVerificationMethod")
			t1.navigation.navigate(AccountRecoveryPageState.SendCodeScreen, Cryo.Dictionary.join(v34, {
				recoveryMethodInputTypeOverride = p1
			}))

			return
		end

		t1.navigation.goBack()
	end

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v29.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v31.Size.Size_200),
			PaddingLeft = UDim.new(0, v31.Size.Size_300),
			PaddingRight = UDim.new(0, v31.Size.Size_300),
			PaddingBottom = UDim.new(0, v31.Size.Size_200)
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical
			}),
			Header = React.createElement(RecoveryHeader, {
				LayoutOrder = 1,
				backButtonDisabled = false,
				currentComponent = "chooseVerificationMethod",
				onBackActivated = function() -- line: 82
					-- upvalues: t1 (copy)
					t1.navigation.goBack()
				end,
				recoveryHeadingText = v36.chooseVerificationMethodHeadingText,
				recoverySessionId = v28.state.recoverySessionId
			}),
			Content = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[React.Change.AbsoluteSize] = function(p2) -- line: 76
						-- upvalues: v32 (copy), v33 (copy)
						if v32 ~= p2.AbsoluteSize then
							v33(p2.AbsoluteSize)
						end
					end
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v31.Size.Size_200),
						PaddingRight = UDim.new(0, v31.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v31.Size.Size_50)
					}),
					HeadingToScrollSpacing = React.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v31.Size.Size_500)
					})
				}),
				ContentScrollView = React.createElement(ScrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = Visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -v32.Y)
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v31.Size.Size_200),
						PaddingRight = UDim.new(0, v31.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v31.Size.Size_50)
					}),
					VerifiedBanner = React.createElement(SystemBanner, {
						LayoutOrder = 1,
						severity = AlertSeverity.Info,
						variant = AlertVariant.Standard,
						title = v36.previousMethodVerifiedText,
						description = v36.enterPhoneBackupCodeOrAnotherEmailText
					}),
					BannerSpacing = React.createElement("Frame", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v30.Size.Size_400)
					}),
					MethodList = React.createElement(List.Root, {
						LayoutOrder = 3,
						hasDivider = {
							hasDivider = true,
							isInset = false
						},
						isContained = {
							isContained = false,
							hasMargin = false
						}
					}, {
						PhoneItem = React.createElement(List.Item, {
							LayoutOrder = 1,
							leading = IconName.SmartphonePortrait,
							title = v36.phoneText,
							onActivated = {
								onActivated = function() -- line: 211
									-- upvalues: v37 (copy), RecoveryMethodInputType (copy)
									v37(RecoveryMethodInputType.Phone)
								end
							}
						}),
						EmailItem = React.createElement(List.Item, {
							LayoutOrder = 2,
							leading = IconName.Envelope,
							title = v36.emailText,
							onActivated = {
								onActivated = function() -- line: 221
									-- upvalues: v37 (copy), RecoveryMethodInputType (copy)
									v37(RecoveryMethodInputType.Email)
								end
							}
						}),
						BackupCodeItem = React.createElement(List.Item, {
							LayoutOrder = 3,
							leading = IconName.ClockSpinReverseDashed,
							title = v36.backupCodeText,
							onActivated = {
								onActivated = function() -- line: 231
									-- upvalues: v37 (copy), RecoveryMethodInputType (copy)
									v37(RecoveryMethodInputType.BackupCode)
								end
							}
						})
					})
				})
			})
		})
	})
end

return ChooseVerificationMethodScreen
