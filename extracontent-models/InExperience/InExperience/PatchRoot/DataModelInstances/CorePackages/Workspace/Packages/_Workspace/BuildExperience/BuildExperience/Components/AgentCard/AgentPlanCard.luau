local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local Markdown = require(BuildExperienceParent.Markdown)
local React = require(BuildExperienceParent.React)
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

local function AgentPlanSheet(t1: {[any]: any}) -- line: 45
	-- upvalues: Foundation (copy), React (copy), getMarkdownRendererProps (copy), Sheet (copy), FoundationText (copy), View (copy), MarkdownViewer (copy)
	local v20 = Foundation.Hooks.useTokens()
	local Default = v20.Color.Content.Default
	local v22 = React.useMemo(function() -- line: 48
		-- upvalues: getMarkdownRendererProps (copy), v20 (copy), Default (copy)
		return getMarkdownRendererProps(v20, Default)
	end, {
		v20,
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
					Text = "Overview",
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-default"
				}),
				Body = React.createElement(MarkdownViewer, {
					Markdown = t1.textContent,
					WrapperProps = {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y text-body-medium content-emphasis",
						testId = `{ t1.testId }-text-content`
					},
					MarkdownRendererProps = v22
				})
			})
		})
	})
end
local function AgentPlanCard(t2: {[any]: any}) -- line: 94
	-- upvalues: React (copy), AgentCard (copy), AgentCardActions (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), AgentPlanSheet (copy)
	local v24 = t2.testId or "agent-plan-card"
	local v25, v26 = React.useState(false)
	local v27 = React.useCallback(function() -- line: 98
		-- upvalues: t2 (copy)
		if t2.isBuildDisabled == true then
			return
		end

		t2.onBuild()
	end, {
		t2.isBuildDisabled,
		t2.onBuild
	})
	local v28 = React.useCallback(function() -- line: 105
		-- upvalues: v26 (copy)
		v26(true)
	end, {})
	local v29 = React.useCallback(function() -- line: 109
		-- upvalues: v26 (copy)
		v26(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		Card = React.createElement(AgentCard, {
			title = t2.title,
			textContent = t2.summary or t2.textContent,
			layoutOrder = t2.layoutOrder,
			testId = v24
		}, {
			Actions = React.createElement(AgentCardActions, nil, {
				Build = React.createElement(Button, {
					LayoutOrder = 1,
					text = "Build",
					size = InputSize.Small,
					variant = ButtonVariant.SoftEmphasis,
					fillBehavior = FillBehavior.Fill,
					isDisabled = t2.isBuildDisabled == true,
					onActivated = v27,
					testId = `{ v24 }-build-button`
				}),
				View = React.createElement(Button, {
					LayoutOrder = 2,
					text = "View",
					size = InputSize.Small,
					variant = ButtonVariant.Standard,
					fillBehavior = FillBehavior.Fill,
					onActivated = v28,
					testId = `{ v24 }-view-button`
				})
			})
		}),
		Sheet = React.createElement(AgentPlanSheet, {
			title = t2.title,
			textContent = t2.textContent,
			isOpen = v25,
			onClose = v29,
			testId = `{ v24 }-sheet`
		})
	})
end

return AgentPlanCard
