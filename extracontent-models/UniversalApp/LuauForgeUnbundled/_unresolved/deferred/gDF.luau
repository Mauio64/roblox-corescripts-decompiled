local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local expandableTextArea = UIBlox.App.Text.ExpandableTextArea
local getCanExpand = UIBlox.Core.Text.ExpandableText.GetCanExpand
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize

local module = require("@luauforge/deferred/gDG")

local module2 = require("@luauforge/deferred/gDJ")
local contentThresholdImpressionsDetector = require("@luauforge/bundled/egA").ContentThresholdImpressionsDetector
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module4 = require("@luauforge/deferred/gDI")
local defineFastFlag = game:DefineFastFlag("LuaAppFixDescriptionImpressionExpanded", false)

local Foundation = require(CorePackages.Packages.Foundation)
local useCursor = Foundation.Hooks.useCursor

local v5 = { 0.01, 0.5, 1 }

local function NOOP_NEEDED_FOR_SELECTION() end

return function(props)
	local v6 = useCursor("RoundedRect")
	local v7 = useStyle()
	local v8 = useLocalization({
		DescriptionTitle = "Feature.ExperienceDetails.Body.DescriptionTitle"
	})

	local v9 = useAppPolicy(function(p2)
		return p2.enableExperienceDetailsPanel()
	end)

	local v10 = useDesignTokens(function(p2)
		if p2 then
			return p2.LuaApps.ExperienceDetails.PanelWidthScale
		end

		return 1
	end)

	local v11 = useDesignTokens(function(p2)
		if p2 then
			return p2.LuaApps.ExperienceDetails.PanelInnerPadding
		end

		return 0
	end)

	local v12 = props.dataStatus == retrievalStatus.Done
	local v13 = props.descriptionText and #props.descriptionText > 0

	local v14 = useDesignTokens(function(p2)
		return p2.Typography.BodyLarge
	end)

	local v15 = useDesignTokens(function(p2)
		return p2.Typography.HeadingSmall
	end)

	local lineHeight = v14.LineHeight
	local v16, font

	if module4 then
		v16 = v14.FontSize
		font = v14.Font
	else
		v16 = v7.Font.BaseSize * v7.Font.Body.RelativeSize
		font = v7.Font.Body.Font
	end

	local state, setState = React.useState(0)
	local v17 = state * v10
	local v18 = React.useMemo(function()
		if not v13 then
			return 0
		end

		local textSize = getTextSize(props.descriptionText, v16, font, Vector2.new(v17, 1e999))

		if props.expandable then
			return textSize.Y
		end

		return textSize.Y * lineHeight
	end, { props.descriptionText, v16, font, v17, lineHeight, props.expandable, v13 })

	local ref = React.useRef(false)
	local v19 = React.useCallback(function()
		ref.current = not ref.current
	end)

	local v20 = if defineFastFlag then React.useRef(nil) else nil

	local useCallback = React.useCallback
	local function fn(items)
		local v21 = nil

		if defineFastFlag and props.expandable then
			local x = v20.current and v20.current.AbsoluteSize.X or 0

			if x > 0 then
				v21 = getCanExpand(v7.Font, x, props.descriptionText, 3)
			end
		end

		for k, item in items do
			local v23 = {
				impressionThreshold = item * 100,
				isButtonExpanded = 0,
				interactionUuid = 0,
				contentType = "description",
				pageContext = 0,
				itemId = 0,
				componentType = 0
			}
			local current

			if defineFastFlag then
				if v21 then
					current = ref.current
				end
			elseif props.expandable then
				current = ref.current
			end

			v23.isButtonExpanded = current

			v23.interactionUuid = HttpService:GenerateGUID(false)

			v23.pageContext = props.pageContext
			v23.itemId = tonumber(props.universeId)
			v23.componentType = props.componentType or "unknown"
			module2(v23)
		end
	end

	local descriptionText = if defineFastFlag then props.descriptionText else nil

	local expandable = props.expandable
	local componentType = props.componentType
	local pageContext = props.pageContext
	local universeId = props.universeId
	local v23 = if defineFastFlag then v7.Font else nil
	local v24 = useCallback(fn, {
		descriptionText,
		ref,
		expandable,
		componentType,
		pageContext,
		universeId,
		v23
	})

	local formatted = `ExperienceDescription_{props.universeId}_{props.componentType}_{props.pageContext}`

	if not defineFastFlag then
		v20 = React.useRef(nil)
	end

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		if ref2.current then
			setState(ref2.current.AbsoluteSize.X)
		end
	end)

	if not (v12 and v13) then
		return nil
	end

	local v25

	if props.expandable then
		v25 = React.createElement(expandableTextArea, {
			Text = props.descriptionText,
			compactNumberOfLines = 3,
			padding = Vector2.new(0, 0),
			gradientColor = v7.Theme.BackgroundContrast.Color,
			onClick = v19
		})
	else
		local createElement = React.createElement
		local v27 = {
			text = props.descriptionText,
			size = UDim2.new(v10, 0, 0, v18),
			textYAlignment = Enum.TextYAlignment.Top,
			fontStyle = 0,
			colorStyle = 0,
			automaticSize = 0,
			lineHeight = 0,
			richText = false,
			fluidSizing = false
		}

		if not module4 then
			v14 = v7.Font.Body
		end

		v27.fontStyle = v14
		v27.colorStyle = v7.Theme.TextDefault
		local v28 = if not v9 then Enum.AutomaticSize.Y else nil
		v27.automaticSize = v28
		v27.lineHeight = lineHeight
		v25 = createElement(styledTextLabel, v27)
	end

	local createElement = React.createElement
	local v27 = {
		ref = ref2,
		[React.Change.AbsoluteSize] = function(p2)
			setState(p2.AbsoluteSize.X)
		end,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Selectable = true,
		[React.Event.SelectionGained] = NOOP_NEEDED_FOR_SELECTION,
		SelectionImageObject = v6
	}

	local v28 = if v9 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v11),
		PaddingTop = UDim.new(0, v11),
		PaddingRight = UDim.new(0, v11),
		PaddingBottom = UDim.new(0, v11)
	}) else nil
	local children = {
		Padding = v28,
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, props.listPadding or 24)
		}),
		Title = 0,
		Description = 0,
		ContentThresholdImpressionsDetector = 0
	}
	local v29

	if not v9 then
		local createElement2 = React.createElement
		local v31 = {
			text = props.headerText or v8.DescriptionTitle,
			size = UDim2.fromScale(1, 0),
			fontStyle = 0,
			colorStyle = 0,
			automaticSize = 0,
			richText = false,
			fluidSizing = false
		}

		if not module4 then
			v15 = v7.Font.Header1
		end

		v31.fontStyle = v15
		v31.colorStyle = v7.Theme.TextEmphasis
		v31.automaticSize = Enum.AutomaticSize.Y
		v29 = createElement2(styledTextLabel, v31)
	end

	children.Title = v29

	children.Description = React.createElement("Frame", {
		ref = v20,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}, { Body = v25 })

	children.ContentThresholdImpressionsDetector = React.createElement(contentThresholdImpressionsDetector, {
		containerRef = v20,
		fullContentHeight = v18,
		thresholds = v5,
		impressionsTag = formatted,
		sendImpressions = v24,
		viewportBoundsOffset = props.viewportBoundsOffset
	})
	local element = createElement("Frame", v27, children)

	if v9 then
		return React.createElement(module, {
			title = props.headerText or v8.DescriptionTitle,
			onFocusChanged = props.onFocusChanged
		}, element)
	end

	return element
end
