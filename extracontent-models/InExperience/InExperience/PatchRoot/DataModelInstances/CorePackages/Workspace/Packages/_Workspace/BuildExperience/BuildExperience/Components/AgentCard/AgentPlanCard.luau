local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Markdown = require(BuildExperienceParent.Markdown)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local AgentCard = require(script.Parent.AgentCard)
local AgentCardActions = require(script.Parent.AgentCardActions)
local getMarkdownRendererProps = require(BuildExperience.utils.getMarkdownRendererProps)
local Button = Foundation.Button
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local MarkdownViewer = Markdown.Components.MarkdownViewer

local function AgentPlanSheet(t1: {[any]: any}) -- line: 42
	-- upvalues: Foundation (copy), React (copy), getMarkdownRendererProps (copy), Sheet (copy), FoundationText (copy), View (copy), LocalizationStrings (copy), MarkdownViewer (copy)
	local v21 = Foundation.Hooks.useTokens()
	local Default = v21.Color.Content.Default
	local v23 = React.useMemo(function() -- line: 45
		-- upvalues: getMarkdownRendererProps (copy), v21 (copy), Default (copy)
		return getMarkdownRendererProps(v21, Default)
	end, {
		v21,
		Default
	})

	return React.createElement(Sheet.Root, {
		defaultSnapPointIndex = 1,
		isOpen = t1.isOpen,
		onClose = t1.onClose,
		snapPoints = {
			0.5,
			1
		},
		testId = t1.testId
	}, {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y margin-x-small padding-y-small text-heading-small text-wrap text-align-x-left content-emphasis",
				Text = t1.title
			})
		}),
		Content = React.createElement(Sheet.Content, nil, {
			OverviewAndBody = React.createElement(View, {
				tag = "col gap-xsmall size-full-0 auto-y margin-x-small padding-bottom-large"
			}, {
				Overview = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-default",
					Text = LocalizationStrings.AGENT_PLAN_OVERVIEW
				}),
				Body = React.createElement(MarkdownViewer, {
					Markdown = t1.textContent,
					WrapperProps = {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y text-body-medium content-emphasis",
						testId = `{ t1.testId }-text-content`
					},
					MarkdownRendererProps = v23
				})
			})
		})
	})
end
local function AgentPlanCard(t2: {[any]: any}) -- line: 91
	-- upvalues: React (copy), AgentCard (copy), AgentCardActions (copy), Button (copy), LocalizationStrings (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), AgentPlanSheet (copy)
	local v25 = t2.testId or "agent-plan-card"
	local v26, v27 = React.useState(false)
	local v28 = React.useCallback(function() -- line: 95
		-- upvalues: t2 (copy)
		if t2.isBuildDisabled == true then
			return
		end

		t2.onBuild()
	end, {
		t2.isBuildDisabled,
		t2.onBuild
	})
	local v29 = React.useCallback(function() -- line: 102
		-- upvalues: v27 (copy)
		v27(true)
	end, {})
	local v30 = React.useCallback(function() -- line: 106
		-- upvalues: v27 (copy)
		v27(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		Card = React.createElement(AgentCard, {
			title = t2.title,
			textContent = t2.summary or t2.textContent,
			layoutOrder = t2.layoutOrder,
			testId = v25
		}, {
			Actions = React.createElement(AgentCardActions, nil, {
				Build = React.createElement(Button, {
					LayoutOrder = 1,
					text = LocalizationStrings.AGENT_PLAN_BUILD,
					size = InputSize.Small,
					variant = ButtonVariant.Emphasis,
					fillBehavior = FillBehavior.Fill,
					isDisabled = t2.isBuildDisabled == true,
					onActivated = v28,
					testId = `{ v25 }-build-button`
				}),
				View = React.createElement(Button, {
					LayoutOrder = 2,
					text = LocalizationStrings.AGENT_PLAN_VIEW,
					size = InputSize.Small,
					variant = ButtonVariant.Standard,
					fillBehavior = FillBehavior.Fill,
					onActivated = v29,
					testId = `{ v25 }-view-button`
				})
			})
		}),
		Sheet = React.createElement(AgentPlanSheet, {
			title = t2.title,
			textContent = t2.textContent,
			isOpen = v26,
			onClose = v30,
			testId = `{ v25 }-sheet`
		})
	})
end

return AgentPlanCard
