local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/bundled/fTi")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSheetNavigation = Foundation.Hooks.useSheetNavigation

local image = Foundation.Image
local loading = Foundation.Loading
local text = Foundation.Text
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize

local color = Color3.fromHex("#FFFFFF")

local function spaceOutCode(deviceCode)
	local v5 = {}

	for k in string.gmatch(deviceCode, ".") do
		table.insert(v5, k)
	end

	return table.concat(v5, " ")
end

local function QuickSignInSheetView(props)
	local v5 = useDesignTokens()
	local v6 = module({
		instructions = "Authentication.CrossDevice.Description.QuickSignInInstructionsModal",
		havingTrouble = "Authentication.Login.Label.TroubleSigningIn"
	})

	local v7 = useSheetNavigation()
	local ref = React.useRef(nil)
	local contentStartRef = props.contentStartRef or ref
	local setContentStartRef = v7.setContentStartRef
	React.useEffect(function()
		setContentStartRef(contentStartRef)
	end, { setContentStartRef, contentStartRef })

	local v8 = math.max(148, v5.LuaApps.LoginView.qrWidth)
	local qrCodeUrl = props.qrCodeUrl
	local deviceCode = props.deviceCode
	local v9 = not (deviceCode == nil) and deviceCode ~= ""

	local createElement = React.createElement

	local createElement2 = React.createElement

	local v14 = {
		InstructionText = React.createElement(text, {
			LayoutOrder = 1,
			Text = v6.instructions,
			RichText = true,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
		}),
		HavingTroubleLink = 0
	}

	local v15 = if props.renderNeedHelpButton then props.renderNeedHelpButton({
		contentStartRef = contentStartRef,
		onBeforeActivated = props.onHavingTroubleActivated
	}) else React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "auto-xy",
			onActivated = props.onHavingTroubleActivated,
			ref = contentStartRef
		},
		{
			Label = React.createElement(text, {
				Text = `<u>{v6.havingTrouble}</u>`,
				RichText = true,
				tag = "auto-xy text-label-small content-default"
			})
		}
	)
	v14.HavingTroubleLink = v15
	local children = {
		Instructions = createElement2(
			view,
			{ LayoutOrder = 1, tag = "col gap-small size-full-0 auto-y" },
			v14
		),
		QrAndCode = 0
	}

	local createElement3 = React.createElement

	local v19 = if qrCodeUrl then React.createElement(
		view,
		{
			LayoutOrder = 1,
			tag = "row align-x-center size-full-0 auto-y padding-x-xxlarge"
		},
		{
			QrCard = React.createElement(view, {
				tag = "col auto-xy padding-x-medium padding-y-large radius-medium",
				backgroundStyle = { Color3 = color, Transparency = 0 }
			}, {
				QrImage = React.createElement(image, {
					Image = qrCodeUrl,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.fromOffset(v8, v8)
				})
			})
		}
	) else nil

	local createElement4 = React.createElement

	local v23 = if v9 then React.createElement(text, {
		Text = spaceOutCode(deviceCode),
		tag = "auto-xy text-heading-medium text-align-x-center content-emphasis"
	}) else nil

	local v24 = if not v9 then React.createElement(loading, { size = iconSize.Small }) else nil
	children.QrAndCode = createElement3(
		view,
		{ LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y" },
		{
			QrCode = v19,
			Code = createElement4(
				view,
				{ LayoutOrder = 2, tag = "row align-x-center size-full-0 auto-y" },
				{ CodeText = v23, CodeSpinner = v24 }
			)
		}
	)
	return createElement(view, { tag = "col gap-xlarge size-full-0 auto-y" }, children)
end

return QuickSignInSheetView
