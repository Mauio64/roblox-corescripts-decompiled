local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjR")
local module3 = require("@luauforge/bundled/gjJ")
local useModalFocus = require("@luauforge/bundled/gkd").useModalFocus
local fFlagLoginV2ModalFocusNavigation = require("@luauforge/bundled/gjO").FFlagLoginV2ModalFocusNavigation

local fullscreenPageWithSafeArea = module2.FullscreenPageWithSafeArea
local sheet = module3.Sheet
local dialogSize = module3.Enums.DialogSize

local function noop() end

local function LoginV2ModalPageView(props)
	local v5

	if fFlagLoginV2ModalFocusNavigation then
		v5 = useModalFocus(props.useModalLayout and not (props.isPageObscured or props.isCoveredByDialog))
	end

	local v6

	if not (props.useModalLayout and props.isPageObscured) then
		if props.useModalLayout then
			v6 = { Sheet = 0 }
			local createElement = module.createElement
			local root = sheet.Root
			local v7 = {
				preferCenterSheet = true,
				snapPoints = { 1 },
				size = dialogSize.Medium,
				onClose = props.onClose or noop,
				ref = v5
			}

			local v9 = if props.header then module.createElement(
				sheet.Header,
				{ hasCloseAffordance = false },
				props.header
			) else nil
			v6.Sheet = createElement(root, v7, {
				Header = v9,
				Content = module.createElement(sheet.Content, nil, {
					Body = module.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						},
						props.children
					)
				})
			})
		else
			v6 = props.children
		end
	end

	return module.createElement(
		fullscreenPageWithSafeArea,
		{
			includeStatusBar = true,
			BackgroundColor3 = props.backgroundColor3,
			BackgroundTransparency = props.backgroundTransparency
		},
		v6
	)
end

return LoginV2ModalPageView
