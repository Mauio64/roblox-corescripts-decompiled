local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local UserAgreementUtils = require(ParentParent.UserAgreementUtils)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Checkbox = dependencies.Foundation.Checkbox
local withLocalization = dependencies.Localization.withLocalization
local withStyle = UIBlox.Core.Style.withStyle
local t = dependencies.t
local FitFrame = dependencies.FitFrame
local UserAgreementsListItem = require(script.Parent.UserAgreementsListItem)
local FFlagEnableModularizedUserAgreementsList = dependencies.SharedFlags.FFlagEnableModularizedUserAgreementsList
local GetFFlagVngTOSRevisedEnabled = dependencies.SharedFlags.GetFFlagVngTOSRevisedEnabled
local v14 = game:DefineFastFlag("AgreementItemsOrderFixEnabled", false)
local _ = {
	REQUIRED = "REQUIRED",
	OPTIONAL = "OPTIONAL"
}
local v16 = Roact.PureComponent:extend("UserAgreementsList")

v16.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.integer),
	agreements = t.array(t.strictInterface({
		id = t.string,
		agreementType = t.string,
		clientType = t.string,
		displayUrl = t.string,
		regulationType = t.string
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
	useScrollableFrame = t.optional(t.boolean)
})
v16.defaultProps = {
	margin = FitFrame.Rect.square(0)
}

function shouldCreateRowsForAgreementType(p1, p2) -- line: 55
	local agreementType = p1.agreementType
	local v20 = string.find(agreementType:lower(), "optional")

	if tostring(p2) == tostring("REQUIRED") and not v20 or tostring(p2) == tostring("OPTIONAL") and v20 then
		return true
	end

	return false
end
function updateTable(p3, p4, p5) -- line: 70
	local v24 = table.clone(p3)

	v24[p4] = p5

	return v24
end
function v16.getListItemsWithCheckBoxes(p6, _, p8, p9, p10, p11, p12) -- line: 78
	-- upvalues: UserAgreementUtils (copy), Roact (copy), Checkbox (copy), UserAgreementsListItem (copy), GetFFlagVngTOSRevisedEnabled (copy), FitFrame (copy)
	local agreements = p6.props.agreements
	local t1 = {}
	local t2 = {}

	for _, v in pairs(agreements) do
		local agreementType = v.agreementType

		if UserAgreementUtils.CheckAgreementTypeExists(agreementType) then
			table.insert(t1, v)
		else
			table.insert(t2, v)
		end
	end

	local t3 = {}

	for i, v in ipairs({
		t1,
		t2
	}) do
		for _, v2 in pairs(v) do
			local v43 = ({
				true,
				false
			})[i]
			local v44 = p11[v2.id]

			if shouldCreateRowsForAgreementType(v2, p9) then
				p8 += 1
				t3["Item." .. v2.id] = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = p8
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					CheckboxFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 0,
						Size = UDim2.new(0, p10.Size.Size_1200, 1, 0)
					}, {
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, p10.Size.Size_600),
							PaddingTop = UDim.new(0, p10.Size.Size_300)
						}),
						Checkbox = Roact.createElement(Checkbox, {
							label = "",
							Size = UDim2.new(1, 0, 1, 0),
							isChecked = v44,
							onActivated = function() -- line: 140
								-- upvalues: v44 (copy), p11 (copy), v2 (copy), p12 (copy)
								local v76 = not v44
								local v77 = updateTable(p11, v2.id, v76)

								p12(v77, v2.id, v76)
							end
						})
					}),
					AgreementRow = Roact.createElement(UserAgreementsListItem, {
						hideLink = true,
						checkBoxPresent = true,
						LayoutOrder = p8,
						Size = if GetFFlagVngTOSRevisedEnabled() then nil else UDim2.new(1, 0, 0, 55),
						minHeight = if not GetFFlagVngTOSRevisedEnabled() then nil else 55,
						agreement = v2,
						agreementTypeExists = v43,
						margin = FitFrame.Rect.quad(0, p10.Size.Size_600, 0, p10.Size.Size_400)
					})
				})
			end
		end
	end

	return t3
end
function getTableCount(p13) -- line: 168
	local n1 = 0

	for _ in pairs(p13) do
		n1 += 1
	end

	return n1
end
function setLayoutOrder(p14, p15) -- line: 177
	assert(type(p15) == "number", "Expected 'start' to be a number")

	local n2 = 0
	local t4 = {}

	for _, v in pairs(p14) do
		for k, _ in pairs(v.props) do
			if k == "LayoutOrder" then
				n2 += 1
				v.props.LayoutOrder = p15 + n2
				table.insert(t4, v)
			end
		end
	end

	return t4
end
function v16.getListItems(p16, _) -- line: 196
	-- upvalues: UserAgreementUtils (copy), v14 (copy), Roact (copy), UserAgreementsListItem (copy), GetFFlagVngTOSRevisedEnabled (copy), FitFrame (copy)
	local margin = p16.props.margin
	local agreements = p16.props.agreements
	local t5 = {}
	local t6 = {}

	for _, v in ipairs(agreements) do
		local agreementType = v.agreementType

		if UserAgreementUtils.CheckAgreementTypeExists(agreementType) then
			table.insert(t5, v)
		else
			table.insert(t6, v)
		end
	end

	local n3 = 0
	local t7 = {}

	for i, v in ipairs({
		t5,
		t6
	}) do
		for _, v3 in ipairs(v) do
			local v71 = ({
				true,
				false
			})[i]

			n3 += 1

			if v14 then
				table.insert(t7, (Roact.createElement(UserAgreementsListItem, {
					LayoutOrder = n3,
					Size = if GetFFlagVngTOSRevisedEnabled() then nil else UDim2.new(1, 0, 0, 55),
					minHeight = if not GetFFlagVngTOSRevisedEnabled() then nil else 55,
					agreement = v3,
					agreementTypeExists = v71,
					margin = FitFrame.Rect.quad(0, margin.right, 0, margin.left)
				})))
			else
				t7["Item." .. v3.id] = Roact.createElement(UserAgreementsListItem, {
					LayoutOrder = n3,
					Size = if GetFFlagVngTOSRevisedEnabled() then nil else UDim2.new(1, 0, 0, 55),
					minHeight = if not GetFFlagVngTOSRevisedEnabled() then nil else 55,
					agreement = v3,
					agreementTypeExists = v71,
					margin = FitFrame.Rect.quad(0, margin.right, 0, margin.left)
				})
			end
		end
	end

	return t7
end
function v16.checkBoxPropsExist(p18) -- line: 247
	return p18.props.checkBoxStates ~= nil and (p18.props.setCheckBoxStates ~= nil and p18.props.isAgreeAllChecked ~= nil)
end
function v16.shouldReturnScrollableFrame(p19) -- line: 253
	-- upvalues: FFlagEnableModularizedUserAgreementsList (copy)
	local v74 = p19.props.useScrollableFrame or false

	return FFlagEnableModularizedUserAgreementsList and v74
end
function v16.render(p20) -- line: 258
	-- upvalues: withStyle (copy), Roact (copy), FitFrame (copy), withLocalization (copy)
	return withStyle(function(p21) -- line: 259
		-- upvalues: p20 (copy), Roact (copy), FitFrame (copy), withLocalization (copy)
		local Theme = p21.Theme
		local p21Font = p21.Font
		local propsLayoutOrder = p20.props.LayoutOrder
		local margin = p20.props.margin
		local v83 = p20:getListItems(Theme)

		if not p20:shouldReturnScrollableFrame() then
			return Roact.createElement(FitFrame.FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = propsLayoutOrder,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				margin = FitFrame.Rect.quad(margin.top, 0, margin.bottom, 0)
			}, v83)
		end

		local v84 = p20.props.separateRequiredOptional or false
		local v85 = p20.props.verticalSpaceOffset or 0
		local Tokens = p21.Tokens
		local t8 = {
			required = "CommonUI.UserAgreements.Popup.Agreement.Required",
			optional = "CommonUI.UserAgreements.Popup.Agreement.Optional"
		}
		local t9 = {}
		local v89

		if p20:checkBoxPropsExist() then
			v89 = p20:getListItemsWithCheckBoxes(Theme, 0, "REQUIRED", Tokens, p20.props.checkBoxStates, p20.props.setCheckBoxStates)
			t9 = p20:getListItemsWithCheckBoxes(Theme, getTableCount(v83), "OPTIONAL", Tokens, p20.props.checkBoxStates, p20.props.setCheckBoxStates)
		else
			v89 = p20:getListItems(Theme)
		end

		local u90 = setLayoutOrder(v89, 1)
		local u91 = setLayoutOrder(t9, getTableCount(v83) + 4)

		return withLocalization(t8)(function(p22) -- line: 318
			-- upvalues: Roact (copy), propsLayoutOrder (copy), v85 (copy), v84 (copy), Tokens (copy), p21 (copy), p21Font (copy), u90 (ref), v83 (copy), u91 (ref)
			return Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				ScrollingEnabled = true,
				BorderSizePixel = 0,
				ScrollBarThickness = 2,
				LayoutOrder = propsLayoutOrder,
				Size = UDim2.new(1, 0, 1, -v85),
				CanvasSize = UDim2.new(1, 0, 1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				RequiredTitleText = v84 and Roact.createElement("Frame", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, Tokens.Size.Size_600),
						PaddingTop = UDim.new(0, Tokens.Size.Size_200),
						PaddingBottom = UDim.new(0, Tokens.Size.Size_200)
					}),
					TextLabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = p22.required,
						TextSize = Tokens.FontSize.FontSize_400,
						TextColor3 = Tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p21.Theme.TextDefault.Transparency,
						Font = p21Font.Header1.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0)
					})
				}),
				ItemsRequired = Roact.createFragment(u90),
				OptionalTitleText = v84 and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = getTableCount(v83) + 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, Tokens.Size.Size_600),
						PaddingTop = UDim.new(0, Tokens.Size.Size_200),
						PaddingBottom = UDim.new(0, Tokens.Size.Size_200)
					}),
					TextLabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = p22.optional,
						TextSize = Tokens.FontSize.FontSize_400,
						TextColor3 = Tokens.Color.Content.Emphasis.Color3,
						TextTransparency = p21.Theme.TextDefault.Transparency,
						Font = p21Font.Header1.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0)
					})
				}),
				OptionalItems = v84 and Roact.createFragment(u91)
			})
		end)
	end)
end

return v16
