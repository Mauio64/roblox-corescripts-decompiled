local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Markdown")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local AgentCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentCard/AgentCard")
local AgentCardActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/AgentCard/AgentCardActions")
local getMarkdownRendererProps = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getMarkdownRendererProps")
local ChatCardPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardPriority")
local useChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/useChatCardEmphasis")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")

local button = Foundation.Button
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local markdownViewer = module2.Components.MarkdownViewer

local function AgentPlanSheet(props)
	local v5 = useLocalization({ overview = LocalizationStrings.AGENT_PLAN_OVERVIEW })

	local v6 = Foundation.Hooks.useTokens()
	local default = v6.Color.Content.Default
	local v7 = React.useMemo(function()
		return getMarkdownRendererProps(v6, default)
	end, { v6, default })

	return React.createElement(sheet.Root, {
		isOpen = props.isOpen,
		onClose = props.onClose,
		snapPoints = { 0.5, 1 },
		defaultSnapPointIndex = 1,
		testId = props.testId
	}, {
		Header = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.title,
				tag = "size-full-0 auto-y margin-x-small padding-y-small text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = React.createElement(sheet.Content, nil, {
			OverviewAndBody = React.createElement(
				view,
				{
					tag = "col gap-xsmall size-full-0 auto-y margin-x-small padding-bottom-large"
				},
				{
					Overview = React.createElement(text, {
						LayoutOrder = 1,
						Text = v5.overview,
						tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-default"
					}),
					Body = React.createElement(markdownViewer, {
						Markdown = props.textContent,
						WrapperProps = {
							LayoutOrder = 2,
							tag = "size-full-0 auto-y text-body-medium content-emphasis",
							testId = `{props.testId}-text-content`
						},
						MarkdownRendererProps = v7
					})
				}
			)
		})
	})
end

local function AgentPlanCard(props)
	local v5 = useLocalization({
		build = LocalizationStrings.AGENT_PLAN_BUILD,
		view = LocalizationStrings.AGENT_PLAN_VIEW
	})

	local testId = props.testId or "agent-plan-card"
	local state, setState = React.useState(false)
	local v6

	if FFlagBuildExperienceChatCardEmphasis then
		local v8 = if props.isBuildDisabled ~= true then ChatCardPriority.AgentProposal else nil
		v6 = useChatCardEmphasis(v8)
	end

	local v7 = React.useCallback(function()
		if props.isBuildDisabled == true then
			return
		end

		props.onBuild()
	end, { props.isBuildDisabled, props.onBuild })

	local v8 = React.useCallback(function()
		setState(true)
	end, {})

	local v9 = React.useCallback(function()
		setState(false)
	end, {})

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v12 = {
		title = props.title,
		textContent = props.summary or props.textContent,
		layoutOrder = props.layoutOrder,
		testId = testId
	}

	local createElement3 = React.createElement
	local createElement4 = React.createElement
	local v17 = {
		LayoutOrder = 1,
		text = v5.build,
		size = inputSize.Small,
		variant = 0,
		fillBehavior = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = 0
	}
	local v18 = if v6 == false then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
	v17.variant = v18
	v17.fillBehavior = fillBehavior.Fill
	v17.isDisabled = props.isBuildDisabled == true
	v17.onActivated = v7
	v17.testId = `{testId}-build-button`
	return createElement(fragment, nil, {
		Card = createElement2(AgentCard, v12, {
			Actions = createElement3(AgentCardActions, nil, {
				Build = createElement4(button, v17),
				View = React.createElement(button, {
					LayoutOrder = 2,
					text = v5.view,
					size = inputSize.Small,
					variant = buttonVariant.Standard,
					fillBehavior = fillBehavior.Fill,
					onActivated = v8,
					testId = `{testId}-view-button`
				})
			})
		}),
		Sheet = React.createElement(AgentPlanSheet, {
			title = props.title,
			textContent = props.textContent,
			isOpen = state,
			onClose = v9,
			testId = `{testId}-sheet`
		})
	})
end

return AgentPlanCard
