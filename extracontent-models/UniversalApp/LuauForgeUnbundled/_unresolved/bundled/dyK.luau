local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/duf")
local normalizeFontFace = require("@luauforge/bundled/dvi").Utility.normalizeFontFace
local useStyle = module2.Core.Style.useStyle
local useSelector = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useSelector
local module3 = require("@luauforge/bundled/dtM")
local extractAndStyleRichTextLinks = module3.extractAndStyleRichTextLinks
local useDispatch = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useDispatch
local appLinking = require("@luauforge/bundled/dum").AppLinking
local useRoactService = require("@luauforge/bundled/dvr").useRoactService
local module4 = require("@luauforge/bundled/duY")
local setCentralOverlay = module4.Actions.SetCentralOverlay
local closeCentralOverlay = module4.Thunks.CloseCentralOverlay
local centralOverlayType = require("@luauforge/bundled/dup").CentralOverlayType
local safetyResourceBannerAction = require("@luauforge/bundled/dtq").Constants.SafetyResourceBannerAction
local signal = require("@luauforge/bundled/dua").Signal
local module5 = require("@luauforge/bundled/dvd")
local useImpressionsTagger = module5.useImpressionsTagger
local screenSizeImpressionsDetector = module5.ScreenSizeImpressionsDetector
local module6 = require("@luauforge/bundled/dyL")
local fFlagSafetyResourceBannerTelemetry = require("@luauforge/bundled/dtD").FFlagSafetyResourceBannerTelemetry

return function(props)
	local v5 = useStyle()
	local font = v5.Font
	local v6 = font.BaseSize * font.Header2.RelativeSize

	local v7 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local state, setState = module.useState(v7)
	local function fn(p2)
		if p2 then
			setState(p2.AbsoluteSize)
		end
	end

	local v8 = state.X and module3.getPageSideMargin(state.X) or 0
	local sidePadding = props.sidePadding or v8

	local v9 = useRoactService(appLinking)

	local v10 = module.useMemo(function()
		local v11, v12 = extractAndStyleRichTextLinks(props.text)

		local v14 = if #v11 > 0 then v11[1] else nil
		return { link = v14, styledText = v12 }
	end, { props.text })

	local v11 = useDispatch()

	local v12 = nil
	local v13, ref, ref2

	if fFlagSafetyResourceBannerTelemetry then
		v13 = module6(props.safetyResourceTelemetry, v10.link)
		ref = module.useRef(nil)
		ref2 = module.useRef(signal.new())

		local safetyResourceTelemetry = props.safetyResourceTelemetry

		if safetyResourceTelemetry and v10.link then
			v12 = `SafetyResourceBanner_{safetyResourceTelemetry.textFilterRequestId}_{safetyResourceTelemetry.surface}`
		end

		useImpressionsTagger(ref, v12, 1)

		module.useEffect(function()
			if ref2 == nil or v12 == nil then
				return
			end

			ref2.current:fire()
		end, { v12 })
	else
		v13 = nil
		ref2 = nil
	end

	local useCallback = module.useCallback
	local function fn2()
		if fFlagSafetyResourceBannerTelemetry then
			v13.sendEvent(safetyResourceBannerAction.LinkTapped)
		end

		v11(setCentralOverlay(centralOverlayType.LeaveRobloxAlert, {
			continueFunc = function()
				if fFlagSafetyResourceBannerTelemetry then
					v13.sendEvent(safetyResourceBannerAction.Continue)
				end

				v9:openURL(v10.link)
				v11(closeCentralOverlay())
			end
		}))
	end

	local link = v10.link
	local v15 = if fFlagSafetyResourceBannerTelemetry then v13 else nil
	local v17 = useCallback(fn2, {
		link,
		v11,
		v15,
		if fFlagSafetyResourceBannerTelemetry then v9 else nil
	})

	local createElement = module.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 0, 32),
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = v5.Theme.BackgroundContrast.Transparency,
		BackgroundColor3 = v5.Theme.BackgroundContrast.Color,
		BorderSizePixel = 0,
		ref = ref,
		[module.Change.AbsoluteSize] = fn
	}
	local v20 = {
		Padding = module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sidePadding),
			PaddingRight = UDim.new(0, sidePadding),
			PaddingTop = UDim.new(0, 16),
			PaddingBottom = UDim.new(0, 16)
		}),
		BannerText = 0,
		ImpressionsDetector = 0
	}

	local createElement2 = module.createElement
	local v22 = {
		["AutomaticSize"] = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		RichText = true,
		Size = UDim2.new(1, 0, 0, 32),
		Text = v10.styledText,
		TextSize = v6,
		FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = v5.Theme.TextEmphasis.Color,
		Active = v10.link ~= nil,
		Selectable = v10.link ~= nil
	}
	local activated = module.Event.Activated

	if not v10.link then
		v17 = nil
	end

	v22[activated] = v17
	v20.BannerText = createElement2("TextButton", v22)
	local v23

	if fFlagSafetyResourceBannerTelemetry and v12 and v13 and ref2 then
		v23 = module.createElement(screenSizeImpressionsDetector, {
			impressionsTag = v12,
			onRequestImpressionsSignal = ref2.current,
			filterImpressionFunc = v13.filterImpressionFunc,
			onImpressionsDetected = function(p2)
				v13.onImpressed()
			end,
			skipZeroSizes = true
		})
	end

	v20.ImpressionsDetector = v23
	return createElement("Frame", v19, v20)
end
