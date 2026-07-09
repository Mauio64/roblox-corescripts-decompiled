local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")
local React = require(AccountRecoveryParent.React)
local UIBlox = require(AccountRecoveryParent.UIBlox)
local AppBlox = require(AccountRecoveryParent.AppBlox)
local useDesignTokens = require(AccountRecoveryParent.Style).useDesignTokens
local useLocalization = require(AccountRecoveryParent.Localization).Hooks.useLocalization
local useDispatch = require(AccountRecoveryParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(AccountRecoveryParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(AccountRecoveryParent.RoactServiceTags).RoactNetworking
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(AccountRecoveryParent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize
local GetFFlagEnableContinueRecovery = require(AccountRecoveryParent.SharedFlags).GetFFlagEnableContinueRecovery
local Logger = require(AccountRecoveryParent.Loggers).Logger
local useClearFocusOnUnmount = require(AccountRecovery.Hooks).useClearFocusOnUnmount
local AccountRecoveryContext = require(AccountRecovery.Store.AccountRecoveryContext)
local RecoverySessionMetadata = require(AccountRecovery.Thunks.RecoverySessionMetadata)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local RecoveryHeader = require(AccountRecovery.Components.RecoveryHeader)
local ProfileListItem = require(AccountRecovery.Components.ProfileListItem)
local AccountRecoveryPageState = require(AccountRecovery.Enums.AccountRecoveryPageState)
local EventService = require(AccountRecovery.Analytics.EventService)
local Constants = require(AccountRecovery.Components.Constants)

return function(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), AccountRecoveryContext (copy), useStyle (copy), useTokens (copy), useDesignTokens (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useClearFocusOnUnmount (copy), RecoverySessionMetadata (copy), Logger (copy), HttpService (copy), AccountRecoveryPageState (copy), GetFFlagEnableContinueRecovery (copy), ProfileListItem (copy), useLocalization (copy), FullscreenPageWithSafeArea (copy), RecoveryHeader (copy), Loading (copy), IconSize (copy), FoundationText (copy), ScrollView (copy), Visibility (copy), EventService (copy), Constants (copy)
	local v32 = React.useContext(AccountRecoveryContext)
	local v33 = useStyle()
	local v34 = useTokens()
	local v35 = useDesignTokens()
	local v36 = useDispatch()
	local v37 = useRoactService(RoactNetworking)
	local v38, v39 = React.useState({})
	local v40, v41 = React.useState(false)
	local v42, v43 = React.useState(true)
	local v44, v45 = React.useState("")
	local v46, v47 = React.useState(false)
	local v48, v49 = React.useState(Vector2.new(0, 0))
	local v50 = t1.navigation.getParam("userID")
	local v51 = v50 ~= nil and v50 ~= 0

	useClearFocusOnUnmount()
	React.useEffect(function() -- line: 100
		-- upvalues: v43 (copy), v32 (copy), v36 (copy), RecoverySessionMetadata (copy), v37 (copy), Logger (copy), HttpService (copy), v39 (copy), v47 (copy), v41 (copy), v51 (copy), t1 (copy), AccountRecoveryPageState (copy), v50 (copy), GetFFlagEnableContinueRecovery (copy), v45 (copy)
		v43(true)

		local recoverySessionId = v32.state.recoverySessionId

		v36(RecoverySessionMetadata(v37, {
			recoverySessionId = recoverySessionId
		})):andThen(function(p1) -- line: 103
			-- upvalues: Logger (copy), HttpService (copy), v39 (copy), v43 (copy), v47 (copy), v41 (copy), v51 (copy), t1 (copy), AccountRecoveryPageState (copy), v50 (copy), GetFFlagEnableContinueRecovery (copy), v45 (copy), v32 (copy)
			if p1.isError then
				Logger:warning("Error getting recovery session metadata: {}", HttpService:JSONEncode(p1))

				return
			end

			local function v67() -- line: 108
				-- upvalues: v39 (copy), p1 (copy), v43 (copy), v47 (copy)
				v39(p1.data.eligibleUserIDsToRecover)
				v43(false)
				v47(false)
			end

			v41(p1.data.shouldAddContactMethod)

			if v51 then
				t1.navigation.replace(AccountRecoveryPageState.ResetPasswordScreen, {
					userID = v50,
					shouldAddContactMethod = p1.data.shouldAddContactMethod
				})

				return
			end

			if p1.data.eligibleUserIDsToRecover and #p1.data.eligibleUserIDsToRecover == 1 then
				if GetFFlagEnableContinueRecovery() then
					local v68 = p1.data.eligibleUserIDsToRecover[1]

					v47(true)
					v45("")
					v32.utils.handleContinueRecovery(v32.state.recoverySessionId, v68, function() -- line: 121
						-- upvalues: t1 (copy), AccountRecoveryPageState (copy), p1 (copy)
						t1.navigation.replace(AccountRecoveryPageState.ResetPasswordScreen, {
							userID = p1.data.eligibleUserIDsToRecover[1],
							shouldAddContactMethod = p1.data.shouldAddContactMethod
						})
					end, v67, v67, nil, nil, nil)

					return
				end

				t1.navigation.replace(AccountRecoveryPageState.ResetPasswordScreen, {
					userID = p1.data.eligibleUserIDsToRecover[1],
					shouldAddContactMethod = p1.data.shouldAddContactMethod
				})

				return
			end

			if p1.data.eligibleUserIDsToRecover then
				v39(p1.data.eligibleUserIDsToRecover)
				v43(false)
				v47(false)

				return
			end

			Logger:warning("Eligible user IDs to recover is nil")
			v43(false)
		end):await()
	end, {})

	local v52 = useLocalization({
		resetPasswordHeadingText = "Authentication.AccountRecovery.Heading.ResetPassword",
		chooseAccountText = "Authentication.AccountRecovery.Description.ChooseAccount",
		requestErrorText = if v44 == "" then nil else v44
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v33.Theme.BackgroundDefault.Color
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v35.Size.Size_200),
			PaddingLeft = UDim.new(0, v35.Size.Size_300),
			PaddingRight = UDim.new(0, v35.Size.Size_300),
			PaddingBottom = UDim.new(0, v35.Size.Size_200)
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
				currentComponent = "chooseAccount",
				onBackActivated = function() -- line: 194
					-- upvalues: t1 (copy)
					t1.navigation.goBack()
				end,
				backButtonDisabled = v46 or v42,
				recoveryHeadingText = v52.resetPasswordHeadingText,
				recoverySessionId = v32.state.recoverySessionId
			}),
			Loading = v42 and React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v35.Size.Size_50),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				LoadingIcon = React.createElement(Loading, {
					size = IconSize.Medium
				})
			}),
			Content = not v42 and React.createElement("Frame", {
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
					[React.Change.AbsoluteSize] = function(p2) -- line: 161
						-- upvalues: v48 (copy), v49 (copy)
						if v48 ~= p2.AbsoluteSize then
							v49(p2.AbsoluteSize)
						end
					end
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v35.Size.Size_200),
						PaddingRight = UDim.new(0, v35.Size.Size_200)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v35.Size.Size_50)
					}),
					HeaderSpacing = React.createElement("Frame", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v34.Size.Size_400)
					}),
					BodyText = React.createElement(FoundationText, {
						LayoutOrder = 2,
						TextWrapped = true,
						Text = v52.chooseAccountText,
						fontStyle = v34.Typography.BodyMedium,
						textStyle = v34.Color.Content.Default,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					BodyTextSpacing = React.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, v34.Size.Size_300)
					}),
					RequestErrorTextLabel = v44 ~= "" and React.createElement(FoundationText, {
						LayoutOrder = 4,
						Text = v52.requestErrorText or "",
						fontStyle = v34.Typography.CaptionSmall,
						textStyle = v34.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						padding = {
							bottom = UDim.new(0, v34.Size.Size_300)
						}
					})
				}),
				AccountListScrollView = React.createElement(ScrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = Visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -v48.Y)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v35.Size.Size_50)
					}),
					ProfilesList = React.createElement(React.Fragment, nil, ((function(t2: {[any]: any}, p3: ((...any) -> ...any)) -- line: 143
						-- upvalues: React (copy), ProfileListItem (copy)
						if t2 == nil or #t2 == 0 then
							return nil
						end

						local t3 = {}

						for i, v in ipairs(t2) do
							t3["Profile_" .. tostring(i)] = React.createElement(ProfileListItem, {
								index = i,
								userId = v,
								onProfileActivated = p3
							})
						end

						return t3
					end)(v38, function(n1: number) -- line: 297
						-- upvalues: EventService (copy), v32 (copy), GetFFlagEnableContinueRecovery (copy), v47 (copy), t1 (copy), AccountRecoveryPageState (copy), v40 (copy), v45 (copy), Constants (copy)
						EventService.sendUserSelectedEvent(v32.state.recoverySessionId)

						if GetFFlagEnableContinueRecovery() then
							v47(true)
							v45("")
							v32.utils.handleContinueRecovery(v32.state.recoverySessionId, n1, function() -- line: 300
								-- upvalues: v47 (copy), t1 (copy), AccountRecoveryPageState (copy), n1 (copy), v40 (copy)
								v47(false)
								t1.navigation.navigate(AccountRecoveryPageState.ResetPasswordScreen, {
									userID = n1,
									shouldAddContactMethod = v40
								})
							end, function(s1: string?) -- line: 306
								-- upvalues: v45 (copy), Constants (copy), v47 (copy)
								v45(s1 or Constants.UnknownErrorKey)
								v47(false)
							end, function() -- line: 309
								-- upvalues: v47 (copy)
								v47(false)
							end, nil, nil, nil)

							return
						end

						t1.navigation.navigate(AccountRecoveryPageState.ResetPasswordScreen, {
							userID = n1,
							shouldAddContactMethod = v40
						})
					end)))
				})
			})
		})
	})
end
