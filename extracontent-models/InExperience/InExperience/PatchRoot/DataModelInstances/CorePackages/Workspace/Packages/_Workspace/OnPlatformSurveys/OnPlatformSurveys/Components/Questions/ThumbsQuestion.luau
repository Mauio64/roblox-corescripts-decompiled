local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local IconVariant = Foundation.Enums.IconVariant
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local v = {}

local v2 = {
	{ id = "1", icon = "thumb-down" },
	{ id = "2", icon = "thumb-up" }
}

local function findChoice(question, id: string) -- 1 equivalent call inferred from this helper
	for _, v3 in question.choices or v do
		if v3.id == id then
			return v3
		end
	end

	return nil
end

local function ThumbsQuestion(props)
	local v3 = useTokens()
	local question = props.question
	local answer = props.answer
	local isDisabled = props.isDisabled == true
	local v4

	if answer.choiceIds ~= nil then
		v4 = answer.choiceIds[1]
	end

	local state, setState = React.useState(nil)

	local color3 = v3.Color.Content.Default.Color3

	local children = {}

	for k, v5 in v2 do
		local choice = findChoice(question, v5.id) -- inferred equivalent call

		if choice == nil then
			continue
		end

		local v6 = v4 == v5.id
		local v7 = state == v5.id

		local v8 = "Cell_" .. v5.id
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v9 = {
			Size = UDim2.fromOffset(76, 76),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Active = not isDisabled,
			Selectable = not isDisabled,
			LayoutOrder = 1,
			[React.Tag] = "data-testid=thumb-" .. v5.id,
			[React.Event.Activated] = function()
				if isDisabled then
					return
				end

				props.onAnswerChanged({
					choiceIds = v6 and {} or { v5.id }
				})
			end,
			[React.Event.MouseEnter] = function()
				setState(v5.id)
			end,
			[React.Event.MouseLeave] = function()
				setState(function(p: string?)
					return if p ~= v5.id then p else nil
				end)
			end
		}
		local children2 = {
			Backplate = React.createElement(View, {
				tag = "size-full radius-circle",
				backgroundStyle = {
					Color3 = color3,
					Transparency = v6 and 0.75 or v7 and 0.85 or 0.92
				},
				ZIndex = 1
			}),
			Icon = 0
		}

		local createElement3 = React.createElement
		local v10 = {
			name = v5.icon,
			size = 40,
			variant = 0,
			AnchorPoint = 0,
			Position = 0,
			ZIndex = 2
		}
		local variant

		if v6 then
			variant = IconVariant.Filled
		else
			variant = IconVariant.Regular
		end

		v10.variant = variant
		v10.AnchorPoint = Vector2.new(0.5, 0.5)
		v10.Position = UDim2.fromScale(0.5, 0.5)
		children2.Icon = createElement3(Icon, v10)
		children[v8] = createElement(View, {
			tag = "col align-x-center gap-small auto-xy",
			LayoutOrder = k
		}, {
			Button = createElement2("TextButton", v9, children2),
			Label = React.createElement(Text, {
				Text = choice.label,
				tag = "auto-xy text-body-medium text-align-x-center content-default",
				LayoutOrder = 2
			})
		})
	end

	return React.createElement(
		View,
		{ tag = "row flex-around align-y-top size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		children
	)
end

return React.memo(ThumbsQuestion)
