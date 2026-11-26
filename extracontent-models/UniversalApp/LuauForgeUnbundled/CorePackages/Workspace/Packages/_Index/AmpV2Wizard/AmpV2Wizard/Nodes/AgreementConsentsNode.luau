local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local checkbox = Foundation.Checkbox
local divider = Foundation.Divider
local inputLabel = Foundation.InputLabel
local scrollView = Foundation.ScrollView
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local InlineRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/InlineRichText")
local renderer = InlineRichText.Renderer
local linkBehavior = InlineRichText.Enums.LinkBehavior
local prepareRichTextCopy = InlineRichText.prepareRichTextCopy

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FullPageChrome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FullPageChrome")

local function renderRow(props, k)
	return React.createElement(
		view,
		{ tag = "row align-y-top gap-medium size-full-0 auto-y", LayoutOrder = k },
		{
			Check = React.createElement(checkbox, {
				label = "",
				isChecked = props.checked[k] == true,
				onActivated = function()
					props.toggleRow(k)
				end,
				size = inputSize.Medium,
				testId = `amp-v2-wizard-consent-row-{k}`,
				LayoutOrder = 1
			}),
			Label = React.createElement(renderer, {
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

	return React.createElement(view, {
		tag = "col gap-large size-full-0 auto-y",
		LayoutOrder = p5
	}, {
		SectionLabel = React.createElement(inputLabel, { Text = p3, LayoutOrder = 1 }),
		Rows = React.createElement(
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

	local state, setState = React.useState({})
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
	local v8 = React.useCallback(function()
		local v9 = not v6
		local v10 = {}

		for k in rows do
			v10[k] = v9
		end

		setState(v10)
	end, { v6, rows })

	local v9 = React.useCallback(function(p2)
		setState(function(p3)
			local clone = table.clone(p3)
			clone[p2] = not p3[p2]
			return clone
		end)
	end, {})

	local v10 = React.useCallback(function()
		local v11 = {}

		for k, row in rows do
			if state[k] then
				table.insert(v11, { id = row.id, target = row.target })
			end
		end

		report("Agree", { acceptedRows = v11 })
	end, { rows, state, report })

	local v11 = React.useCallback(function()
		report("Back")
	end, { report })

	local v12 = React.useMemo(function()
		return {
			evaluateLinkBehavior = function()
				return linkBehavior.Webview
			end
		}
	end, {})

	local v13 = {
		rows = rows,
		labels = React.useMemo(function()
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

	local element = React.createElement(view, { tag = "col size-full" }, {
		Body = React.createElement(scrollView, {
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
				view,
				{
					tag = "col gap-xlarge size-full-0 auto-y padding-x-xlarge padding-y-xlarge"
				},
				{
					Intro = React.createElement(
						view,
						{ tag = "col gap-none size-full-0 auto-y", LayoutOrder = 1 },
						{
							Title = React.createElement(text, {
								Text = props2.title,
								tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left text-align-y-top content-emphasis",
								LayoutOrder = 1
							}),
							Description = React.createElement(text, {
								Text = props2.description,
								tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left text-align-y-top content-default",
								LayoutOrder = 2
							})
						}
					),
					ConsentToAll = React.createElement(checkbox, {
						label = props2.consentToAllLabel,
						isChecked = v6,
						onActivated = v8,
						size = inputSize.Medium,
						testId = "amp-v2-wizard-consent-all",
						LayoutOrder = 2
					}),
					Separator = React.createElement(divider, { LayoutOrder = 3 }),
					Required = renderSection(v13, props2.requiredSectionLabel, true, 4),
					Optional = renderSection(v13, props2.optionalSectionLabel, false, 5)
				}
			)
		}),
		Footer = React.createElement(
			view,
			{
				tag = "col gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-large",
				LayoutOrder = 2
			},
			{
				Agree = React.createElement(button, {
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

	local createElement = React.createElement
	local v16 = { title = props2.headerTitle, onBack = 0 }

	if not v14 then
		v11 = nil
	end

	v16.onBack = v11
	return createElement(FullPageChrome, v16, { Content = element })
end

return AgreementConsentsNode
