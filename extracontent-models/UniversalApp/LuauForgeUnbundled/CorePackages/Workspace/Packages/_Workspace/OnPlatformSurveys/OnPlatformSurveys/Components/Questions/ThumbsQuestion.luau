local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local icon = Foundation.Icon
local iconVariant = Foundation.Enums.IconVariant
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local v5 = {}

local v6 = {
	{ id = "1", icon = "thumb-down" },
	{ id = "2", icon = "thumb-up" }
}

local function findChoice(p2, p3)
	for k, v7 in p2.choices or v5 do
		if v7.id == p3 then
			return v7
		end
	end

	return nil
end

local function ThumbsQuestion(props)
	local v7 = useTokens()
	local question = props.question
	local answer = props.answer
	local isDisabled = props.isDisabled == true
	local v8 = if answer.choiceIds ~= nil then answer.choiceIds[1] else nil
	local state, setState = React.useState(nil)

	local color3 = v7.Color.Content.Default.Color3

	local children = {}

	for k, v9 in v6 do
		local id = v9.id
		local v10 = nil

		for k2, v12 in question.choices or v5 do
			if v12.id == id then
				v10 = v12
				break
			end
		end

		if v10 == nil then
			continue
		end

		local v12 = v8 == v9.id
		local v13 = state == v9.id

		local v14 = "Cell_" .. v9.id
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v18 = {
			Size = UDim2.fromOffset(76, 76),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Active = not isDisabled,
			Selectable = not isDisabled,
			LayoutOrder = 1,
			[React.Tag] = "data-testid=thumb-" .. v9.id,
			[React.Event.Activated] = function()
				if isDisabled then
					return
				end

				props.onAnswerChanged({
					choiceIds = v12 and {} or { v9.id }
				})
			end,
			[React.Event.MouseEnter] = function()
				setState(v9.id)
			end,
			[React.Event.MouseLeave] = function()
				setState(function(p2)
					if p2 == v9.id then
						return nil
					end

					return p2
				end)
			end
		}
		local children3 = {
			Backplate = React.createElement(view, {
				tag = "size-full radius-circle",
				backgroundStyle = {
					Color3 = color3,
					Transparency = v12 and 0.75 or v13 and 0.85 or 0.92
				},
				ZIndex = 1
			}),
			Icon = 0
		}

		local createElement3 = React.createElement
		local v20 = {
			name = v9.icon,
			size = 40,
			variant = 0,
			AnchorPoint = 0,
			Position = 0,
			ZIndex = 2
		}

		local v21 = if v12 then iconVariant.Filled else iconVariant.Regular
		v20.variant = v21
		v20.AnchorPoint = Vector2.new(0.5, 0.5)
		v20.Position = UDim2.fromScale(0.5, 0.5)
		children3.Icon = createElement3(icon, v20)
		children[v14] = createElement(
			view,
			{ tag = "col align-x-center gap-small auto-xy", LayoutOrder = k },
			{
				Button = createElement2("TextButton", v18, children3),
				Label = React.createElement(text, {
					Text = v10.label,
					tag = "auto-xy text-body-medium text-align-x-center content-default",
					LayoutOrder = 2
				})
			}
		)
	end

	return React.createElement(
		view,
		{
			tag = "row flex-around align-y-top size-full-0 auto-y",
			LayoutOrder = props.layoutOrder
		},
		children
	)
end

return React.memo(ThumbsQuestion)
