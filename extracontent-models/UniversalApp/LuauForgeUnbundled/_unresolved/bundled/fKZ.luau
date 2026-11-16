local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fJc")
local module2 = require("@luauforge/bundled/fJe")
local module3 = require("@luauforge/bundled/fKb")

local useDesignTokens = require("@luauforge/bundled/fKc").useDesignTokens
local useLocalization = require("@luauforge/bundled/fKd").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/fJh").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/fJu").useRoactService

local roactNetworking = require("@luauforge/bundled/fJv").RoactNetworking

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle

local module4 = require("@luauforge/bundled/fKe")
local text = module4.Text
local useTokens = module4.Hooks.useTokens
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility
local loading = module4.Loading
local iconSize = module4.Enums.IconSize

local getFFlagEnableContinueRecovery = require("@luauforge/bundled/fJI").GetFFlagEnableContinueRecovery

local logger = require("@luauforge/bundled/fJr").Logger

local useClearFocusOnUnmount = require("@luauforge/bundled/fKf").useClearFocusOnUnmount

local module5 = require("@luauforge/bundled/fJz")
local module6 = require("@luauforge/bundled/fLa")
require("@luauforge/bundled/fJj")
local module7 = require("@luauforge/bundled/fKm")
local module8 = require("@luauforge/bundled/fLc")
local module9 = require("@luauforge/bundled/fJZ")
local module10 = require("@luauforge/bundled/fJU")
local module11 = require("@luauforge/bundled/fJH")
local module12 = require("@luauforge/bundled/fKp")

return function(p2)
	local v5 = module.useContext(module5)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()
	local v9 = useDispatch()
	local v10 = useRoactService(roactNetworking)

	local state, setState = module.useState({})
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(true)
	local state4, setState4 = module.useState("")
	local state5, setState5 = module.useState(false)

	local state6, setState6 = module.useState(Vector2.new(0, 0))

	local param = p2.navigation.getParam("userID")
	local v11 = not (param == nil) and param ~= 0

	useClearFocusOnUnmount()

	module.useEffect(function()
		setState3(true)
		v9(module6(v10, { recoverySessionId = v5.state.recoverySessionId })):andThen(function(p3)
			if p3.isError then
				logger:warning("Error getting recovery session metadata: {}", HttpService:JSONEncode(p3))
				return
			end

			local function fn()
				setState(p3.data.eligibleUserIDsToRecover)
				setState3(false)
				setState5(false)
			end
			setState2(p3.data.shouldAddContactMethod)

			if v11 then
				p2.navigation.replace(module9.ResetPasswordScreen, {
					userID = param,
					shouldAddContactMethod = p3.data.shouldAddContactMethod
				})
			elseif p3.data.eligibleUserIDsToRecover and #p3.data.eligibleUserIDsToRecover == 1 then
				if not getFFlagEnableContinueRecovery() then
					p2.navigation.replace(module9.ResetPasswordScreen, {
						userID = p3.data.eligibleUserIDsToRecover[1],
						shouldAddContactMethod = p3.data.shouldAddContactMethod
					})
					return
				end

				local v12 = p3.data.eligibleUserIDsToRecover[1]
				local function fn2()
					p2.navigation.replace(module9.ResetPasswordScreen, {
						userID = p3.data.eligibleUserIDsToRecover[1],
						shouldAddContactMethod = p3.data.shouldAddContactMethod
					})
				end

				setState5(true)
				setState4("")
				v5.utils.handleContinueRecovery(v5.state.recoverySessionId, v12, fn2, fn, fn, nil, nil, nil)
			elseif p3.data.eligibleUserIDsToRecover then
				setState(p3.data.eligibleUserIDsToRecover)
				setState3(false)
				setState5(false)
			else
				logger:warning("Eligible user IDs to recover is nil")
				setState3(false)
			end
		end):await()
	end, {})

	local function fn(state7, onProfileActivated)
		if state7 == nil or #state7 == 0 then
			return nil
		end

		local children = {}

		for i, item in ipairs(state7) do
			children["Profile_" .. tostring(i)] = module.createElement(module8, {
				index = i,
				userId = item,
				onProfileActivated = onProfileActivated
			})
		end

		return children
	end

	local function fn2(p3)
		if state6 ~= p3.AbsoluteSize then
			setState6(p3.AbsoluteSize)
		end
	end

	local v14 = if state4 ~= "" then state4 else nil
	local v15 = useLocalization({
		resetPasswordHeadingText = "Authentication.AccountRecovery.Heading.ResetPassword",
		chooseAccountText = "Authentication.AccountRecovery.Description.ChooseAccount",
		requestErrorText = v14
	})

	local createElement = module.createElement
	local v17 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v18 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v20 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v22 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0
	}
	local v23 = if module12() then Enum.HorizontalAlignment.Center else nil
	v22.HorizontalAlignment = v23
	local children = {
		UIListLayout = createElement3("UIListLayout", v22),
		Header = module.createElement(module7, {
			LayoutOrder = 1,
			onBackActivated = function()
				p2.navigation.goBack()
			end,
			backButtonDisabled = state5 or state3,
			recoveryHeadingText = v15.resetPasswordHeadingText,
			currentComponent = "chooseAccount",
			recoverySessionId = v5.state.recoverySessionId
		}),
		Loading = state3 and module.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v8.Size.Size_50),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				LoadingIcon = module.createElement(loading, { size = iconSize.Medium })
			}
		),
		Content = 0
	}

	local v24 = not state3

	if v24 then
		v24 = module.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				UISizeConstraint = module12() and module.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(module11.ContentMaxWidth, 1e999)
				}),
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				PreScrollContent = module.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					[module.Change.AbsoluteSize] = fn2
				}, {
					UIPadding = module.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v8.Size.Size_200),
						PaddingRight = UDim.new(0, v8.Size.Size_200)
					}),
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					HeaderSpacing = module.createElement("Frame", {
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_400),
						BackgroundTransparency = 1
					}),
					BodyText = module.createElement(text, {
						LayoutOrder = 2,
						Text = v15.chooseAccountText,
						TextWrapped = true,
						fontStyle = v7.Typography.BodyMedium,
						textStyle = v7.Color.Content.Default,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center
					}),
					BodyTextSpacing = module.createElement("Frame", {
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v7.Size.Size_300),
						BackgroundTransparency = 1
					}),
					RequestErrorTextLabel = state4 ~= "" and module.createElement(text, {
						LayoutOrder = 4,
						Text = v15.requestErrorText or "",
						fontStyle = v7.Typography.CaptionSmall,
						textStyle = v7.Color.System.Alert,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						padding = { bottom = UDim.new(0, v7.Size.Size_300) }
					})
				}),
				AccountListScrollView = module.createElement(scrollView, {
					LayoutOrder = 2,
					scroll = {
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = UDim2.new(1, 0, 0, 0),
						ScrollingDirection = Enum.ScrollingDirection.Y,
						scrollBarVisibility = visibility.Always
					},
					Size = UDim2.new(1, 0, 1, -state6.Y)
				}, {
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						Padding = UDim.new(0, v8.Size.Size_50)
					}),
					ProfilesList = module.createElement(module.Fragment, nil, fn(state, function(p3)
						module10.sendUserSelectedEvent(v5.state.recoverySessionId)

						if not getFFlagEnableContinueRecovery() then
							p2.navigation.navigate(module9.ResetPasswordScreen, {
								userID = p3,
								shouldAddContactMethod = state2
							})

							return
						end

						local function fn3()
							setState5(false)
							p2.navigation.navigate(module9.ResetPasswordScreen, {
								userID = p3,
								shouldAddContactMethod = state2
							})
						end
						local function fn4(p4)
							setState4(p4 or module11.UnknownErrorKey)
							setState5(false)
						end
						local function fn5()
							setState5(false)
						end

						setState5(true)
						setState4("")
						v5.utils.handleContinueRecovery(
							v5.state.recoverySessionId,
							p3,
							fn3,
							fn4,
							fn5,
							nil,
							nil,
							nil
						)
					end))
				})
			}
		)
	end

	children.Content = v24
	v18.Wrapper = createElement2("Frame", v20, children)
	return createElement(fullscreenPageWithSafeArea, v17, v18)
end
