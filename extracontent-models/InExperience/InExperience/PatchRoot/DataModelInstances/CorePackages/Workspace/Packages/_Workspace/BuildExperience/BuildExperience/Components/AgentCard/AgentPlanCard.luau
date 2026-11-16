local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Markdown = require(parent.Markdown)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local AgentCard = require(script.Parent.AgentCard)
local AgentCardActions = require(script.Parent.AgentCardActions)
local getMarkdownRendererProps = require(BuildExperience.utils.getMarkdownRendererProps)
local ChatCardPriority = require(BuildExperience.Components.Chat.ChatCardEmphasis.ChatCardPriority)
local useChatCardEmphasis = require(BuildExperience.Components.Chat.ChatCardEmphasis.useChatCardEmphasis)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)

local Button = Foundation.Button
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local MarkdownViewer = Markdown.Components.MarkdownViewer

local function AgentPlanSheet(props)
	local v = useLocalization({ overview = LocalizationStrings.AGENT_PLAN_OVERVIEW })

	local v2 = Foundation.Hooks.useTokens()
	local default = v2.Color.Content.Default
	local markdownRendererProps = React.useMemo(function()
		return getMarkdownRendererProps(v2, default)
	end, { v2, default })

	return React.createElement(Sheet.Root, {
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		defaultSnapPointIndex = 1,
		testId = props.testId
	}, {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.title,
				tag = "size-full-0 auto-y margin-x-small padding-y-small text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			OverviewAndBody = React.createElement(
				View,
				{ tag = "col gap-xsmall size-full-0 auto-y margin-x-small padding-bottom-large" },
				{
					Overview = React.createElement(Text, {
						LayoutOrder = 1,
						Text = v.overview,
						tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-default"
					}),
					Body = React.createElement(MarkdownViewer, {
						Markdown = props.textContent,
						WrapperProps = {
							LayoutOrder = 2,
							tag = "size-full-0 auto-y text-body-medium content-emphasis",
							testId = `{props.testId}-text-content`
						},
						MarkdownRendererProps = markdownRendererProps
					})
				}
			)
		})
	})
end

local function AgentPlanCard(props)
	local v = useLocalization({
		build = LocalizationStrings.AGENT_PLAN_BUILD,
		view = LocalizationStrings.AGENT_PLAN_VIEW
	})

	local testId = props.testId or "agent-plan-card"
	local state, setState = React.useState(false)
	local v2

	if FFlagBuildExperienceChatCardEmphasis then
		local v3

		if props.isBuildDisabled ~= true then
			v3 = ChatCardPriority.AgentProposal
		end

		v2 = useChatCardEmphasis(v3)
	end

	local onActivated = React.useCallback(function()
		if props.isBuildDisabled == true then
			return
		end

		props.onBuild()
	end, { props.isBuildDisabled, props.onBuild })

	local onActivated2 = React.useCallback(function()
		setState(true)
	end, {})

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v3 = {
		title = props.title,
		textContent = props.summary or props.textContent,
		layoutOrder = props.layoutOrder,
		testId = testId
	}

	local createElement3 = React.createElement
	local createElement4 = React.createElement
	local v4 = {
		LayoutOrder = 1,
		text = v.build,
		size = InputSize.Small,
		variant = 0,
		fillBehavior = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = 0
	}
	local variant

	if v2 == false then
		variant = ButtonVariant.SoftEmphasis
	else
		variant = ButtonVariant.Emphasis
	end

	v4.variant = variant
	v4.fillBehavior = FillBehavior.Fill
	v4.isDisabled = props.isBuildDisabled == true
	v4.onActivated = onActivated
	v4.testId = `{testId}-build-button`
	return createElement(fragment, nil, {
		Card = createElement2(AgentCard, v3, {
			Actions = createElement3(AgentCardActions, nil, {
				Build = createElement4(Button, v4),
				View = React.createElement(Button, {
					LayoutOrder = 2,
					text = v.view,
					size = InputSize.Small,
					variant = ButtonVariant.Standard,
					fillBehavior = FillBehavior.Fill,
					onActivated = onActivated2,
					testId = `{testId}-view-button`
				})
			})
		}),
		Sheet = React.createElement(AgentPlanSheet, {
			title = props.title,
			textContent = props.textContent,
			isOpen = state,
			onClose = onClose,
			testId = `{testId}-sheet`
		})
	})
end

return AgentPlanCard
