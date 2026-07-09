local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(AccountRecoveryParent.Foundation)
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local Logger = require(AccountRecoveryParent.Loggers).Logger
local GetUserById = require(AccountRecoveryParent.AuthCommon).Thunks.GetUserById
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local UserHeader = require(AccountRecovery.Components.UserHeader)

return function(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useRoactService (copy), RoactNetworking (copy), useClearFocusOnUnmount (copy), GetUserById (copy), Logger (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), ScrollView (copy), Visibility (copy), UserHeader (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v27 = React.useContext(AccountRecoveryContext)
	local v28 = useStyle()
	local v29 = useTokens()
	local v30 = useDesignTokens()
	local v31 = useRoactService(RoactNetworking)
	local v32 = t1.navigation.getParam("userID")
	local v33 = t1.navigation.getParam("isConsole") or false
	local v34, v35 = React.useState("")
	local v36, v37 = React.useState("")
	local v38, v39 = React.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()
	React.useEffect(function() -- line: 62
		-- upvalues: v32 (copy), GetUserById (copy), v31 (copy), v37 (copy), v35 (copy), Logger (copy)
		if v32 and v32 ~= 0 then
			GetUserById(v31, `{ v32 }`):andThen(function(p1) -- line: 64
				-- upvalues: v37 (copy), v35 (copy)
				v37(p1.name)
				v35(p1.displayName)
			end):catch(function(p2) -- line: 67
				-- upvalues: Logger (copy)
				Logger:warning("Error getting user info: {}", p2)
			end)
		end
	end, {})

	local v40 = useLocalization({
		useAnotherDeviceHeadingText = "Authentication.AccountRecovery.Heading.UseAnotherDevice",
		cannotRecoverAccountHeadingText = "Authentication.AccountRecovery.Heading.CannotRecoverAccount",
		bodyText = "Authentication.AccountRecovery.Description.CannotRecoverAccount",
		platformNotSupportedText = "Authentication.AccountRecovery.Description.PlatformNotSupported",
		okButtonText = "Authentication.AccountRecovery.Action.Ok"
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v28.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v30.Size.Size_200),
			PaddingLeft = UDim.new(0, v30.Size.Size_300),
			PaddingRight = UDim.new(0, v30.Size.Size_300),
			PaddingBottom = UDim.new(0, v30.Size.Size_200)
		}),
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v30.Size.Size_500)
			}),
			PreScrollContent = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				[React.Change.AbsoluteSize] = function(p3) -- line: 73
					-- upvalues: v38 (copy), v39 (copy)
					if v38 ~= p3.AbsoluteSize then
						v39(p3.AbsoluteSize)
					end
				end
			}, {
				Header = React.createElement(RecoveryHeader, {
					LayoutOrder = 1,
					currentComponent = "cannotRecoverAccount",
					recoveryHeadingText = v33 and v40.useAnotherDeviceHeadingText or v40.cannotRecoverAccountHeadingText,
					recoverySessionId = v27.state.recoverySessionId
				})
			}),
			ContentScrollView = React.createElement(ScrollView, {
				LayoutOrder = 2,
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					scrollBarVisibility = Visibility.Auto
				},
				Size = UDim2.new(1, 0, 1, -v38.Y)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v30.Size.Size_200),
					PaddingRight = UDim.new(0, v30.Size.Size_200)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v30.Size.Size_50)
				}),
				UserHeader = v32 and (v32 ~= 0 and React.createElement(UserHeader, {
					LayoutOrder = 1,
					userId = `{ v32 }`,
					displayName = v34,
					username = v36
				})),
				Body = React.createElement(FoundationText, {
					LayoutOrder = 2,
					TextWrapped = true,
					Text = v33 and v40.platformNotSupportedText or v40.bodyText,
					fontStyle = v29.Typography.BodyMedium,
					textStyle = v29.Color.Content.Default,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					padding = {
						top = UDim.new(0, v29.Size.Size_300),
						bottom = UDim.new(0, v29.Size.Size_300)
					}
				}),
				OkButton = React.createElement(Button, {
					LayoutOrder = 3,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					text = v40.okButtonText,
					width = UDim.new(1, 0),
					onActivated = function() -- line: 168
						-- upvalues: v27 (copy)
						v27.parentNavigation.goBack()
					end
				})
			})
		})
	})
end
