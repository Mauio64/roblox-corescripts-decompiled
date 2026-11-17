local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local Checkbox = Foundation.Checkbox
local Divider = Foundation.Divider
local InputLabel = Foundation.InputLabel
local ScrollView = Foundation.ScrollView
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local InlineRichText = require(parent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior
local prepareRichTextCopy = InlineRichText.prepareRichTextCopy

require(AmpV2Wizard.Types)
local FullPageChrome = require(AmpV2Wizard.FullPageChrome)

local function renderRow(props, k: number)
	return React.createElement(View, {
		tag = "row align-y-top gap-medium size-full-0 auto-y",
		LayoutOrder = k
	}, {
		Check = React.createElement(Checkbox, {
			label = "",
			isChecked = props.checked[k] == true,
			onActivated = function()
				props.toggleRow(k)
			end,
			size = InputSize.Medium,
			testId = `amp-v2-wizard-consent-row-{k}`,
			LayoutOrder = 1
		}),
		Label = React.createElement(Renderer, {
			text = props.labels[k],
			textStyle = props.textStyle,
			fontStyle = props.fontStyle,
			linkerOptions = props.linkerOptions,
			wrapperProps = {
				tag = "fill size-full-0 auto-y",
				LayoutOrder = 2,
				selection = { Selectable = false },
				onActivated = function()
					props.toggleRow(k)
				end
			},
			nodeProps = {
				LINK = { showUnderline = true }
			}
		})
	})
end

local function renderSection(p, text: string, flag: boolean, layoutOrder: number)
	local v = {}

	for k, row in p.rows do
		if row.isRequired == flag then
			v[`Row_{k}`] = renderRow(p, k)
		end
	end

	if next(v) == nil then
		return nil
	end

	return React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y",
		LayoutOrder = layoutOrder
	}, {
		SectionLabel = React.createElement(InputLabel, { Text = text, LayoutOrder = 1 }),
		Rows = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 2
		}, v)
	})
end

local function AgreementConsentsNode(props)
	local props2 = props.props
	local report = props.report
	local v = useTokens()

	local rows = props2.rows or {}

	local state, setState = React.useState({})
	local count = 0
	local count2 = 0
	local count3 = 0

	for k, row in rows do
		local v2 = state[k] == true

		if v2 then
			count += 1
		end

		if not row.isRequired then
			continue
		end

		count2 += 1

		if v2 then
			count3 += 1
		end
	end

	local isChecked

	if #rows > 0 then
		isChecked = count == #rows
	else
		isChecked = false
	end

	local v2 = count3 == count2
	local onActivated = React.useCallback(function()
		local v3 = not isChecked
		local v4 = {}

		for k in rows do
			v4[k] = v3
		end

		setState(v4)
	end, { isChecked, rows })

	local toggleRow = React.useCallback(function(p: number)
		setState(function(p2)
			local clone = table.clone(p2)
			clone[p] = not p2[p]
			return clone
		end)
	end, {})

	local onActivated2 = React.useCallback(function()
		local acceptedRows = {}

		for k, row in rows do
			if state[k] then
				table.insert(acceptedRows, { id = row.id, target = row.target })
			end
		end

		report("Agree", { acceptedRows = acceptedRows })
	end, { rows, state, report })

	local onBack = React.useCallback(function()
		report("Back")
	end, { report })

	local linkerOptions = React.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return LinkBehavior.Webview
			end
		}
	end, {})

	local v3 = {
		rows = rows,
		labels = React.useMemo(function()
			local result = {}

			for k, row in rows do
				result[k] = type(row.label) ~= "string" and "" or prepareRichTextCopy(row.label)
			end

			return result
		end, { rows }),
		checked = state,
		toggleRow = toggleRow,
		linkerOptions = linkerOptions,
		textStyle = v.Color.Content.Emphasis,
		fontStyle = v.Typography.BodyMedium
	}
	local v4

	if props.transitions == nil then
		v4 = false
	else
		v4 = props.transitions.Back ~= nil
	end

	local element = React.createElement(View, { tag = "col size-full" }, {
		Body = React.createElement(ScrollView, {
			LayoutOrder = 1,
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.fromScale(1, 0),
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 1)
			}
		}, {
			Content = React.createElement(
				View,
				{ tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge" },
				{
					Intro = React.createElement(View, {
						tag = "col gap-none size-full-0 auto-y",
						LayoutOrder = 1
					}, {
						Title = React.createElement(Text, {
							Text = props2.title,
							tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
							LayoutOrder = 1
						}),
						Description = React.createElement(Text, {
							Text = props2.description,
							tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-default",
							LayoutOrder = 2
						})
					}),
					ConsentToAll = React.createElement(Checkbox, {
						label = props2.consentToAllLabel,
						isChecked = isChecked,
						onActivated = onActivated,
						size = InputSize.Medium,
						testId = "amp-v2-wizard-consent-all",
						LayoutOrder = 2
					}),
					Separator = React.createElement(Divider, { LayoutOrder = 3 }),
					Required = renderSection(v3, props2.requiredSectionLabel, true, 4),
					Optional = renderSection(v3, props2.optionalSectionLabel, false, 5)
				}
			)
		}),
		Footer = React.createElement(
			View,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{
				Agree = React.createElement(Button, {
					text = props2.agreeLabel,
					onActivated = onActivated2,
					isDisabled = not v2,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			}
		)
	})

	local createElement = React.createElement
	local v5 = { title = props2.headerTitle, onBack = 0 }

	if not v4 then
		onBack = nil
	end

	v5.onBack = onBack
	return createElement(FullPageChrome, v5, { Content = element })
end

return AgreementConsentsNode
