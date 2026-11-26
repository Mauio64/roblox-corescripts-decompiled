local module = require("@luauforge/bundled/gsU")
local module2 = require("@luauforge/bundled/gsR")
local roact = module.Roact
local uiBlox = module.UIBlox
local foundation = module.Foundation
local checkbox = foundation.Checkbox
local text = foundation.Text
local icon = foundation.Icon
local enums = foundation.Enums
local normalizeFontFace = foundation.Utility.normalizeFontFace

local withLocalization = module.Localization.withLocalization
local withStyle = uiBlox.Core.Style.withStyle

local t = module.t
local fitFrame = module.FitFrame
local module3 = require("@luauforge/bundled/gti")
local fFlagEnableModularizedUserAgreementsList = module.SharedFlags.FFlagEnableModularizedUserAgreementsList
local getFFlagVngTOSRevisedEnabled = module.SharedFlags.GetFFlagVngTOSRevisedEnabled
local defineFastFlag = game:DefineFastFlag("AgreementItemsOrderFixEnabled", false)

local v5 = { REQUIRED = "REQUIRED", OPTIONAL = "OPTIONAL" }

local extended = roact.PureComponent:extend("UserAgreementsList")

extended.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.integer),
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string,
		agreementBodyText = t.optional(t.string)
	})),
	checkBoxStates = t.optional(t.map(t.string, t.boolean)),
	setCheckBoxStates = t.optional(t.callback),
	separateRequiredOptional = t.optional(t.boolean),
	margin = t.optional(t.strictInterface({
		top = t.integer,
		right = t.integer,
		bottom = t.integer,
		left = t.integer
	})),
	verticalSpaceOffset = t.optional(t.integer),
	isAgreeAllChecked = t.optional(t.boolean),
	useScrollableFrame = t.optional(t.boolean),
	disableInnerScrolling = t.optional(t.boolean),
	useMutedCheckboxText = t.optional(t.boolean),
	useExternalLinkArrowForAgreementRows = t.optional(t.boolean),
	agreementTitleKeys = t.optional(t.map(t.string, t.string)),
	agreementTypeOrder = t.optional(t.map(t.string, t.integer)),
	listItemHeight = t.optional(t.integer),
	horizontalPadding = t.optional(t.integer),
	checkboxLabelGap = t.optional(t.integer),
	useLabelMediumSectionTitles = t.optional(t.boolean),
	useContrastUncheckedCheckbox = t.optional(t.boolean),
	useChevronArrow = t.optional(t.boolean),
	useBoldTitle = t.optional(t.boolean),
	requiredSectionEndRef = t.optional(t.union(t.table, t.callback))
})

extended.defaultProps = { margin = fitFrame.Rect.square(0) }

function LUAUFORGE_MODULE_GLOBALS_gsT_shouldCreateRowsForAgreementType(p2, p3): boolean
	local agreementType = p2.agreementType
	local v6 = string.find(agreementType:lower(), "optional")

	if tostring(p3) == tostring("REQUIRED") and not v6 or tostring(p3) == tostring("OPTIONAL") and v6 then
		return true
	end

	return false
end

function LUAUFORGE_MODULE_GLOBALS_gsT_updateTable(p2, p3, p4)
	local clone = table.clone(p2)
	clone[p3] = p4
	return clone
end

function LUAUFORGE_MODULE_GLOBALS_gsT_sortAgreementsByType(list, p2)
	local v6 = {}

	for i, item in ipairs(list) do
		v6[item] = i
	end

	local clone = table.clone(list)
	table.sort(clone, function(a, b): boolean
		local v7 = p2[a.agreementType] or 1e999
		local v8 = p2[b.agreementType] or 1e999

		if v7 == v8 then
			return v6[a] < v6[b]
		end

		return v7 < v8
	end)

	return clone
end

local function createContrastStrokeCheckbox(props, p2, fn)
	local color3 = props.Color.Stroke.Default.Color3
	local background = props.Color.ActionSubEmphasis.Background
	local createElement = roact.createElement
	local v7 = {}
	v7.Size = UDim2.fromOffset(props.Size.Size_600, props.Size.Size_600)
	local v8 = if p2 then background.Color3 else Color3.new(1, 1, 1)
	v7.BackgroundColor3 = v8
	v7.BackgroundTransparency = not p2 and 1 or background.Transparency
	v7.AutoButtonColor = false
	v7.BorderSizePixel = 0
	v7[roact.Event.Activated] = fn
	local v9 = {
		UICorner = roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.Radius.Small)
		}),
		UIStroke = 0,
		Check = 0
	}

	local createElement2 = roact.createElement

	if p2 then
		color3 = background.Color3
	end

	v9.UIStroke = createElement2("UIStroke", {
		Color = color3,
		Transparency = not p2 and 0.6 or background.Transparency,
		Thickness = 1
	})

	local v12 = if p2 then roact.createElement(icon, {
		name = enums.IconName.Check,
		size = enums.IconSize.Small,
		style = props.Color.ActionSubEmphasis.Foreground,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}) else nil
	v9.Check = v12
	return createElement("ImageButton", v7, v9)
end

function extended:getListItemsWithCheckBoxes(p3, count, p4, p5, p6, callback)
	local agreements = {}

	if self.props.agreementTypeOrder then
		agreements = LUAUFORGE_MODULE_GLOBALS_gsT_sortAgreementsByType(
			self.props.agreements,
			self.props.agreementTypeOrder
		)
	else
		for k, agreement in pairs(self.props.agreements) do
			table.insert(agreements, agreement)
		end
	end

	local horizontalPadding = self.props.horizontalPadding or p5.Size.Size_600
	local checkboxLabelGap = self.props.checkboxLabelGap or p5.Size.Size_400
	local listItemHeight = self.props.listItemHeight or 55
	local v6 = horizontalPadding + p5.Size.Size_600
	local v7 = not self.props.listItemHeight and 0 or -p5.Size.Size_600

	local v8 = {}
	local v9 = {}

	for i, v10 in ipairs(agreements) do
		local agreementType = v10.agreementType

		if module2.CheckAgreementTypeExists(agreementType) then
			table.insert(v8, v10)
		else
			table.insert(v9, v10)
		end
	end

	local v10 = { true, false }
	local children = {}

	for i, list in ipairs({ v8, v9 }) do
		for j, item in ipairs(list) do
			local v11 = v10[i]
			local v12 = p6[item.id]

			if not LUAUFORGE_MODULE_GLOBALS_gsT_shouldCreateRowsForAgreementType(item, p4) then
				continue
			end

			count += 1

			local v13 = "Item." .. item.id
			local createElement = roact.createElement
			local v15 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = count
			}

			local children2 = {
				Layout = roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				CheckboxFrame = 0,
				AgreementRow = 0
			}

			local createElement2 = roact.createElement
			local v17 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v6, 1, 0),
				LayoutOrder = 0
			}

			local v18 = {
				Padding = roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, horizontalPadding),
					PaddingTop = UDim.new(0, self.props.listItemHeight and 0 or p5.Size.Size_300)
				}),
				Layout = 0,
				Checkbox = 0
			}

			local v19 = if self.props.listItemHeight then roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center
			}) else nil
			v18.Layout = v19
			local v20

			if self.props.useContrastUncheckedCheckbox then
				local v21 = item
				v20 = createContrastStrokeCheckbox(p5, v12, function()
					local v22 = not v12

					callback(LUAUFORGE_MODULE_GLOBALS_gsT_updateTable(p6, v21.id, v22), v21.id, v22)
				end)
			else
				local v21 = item
				v20 = roact.createElement(checkbox, {
					Size = UDim2.new(1, 0, 1, 0),
					label = "",
					isChecked = v12,
					onActivated = function()
						local v22 = not v12

						callback(LUAUFORGE_MODULE_GLOBALS_gsT_updateTable(p6, v21.id, v22), v21.id, v22)
					end
				})
			end

			v18.Checkbox = v20
			children2.CheckboxFrame = createElement2("Frame", v17, v18)

			local createElement3 = roact.createElement

			local v23 = if not getFFlagVngTOSRevisedEnabled() then UDim2.new(1, v7, 0, listItemHeight) else nil

			local v24 = if getFFlagVngTOSRevisedEnabled() then listItemHeight else nil
			local v25 = if getFFlagVngTOSRevisedEnabled() then v7 else nil
			children2.AgreementRow = createElement3(module3, {
				LayoutOrder = count,
				Size = v23,
				minHeight = v24,
				widthOffset = v25,
				agreement = item,
				agreementTitleKey = self.props.agreementTitleKeys and self.props.agreementTitleKeys[item.agreementType],
				agreementTypeExists = v11,
				margin = fitFrame.Rect.quad(0, horizontalPadding, 0, checkboxLabelGap),
				hideLink = true,
				checkBoxPresent = true,
				useMutedText = self.props.useMutedCheckboxText,
				useExternalLinkArrow = self.props.useExternalLinkArrowForAgreementRows
			})
			children[v13] = createElement("Frame", v15, children2)
		end
	end

	return children
end

function LUAUFORGE_MODULE_GLOBALS_gsT_getTableCount(items)
	local count = 0

	for k in pairs(items) do
		count += 1
	end

	return count
end

function LUAUFORGE_MODULE_GLOBALS_gsT_setLayoutOrder(items, value)
	assert(type(value) == "number", "Expected 'start' to be a number")
	local count = 0
	local result = {}

	for k, item in pairs(items) do
		for k2 in pairs(item.props) do
			if k2 ~= "LayoutOrder" then
				continue
			end

			count += 1
			item.props.LayoutOrder = value + count
			table.insert(result, item)
		end
	end

	return result
end

local function setLayoutOrderPreservingExistingOrder(items, p2)
	local v6 = {}

	for k, item in pairs(items) do
		if item.props and item.props.LayoutOrder ~= nil then
			table.insert(v6, item)
		end
	end

	table.sort(v6, function(a, b): boolean
		return a.props.LayoutOrder < b.props.LayoutOrder
	end)

	for i, v7 in ipairs(v6) do
		v7.props.LayoutOrder = p2 + i
	end

	return items
end

function extended:getListItems(p3)
	local margin = self.props.margin
	local agreements = self.props.agreements

	local agreements2 = {}
	local agreements3 = {}

	for i, agreement in ipairs(agreements) do
		local agreementType = agreement.agreementType

		if module2.CheckAgreementTypeExists(agreementType) then
			table.insert(agreements2, agreement)
		else
			table.insert(agreements3, agreement)
		end
	end

	local v6 = { true, false }
	local count = 0
	local children = {}

	for i, list in ipairs({ agreements2, agreements3 }) do
		for j, item in ipairs(list) do
			local v7 = v6[i]

			count += 1

			if defineFastFlag then
				local createElement = roact.createElement

				local v10 = if not getFFlagVngTOSRevisedEnabled() then UDim2.new(1, 0, 0, 55) else nil
				local v9 = {
					LayoutOrder = count,
					Size = v10,
					minHeight = getFFlagVngTOSRevisedEnabled() and 55 or nil,
					agreement = item,
					agreementTypeExists = v7,
					margin = fitFrame.Rect.quad(0, margin.right, 0, margin.left),
					useChevronArrow = self.props.useChevronArrow,
					useBoldTitle = self.props.useBoldTitle
				}
				table.insert(children, (createElement(module3, v9)))
			else
				local v8 = "Item." .. item.id
				local createElement = roact.createElement

				local v11 = if not getFFlagVngTOSRevisedEnabled() then UDim2.new(1, 0, 0, 55) else nil
				children[v8] = createElement(module3, {
					LayoutOrder = count,
					Size = v11,
					minHeight = getFFlagVngTOSRevisedEnabled() and 55 or nil,
					agreement = item,
					agreementTypeExists = v7,
					margin = fitFrame.Rect.quad(0, margin.right, 0, margin.left),
					useChevronArrow = self.props.useChevronArrow,
					useBoldTitle = self.props.useBoldTitle
				})
			end
		end
	end

	return children
end

function extended:checkBoxPropsExist(): boolean
	return self.props.checkBoxStates ~= nil
		and self.props.setCheckBoxStates ~= nil
		and self.props.isAgreeAllChecked ~= nil
end

function extended:shouldReturnScrollableFrame()
	local useScrollableFrame = self.props.useScrollableFrame or false
	return fFlagEnableModularizedUserAgreementsList and useScrollableFrame
end

function extended:render()
	return withStyle(function(p2)
		local theme = p2.Theme
		local layoutOrder = self.props.LayoutOrder
		local margin = self.props.margin
		local listItems = self:getListItems(theme)

		if not self:shouldReturnScrollableFrame() then
			return roact.createElement(fitFrame.FitFrameVertical, {
				LayoutOrder = layoutOrder,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				margin = fitFrame.Rect.quad(margin.top, 0, margin.bottom, 0)
			}, listItems)
		end

		local separateRequiredOptional = self.props.separateRequiredOptional or false
		local verticalSpaceOffset = self.props.verticalSpaceOffset or 0
		local tokens = p2.Tokens

		local v7 = {}
		local v8

		if self:checkBoxPropsExist() then
			v8 = self:getListItemsWithCheckBoxes(
				theme,
				0,
				"REQUIRED",
				tokens,
				self.props.checkBoxStates,
				self.props.setCheckBoxStates
			)

			v7 = self:getListItemsWithCheckBoxes(
				theme,
				LUAUFORGE_MODULE_GLOBALS_gsT_getTableCount(listItems),
				"OPTIONAL",
				tokens,
				self.props.checkBoxStates,
				self.props.setCheckBoxStates
			)
		else
			v8 = self:getListItems(theme)
		end

		local v9, v10

		if self.props.agreementTypeOrder then
			v9 = setLayoutOrderPreservingExistingOrder(v8, 1)
			v10 = setLayoutOrderPreservingExistingOrder(
				v7,
				LUAUFORGE_MODULE_GLOBALS_gsT_getTableCount(listItems) + 4
			)
		else
			v9 = LUAUFORGE_MODULE_GLOBALS_gsT_setLayoutOrder(v8, 1)
			v10 = LUAUFORGE_MODULE_GLOBALS_gsT_setLayoutOrder(
				v7,
				LUAUFORGE_MODULE_GLOBALS_gsT_getTableCount(listItems) + 4
			)
		end

		local disableInnerScrolling = self.props.disableInnerScrolling or false
		local v11 = disableInnerScrolling and "Frame" or "ScrollingFrame"
		local v12 = {
			LayoutOrder = layoutOrder,
			Size = 0,
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			ScrollingEnabled = 0,
			BorderSizePixel = 0,
			CanvasSize = 0,
			ScrollingDirection = 0,
			ScrollBarThickness = 0
		}

		local v13 = if disableInnerScrolling then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 1, -verticalSpaceOffset)
		v12.Size = v13

		local v14 = if disableInnerScrolling then Enum.AutomaticSize.Y else nil
		v12.AutomaticSize = v14

		v12.ScrollingEnabled = not disableInnerScrolling or nil

		local v15 = if not disableInnerScrolling then UDim2.new(1, 0, 1, 0) else nil
		v12.CanvasSize = v15
		local v16 = if not disableInnerScrolling then Enum.ScrollingDirection.Y else nil
		v12.ScrollingDirection = v16
		v12.ScrollBarThickness = not disableInnerScrolling and 2 or nil
		return withLocalization({
			required = "CommonUI.UserAgreements.Popup.Agreement.Required",
			optional = "CommonUI.UserAgreements.Popup.Agreement.Optional"
		})(function(p3)
			local createElement = roact.createElement
			local v19 = {
				UIListLayout = roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				RequiredTitleText = 0,
				ItemsRequired = 0,
				RequiredSectionEnd = 0,
				OptionalTitleText = 0,
				OptionalItems = 0
			}

			local v20 = separateRequiredOptional

			if v20 then
				local createElement2 = roact.createElement
				local v22 = {
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}

				local createElement3 = roact.createElement
				local v25 = {
					PaddingLeft = UDim.new(0, self.props.horizontalPadding or tokens.Size.Size_600),
					PaddingTop = UDim.new(0, disableInnerScrolling and 0 or tokens.Size.Size_200),
					PaddingBottom = 0
				}
				local newUDim = UDim.new

				local v27 = if self.props.listItemHeight then tokens.Size.Size_300 else tokens.Size.Size_200
				v25.PaddingBottom = newUDim(0, v27)
				local v23 = {
					Padding = createElement3("UIPadding", v25),
					TextLabel = 0
				}
				local v28

				if self.props.useLabelMediumSectionTitles then
					v28 = roact.createElement(text, {
						tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
						Text = p3.required
					})
				else
					v28 = roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = p3.required,
						TextSize = tokens.FontSize.FontSize_400,
						TextColor3 = tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p2.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(tokens.Typography.HeadingSmall.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0)
					})
				end

				v23.TextLabel = v28
				v20 = createElement2("Frame", v22, v23)
			end

			v19.RequiredTitleText = v20

			v19.ItemsRequired = roact.createFragment(v9)
			local v21

			if self.props.requiredSectionEndRef then
				v21 = roact.createElement("Frame", {
					LayoutOrder = LUAUFORGE_MODULE_GLOBALS_gsT_getTableCount(listItems) + 1,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[roact.Ref] = self.props.requiredSectionEndRef
				})
			end

			v19.RequiredSectionEnd = v21

			local v22 = separateRequiredOptional

			if v22 then
				local createElement2 = roact.createElement
				local v24 = {
					LayoutOrder = LUAUFORGE_MODULE_GLOBALS_gsT_getTableCount(listItems) + 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}

				local createElement3 = roact.createElement
				local v27 = {
					PaddingLeft = UDim.new(0, self.props.horizontalPadding or tokens.Size.Size_600),
					PaddingTop = 0,
					PaddingBottom = 0
				}
				local newUDim = UDim.new

				local v29 = if self.props.listItemHeight then tokens.Size.Size_500 else tokens.Size.Size_200
				v27.PaddingTop = newUDim(0, v29)

				local newUDim2 = UDim.new

				local v31 = if self.props.listItemHeight then tokens.Size.Size_300 else tokens.Size.Size_200
				v27.PaddingBottom = newUDim2(0, v31)
				local v25 = {
					Padding = createElement3("UIPadding", v27),
					TextLabel = 0
				}
				local v32

				if self.props.useLabelMediumSectionTitles then
					v32 = roact.createElement(text, {
						tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
						Text = p3.optional
					})
				else
					v32 = roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = p3.optional,
						TextSize = tokens.FontSize.FontSize_400,
						TextColor3 = tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p2.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(tokens.Typography.HeadingSmall.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0)
					})
				end

				v25.TextLabel = v32
				v22 = createElement2("Frame", v24, v25)
			end

			v19.OptionalTitleText = v22

			v19.OptionalItems = separateRequiredOptional and roact.createFragment(v10)
			return createElement(v11, v12, v19)
		end)
	end)
end

return extended
