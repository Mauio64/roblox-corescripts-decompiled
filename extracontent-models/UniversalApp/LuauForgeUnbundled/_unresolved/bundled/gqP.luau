local module = require("@luauforge/bundled/gnx")
local module2 = require("@luauforge/bundled/gnz")
local module3 = require("@luauforge/bundled/gow")

local useDesignTokens = require("@luauforge/bundled/gox").useDesignTokens
local useRoactService = require("@luauforge/bundled/gnP").useRoactService
local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local fullscreenPageWithSafeArea = module3.FullscreenPageWithSafeArea
local useStyle = module2.Core.Style.useStyle

local module4 = require("@luauforge/bundled/goz")

local text = module4.Text
local button = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize
local useTokens = module4.Hooks.useTokens
local scrollView = module4.ScrollView
local visibility = module4.Enums.Visibility

local logger = require("@luauforge/bundled/gnM").Logger

local getUserById = require("@luauforge/bundled/gnT").Thunks.GetUserById

local useClearFocusOnUnmount = require("@luauforge/bundled/goA").useClearFocusOnUnmount

local module5 = require("@luauforge/bundled/gnU")
local module6 = require("@luauforge/bundled/goc")
local module7 = require("@luauforge/bundled/goH")
local module8 = require("@luauforge/bundled/goO")
local module9 = require("@luauforge/bundled/goK")

return function(p2)
	local v5 = module.useContext(module5)

	local v6 = useStyle()
	local v7 = useTokens()
	local v8 = useDesignTokens()
	local v9 = useRoactService(roactNetworking)

	local param = p2.navigation.getParam("userID")
	local v10 = p2.navigation.getParam("isConsole") or false
	local state, setState = module.useState("")
	local state2, setState2 = module.useState("")

	local state3, setState3 = module.useState(Vector2.new(0, 0))

	useClearFocusOnUnmount()

	module.useEffect(function()
		if param and param ~= 0 then
			getUserById(v9, `{param}`):andThen(function(p3)
				setState2(p3.name)
				setState(p3.displayName)
			end):catch(function(p3)
				logger:warning("Error getting user info: {}", p3)
			end)
		end
	end, {})

	local function fn(p3)
		if state3 ~= p3.AbsoluteSize then
			setState3(p3.AbsoluteSize)
		end
	end

	local v11 = useLocalization({
		useAnotherDeviceHeadingText = "Authentication.AccountRecovery.Heading.UseAnotherDevice",
		cannotRecoverAccountHeadingText = "Authentication.AccountRecovery.Heading.CannotRecoverAccount",
		bodyText = "Authentication.AccountRecovery.Description.CannotRecoverAccount",
		platformNotSupportedText = "Authentication.AccountRecovery.Description.PlatformNotSupported",
		okButtonText = "Authentication.AccountRecovery.Action.Ok"
	})

	local createElement = module.createElement
	local v13 = {
		includeStatusBar = true,
		BackgroundColor3 = v6.Theme.BackgroundDefault.Color
	}
	local v14 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v8.Size.Size_200),
			PaddingLeft = UDim.new(0, v8.Size.Size_300),
			PaddingRight = UDim.new(0, v8.Size.Size_300),
			PaddingBottom = UDim.new(0, v8.Size.Size_200)
		}),
		Wrapper = 0
	}

	local createElement2 = module.createElement
	local v16 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local createElement3 = module.createElement
	local v18 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v8.Size.Size_500),
		HorizontalAlignment = 0
	}
	local v19 = if module9() then Enum.HorizontalAlignment.Center else nil
	v18.HorizontalAlignment = v19
	local children = {
		UIListLayout = createElement3("UIListLayout", v18),
		PreScrollContent = module.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			[module.Change.AbsoluteSize] = fn
		}, {
			Header = module.createElement(module7, {
				LayoutOrder = 1,
				recoveryHeadingText = v10 and v11.useAnotherDeviceHeadingText or v11.cannotRecoverAccountHeadingText,
				currentComponent = "cannotRecoverAccount",
				recoverySessionId = v5.state.recoverySessionId
			})
		}),
		ContentScrollView = 0
	}

	local createElement5 = module.createElement
	local v22 = {
		LayoutOrder = 2,
		sizeConstraint = module9() and {
			MaxSize = Vector2.new(module6.ContentMaxWidth, 1e999)
		} or nil,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = visibility.Auto
		},
		Size = UDim2.new(1, 0, 1, -state3.Y)
	}
	local children2 = {
		UIPadding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v8.Size.Size_200),
			PaddingRight = UDim.new(0, v8.Size.Size_200)
		}),
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v8.Size.Size_50)
		}),
		UserHeader = 0,
		Body = 0,
		OkButton = 0
	}
	local v23

	if param then
		if param == 0 then
			v23 = false
		else
			v23 = module.createElement(module8, {
				LayoutOrder = 1,
				userId = `{param}`,
				displayName = state,
				username = state2
			})
		end
	else
		v23 = param
	end

	children2.UserHeader = v23

	children2.Body = module.createElement(text, {
		LayoutOrder = 2,
		Text = v10 and v11.platformNotSupportedText or v11.bodyText,
		TextWrapped = true,
		fontStyle = v7.Typography.BodyMedium,
		textStyle = v7.Color.Content.Default,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		padding = {
			top = UDim.new(0, v7.Size.Size_300),
			bottom = UDim.new(0, v7.Size.Size_300)
		}
	})

	children2.OkButton = module.createElement(button, {
		LayoutOrder = 3,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		text = v11.okButtonText,
		width = UDim.new(1, 0),
		onActivated = function()
			v5.parentNavigation.goBack()
		end
	})
	children.ContentScrollView = createElement5(scrollView, v22, children2)
	v14.Wrapper = createElement2("Frame", v16, children)
	return createElement(fullscreenPageWithSafeArea, v13, v14)
end
