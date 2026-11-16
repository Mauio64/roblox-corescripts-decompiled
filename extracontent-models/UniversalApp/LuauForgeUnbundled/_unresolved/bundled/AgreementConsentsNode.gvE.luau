local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local view = module2.View
local text = module2.Text
local button = module2.Button
local checkbox = module2.Checkbox
local divider = module2.Divider
local inputLabel = module2.InputLabel
local scrollView = module2.ScrollView
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/bundled/gvk")
local renderer = module3.Renderer
local linkBehavior = module3.Enums.LinkBehavior
local prepareRichTextCopy = module3.prepareRichTextCopy

require("@luauforge/bundled/gvc")
local module4 = require("@luauforge/bundled/gvr")

local function renderRow(props, k)
	return module.createElement(
		view,
		{ tag = "row align-y-top gap-medium size-full-0 auto-y", LayoutOrder = k },
		{
			Check = module.createElement(checkbox, {
				label = "",
				isChecked = props.checked[k] == true,
				onActivated = function()
					props.toggleRow(k)
				end,
				size = inputSize.Medium,
				testId = `amp-v2-wizard-consent-row-{k}`,
				LayoutOrder = 1
			}),
			Label = module.createElement(renderer, {
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
		}
	)
end

local function renderSection(p2, p3, p4, p5)
	local v5 = {}

	for k, row in p2.rows do
		if row.isRequired == p4 then
			v5[`Row_{k}`] = renderRow(p2, k)
		end
	end

	if next(v5) == nil then
		return nil
	end

	return module.createElement(view, {
		tag = "col gap-large size-full-0 auto-y",
		LayoutOrder = p5
	}, {
		SectionLabel = module.createElement(inputLabel, { Text = p3, LayoutOrder = 1 }),
		Rows = module.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 2 },
			v5
		)
	})
end

local function AgreementConsentsNode(props)
	local props2 = props.props
	local report = props.report
	local v5 = useTokens()

	local rows = props2.rows or {}

	local state, setState = module.useState({})
	local count = 0
	local count2 = 0
	local count3 = 0

	for k, row in rows do
		local v6 = state[k] == true

		if v6 then
			count += 1
		end

		if not row.isRequired then
			continue
		end

		count2 += 1

		if v6 then
			count3 += 1
		end
	end

	local v6 = #rows > 0 and count == #rows
	local v7 = count3 == count2
	local v8 = module.useCallback(function()
		local v9 = not v6
		local v10 = {}

		for k in rows do
			v10[k] = v9
		end

		setState(v10)
	end, { v6, rows })

	local v9 = module.useCallback(function(p2)
		setState(function(p3)
			local clone = table.clone(p3)
			clone[p2] = not p3[p2]
			return clone
		end)
	end, {})

	local v10 = module.useCallback(function()
		local v11 = {}

		for k, row in rows do
			if state[k] then
				table.insert(v11, { id = row.id, target = row.target })
			end
		end

		report("Agree", { acceptedRows = v11 })
	end, { rows, state, report })

	local v11 = module.useCallback(function()
		report("Back")
	end, { report })

	local v12 = module.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return linkBehavior.Webview
			end
		}
	end, {})

	local v13 = {
		rows = rows,
		labels = module.useMemo(function()
			local result = {}

			for k, row in rows do
				result[k] = type(row.label) ~= "string" and "" or prepareRichTextCopy(row.label)
			end

			return result
		end, { rows }),
		checked = state,
		toggleRow = v9,
		linkerOptions = v12,
		textStyle = v5.Color.Content.Emphasis,
		fontStyle = v5.Typography.BodyMedium
	}

	local v14 = not (props.transitions == nil) and props.transitions.Back ~= nil

	local element = module.createElement(view, { tag = "col size-full" }, {
		Body = module.createElement(scrollView, {
			LayoutOrder = 1,
			flexItem = { FlexMode = Enum.UIFlexMode.Fill },
			Size = UDim2.fromScale(1, 0),
			scroll = {
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(0, 1)
			}
		}, {
			Content = module.createElement(
				view,
				{
					tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge"
				},
				{
					Intro = module.createElement(
						view,
						{ tag = "col gap-none size-full-0 auto-y", LayoutOrder = 1 },
						{
							Title = module.createElement(text, {
								Text = props2.title,
								tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
								LayoutOrder = 1
							}),
							Description = module.createElement(text, {
								Text = props2.description,
								tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-default",
								LayoutOrder = 2
							})
						}
					),
					ConsentToAll = module.createElement(checkbox, {
						label = props2.consentToAllLabel,
						isChecked = v6,
						onActivated = v8,
						size = inputSize.Medium,
						testId = "amp-v2-wizard-consent-all",
						LayoutOrder = 2
					}),
					Separator = module.createElement(divider, { LayoutOrder = 3 }),
					Required = renderSection(v13, props2.requiredSectionLabel, true, 4),
					Optional = renderSection(v13, props2.optionalSectionLabel, false, 5)
				}
			)
		}),
		Footer = module.createElement(
			view,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{
				Agree = module.createElement(button, {
					text = props2.agreeLabel,
					onActivated = v10,
					isDisabled = not v7,
					variant = buttonVariant.Emphasis,
					size = inputSize.Medium,
					width = UDim.new(1, 0),
					LayoutOrder = 1
				})
			}
		)
	})

	local createElement = module.createElement
	local v16 = { title = props2.headerTitle, onBack = 0 }

	if not v14 then
		v11 = nil
	end

	v16.onBack = v11
	return createElement(module4, v16, { Content = element })
end

return AgreementConsentsNode
